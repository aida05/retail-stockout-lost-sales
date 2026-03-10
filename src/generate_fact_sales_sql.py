from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parents[1]
OUTPUT_SQL = PROJECT_ROOT / "sql" / "02_build_fact_sales_daily_full.sql"

# Build day column list: d_1, d_2, ..., d_1913
day_columns = ",\n            ".join([f"d_{i}" for i in range(1, 1914)])

sql_text = f"""
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
            {day_columns}
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
""".strip()

OUTPUT_SQL.write_text(sql_text, encoding="utf-8")

print(f"✅ SQL file created: {OUTPUT_SQL}")
print("Preview:")
print(sql_text[:500])
