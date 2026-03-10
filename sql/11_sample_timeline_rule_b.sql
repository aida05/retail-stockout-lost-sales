-- pick one item-store with signals and inspect around them
WITH candidates AS (
  SELECT item_id, store_id
  FROM stockout_signal
  WHERE is_stockout_signal = 1
  GROUP BY 1,2
  ORDER BY COUNT(*) DESC
  LIMIT 1
)
SELECT s.*
FROM stockout_signal s
JOIN candidates c
  ON s.item_id = c.item_id AND s.store_id = c.store_id
ORDER BY sales_date
LIMIT 120;