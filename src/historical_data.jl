
using Dates

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

    return res["data"]["candles"]
end

