/* Customer experience: returns and reviews | MySQL 8.0+ */
USE Skincare_analytics;

/* 1. Return reason counts and share of all return records. */
SELECT
    return_reason,
    COUNT(*) AS total_returns,
    ROUND(COUNT(*) * 100.0 / NULLIF((SELECT COUNT(*) FROM returns_clean), 0), 2) AS percentage_of_returns
FROM returns_clean
GROUP BY return_reason
ORDER BY total_returns DESC;

/* 2. Recorded return-resolution status. This column includes replacement and review states, not only refunds. */
SELECT
    refund_status AS recorded_resolution_status,
    COUNT(*) AS return_records,
    ROUND(COUNT(*) * 100.0 / NULLIF((SELECT COUNT(*) FROM returns_clean), 0), 2) AS percentage_of_returns
FROM returns_clean
GROUP BY refund_status
ORDER BY return_records DESC;

/* 3. Lowest-rated products with at least five reviews. */
SELECT
    p.product_id,
    p.product_name,
    p.category,
    COUNT(r.review_id) AS review_count,
    ROUND(AVG(r.rating), 2) AS average_rating
FROM reviews_clean AS r
INNER JOIN products_clean AS p ON r.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.category
HAVING COUNT(r.review_id) >= 5
ORDER BY average_rating ASC, review_count DESC;

/* 4. Average rating and review volume by category. */
SELECT
    p.category,
    COUNT(r.review_id) AS review_count,
    ROUND(AVG(r.rating), 2) AS average_rating
FROM reviews_clean AS r
INNER JOIN products_clean AS p ON r.product_id = p.product_id
GROUP BY p.category
ORDER BY average_rating DESC;

/* 5. Compare product-level return counts and ratings without join fan-out.
   Aggregating each table before joining prevents reviews from being duplicated
   by multiple return records (and vice versa). This is descriptive, not causal.
*/
WITH product_returns AS (
    SELECT product_id, COUNT(*) AS return_records
    FROM returns_clean
    GROUP BY product_id
),
product_reviews AS (
    SELECT
        product_id,
        COUNT(*) AS review_records,
        AVG(rating) AS average_rating
    FROM reviews_clean
    GROUP BY product_id
)
SELECT
    p.product_id,
    p.product_name,
    COALESCE(pr.return_records, 0) AS return_records,
    COALESCE(pv.review_records, 0) AS review_records,
    ROUND(pv.average_rating, 2) AS average_rating
FROM products_clean AS p
LEFT JOIN product_returns AS pr ON p.product_id = pr.product_id
LEFT JOIN product_reviews AS pv ON p.product_id = pv.product_id
ORDER BY return_records DESC, review_records DESC;
