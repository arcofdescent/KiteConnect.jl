"""
    KiteConnect

Julia module to interface with Zerodha's KiteConnect API
"""
module KiteConnect

using HTTP
using JSON3
using SHA

include("quote.jl")
include("historical_data.jl")

const API_ENDPOINT = "https://api.kite.trade"
API_KEY = ""
API_SECRET = ""
ACCESS_TOKEN = ""

"""
  `init(api_key::String, api_secret::String)`

Setup your KiteConnect session by providing your API key and
API secret which you get from Zerodha
"""
function init(api_key::String, api_secret::String)
    global API_KEY = api_key
    global API_SECRET = api_secret
end

function get_http_headers()
    return [
        "X-Kite-Version" => "3",
        "Authorization" => "token $API_KEY:$ACCESS_TOKEN",
    ]
end

function http_get(url_fragment::String)
    url = "$API_ENDPOINT/$url_fragment"
    r = HTTP.request("GET", url, get_http_headers())
    return r.body |> String |> JSON3.read
end

"""
  `gen_access_token(request_token::String)`

Generate the access token by passing in yout request token
"""
function gen_access_token(request_token::String)
    checksum = (API_KEY * request_token * API_SECRET) |> sha256 |> bytes2hex
    url = "$API_ENDPOINT/session/token"

    headers = [
        "X-Kite-Version" => "3",
        "Content-Type"   => "application/x-www-form-urlencoded",
    ]
    body = "api_key=$API_KEY&request_token=$request_token&checksum=$checksum"

    res = HTTP.request("POST", url, headers, body)
    r = res.body |> String |> JSON3.read
    global ACCESS_TOKEN = r["data"]["access_token"]
end

end # module
