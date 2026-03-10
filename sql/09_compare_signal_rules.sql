WITH base AS (
  SELECT *
  FROM daily_sales_features_all
  WHERE prev_28d_avg IS NOT NULL
)
SELECT
  'Rule_A' AS rule_name,
  COUNT(*) FILTER (WHERE units = 0 AND days_with_sales_last_28d >= 7 AND prev_28d_avg >= 0.5) AS signal_days,
  COUNT(*) AS total_days,
  1.0 * COUNT(*) FILTER (WHERE units = 0 AND days_with_sales_last_28d >= 7 AND prev_28d_avg >= 0.5) / COUNT(*) AS signal_rate
FROM base

UNION ALL
SELECT
  'Rule_B',
  COUNT(*) FILTER (WHERE units = 0 AND days_with_sales_last_28d >= 10 AND prev_28d_avg >= 1.0),
  COUNT(*),
  1.0 * COUNT(*) FILTER (WHERE units = 0 AND days_with_sales_last_28d >= 10 AND prev_28d_avg >= 1.0) / COUNT(*)
FROM base

UNION ALL
SELECT
  'Rule_C',
  COUNT(*) FILTER (WHERE units = 0 AND days_with_sales_last_28d >= 14 AND prev_28d_avg >= 2.0),
  COUNT(*),
  1.0 * COUNT(*) FILTER (WHERE units = 0 AND days_with_sales_last_28d >= 14 AND prev_28d_avg >= 2.0) / COUNT(*)
FROM base;