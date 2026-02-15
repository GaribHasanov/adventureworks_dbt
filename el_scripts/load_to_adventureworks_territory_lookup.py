import psycopg2
import pandas as pd
from io import StringIO
import os
import sys
import chardet
from dotenv import load_dotenv
# ---------------------------------
# CONFIG
# ---------------------------------
load_dotenv()

CONNECTION_PARAMS = {
    "host": os.getenv("DB_HOST"),
    "port": int(os.getenv("DB_PORT")),
    "dbname": os.getenv("DB_NAME"),
    "user": os.getenv("DB_USER"),
    "password": os.getenv("DB_PASSWORD")
}
# CSV path - absolute path tövsiyə olunur
CSV_PATH = r"dbt_projects\AdventureWorks\csv\AdventureWorks_Territory_Lookup.csv"

SCHEMA_NAME = "raw"

# CSV file-dan table name götürürük (lowercase)
TABLE_NAME = os.path.splitext(os.path.basename(CSV_PATH))[0].lower()

# ---------------------------------
# CHECK FILE EXISTENCE
# ---------------------------------
if not os.path.exists(CSV_PATH):
    print(f"❌ CSV file not found: {CSV_PATH}")
    sys.exit(1)

# ---------------------------------
# READ CSV with robust encoding detection
# ---------------------------------
try:
    # detect file encoding
    with open(CSV_PATH, 'rb') as f:
        rawdata = f.read()
        result = chardet.detect(rawdata)
        encoding = result['encoding']
        if encoding is None:
            encoding = 'utf-8'  # fallback
    
    df = pd.read_csv(CSV_PATH, encoding=encoding)
except Exception as e:
    print(f"❌ Error reading CSV: {e}")
    sys.exit(1)

if df.empty:
    print(f"❌ CSV file is empty: {CSV_PATH}")
    sys.exit(1)

# ---------------------------------
# NORMALIZE COLUMN NAMES
# ---------------------------------
# Lowercase, strip whitespace, replace spaces/special chars with underscores
def normalize_col(c):
    c = str(c).strip().lower()
    c = c.replace(" ", "_")
    c = ''.join(ch if ch.isalnum() or ch=='_' else '_' for ch in c)
    return c

df.columns = [normalize_col(c) for c in df.columns]

# ---------------------------------
# CREATE SCHEMA & TABLE SQL
# ---------------------------------
columns_sql = ",\n".join([f'"{col}" TEXT' for col in df.columns])
create_schema_sql = f"CREATE SCHEMA IF NOT EXISTS {SCHEMA_NAME};"
create_table_sql = f"""
CREATE TABLE IF NOT EXISTS {SCHEMA_NAME}.{TABLE_NAME} (
{columns_sql}
);
"""

# ---------------------------------
# CONNECT TO POSTGRES
# ---------------------------------
try:
    conn = psycopg2.connect(**CONNECTION_PARAMS)
    conn.autocommit = True
    cur = conn.cursor()
except Exception as e:
    print(f"❌ Error connecting to PostgreSQL: {e}")
    sys.exit(1)

# ---------------------------------
# EXECUTE TABLE CREATION & CSV LOAD
# ---------------------------------
try:
    # Create schema & table
    cur.execute(create_schema_sql)
    cur.execute(create_table_sql)

    # Load CSV via COPY
    csv_buffer = StringIO()
    df.to_csv(csv_buffer, index=False, header=False)
    csv_buffer.seek(0)

    columns_list = ", ".join([f'"{c}"' for c in df.columns])
    copy_sql = f"COPY {SCHEMA_NAME}.{TABLE_NAME} ({columns_list}) FROM STDIN WITH CSV"

    cur.copy_expert(copy_sql, csv_buffer)

except psycopg2.errors.UndefinedColumn as e:
    print(f"❌ Column mismatch error: {e}")
    print("➡ Check that normalized CSV headers match table column names.")
    cur.close()
    conn.close()
    sys.exit(1)
except Exception as e:
    print(f"❌ Unexpected error: {e}")
    cur.close()
    conn.close()
    sys.exit(1)
finally:
    cur.close()
    conn.close()

print(f"✅ Table created and data loaded successfully: {SCHEMA_NAME}.{TABLE_NAME}")
