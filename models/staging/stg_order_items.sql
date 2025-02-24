WITH source AS (
    SELECT * FROM {{ source('raw_data', 'order_items') }}
)
SELECT
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price
FROM source
WHERE order_item_id IS NOT NULL


