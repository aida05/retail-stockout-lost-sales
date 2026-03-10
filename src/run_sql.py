from pathlib import Path
import sys
import duckdb

PROJECT_ROOT = Path(__file__).resolve().parents[1]
DB_PATH = PROJECT_ROOT / "data" / "processed" / "m5.duckdb"

sql_file = Path(sys.argv[1]) if len(sys.argv) > 1 else None
if not sql_file or not sql_file.exists():
    raise SystemExit("Usage: python src/run_sql.py path/to/file.sql")

sql_text = sql_file.read_text(encoding="utf-8")
statements = [s.strip() for s in sql_text.split(";") if s.strip()]

con = duckdb.connect(str(DB_PATH))

# Memory-friendly settings
con.execute("SET threads = 1;")
con.execute("SET preserve_insertion_order = false;")
con.execute("SET memory_limit = '2GB';")

for i, stmt in enumerate(statements, start=1):
    print(f"\n--- Statement {i} ---")
    print(stmt[:120] + ("..." if len(stmt) > 120 else ""))

    result = con.execute(stmt)

    if result.description is not None:
        rows = result.fetchmany(10)
        columns = [col[0] for col in result.description]

        print("Columns:", columns)
        for row in rows:
            print(row)

        if len(rows) == 10:
            print("... showing first 10 rows only")

con.close()

print(f"\n✅ Executed: {sql_file}")
print(f"✅ DB: {DB_PATH}")
