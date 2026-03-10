from pathlib import Path
import duckdb

PROJECT_ROOT = Path(__file__).resolve().parents[1]
RAW_DIR = PROJECT_ROOT / "data" / "raw" / "m5"
DB_PATH = PROJECT_ROOT / "data" / "processed" / "m5.duckdb"

sales_path = RAW_DIR / "sales_train_validation.csv"
cal_path = RAW_DIR / "calendar.csv"
prices_path = RAW_DIR / "sell_prices.csv"

# Create DB folder if missing
DB_PATH.parent.mkdir(parents=True, exist_ok=True)

con = duckdb.connect(str(DB_PATH))

# Load CSVs into DuckDB (create tables)
con.execute("DROP TABLE IF EXISTS sales_raw;")
con.execute("DROP TABLE IF EXISTS calendar;")
con.execute("DROP TABLE IF EXISTS sell_prices;")

con.execute(f"""
    CREATE TABLE sales_raw AS
    SELECT * FROM read_csv_auto('{sales_path.as_posix()}', header=True);
""")

con.execute(f"""
    CREATE TABLE calendar AS
    SELECT * FROM read_csv_auto('{cal_path.as_posix()}', header=True);
""")

con.execute(f"""
    CREATE TABLE sell_prices AS
    SELECT * FROM read_csv_auto('{prices_path.as_posix()}', header=True);
""")

# Quick sanity checks
print("Rows:")
print("sales_raw:", con.execute("SELECT COUNT(*) FROM sales_raw").fetchone()[0])
print("calendar:", con.execute("SELECT COUNT(*) FROM calendar").fetchone()[0])
print("sell_prices:", con.execute("SELECT COUNT(*) FROM sell_prices").fetchone()[0])

con.close()
print(f"DuckDB created at: {DB_PATH}")
