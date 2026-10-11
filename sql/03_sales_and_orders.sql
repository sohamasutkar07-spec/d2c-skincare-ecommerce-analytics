/* Sales and order analyses practiced for this portfolio | MySQL 8.0+ */
USE Skincare_analytics;

/* 1. Count orders by status. */
SELECT
    order_status,
    COUNT(order_id) AS total_order
FROM orders_clean
GROUP BY order_status
ORDER BY total_order DESC;

/* 2. Percentage of all orders by status. */
SELECT
    order_status,
    COUNT(*) AS total_order,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage_of_order
FROM orders_clean
GROUP BY order_status
ORDER BY percentage_of_order DESC;

/* 3. Sum final amount for delivered orders.
   final_amount includes shipping in this dataset.
*/
SELECT
    SUM(final_amount) AS total_amount
FROM orders_clean
WHERE order_status = 'Delivered';

/* 4. Average delivered order value including shipping. */
SELECT
    ROUND(AVG(final_amount), 2) AS average_amount
FROM orders_clean
WHERE order_status = 'Delivered';

/* 5. Monthly delivered order value, newest month first. */
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
    COUNT(*) AS delivered_order,
    ROUND(SUM(final_amount), 2) AS monthly_revenue
FROM orders_clean
WHERE order_status = 'Delivered'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY sales_month DESC;

/* 6. Compare delivered orders and delivered order value in Oct 2024 and Oct 2025. */
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
    COUNT(*) AS delivered_order,
    ROUND(SUM(final_amount), 2) AS monthly_revenue
FROM orders_clean
WHERE order_status = 'Delivered'
  AND DATE_FORMAT(order_date, '%Y-%m') IN ('2024-10', '2025-10')
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY sales_month;

/* 7. Calculate the two October delivered order values using conditional aggregation. */
SELECT
    ROUND(SUM(CASE WHEN DATE_FORMAT(order_date, '%Y-%m') = '2024-10'
                   THEN final_amount ELSE 0 END), 2) AS revenue_oct_2024,
    ROUND(SUM(CASE WHEN DATE_FORMAT(order_date, '%Y-%m') = '2025-10'
                   THEN final_amount ELSE 0 END), 2) AS revenue_oct_2025
FROM orders_clean
WHERE order_status = 'Delivered';

/* 8. Percentage change in delivered order value from Oct 2024 to Oct 2025. */
SELECT
    ROUND(
        (
            SUM(CASE WHEN DATE_FORMAT(order_date, '%Y-%m') = '2025-10'
                     THEN final_amount ELSE 0 END)
            -
            SUM(CASE WHEN DATE_FORMAT(order_date, '%Y-%m') = '2024-10'
                     THEN final_amount ELSE 0 END)
        )
        /
        NULLIF(
            SUM(CASE WHEN DATE_FORMAT(order_date, '%Y-%m') = '2024-10'
                     THEN final_amount ELSE 0 END),
            0
        ) * 100,
        2
    ) AS revenue_change_pct
FROM orders_clean
WHERE order_status = 'Delivered';
