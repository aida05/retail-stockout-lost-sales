DROP TABLE IF EXISTS stockout_episodes;

CREATE TABLE stockout_episodes AS
WITH signals AS (
  SELECT
    item_id,
    store_id,
    sales_date,
    is_stockout_signal,
    -- previous day's signal
    LAG(is_stockout_signal, 1, 0) OVER (
      PARTITION BY item_id, store_id
      ORDER BY sales_date
    ) AS prev_signal
  FROM stockout_signal
),
starts AS (
  SELECT
    item_id,
    store_id,
    sales_date,
    -- start of episode: today is 1 and yesterday was 0
    CASE WHEN is_stockout_signal = 1 AND prev_signal = 0 THEN 1 ELSE 0 END AS is_start
  FROM signals
),
episode_ids AS (
  SELECT
    item_id,
    store_id,
    sales_date,
    -- cumulative sum of starts gives an episode id (within each item-store)
    SUM(is_start) OVER (
      PARTITION BY item_id, store_id
      ORDER BY sales_date
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS episode_id,
    is_start
  FROM starts
  WHERE sales_date IS NOT NULL
),
only_signal_days AS (
  SELECT
    e.item_id,
    e.store_id,
    e.episode_id,
    e.sales_date
  FROM episode_ids e
  JOIN stockout_signal s
    ON s.item_id = e.item_id AND s.store_id = e.store_id AND s.sales_date = e.sales_date
  WHERE s.is_stockout_signal = 1
)
SELECT
  item_id,
  store_id,
  episode_id,
  MIN(sales_date) AS episode_start,
  MAX(sales_date) AS episode_end,
  (MAX(sales_date) - MIN(sales_date) + 1) AS duration_days
FROM only_signal_days
GROUP BY item_id, store_id, episode_id;