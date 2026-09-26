-- Before/after summary

-- Total rows
SELECT
    (SELECT COUNT(*) FROM raw_orders) AS raw_rows,
    (SELECT COUNT(*) FROM orders_clean) AS clean_rows,
    (SELECT COUNT(*) FROM raw_orders) - (SELECT COUNT(*) FROM orders_clean) AS rows_removed;

-- Duplicates removed (approx): count duplicated order_id in raw
SELECT COUNT(*) AS duplicate_order_ids_in_raw
FROM (
    SELECT order_id
    FROM raw_orders
    GROUP BY order_id
    HAVING COUNT(*) > 1
) t;

-- Null emails before and after
SELECT
    (SELECT COUNT(*) FROM raw_orders WHERE email IS NULL OR email = '') AS raw_null_emails,
    (SELECT COUNT(*) FROM orders_clean WHERE email IS NULL) AS clean_null_emails;

-- Category distribution after cleaning
SELECT category, COUNT(*) AS row_count
FROM orders_clean
GROUP BY category
ORDER BY row_count DESC;

-- Status distribution after cleaning
SELECT status, COUNT(*) AS row_count
FROM orders_clean
GROUP BY status
ORDER BY row_count DESC;