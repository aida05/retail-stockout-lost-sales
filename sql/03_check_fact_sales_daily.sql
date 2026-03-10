SELECT COUNT(*) AS rows_in_fact FROM fact_sales_daily;
SELECT * FROM fact_sales_daily LIMIT 5;


SELECT MIN(sales_date) AS min_date, MAX(sales_date) AS max_date
FROM fact_sales_daily;
