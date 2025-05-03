with price_dev as (
    select
        station_name,
        fuel_type,
        state,
        STDDEV(price) as price_stddev,
        COUNT(*) as num_entries
    from {{ ref('int_price_history_stations') }}
    group by station_name, fuel_type, state
)

select * from price_dev
