
using Dates

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

    return bars
end

function accumulate_historical_data(bars, period)

    period_2 = period

    for idx in 1:period:length(bars)

        println(idx)
        inside_bars = bars[idx:period_2]
        println(inside_bars)
        period_2 += period
        # bar = Bar(
        #     bar1.instrument_token,
        #     bar1.interval,
        #     bar1.timestamp,
        #     bar1.open,
        #     (bar1.high > bar2.high ? bar1.high : bar2.high),
        #     (bar1.low < bar2.low ? bar1.low : bar2.low),
        #     bar2.close,
        #     bar1.volume + bar2.volume
        # )
        
        # println(bar)
    end
end


