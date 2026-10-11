/* Sales and order analysis | MySQL 8.0+ */
USE Skincare_analytics;

/* 1. Order status mix across all orders. */
SELECT
    order_status,
    COUNT(*) AS total_orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage_of_orders
FROM orders_clean
GROUP BY order_status
ORDER BY total_orders DESC;

/* 2. Delivered-order KPIs.
   gross_amount = discounted merchandise amount in this dataset.
   final_amount = gross_amount + shipping_fee (verified by reconciliation).
*/
SELECT
    COUNT(*) AS delivered_orders,
    ROUND(SUM(gross_amount), 2) AS delivered_merchandise_revenue,
    ROUND(SUM(final_amount), 2) AS delivered_order_value_including_shipping,
    ROUND(AVG(final_amount), 2) AS average_delivered_order_value,
    ROUND(AVG(gross_amount), 2) AS average_merchandise_value_per_delivered_order
FROM orders_clean
WHERE order_status = 'Delivered';

/* 3. Monthly trend. Use four-digit year and numeric month for proper sorting. */
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
    COUNT(*) AS delivered_orders,
    ROUND(SUM(gross_amount), 2) AS merchandise_revenue,
    ROUND(SUM(final_amount), 2) AS order_value_including_shipping
FROM orders_clean
WHERE order_status = 'Delivered'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY sales_month;

/* 4. October 2024 vs October 2025 comparison.
   The first percentage is merchandise revenue growth; the second includes shipping.
*/
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
        SUM(gross_amount) AS merchandise_revenue,
        SUM(final_amount) AS order_value_including_shipping,
        COUNT(*) AS delivered_orders
    FROM orders_clean
    WHERE order_status = 'Delivered'
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
),
october_comparison AS (
    SELECT
        MAX(CASE WHEN sales_month = '2024-10' THEN merchandise_revenue END) AS merch_oct_2024,
        MAX(CASE WHEN sales_month = '2025-10' THEN merchandise_revenue END) AS merch_oct_2025,
        MAX(CASE WHEN sales_month = '2024-10' THEN order_value_including_shipping END) AS order_value_oct_2024,
        MAX(CASE WHEN sales_month = '2025-10' THEN order_value_including_shipping END) AS order_value_oct_2025,
        MAX(CASE WHEN sales_month = '2024-10' THEN delivered_orders END) AS orders_oct_2024,
        MAX(CASE WHEN sales_month = '2025-10' THEN delivered_orders END) AS orders_oct_2025
    FROM monthly_sales
)
SELECT
    orders_oct_2024,
    orders_oct_2025,
    ROUND(merch_oct_2024, 2) AS merchandise_revenue_oct_2024,
    ROUND(merch_oct_2025, 2) AS merchandise_revenue_oct_2025,
    ROUND((merch_oct_2025 - merch_oct_2024) * 100.0 / NULLIF(merch_oct_2024, 0), 2) AS merchandise_revenue_yoy_change_pct,
    ROUND(order_value_oct_2024, 2) AS order_value_oct_2024,
    ROUND(order_value_oct_2025, 2) AS order_value_oct_2025,
    ROUND((order_value_oct_2025 - order_value_oct_2024) * 100.0 / NULLIF(order_value_oct_2024, 0), 2) AS order_value_yoy_change_pct
FROM october_comparison;

/* 5. Delivered order counts and merchandise revenue by sales channel. */
SELECT
    sales_channel,
    COUNT(*) AS delivered_orders,
    ROUND(SUM(gross_amount), 2) AS merchandise_revenue,
    ROUND(AVG(final_amount), 2) AS average_order_value_including_shipping
FROM orders_clean
WHERE order_status = 'Delivered'
GROUP BY sales_channel
ORDER BY merchandise_revenue DESC;

/* 6. Customer acquisition channel: delivered activity among all customers. */
SELECT
    c.acquisition_channel,
    COUNT(DISTINCT c.customer_id) AS customers,
    COUNT(DISTINCT o.customer_id) AS customers_with_delivered_orders,
    COUNT(DISTINCT o.order_id) AS delivered_orders,
    ROUND(COALESCE(SUM(o.gross_amount), 0), 2) AS delivered_merchandise_revenue
FROM customers_clean AS c
LEFT JOIN orders_clean AS o
    ON c.customer_id = o.customer_id
   AND o.order_status = 'Delivered'
GROUP BY c.acquisition_channel
ORDER BY delivered_merchandise_revenue DESC;

/* 7. Repeat purchasers based on delivered orders. */
WITH customer_order_counts AS (
    SELECT customer_id, COUNT(DISTINCT order_id) AS delivered_order_count
    FROM orders_clean
    WHERE order_status = 'Delivered'
    GROUP BY customer_id
)
SELECT
    COUNT(*) AS customers_with_delivered_orders,
    SUM(delivered_order_count >= 2) AS repeat_customers,
    ROUND(SUM(delivered_order_count >= 2) * 100.0 / COUNT(*), 2) AS repeat_customer_pct
FROM customer_order_counts;
