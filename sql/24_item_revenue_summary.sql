DROP TABLE IF EXISTS item_lost_revenue_summary;

CREATE TABLE item_lost_revenue_summary AS
SELECT
  item_id,
  COUNT(*) AS episode_count,
  SUM(duration_days) AS total_signal_days,
  SUM(lost_units_estimate) AS total_lost_units,
  SUM(lost_revenue_estimate) AS total_lost_revenue,
  AVG(lost_revenue_estimate) AS avg_lost_revenue_per_episode
FROM lost_revenue_episode
GROUP BY item_id
ORDER BY total_lost_revenue DESC;