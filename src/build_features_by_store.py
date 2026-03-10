from pathlib import Path
import duckdb
import time

PROJECT_ROOT = Path(__file__).resolve().parents[1]
DB_PATH = PROJECT_ROOT / "data" / "processed" / "m5.duckdb"

con = duckdb.connect(str(DB_PATH))

# Memory-friendly settings
con.execute("SET threads = 1;")
con.execute("SET preserve_insertion_order = false;")
con.execute("SET memory_limit = '2GB';")

# Get list of stores
stores = [r[0] for r in con.execute("""
    SELECT DISTINCT store_id
    FROM fact_sales_daily
    ORDER BY store_id;
""").fetchall()]

# Optional: resume support (skip stores already loaded)
already_loaded = set(r[0] for r in con.execute("""
    SELECT DISTINCT store_id
    FROM daily_sales_features_all;
""").fetchall())

stores_to_run = [s for s in stores if s not in already_loaded]

print(f"Total stores: {len(stores)}")
print(f"Already loaded: {len(already_loaded)}")
print(f"To process: {len(stores_to_run)}")

for i, store_id in enumerate(stores_to_run, start=1):
    t0 = time.time()
    print(f"\n[{i}/{len(stores_to_run)}] Processing store: {store_id}")

    con.execute(f"""
        INSERT INTO daily_sales_features_all
        SELECT
            item_id,
            store_id,
            sales_date,
            units,
            CASE WHEN units = 0 THEN 1 ELSE 0 END AS is_zero_sales_day,

            AVG(units) OVER (
                PARTITION BY item_id, store_id
                ORDER BY sales_date
                ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING
            ) AS prev_7d_avg,

            AVG(units) OVER (
                PARTITION BY item_id, store_id
                ORDER BY sales_date
                ROWS BETWEEN 28 PRECEDING AND 1 PRECEDING
            ) AS prev_28d_avg,

            SUM(CASE WHEN units > 0 THEN 1 ELSE 0 END) OVER (
                PARTITION BY item_id, store_id
                ORDER BY sales_date
                ROWS BETWEEN 28 PRECEDING AND 1 PRECEDING
            ) AS days_with_sales_last_28d
        FROM fact_sales_daily
        WHERE store_id = '{store_id}';
    """)

    elapsed = time.time() - t0
    row_count = con.execute(f"""
        SELECT COUNT(*) FROM daily_sales_features_all WHERE store_id = '{store_id}';
    """).fetchone()[0]
    print(f"✅ Inserted rows for {store_id}: {row_count:,} (took {elapsed:.1f}s)")

con.close()
print("\n✅ Done. Features table built: daily_sales_features_all")