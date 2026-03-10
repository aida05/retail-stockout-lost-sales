COPY (
  SELECT *
  FROM item_lost_revenue_summary
  ORDER BY total_lost_revenue DESC
) TO 'data/processed/export_top_items.csv' (HEADER, DELIMITER ',');