-- 1. Customer Dimension
CREATE TABLE dim_customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state CHAR(2)
);

INSERT INTO dim_customers
SELECT DISTINCT 
    customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state
FROM olist_customers_dataset;

-- 2. Product Dimension (Enriched with English category names if available)
CREATE TABLE dim_products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

INSERT INTO dim_products
SELECT DISTINCT 
    product_id, product_category_name, product_weight_g, product_length_cm, product_height_cm, product_width_cm
FROM olist_products_dataset;

-- 3. Seller Dimension
CREATE TABLE dim_sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(100),
    seller_state CHAR(2)
);

INSERT INTO dim_sellers
SELECT DISTINCT 
    seller_id, seller_zip_code_prefix, seller_city, seller_state
FROM olist_sellers_dataset;

-- 4. Date Dimension (Generated from order purchase dates)
CREATE TABLE dim_date (
    date_key INT PRIMARY KEY, -- Format: YYYYMMDD
    full_date DATE,
    year INT,
    quarter INT,
    month INT,
    month_name VARCHAR(20),
    day_of_week VARCHAR(20)
);

INSERT INTO dim_date
SELECT DISTINCT
    CAST(FORMAT(CAST(order_purchase_timestamp AS DATE), 'yyyyMMdd') AS INT) AS date_key,
    CAST(order_purchase_timestamp AS DATE) AS full_date,
    YEAR(order_purchase_timestamp) AS year,
    DATEPART(QUARTER, order_purchase_timestamp) AS quarter,
    MONTH(order_purchase_timestamp) AS month,
    DATENAME(MONTH, order_purchase_timestamp) AS month_name,
    DATENAME(WEEKDAY, order_purchase_timestamp) AS day_of_week
FROM olist_orders_dataset
WHERE order_purchase_timestamp IS NOT NULL;