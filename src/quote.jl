module Quote

# using ..KiteConnect

"""
    KiteConnect.Quote.ltp("NSE:INFY")

Get LTP of trading symbol
"""
function ltp(instrument)
  url_fragment = "quote/ltp?i=$instrument"
  res = KiteConnect.http_get(url_fragment)
  res["data"][instrument]["last_price"]
end

end
