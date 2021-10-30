
using Dates

struct Bar
    instrument_token::Int
    interval::String
    timestamp::DateTime
    open::Number
    low::Number
    high::Number
    close::Number
    Volume::Int
end

"""
    historical_data(instrument_token::Integer, interval::String,
                    from_dt::DateTime, to_dt::DateTime)

Get historical data
"""
function historical_data(instrument_token::Integer, interval::String,
                         from_dt::DateTime, to_dt::DateTime)
    url_fragment = "instruments/historical/$instrument_token/$interval"
    fd = Dates.format(from_dt, "yyyy-mm-dd+HH:MM:SS")
    td = Dates.format(to_dt, "yyyy-mm-dd+HH:MM:SS")
    res = http_get(url_fragment * "?from=$fd&to=$td")

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

