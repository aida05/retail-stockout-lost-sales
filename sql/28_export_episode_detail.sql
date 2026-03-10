COPY (
  SELECT *
  FROM lost_revenue_episode
  ORDER BY lost_revenue_estimate DESC
  LIMIT 50000
) TO 'data/processed/export_episode_detail_top50k.csv' (HEADER, DELIMITER ',');