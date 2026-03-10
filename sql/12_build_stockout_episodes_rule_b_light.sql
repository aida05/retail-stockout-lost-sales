DROP TABLE IF EXISTS stockout_episodes;

CREATE TABLE stockout_episodes AS
WITH signal_days AS (
  SELECT
    item_id,
    store_id,
    sales_date
  FROM stockout_signal
  WHERE is_stockout_signal = 1
),
gaps AS (
  SELECT
    item_id,
    store_id,
    sales_date,
    LAG(sales_date) OVER (
      PARTITION BY item_id, store_id
      ORDER BY sales_date
    ) AS prev_date
  FROM signal_days
),
marked AS (
  SELECT
    item_id,
    store_id,
    sales_date,
    CASE
      WHEN prev_date IS NULL THEN 1
      WHEN DATE_DIFF('day', prev_date, sales_date) > 1 THEN 1
      ELSE 0
    END AS is_new_episode
  FROM gaps
),
episode_ids AS (
  SELECT
    item_id,
    store_id,
    sales_date,
    SUM(is_new_episode) OVER (
      PARTITION BY item_id, store_id
      ORDER BY sales_date
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS episode_id
  FROM marked
)
SELECT
  item_id,
  store_id,
  episode_id,
  MIN(sales_date) AS episode_start,
  MAX(sales_date) AS episode_end,
  DATE_DIFF('day', MIN(sales_date), MAX(sales_date)) + 1 AS duration_days,
  COUNT(*) AS signal_days_in_episode
FROM episode_ids
GROUP BY item_id, store_id, episode_id;