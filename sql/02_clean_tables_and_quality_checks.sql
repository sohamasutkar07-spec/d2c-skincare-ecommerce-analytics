/*
Run after all six CSV files have been imported into their raw tables.
This file rebuilds only the *_clean tables. Raw staging tables remain unchanged.
Date strings in the source use DD-MM-YYYY format.
*/
USE Skincare_analytics;

DROP TABLE IF EXISTS customers_clean;
CREATE TABLE customers_clean AS
SELECT
    TRIM(customer_id) AS customer_id,
    NULLIF(TRIM(customer_name), '') AS customer_name,
    NULLIF(TRIM(city), '') AS city,
    NULLIF(TRIM(state), '') AS state,
    NULLIF(TRIM(gender), '') AS gender,
    NULLIF(TRIM(age_group), '') AS age_group,
    STR_TO_DATE(NULLIF(TRIM(signup_date), ''), '%d-%m-%Y') AS signup_date,
    NULLIF(TRIM(acquisition_channel), '') AS acquisition_channel
FROM customer_raw;

DROP TABLE IF EXISTS orders_clean;
CREATE TABLE orders_clean AS
SELECT
    TRIM(order_id) AS order_id,
    TRIM(customer_id) AS customer_id,
    STR_TO_DATE(NULLIF(TRIM(order_date), ''), '%d-%m-%Y') AS order_date,
    TRIM(order_status) AS order_status,
    NULLIF(TRIM(payment_method), '') AS payment_method,
    NULLIF(TRIM(sales_channel), '') AS sales_channel,
    gross_amount,
    discount_amount,
    shipping_fee,
    final_amount,
    STR_TO_DATE(NULLIF(TRIM(delivered_date), ''), '%d-%m-%Y') AS delivered_date
FROM orders_raw;

DROP TABLE IF EXISTS products_clean;
CREATE TABLE products_clean AS
SELECT
    TRIM(product_id) AS product_id,
    TRIM(product_name) AS product_name,
    TRIM(category) AS category,
    NULLIF(TRIM(concern), '') AS concern,
    NULLIF(TRIM(skin_type), '') AS skin_type,
    NULLIF(TRIM(key_ingredient), '') AS key_ingredient,
    NULLIF(TRIM(size), '') AS size,
    mrp,
    cost_price,
    stock_qty,
    STR_TO_DATE(NULLIF(TRIM(launch_date), ''), '%d-%m-%Y') AS launch_date
FROM products_raw;

DROP TABLE IF EXISTS order_items_clean;
CREATE TABLE order_items_clean AS
SELECT
    TRIM(order_item_id) AS order_item_id,
    TRIM(order_id) AS order_id,
    TRIM(product_id) AS product_id,
    quantity,
    unit_price,
    discount_pct,
    item_total
FROM order_items_raw;

DROP TABLE IF EXISTS returns_clean;
CREATE TABLE returns_clean AS
SELECT
    TRIM(return_id) AS return_id,
    TRIM(order_id) AS order_id,
    TRIM(product_id) AS product_id,
    STR_TO_DATE(NULLIF(TRIM(return_date), ''), '%d-%m-%Y') AS return_date,
    TRIM(return_reason) AS return_reason,
    TRIM(refund_status) AS refund_status
FROM returns_raw;

DROP TABLE IF EXISTS reviews_clean;
CREATE TABLE reviews_clean AS
SELECT
    TRIM(review_id) AS review_id,
    TRIM(customer_id) AS customer_id,
    TRIM(product_id) AS product_id,
    TRIM(order_id) AS order_id,
    rating,
    STR_TO_DATE(NULLIF(TRIM(review_date), ''), '%d-%m-%Y') AS review_date
FROM reviews_raw;

/* A. Verify row counts. Expected row counts from supplied synthetic data:
   customer_raw 500, orders_raw 1250, products_raw 28,
   order_items_raw 2042, returns_raw 79, reviews_raw 494.
*/
SELECT 'customers_clean' AS table_name, COUNT(*) AS row_count FROM customers_clean
UNION ALL SELECT 'orders_clean', COUNT(*) FROM orders_clean
UNION ALL SELECT 'products_clean', COUNT(*) FROM products_clean
UNION ALL SELECT 'order_items_clean', COUNT(*) FROM order_items_clean
UNION ALL SELECT 'returns_clean', COUNT(*) FROM returns_clean
UNION ALL SELECT 'reviews_clean', COUNT(*) FROM reviews_clean;

/* B. Check missing key IDs and invalid / missing dates. */
SELECT
    SUM(customer_id IS NULL OR customer_id = '') AS missing_customer_ids,
    SUM(signup_date IS NULL) AS invalid_or_missing_signup_dates
FROM customers_clean;

SELECT
    SUM(order_id IS NULL OR order_id = '') AS missing_order_ids,
    SUM(customer_id IS NULL OR customer_id = '') AS missing_customer_ids,
    SUM(order_date IS NULL) AS invalid_or_missing_order_dates
FROM orders_clean;

SELECT
    SUM(product_id IS NULL OR product_id = '') AS missing_product_ids,
    SUM(launch_date IS NULL) AS invalid_or_missing_launch_dates
FROM products_clean;

SELECT
    SUM(return_id IS NULL OR return_id = '') AS missing_return_ids,
    SUM(return_date IS NULL) AS invalid_or_missing_return_dates
FROM returns_clean;

SELECT
    SUM(review_id IS NULL OR review_id = '') AS missing_review_ids,
    SUM(review_date IS NULL) AS invalid_or_missing_review_dates,
    SUM(rating IS NULL OR rating NOT BETWEEN 1 AND 5) AS invalid_ratings
FROM reviews_clean;

/* C. Duplicate-key checks: each query should return zero rows. */
SELECT customer_id, COUNT(*) AS records
FROM customers_clean
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT order_id, COUNT(*) AS records
FROM orders_clean
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT product_id, COUNT(*) AS records
FROM products_clean
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT order_item_id, COUNT(*) AS records
FROM order_items_clean
GROUP BY order_item_id
HAVING COUNT(*) > 1;

/* D. Referential integrity checks: each query should return zero rows. */
SELECT o.order_id, o.customer_id
FROM orders_clean AS o
LEFT JOIN customers_clean AS c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT oi.order_item_id, oi.order_id
FROM order_items_clean AS oi
LEFT JOIN orders_clean AS o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT oi.order_item_id, oi.product_id
FROM order_items_clean AS oi
LEFT JOIN products_clean AS p ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

/* E. Reconcile order totals for delivered orders. */
WITH item_totals AS (
    SELECT order_id, SUM(item_total) AS item_total_sum
    FROM order_items_clean
    GROUP BY order_id
)
SELECT
    COUNT(*) AS delivered_orders,
    SUM(it.order_id IS NULL) AS orders_without_items,
    SUM(CASE WHEN it.order_id IS NOT NULL
              AND ABS(o.gross_amount - it.item_total_sum) > 0.01
             THEN 1 ELSE 0 END) AS merchandise_total_mismatches,
    SUM(CASE WHEN ABS(o.final_amount - (o.gross_amount + o.shipping_fee)) > 0.01
             THEN 1 ELSE 0 END) AS final_amount_mismatches
FROM orders_clean AS o
LEFT JOIN item_totals AS it ON o.order_id = it.order_id
WHERE o.order_status = 'Delivered';
