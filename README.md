# KiteConnect.jl

A Julia module to interface with Zerodha's KiteConnect API

## Installation
Using Julia's package manager

```
pkg> add KiteConnect
```

## Get LTP of an instrument

```julia
using KiteConnect

KiteConnect.gen_access_token(request_token)
KiteConnect.ltp("NSE:INFY")
```
