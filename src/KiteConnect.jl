"""
    KiteConnect

Julia module to interface with Zerodha's KiteConnect API
"""
module KiteConnect

using HTTP
using JSON
using SHA

const API_ENDPOINT = "https://api.kite.trade"
API_KEY = ""
API_SECRET = ""
ACCESS_TOKEN = ""

include("quote.jl")

function authenticate(api_key::String, api_secret::String)
  API_KEY = api_key
  API_SECRET = api_secret
end

function http_get(url::String)
  println(API_SECRET)
  # r = HTTP.request("GET", "$API_ENDPOINT/quote/ltp")
  # r.body |> String |> JSON.parse
end

function gen_access_token(request_token::String)
  checksum = request_token |> sha256 |> bytes2hex
  println(checksum)
  url = "$API_ENDPOINT/session/token"

  headers = [
    "X-Kite-Version" => "3",
    "Content-Type"   => "application/x-www-form-urlencoded",
  ]

  body = "api_key=$API_KEY&request_token=$request_token&checksum=$checksum"
  println(body)

  HTTP.request("POST", url, headers, body)
end

end # module
