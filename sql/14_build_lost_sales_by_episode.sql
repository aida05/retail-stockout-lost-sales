DROP TABLE IF EXISTS lost_sales_episode;

CREATE TABLE lost_sales_episode AS
WITH signal_days AS (
  SELECT
    s.item_id,
    s.store_id,
    s.sales_date,
    s.units,
    s.prev_28d_avg,
    -- baseline proxy
    CASE
      WHEN s.prev_28d_avg IS NULL THEN 0
      ELSE s.prev_28d_avg
    END AS baseline_units,
    CASE
      WHEN s.prev_28d_avg IS NULL THEN 0
      WHEN s.prev_28d_avg > s.units THEN (s.prev_28d_avg - s.units)
      ELSE 0
    END AS lost_units
  FROM stockout_signal s
  WHERE s.is_stockout_signal = 1
),
episode_map AS (
 
  SELECT
    d.item_id,
    d.store_id,
    d.sales_date,
    e.episode_id,
    e.episode_start,
    e.episode_end,
    e.duration_days,
    d.units,
    d.baseline_units,
    d.lost_units
  FROM signal_days d
  JOIN stockout_episodes e
    ON d.item_id = e.item_id
   AND d.store_id = e.store_id
   AND d.sales_date BETWEEN e.episode_start AND e.episode_end
)
SELECT
  item_id,
  store_id,
  episode_id,
  episode_start,
  episode_end,
  duration_days,
  SUM(units) AS actual_units_during_episode,
  AVG(baseline_units) AS avg_baseline_units,
  SUM(lost_units) AS lost_units_estimate
FROM episode_map
GROUP BY
  item_id, store_id, episode_id, episode_start, episode_end, duration_days;