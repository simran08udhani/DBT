WITH c AS (
    SELECT * FROM {{ ref('int_orders') }}
)
SELECT
    cust_id,
    customer_full_name,
    email,
    created_at
FROM c





