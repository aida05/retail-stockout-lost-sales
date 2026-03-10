-- 1) Coverage: how many rows have enough history (prev_28d_avg not null)?
SELECT
  COUNT(*) AS total_rows,
  SUM(CASE WHEN prev_28d_avg IS NULL THEN 1 ELSE 0 END) AS rows_prev28_null,
  SUM(CASE WHEN prev_28d_avg IS NOT NULL THEN 1 ELSE 0 END) AS rows_prev28_available
FROM daily_sales_features_all;

-- 2) Percentiles for prev_28d_avg (only where it's available)
SELECT
  quantile_cont(prev_28d_avg, 0.50) AS p50,
  quantile_cont(prev_28d_avg, 0.75) AS p75,
  quantile_cont(prev_28d_avg, 0.90) AS p90,
  quantile_cont(prev_28d_avg, 0.95) AS p95,
  quantile_cont(prev_28d_avg, 0.99) AS p99
FROM daily_sales_features_all
WHERE prev_28d_avg IS NOT NULL;

-- 3) How many rows fall into meaningful bands?
SELECT
  SUM(CASE WHEN prev_28d_avg < 0.1 THEN 1 ELSE 0 END) AS lt_0_1,
  SUM(CASE WHEN prev_28d_avg >= 0.1 AND prev_28d_avg < 0.5 THEN 1 ELSE 0 END) AS _0_1_to_0_5,
  SUM(CASE WHEN prev_28d_avg >= 0.5 AND prev_28d_avg < 1 THEN 1 ELSE 0 END) AS _0_5_to_1,
  SUM(CASE WHEN prev_28d_avg >= 1 AND prev_28d_avg < 2 THEN 1 ELSE 0 END) AS _1_to_2,
  SUM(CASE WHEN prev_28d_avg >= 2 THEN 1 ELSE 0 END) AS gte_2
FROM daily_sales_features_all
WHERE prev_28d_avg IS NOT NULL;