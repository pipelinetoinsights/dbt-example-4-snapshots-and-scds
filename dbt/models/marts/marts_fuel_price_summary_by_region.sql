With latest_prices As (
    Select
        state,
        fuel_type,
        AVG(price) As avg_price,
        MIN(price) As min_price,
        MAX(price) As max_price
    From {{ ref('int_fuel_prices_latest') }}
    Group By state, fuel_type
)

Select * From latest_prices
