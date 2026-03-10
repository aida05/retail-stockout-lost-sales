DROP TABLE IF EXISTS fact_sales_daily;

CREATE TABLE fact_sales_daily AS
WITH unpivoted AS (
    SELECT
        id,
        item_id,
        dept_id,
        cat_id,
        store_id,
        state_id,
        day_key AS d,
        units::INTEGER AS units
    FROM sales_raw
    UNPIVOT (
        units FOR day_key IN (
            d_1, d_2, d_3, d_4, d_5, d_6, d_7, d_8, d_9, d_10,
            d_11, d_12, d_13, d_14, d_15, d_16, d_17, d_18, d_19, d_20,
            d_21, d_22, d_23, d_24, d_25, d_26, d_27, d_28, d_29, d_30
        )
    )
)
SELECT
    u.item_id,
    u.dept_id,
    u.cat_id,
    u.store_id,
    u.state_id,
    c.date::DATE AS sales_date,
    u.d AS day_key,
    u.units
FROM unpivoted u
JOIN calendar c
  ON c.d = u.d;
