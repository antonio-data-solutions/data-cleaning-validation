-- Create raw table to import CSV
CREATE TABLE raw_orders (
    order_id TEXT,
    customer_name TEXT,
    email TEXT,
    order_date TEXT,
    product_name TEXT,
    category TEXT,
    quantity TEXT,
    unit_price TEXT,
    discount TEXT,
    city TEXT,
    state TEXT,
    payment_method TEXT,
    status TEXT
);