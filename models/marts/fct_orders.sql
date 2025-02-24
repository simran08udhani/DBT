WITH o1 AS (
    SELECT * FROM {{ ref('int_orders') }}
)
SELECT
    order_id,
    cust_id,
    order_date,
    total_amount,
    customer_full_name,
    EXTRACT(YEAR FROM order_date) AS order_year
FROM o1


