/* Product analyses practiced for this portfolio | MySQL 8.0+ */
USE Skincare_analytics;

/* 1. Inspect product records. Expected: 28 products. */
SELECT COUNT(*) AS total_products
FROM products_raw;

SELECT *
FROM products_raw
LIMIT 10;

/* 2. First JOIN: show product names for individual order items. */
SELECT
    oi.order_item_id,
    oi.product_id,
    p.product_name,
    oi.quantity,
    oi.item_total
FROM order_items_raw AS oi
INNER JOIN products_raw AS p
    ON oi.product_id = p.product_id
LIMIT 10;

/* 3. Top 10 products by delivered merchandise revenue and share of all product revenue.
   item_total is the discounted merchandise total and excludes shipping.
*/
SELECT
    p.product_id,
    p.product_name,
    ROUND(SUM(oi.item_total), 2) AS product_revenue,
    ROUND(
        SUM(oi.item_total) * 100.0
        / NULLIF(SUM(SUM(oi.item_total)) OVER (), 0),
        2
    ) AS revenue_contribution_pct
FROM order_items_raw AS oi
INNER JOIN orders_clean AS o
    ON oi.order_id = o.order_id
INNER JOIN products_raw AS p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name
ORDER BY product_revenue DESC
LIMIT 10;

/* 4. Top 10 products by estimated gross profit.
   Assumption: products_raw.cost_price is cost per unit.
   Estimate excludes operating expenses and is not net profit.
*/
SELECT
    p.product_id,
    p.product_name,
    ROUND(SUM(oi.item_total), 2) AS product_revenue,
    ROUND(SUM(oi.quantity * p.cost_price), 2) AS estimated_cogs,
    ROUND(
        SUM(oi.item_total) - SUM(oi.quantity * p.cost_price),
        2
    ) AS estimated_gross_profit,
    ROUND(
        (
            SUM(oi.item_total) - SUM(oi.quantity * p.cost_price)
        ) * 100.0 / NULLIF(SUM(oi.item_total), 0),
        2
    ) AS estimated_gross_margin_pct
FROM order_items_raw AS oi
INNER JOIN orders_clean AS o
    ON oi.order_id = o.order_id
INNER JOIN products_raw AS p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name
ORDER BY estimated_gross_profit DESC
LIMIT 10;
