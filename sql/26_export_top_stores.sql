COPY (
  SELECT *
  FROM store_lost_revenue_summary
  ORDER BY total_lost_revenue DESC
) TO 'data/processed/export_top_stores.csv' (HEADER, DELIMITER ',');