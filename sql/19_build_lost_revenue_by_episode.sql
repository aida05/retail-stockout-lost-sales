DROP TABLE IF EXISTS lost_revenue_episode;

CREATE TABLE lost_revenue_episode AS
WITH signal_days AS (
  SELECT
    s.item_id,
    s.store_id,
    s.sales_date,
    s.units,
    s.prev_28d_avg,
    CASE
      WHEN s.prev_28d_avg IS NULL THEN 0
      WHEN s.prev_28d_avg > s.units THEN (s.prev_28d_avg - s.units)
      ELSE 0
    END AS lost_units
  FROM stockout_signal s
  WHERE s.is_stockout_signal = 1
),
signal_with_week AS (
  SELECT
    d.*,
    c.wm_yr_wk
  FROM signal_days d
  JOIN calendar c
    ON c.date::DATE = d.sales_date
),
priced AS (
  SELECT
    w.*,
    p.sell_price
  FROM signal_with_week w
  LEFT JOIN sell_prices p
    ON p.store_id = w.store_id
   AND p.item_id = w.item_id
   AND p.wm_yr_wk = w.wm_yr_wk
),
episode_map AS (
  SELECT
    p.item_id,
    p.store_id,
    p.sales_date,
    e.episode_id,
    e.episode_start,
    e.episode_end,
    e.duration_days,
    p.lost_units,
    p.sell_price,
    (p.lost_units * COALESCE(p.sell_price, 0)) AS lost_revenue
  FROM priced p
  JOIN stockout_episodes e
    ON p.item_id = e.item_id
   AND p.store_id = e.store_id
   AND p.sales_date BETWEEN e.episode_start AND e.episode_end
)
SELECT
  item_id,
  store_id,
  episode_id,
  episode_start,
  episode_end,
  duration_days,
  SUM(lost_units) AS lost_units_estimate,
  SUM(lost_revenue) AS lost_revenue_estimate
FROM episode_map
GROUP BY item_id, store_id, episode_id, episode_start, episode_end, duration_days;