SELECT COUNT(*) AS episode_rows
FROM lost_revenue_episode;

SELECT *
FROM lost_revenue_episode
ORDER BY lost_revenue_estimate DESC
LIMIT 10;