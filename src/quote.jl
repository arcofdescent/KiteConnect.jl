"""
    ltp(instrument::String, access_token::String)

Get LTP of trading symbol

`instrument` should be in EXCHANGE:TRADINGSYMBOL format, eg. "NSE:INFY"
"""
function ltp(instrument::String, access_token::String)
    parts = split(instrument, ":")
    if (length(parts) != 2)
        throw(ArgumentError("instrument should be in EXCHANGE:TRADINGSYMBOL format"))
    end

    url_fragment = "quote/ltp?i=$instrument"
    res = http_get(url_fragment, access_token)

    return res["data"][instrument]["last_price"]
end

