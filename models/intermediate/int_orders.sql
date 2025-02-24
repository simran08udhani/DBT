WITH o AS (
    SELECT * FROM {{ ref('stg_orders') }}
),
c AS (
    SELECT * FROM {{ ref('stg_customers') }}
)
SELECT
    o.order_id,
    o.cust_id,
    o.order_date,
    o.order_status,
    o.total_amount,
    c.email,
    c.first_name || ' ' || c.last_name AS customer_full_name,
    c.created_at
FROM o
LEFT JOIN c ON o.cust_id = c.cust_id
WHERE o.order_status != 'canceled'




