CREATE TABLE fact_sales (
    -- Composite Primary Key defining the grain (1 row per item in an order)
    order_id VARCHAR(50),
    order_item_id INT,
    
    -- Foreign Keys linking to Dimension Primary Keys
    customer_id VARCHAR(50) FOREIGN KEY REFERENCES dim_customers(customer_id),
    product_id VARCHAR(50) FOREIGN KEY REFERENCES dim_products(product_id),
    seller_id VARCHAR(50) FOREIGN KEY REFERENCES dim_sellers(seller_id),
    purchase_date_key INT FOREIGN KEY REFERENCES dim_date(date_key),
    
    -- Degenerate Dimension (useful attribute without its own table)
    order_status VARCHAR(20),
    
    -- MEASURES (Quantitative metrics for aggregation)
    item_price DECIMAL(10, 2),
    freight_value DECIMAL(10, 2),
    total_item_value DECIMAL(10, 2), -- Derived Measure: price + freight
    delivery_days INT,               -- Derived Measure: actual days to deliver
    
    PRIMARY KEY (order_id, order_item_id)
);

INSERT INTO fact_sales
SELECT 
    oi.order_id,
    oi.order_item_id,
    o.customer_id,
    oi.product_id,
    oi.seller_id,
    CAST(FORMAT(CAST(o.order_purchase_timestamp AS DATE), 'yyyyMMdd') AS INT) AS purchase_date_key,
    o.order_status,
    -- Measures
    oi.price AS item_price,
    oi.freight_value,
    (oi.price + oi.freight_value) AS total_item_value,
    DATEDIFF(DAY, o.order_purchase_timestamp, o.order_delivered_customer_date) AS delivery_days
FROM olist_order_items_dataset oi
INNER JOIN olist_orders_dataset o 
    ON oi.order_id = o.order_id;