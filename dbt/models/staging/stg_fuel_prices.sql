WITH source AS (
    SELECT * FROM {{ source('raw_data', 'fuel_prices') }}
)

SELECT
    region,
    suburb,
    state,
    type AS fuel_type,
    price,
    name AS station_name,
    postcode,
    lat,
    lng,
    updated_at::timestamp AS updated_at
FROM source
