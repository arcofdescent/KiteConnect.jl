"""
    KiteConnect

Julia module to interface with Zerodha's KiteConnect API
"""
module KiteConnect

using HTTP
using JSON

const API_ENDPOINT = "https://api.kite.trade"
const API_KEY = ""
const API_SECRET = ""
const ACCESS_TOKEN = ""

include("quote.jl")

function authenticate(api_key::String, api_secret::String)

end

function http_get(url::String)
  r = HTTP.request("GET", "$API_ENDPOINT/quote/ltp")
  r.body |> String |> JSON.parse
end

end # module
