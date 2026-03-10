DROP TABLE IF EXISTS store_lost_revenue_summary;

CREATE TABLE store_lost_revenue_summary AS
SELECT
  store_id,
  COUNT(*) AS episode_count,
  SUM(duration_days) AS total_signal_days,
  SUM(lost_units_estimate) AS total_lost_units,
  SUM(lost_revenue_estimate) AS total_lost_revenue,
  AVG(duration_days) AS avg_episode_duration,
  AVG(lost_revenue_estimate) AS avg_lost_revenue_per_episode
FROM lost_revenue_episode
GROUP BY store_id
ORDER BY total_lost_revenue DESC;