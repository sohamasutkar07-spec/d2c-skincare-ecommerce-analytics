/*
Customer and order cleaning plus the validation checks practiced in this project.
Run after importing Customers.csv and Orders.csv into customer_raw and orders_raw.
Source signup/order/delivery dates use DD-MM-YYYY.
*/
USE Skincare_analytics;

DROP TABLE IF EXISTS customers_clean;
CREATE TABLE customers_clean AS
SELECT
    TRIM(customer_id) AS customer_id,
    TRIM(customer_name) AS customer_name,
    TRIM(city) AS city,
    TRIM(state) AS state,
    TRIM(gender) AS gender,
    TRIM(age_group) AS age_group,
    STR_TO_DATE(TRIM(signup_date), '%d-%m-%Y') AS signup_date,
    TRIM(acquisition_channel) AS acquisition_channel
FROM customer_raw;

DROP TABLE IF EXISTS orders_clean;
CREATE TABLE orders_clean AS
SELECT
    TRIM(order_id) AS order_id,
    TRIM(customer_id) AS customer_id,
    STR_TO_DATE(TRIM(order_date), '%d-%m-%Y') AS order_date,
    TRIM(order_status) AS order_status,
    TRIM(payment_method) AS payment_method,
    TRIM(sales_channel) AS sales_channel,
    gross_amount,
    discount_amount,
    shipping_fee,
    final_amount,
    STR_TO_DATE(NULLIF(TRIM(delivered_date), ''), '%d-%m-%Y') AS delivered_date
FROM orders_raw;

/* Customer row count. Expected: 500. */
SELECT COUNT(*) AS total_customers
FROM customer_raw;

/* Check missing customer fields. */
SELECT
    SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(customer_name IS NULL) AS missing_customer_name,
    SUM(city IS NULL) AS missing_city,
    SUM(signup_date IS NULL) AS missing_signup_date
FROM customer_raw;

/* Check duplicate customer IDs. Expected: zero rows. */
SELECT
    customer_id,
    COUNT(*) AS duplicate_value
FROM customer_raw
GROUP BY customer_id
HAVING COUNT(*) > 1;

/* Inspect raw and converted customer dates. */
SELECT
    signup_date,
    STR_TO_DATE(signup_date, '%d-%m-%Y') AS parsed_signup_date
FROM customer_raw
LIMIT 10;

/* Orders row count. Expected: 1,250. */
SELECT COUNT(*) AS total_orders
FROM orders_clean;

/* Inspect converted order and delivery dates. */
SELECT
    order_id,
    order_date,
    delivered_date,
    order_status
FROM orders_clean
LIMIT 10;

/* Check missing/invalid order dates. Expected: zero. */
SELECT COUNT(*) AS missing_order_dates
FROM orders_clean
WHERE order_date IS NULL;

/* Order-item and order amount reconciliation for delivered orders.
   In this dataset, gross_amount matches the sum of item_total, and
   final_amount = gross_amount + shipping_fee.
*/
WITH item_totals AS (
    SELECT
        order_id,
        SUM(item_total) AS item_total_sum
    FROM order_items_raw
    GROUP BY order_id
)
SELECT
    COUNT(*) AS delivered_orders,
    SUM(CASE WHEN it.order_id IS NULL THEN 1 ELSE 0 END) AS orders_without_items,
    SUM(CASE WHEN ABS(o.gross_amount - it.item_total_sum) > 0.01 THEN 1 ELSE 0 END) AS merchandise_total_mismatches,
    SUM(CASE WHEN ABS(o.final_amount - (o.gross_amount + o.shipping_fee)) > 0.01 THEN 1 ELSE 0 END) AS final_amount_mismatches
FROM orders_clean AS o
LEFT JOIN item_totals AS it
    ON o.order_id = it.order_id
WHERE o.order_status = 'Delivered';
