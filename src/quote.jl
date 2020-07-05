module Quote

using ..KiteConnect: http_get

"""
    ltp("NSE:INFY")

Get LTP of trading symbol
`instrument` should be in EXCHANGE:TRADINGSYMBOL format
"""
function ltp(instrument)
  parts = split(instrument, ":")
  if (length(parts) != 2)
    error("instrument should be in EXCHANGE:TRADINGSYMBOL format")
  end

  url_fragment = "quote/ltp?i=$instrument"
  res = http_get(url_fragment)
  res["data"][instrument]["last_price"]
end

end
