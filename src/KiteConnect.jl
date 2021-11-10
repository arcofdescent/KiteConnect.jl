"""
    KiteConnect

Julia module to interface with Zerodha's KiteConnect API
"""
module KiteConnect

export Bar

using HTTP
using JSON3
using SHA

include("quote.jl")
include("historical_data.jl")

const API_ENDPOINT = "https://api.kite.trade"
ACCESS_TOKEN = ""

function get_http_headers(access_token::String)
    return [
        "X-Kite-Version" => "3",
        "Authorization" => "token " * ENV["KITE_API_KEY"] * ":$access_token",
    ]
end

function http_get(url_fragment::String, access_token::String)
    url = "$API_ENDPOINT/$url_fragment"
    r = HTTP.request("GET", url, get_http_headers(access_token))
    return r.body |> String |> JSON3.read
end

"""
  `gen_access_token(request_token::String)`

Generate the access token by passing in your request token
"""
function gen_access_token(request_token::String)
    checksum = (ENV["KITE_API_KEY"] * request_token * ENV["KITE_API_SECRET"]) |> sha256 |> bytes2hex
    url = "$API_ENDPOINT/session/token"

    headers = [
        "X-Kite-Version" => "3",
        "Content-Type"   => "application/x-www-form-urlencoded",
    ]
    body = "api_key=" * ENV["KITE_API_KEY"] * "&request_token=$request_token&checksum=$checksum"

    res = HTTP.request("POST", url, headers, body)
    r = res.body |> String |> JSON3.read
    return r["data"]["access_token"]
end

end # module
