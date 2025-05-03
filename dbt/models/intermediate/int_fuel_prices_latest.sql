WITH ranked_prices AS (
    SELECT
        region,
        suburb,
        state,
        fuel_type,
        price,
        station_name,
        postcode,
        updated_at,
        dbt_valid_from AS price_valid_from,
        dbt_valid_to AS price_valid_to

    FROM {{ ref('snapshot_fuel_prices') }}
    WHERE dbt_valid_to IS null -- This ensures we get the latest price
)

SELECT *
FROM ranked_prices
