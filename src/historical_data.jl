
using Dates
using StructTypes

struct Bar
    instrument_token::Int
    interval::String
    timestamp::DateTime
    open::Number
    high::Number
    low::Number
    close::Number
    volume::Int
end

StructTypes.StructType(::Type{Bar}) = StructTypes.Struct()

"""
    historical_data(instrument_token::Integer, interval::String,
                    from_dt::DateTime, to_dt::DateTime, access_token::String)

Get historical data
"""
function historical_data(instrument_token::Integer, interval::String,
                         from_dt::DateTime, to_dt::DateTime, access_token::String)
    url_fragment = "instruments/historical/$instrument_token/$interval"
    fd = Dates.format(from_dt, "yyyy-mm-dd+HH:MM:SS")
    td = Dates.format(to_dt, "yyyy-mm-dd+HH:MM:SS")
    res = http_get(url_fragment * "?from=$fd&to=$td", access_token)

    # return a list of Bar objects
    bars = []
    for candle in res["data"]["candles"]
        bar = Bar(
            instrument_token, interval,
            DateTime(candle[1], "yyyy-mm-ddTH:M:S+0530"),
            candle[2], candle[3], candle[4], candle[5],
            candle[6])

        push!(bars, bar)
    end

    # Remove the last bar. Why?
    # Say we want data from 10:00 to 11:00 i.e. for a duration of 60 minutes, at an interval
    # of 15 minutes.
    # This will give 5 bars
    # 1. 10:00 ohlc
    # 2. 10:15 ohlc
    # 3. 10:30 ohlc
    # 4. 10:45 ohlc
    # 5. 11:00 ohlc
    #
    # The last bar contains data from 11:00 onwards. We don't what this, so we can discard this
    # bar
    if length(bars) > 0
        pop!(bars)
    end
    
    return bars
end

function accumulate_historical_data(bars, period)
    period_2 = period

    ret = []
    for idx in 1:period:length(bars)-period
        inside_bars = bars[idx:period_2]
        bar1 = inside_bars[1]

        high = max(map(b -> b.high, inside_bars)...)
        low = min(map(b -> b.low, inside_bars)...)
        vol = sum(map(b -> b.volume, inside_bars))

        bar = Bar(
            bar1.instrument_token,
            bar1.interval,
            bar1.timestamp,
            bar1.open,
            high,
            low,
            inside_bars[end].close,
            vol
        )
        
        push!(ret, bar)
        period_2 += period
    end

    return ret
end


