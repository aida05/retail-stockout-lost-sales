SELECT COUNT(*) AS episode_count
FROM stockout_episodes;

SELECT
  MIN(duration_days) AS min_duration,
  MAX(duration_days) AS max_duration,
  AVG(duration_days) AS avg_duration
FROM stockout_episodes;

-- Top episodes by duration
SELECT *
FROM stockout_episodes
ORDER BY duration_days DESC
LIMIT 10;