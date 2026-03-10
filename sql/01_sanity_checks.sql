-- How many rows?
SELECT COUNT(*) AS sales_rows FROM sales_raw;
SELECT COUNT(*) AS calendar_rows FROM calendar;
SELECT COUNT(*) AS price_rows FROM sell_prices;

-- Preview columns
SELECT * FROM sales_raw LIMIT 5;
SELECT * FROM calendar LIMIT 5;
SELECT * FROM sell_prices LIMIT 5;
