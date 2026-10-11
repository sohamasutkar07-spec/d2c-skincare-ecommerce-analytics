/* Product performance analysis | MySQL 8.0+ */
USE Skincare_analytics;

/* Metric definitions:
   Product revenue = sum of discounted item_total for delivered orders.
   Estimated COGS = quantity * product cost_price, assuming cost_price is per unit.
   Estimated gross profit excludes shipping, marketing, fulfilment overhead and other OPEX.
*/

/* 1. Top 10 products by delivered merchandise revenue and share of all product revenue. */
WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        SUM(oi.quantity) AS units_sold,
        SUM(oi.item_total) AS product_revenue
    FROM order_items_clean AS oi
    INNER JOIN orders_clean AS o ON oi.order_id = o.order_id
    INNER JOIN products_clean AS p ON oi.product_id = p.product_id
    WHERE o.order_status = 'Delivered'
    GROUP BY p.product_id, p.product_name, p.category
)
SELECT
    product_id,
    product_name,
    category,
    units_sold,
    ROUND(product_revenue, 2) AS product_revenue,
    ROUND(product_revenue * 100.0 / NULLIF(SUM(product_revenue) OVER (), 0), 2) AS revenue_contribution_pct
FROM product_sales
ORDER BY product_revenue DESC
LIMIT 10;

/* 2. Top 10 products by estimated gross profit. */
WITH product_economics AS (
    SELECT
        p.product_id,
        p.product_name,
        p.category,
        SUM(oi.quantity) AS units_sold,
        SUM(oi.item_total) AS product_revenue,
        SUM(oi.quantity * p.cost_price) AS estimated_cogs,
        SUM(oi.item_total) - SUM(oi.quantity * p.cost_price) AS estimated_gross_profit
    FROM order_items_clean AS oi
    INNER JOIN orders_clean AS o ON oi.order_id = o.order_id
    INNER JOIN products_clean AS p ON oi.product_id = p.product_id
    WHERE o.order_status = 'Delivered'
    GROUP BY p.product_id, p.product_name, p.category
)
SELECT
    product_id,
    product_name,
    category,
    units_sold,
    ROUND(product_revenue, 2) AS product_revenue,
    ROUND(estimated_cogs, 2) AS estimated_cogs,
    ROUND(estimated_gross_profit, 2) AS estimated_gross_profit,
    ROUND(estimated_gross_profit * 100.0 / NULLIF(product_revenue, 0), 2) AS estimated_gross_margin_pct
FROM product_economics
ORDER BY estimated_gross_profit DESC
LIMIT 10;

/* 3. Category performance. */
SELECT
    p.category,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.item_total), 2) AS merchandise_revenue,
    ROUND(SUM(oi.quantity * p.cost_price), 2) AS estimated_cogs,
    ROUND(SUM(oi.item_total) - SUM(oi.quantity * p.cost_price), 2) AS estimated_gross_profit,
    ROUND((SUM(oi.item_total) - SUM(oi.quantity * p.cost_price)) * 100.0 / NULLIF(SUM(oi.item_total), 0), 2) AS estimated_gross_margin_pct
FROM order_items_clean AS oi
INNER JOIN orders_clean AS o ON oi.order_id = o.order_id
INNER JOIN products_clean AS p ON oi.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.category
ORDER BY merchandise_revenue DESC;

/* 4. Return counts by product and reason. Counts are not return rates. */
SELECT
    p.product_id,
    p.product_name,
    p.category,
    r.return_reason,
    COUNT(*) AS return_records
FROM returns_clean AS r
INNER JOIN products_clean AS p ON r.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.category, r.return_reason
ORDER BY return_records DESC, p.product_name
LIMIT 10;
