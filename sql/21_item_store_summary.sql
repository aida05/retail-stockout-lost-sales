DROP TABLE IF EXISTS item_store_lost_sales_summary;

CREATE TABLE item_store_lost_sales_summary AS
SELECT
  item_id,
  store_id,
  COUNT(*) AS episode_count,
  SUM(duration_days) AS total_signal_days,
  SUM(lost_units_estimate) AS total_lost_units,
  AVG(lost_units_estimate) AS avg_lost_units_per_episode
FROM lost_sales_episode
GROUP BY item_id, store_id
ORDER BY total_lost_units DESC;