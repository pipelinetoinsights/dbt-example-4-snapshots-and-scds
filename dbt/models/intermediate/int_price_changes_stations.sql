WITH prices AS (
    SELECT
        station_name,
        fuel_type,
        postcode,
        state,
        price,
        updated_at,
        LAG(price)
            OVER (
                PARTITION BY station_name, fuel_type, postcode
                ORDER BY updated_at
            )
            AS previous_price,
        updated_at
        - LAG(updated_at) OVER (
            PARTITION BY station_name, fuel_type, postcode
            ORDER BY updated_at
        ) AS time_diff
    FROM {{ ref('snapshot_fuel_prices') }}
)

SELECT
    *,
    price - previous_price AS price_diff
FROM prices
WHERE previous_price IS NOT NULL
