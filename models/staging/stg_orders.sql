WITH source AS (
    SELECT * FROM {{ source('raw_data', 'orders') }}
)
SELECT
    order_id,
    customer_id AS cust_id,
    order_date,
    LOWER(order_status) AS order_status,
    total_amount
FROM source
WHERE order_id IS NOT NULL



