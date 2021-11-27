module Charges

# Flat brokerage in Rs. per executed order. So a buy and sell will become Rs. 40
FLAT_BROKERAGE = 20.00
# in percent
BROKERAGE = 0.03 * 0.01

# STT (Securities Transaction Tax)
# in percent
STT = 0.025 * 0.01
STT_COMMODITY = 0.01 * 0.01

# Exchange Transaction Charges
# percent
EXCHANGE_TRANSACTION_CHARGES_EQUITY_INTRADAY = 0.00325 * 0.01
EXCHANGE_TRANSACTION_CHARGES_CURRENCY_FUTURES = 0.0009 * 0.01
EXCHANGE_TRANSACTION_CHARGES_COMMODITY_FUTURES = 0.0026 * 0.01

# percent
GST = 18 * 0.01

# SEBI charges Rs.5 / crore
SEBI_CHARGES = 1_00_00_000 / 10

# Stamp duty
# percent
STAMP_DUTY = 0.002 * 0.01
STAMP_DUTY_COMMODITY_FUTURES = 0.002 * 0.01

function commodity_futures(commodity, buy_price, sell_price, quantity)
    unit_change =
        if commodity == "crudeoil"
            100
        elseif commodity == "gold"
            100
        elseif commodity == "goldm"
            10
        elseif commodity == "naturalgas"
            1250
        elseif commodity == "silver"
            30
        elseif commodity == "silverm"
            5
        elseif commodity == "silvermic"
            1
        end

    quantity = quantity * unit_change
    turnover = (buy_price + sell_price) * quantity

    brokerage = turnover * BROKERAGE
    @debug brokerage

    brokerage =
      if brokerage > FLAT_BROKERAGE * 2
        FLAT_BROKERAGE * 2
      else
        brokerage
      end
    @debug brokerage

    stt = sell_price * quantity * STT_COMMODITY

    exchange_transaction_charges = turnover * EXCHANGE_TRANSACTION_CHARGES_COMMODITY_FUTURES

    gst = (brokerage + exchange_transaction_charges) * GST
    sebi_charges = turnover / SEBI_CHARGES
    stamp_duty = (buy_price * quantity) * STAMP_DUTY_COMMODITY_FUTURES

    total_charges = brokerage + stt + exchange_transaction_charges + gst + sebi_charges + stamp_duty

    gross_profit = (sell_price - buy_price) * quantity
    net_profit = gross_profit - total_charges

    points_to_breakeven = 0
    pips_to_breakeven = 0

    return Dict(
      "turnover" => turnover,
      "gross_profit" => gross_profit,
      "brokerage" => brokerage,
      "stt" => stt,
      "exchange_transaction_charges" => exchange_transaction_charges,
      "gst" => gst,
      "sebi_charges" => sebi_charges,
      "stamp_duty" => stamp_duty,
      "total_charges" => total_charges,
      "net_profit" => net_profit,
      "points_to_breakeven" => points_to_breakeven,
      "pips_to_breakeven" => pips_to_breakeven
    )
end

end
