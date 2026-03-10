DROP TABLE IF EXISTS daily_sales_features_all;

CREATE TABLE daily_sales_features_all (
    item_id VARCHAR,
    store_id VARCHAR,
    sales_date DATE,
    units INTEGER,
    is_zero_sales_day INTEGER,
    prev_7d_avg DOUBLE,
    prev_28d_avg DOUBLE,
    days_with_sales_last_28d BIGINT
);