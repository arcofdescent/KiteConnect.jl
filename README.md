# KiteConnect.jl

A Julia module to interface with Zerodha's KiteConnect API

## Installation
Using Julia's package manager

```
pkg> add KiteConnect
```

## Get LTP of an instrument

```
using KiteConnect

init(api_key, api_secret)
gen_access_token(request_token)
ltp("NSE:INFY")
```

