-- Validation checks after cleaning

-- 1) Count rows
SELECT 'raw_orders' AS table_name, COUNT(*) AS row_count FROM raw_orders
UNION ALL
SELECT 'orders_clean', COUNT(*) FROM orders_clean;

-- 2) Nulls per column in orders_clean
SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN customer_name IS NULL THEN 1 ELSE 0 END) AS null_customer_name,
    SUM(CASE WHEN email IS NULL THEN 1 ELSE 0 END) AS null_email,
    SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS null_order_date,
    SUM(CASE WHEN product_name IS NULL THEN 1 ELSE 0 END) AS null_product_name,
    SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS null_category,
    SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS null_quantity,
    SUM(CASE WHEN unit_price IS NULL THEN 1 ELSE 0 END) AS null_unit_price,
    SUM(CASE WHEN discount IS NULL THEN 1 ELSE 0 END) AS null_discount,
    SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS null_city,
    SUM(CASE WHEN state IS NULL THEN 1 ELSE 0 END) AS null_state,
    SUM(CASE WHEN payment_method IS NULL THEN 1 ELSE 0 END) AS null_payment_method,
    SUM(CASE WHEN status IS NULL THEN 1 ELSE 0 END) AS null_status
FROM orders_clean;

-- 3) Duplicate order_id in clean table
SELECT order_id, COUNT(*) AS dup_count
FROM orders_clean
GROUP BY order_id
HAVING COUNT(*) > 1;

-- 4) Invalid emails (simple check: must contain '@' and '.')
SELECT email
FROM orders_clean
WHERE email IS NOT NULL
  AND (email NOT LIKE '%@%.%');

-- 5) Quantity and unit_price ranges
SELECT
    MIN(quantity) AS min_qty,
    MAX(quantity) AS max_qty,
    MIN(unit_price) AS min_price,
    MAX(unit_price) AS max_price
FROM orders_clean;