DROP TABLE IF EXISTS daily_sales_features_ca1;


CREATE TABLE daily_sales_features_ca1 AS
SELECT
    item_id,
    store_id,
    sales_date,
    units,
    CASE WHEN units = 0 THEN 1 ELSE 0 END AS is_zero_sales_day,

    AVG(units) OVER (
        PARTITION BY item_id, store_id
        ORDER BY sales_date
        ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING
    ) AS prev_7d_avg,

    AVG(units) OVER (
        PARTITION BY item_id, store_id
        ORDER BY sales_date
        ROWS BETWEEN 28 PRECEDING AND 1 PRECEDING
    ) AS prev_28d_avg,

    SUM(CASE WHEN units > 0 THEN 1 ELSE 0 END) OVER (
        PARTITION BY item_id, store_id
        ORDER BY sales_date
        ROWS BETWEEN 28 PRECEDING AND 1 PRECEDING
    ) AS days_with_sales_last_28d
FROM fact_sales_daily
WHERE store_id = 'CA_1';