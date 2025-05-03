with price_changes as (
    select *
    from {{ ref('int_price_changes_stations') }}
)

select
    station_name,
    fuel_type,
    postcode,
    state,
    price,
    updated_at,
    previous_price,
    time_diff,
    price_diff
from price_changes
