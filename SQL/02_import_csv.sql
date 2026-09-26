-- Import CSV into raw_orders
-- Adjust the file path to match your system
COPY raw_orders
FROM 'D:\Database Freelancer\Potifolio\sql-portifólio\project-02-data-cleaning-validation\raw_orders.csv'
DELIMITER ','
CSV HEADER;