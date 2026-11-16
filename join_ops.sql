-- 1. INNER JOIN: Calculate total revenue and shipping cost per product category for completed sales.
SELECT 
    p.product_category_name,
    COUNT(oi.order_item_id) AS total_items_sold,
    SUM(oi.price) AS total_revenue,
    SUM(oi.freight_value) AS total_freight
FROM olist_order_items_dataset oi
INNER JOIN olist_products_dataset p 
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC;

-- 2. LEFT JOIN: Find all delivered orders that have not yet received a customer review (to target follow-up emails).
SELECT 
    o.order_id,
    o.customer_id,
    o.order_delivered_customer_date
FROM olist_orders_dataset o
LEFT JOIN olist_order_reviews_dataset r 
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered' 
  AND r.review_id IS NULL;

-- 3. RIGHT JOIN: Find all orders that never received a customer review.
SELECT 
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp
FROM olist_order_reviews_dataset r
RIGHT JOIN olist_orders_dataset o 
    ON r.order_id = o.order_id
WHERE r.review_id IS NULL;


-- 4. FULL OUTER JOIN: Audit geographic coverage by comparing cities where customers live vs. cities where sellers operate.
-- FULL OUTER JOIN: Audit geographic coverage by comparing cities where customers live vs. cities where sellers operate.
-- FULL OUTER JOIN: Reconcile total billed order items against total customer payments to catch underpaid or overpaid orders.
SELECT 
    COALESCE(i.order_id, p.order_id) AS order_id,
    ISNULL(i.total_billed, 0) AS total_billed,
    ISNULL(p.total_paid, 0) AS total_paid,
    ISNULL(p.total_paid, 0) - ISNULL(i.total_billed, 0) AS variance
FROM (
    SELECT order_id, SUM(price + freight_value) AS total_billed
    FROM olist_order_items_dataset
    GROUP BY order_id
) i
FULL OUTER JOIN (
    SELECT order_id, SUM(payment_value) AS total_paid
    FROM olist_order_payments_dataset
    GROUP BY order_id
) p
    ON i.order_id = p.order_id
WHERE ABS(ISNULL(p.total_paid, 0) - ISNULL(i.total_billed, 0)) > 0.01
ORDER BY ABS(ISNULL(p.total_paid, 0) - ISNULL(i.total_billed, 0)) DESC;