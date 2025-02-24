WITH revenue AS (
    SELECT * FROM {{ ref('int_order_revenue') }}
), 
o2 AS (
    SELECT * FROM {{ ref('int_orders') }}
)
SELECT
    revenue.order_id,
    revenue.total_revenue,
    o2.order_status
FROM revenue
JOIN o2 
ON revenue.order_id = o2.order_id


