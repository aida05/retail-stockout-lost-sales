SELECT COUNT(*) AS row_count
FROM daily_sales_features;

SELECT *
FROM daily_sales_features
LIMIT 10;

SELECT
    MIN(prev_7d_avg) AS min_prev_7d_avg,
    MAX(prev_7d_avg) AS max_prev_7d_avg,
    MIN(prev_28d_avg) AS min_prev_28d_avg,
    MAX(prev_28d_avg) AS max_prev_28d_avg
FROM daily_sales_features;
