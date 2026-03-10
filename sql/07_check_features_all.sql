SELECT COUNT(*) AS total_rows
FROM daily_sales_features_all;

SELECT COUNT(DISTINCT store_id) AS stores_loaded
FROM daily_sales_features_all;

SELECT MIN(sales_date) AS min_date, MAX(sales_date) AS max_date
FROM daily_sales_features_all;