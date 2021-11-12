
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

    # TODO remove the last bar

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


