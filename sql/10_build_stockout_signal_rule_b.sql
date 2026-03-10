DROP TABLE IF EXISTS stockout_signal;

CREATE TABLE stockout_signal AS
SELECT
  item_id,
  store_id,
  sales_date,
  units,
  prev_28d_avg,
  days_with_sales_last_28d,
  CASE
    WHEN units = 0
     AND days_with_sales_last_28d >= 10
     AND prev_28d_avg >= 1.0
    THEN 1 ELSE 0
  END AS is_stockout_signal
FROM daily_sales_features_all
WHERE prev_28d_avg IS NOT NULL;