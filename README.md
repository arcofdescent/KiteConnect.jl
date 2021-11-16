# KiteConnect.jl

A Julia module to interface with Zerodha's KiteConnect API

## Installation

Using Julia's package manager

```
pkg> add KiteConnect
```

## API keys

Create a `.env` file to store your API key and secret. Look at `.env.sample` for an example.

## Get LTP of an instrument

```julia
using KiteConnect

access_token = KiteConnect.gen_access_token(request_token)
KiteConnect.ltp("NSE:INFY", access_token)
```
