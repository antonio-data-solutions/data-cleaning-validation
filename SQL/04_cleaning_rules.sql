-- Insert cleaned data with rules:
-- 1) order_id: convert to integer, skip null/invalid
-- 2) order_date: standardize to DATE
-- 3) category: normalize to fixed set
-- 4) status: normalize to Paid/Pending/Cancelled
-- 5) quantity/unit_price: skip <= 0, cap quantity <= 100
-- 6) discount: default 0 when null
-- 7) email: keep as is (validation in next script)

INSERT INTO orders_clean (
    order_id,
    customer_name,
    email,
    order_date,
    product_name,
    category,
    quantity,
    unit_price,
    discount,
    city,
    state,
    payment_method,
    status
)
SELECT
    CAST(order_id AS INTEGER) AS order_id,
    customer_name,
    email,
    -- Normalize date formats
    CASE
        WHEN order_date ~ '^\d{4}-\d{2}-\d{2}$' THEN CAST(order_date AS DATE)
        WHEN order_date ~ '^\d{2}/\d{2}/\d{4}$' THEN TO_DATE(order_date, 'DD/MM/YYYY')
        WHEN order_date ~ '^\d{4}/\d{1,2}/\d{1,2}$' THEN TO_DATE(order_date, 'YYYY/MM/DD')
        ELSE NULL
    END AS order_date,
    product_name,
    -- Normalize category
    CASE
        WHEN LOWER(category) IN ('electronics', 'eletronicos', 'eletro') THEN 'Electronics'
        WHEN LOWER(category) IN ('office supplies') THEN 'Office Supplies'
        WHEN LOWER(category) IN ('home & living', 'home and living') THEN 'Home & Living'
        WHEN LOWER(category) IN ('sports') THEN 'Sports'
        ELSE category
    END AS category,
    -- Quantity: cap at 100, skip <= 0
    CASE
        WHEN CAST(quantity AS INTEGER) <= 0 THEN NULL
        WHEN CAST(quantity AS INTEGER) > 100 THEN 100
        ELSE CAST(quantity AS INTEGER)
    END AS quantity,
    -- Unit price: skip <= 0
    CASE
        WHEN CAST(unit_price AS NUMERIC) <= 0 THEN NULL
        ELSE CAST(unit_price AS NUMERIC(10,2))
    END AS unit_price,
    -- Discount: default 0
    COALESCE(CAST(discount AS NUMERIC(10,2)), 0) AS discount,
    city,
    state,
    payment_method,
    -- Normalize status
    CASE
        WHEN LOWER(status) IN ('paid', 'pago') THEN 'Paid'
        WHEN LOWER(status) IN ('pending', 'pendente') THEN 'Pending'
        WHEN LOWER(status) IN ('cancelled', 'cancelado') THEN 'Cancelled'
        ELSE status
    END AS status
FROM raw_orders
WHERE order_id ~ '^\d+$'
  AND quantity ~ '^\d+$'
  AND unit_price ~ '^\d+(\.\d+)?$'
  AND (discount IS NULL OR discount = '' OR discount ~ '^\d+(\.\d+)?$')
  AND CAST(quantity AS INTEGER) > 0
  AND CAST(unit_price AS NUMERIC) > 0;

-- Remove duplicate order_id, keeping the first occurrence
DELETE FROM orders_clean a
USING orders_clean b
WHERE a.order_id = b.order_id
  AND a.ctid > b.ctid;