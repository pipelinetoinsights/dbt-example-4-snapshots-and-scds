WITH prices AS (
    SELECT *
    FROM {{ ref('snapshot_fuel_prices') }}
)

SELECT
    station_name,
    fuel_type,
    postcode,
    state,
    price,
    updated_at
FROM prices
