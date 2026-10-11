/* Returns and reviews analyses practiced for this portfolio | MySQL 8.0+ */
USE Skincare_analytics;

/* 1. Verify source table row counts. Expected: 79 returns and 494 reviews. */
SELECT COUNT(*) AS total_returns
FROM returns_raw;

SELECT COUNT(*) AS total_reviews
FROM reviews_raw;

/* 2. Count return records by reason and calculate share of all return records. */
SELECT
    return_reason,
    COUNT(*) AS total_returns,
    ROUND(
        COUNT(*) * 100.0 / NULLIF((SELECT COUNT(*) FROM returns_raw), 0),
        2
    ) AS percentage_of_returns
FROM returns_raw
GROUP BY return_reason
ORDER BY total_returns DESC;

/* 3. Count return records by recorded resolution status.
   The field includes states such as Replacement Sent and Under Review,
   so it is not exclusively a refund-status field.
*/
SELECT
    refund_status,
    COUNT(*) AS total_returns,
    ROUND(
        COUNT(*) * 100.0 / NULLIF((SELECT COUNT(*) FROM returns_raw), 0),
        2
    ) AS percentage_of_returns
FROM returns_raw
GROUP BY refund_status
ORDER BY total_returns DESC;

/* 4. Product ratings, retaining products with at least five reviews. */
SELECT
    p.product_id,
    p.product_name,
    p.category,
    COUNT(r.review_id) AS review_count,
    ROUND(AVG(r.rating), 2) AS average_rating
FROM reviews_raw AS r
INNER JOIN products_raw AS p
    ON r.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.category
HAVING COUNT(r.review_id) >= 5
ORDER BY average_rating ASC, review_count DESC;

/* 5. Count returns by product and return reason.
   These are counts, not return rates.
*/
SELECT
    p.product_id,
    p.product_name,
    p.category,
    r.return_reason,
    COUNT(r.return_id) AS total_returns
FROM returns_raw AS r
INNER JOIN products_raw AS p
    ON r.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.category, r.return_reason
ORDER BY total_returns DESC
LIMIT 10;
