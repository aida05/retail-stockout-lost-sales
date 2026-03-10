SELECT COUNT(*) AS episode_rows
FROM lost_sales_episode;

SELECT
  MIN(lost_units_estimate) AS min_lost,
  MAX(lost_units_estimate) AS max_lost,
  AVG(lost_units_estimate) AS avg_lost
FROM lost_sales_episode;

-- biggest lost sales episodes
SELECT *
FROM lost_sales_episode
ORDER BY lost_units_estimate DESC
LIMIT 10;