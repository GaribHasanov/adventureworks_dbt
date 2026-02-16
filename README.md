# 🚀 AdventureWorks Data Warehouse with dbt

## 📌 Project Overview

This project implements an end-to-end modern Data Warehouse using the AdventureWorks dataset.

The pipeline follows a structured ELT approach:

- CSV files are ingested using Python
- Raw tables are created in PostgreSQL (`raw` schema)
- dbt transforms raw data into staging models
- Final fact and dimension tables are built in the mart layer

The project demonstrates production-style data engineering practices including layered modeling, schema separation, data testing, and modular SQL transformations.

---

## 🏗️ Architecture

This project follows a modern ELT architecture:

1. **Extract**
   - Source data stored as CSV files.

2. **Load**
   - Python script loads CSV files into PostgreSQL.
   - Tables are created inside the `raw` schema.

3. **Transform**
   - dbt reads raw tables.
   - Staging models clean and standardize data.
   - Mart models build analytics-ready fact and dimension tables.

Data Flow:

CSV Files  
↓  
PostgreSQL (`raw` schema)  
↓  
dbt Staging Models (`adventureworks` schema)  
↓  
dbt Mart Models (`adventureworks` schema)  

---

## 🧰 Tech Stack

- Python (CSV ingestion)
- PostgreSQL (Data Warehouse)
- dbt (Data transformations)
- SQL
- Git & GitHub

---

## ⚙️ Environment Configuration

The Python scripts use a `.env` file to load PostgreSQL connection details (host, port, username, password, database).  

**Important:** The `.env` file is **gitignored** for security reasons and is **not included in the repository**.  

To run the scripts, create a `.env` file in the same folder as the scripts with the following variables:

```env
POSTGRES_HOST=<your_postgres_host>
POSTGRES_PORT=<your_postgres_port>
POSTGRES_USER=<your_username>
POSTGRES_PASSWORD=<your_password>
POSTGRES_DB=<your_database_name>
```

Replace the placeholders with your actual PostgreSQL credentials.

---

## 📂 Project Structure

```
project/
├── python/
│   └── load_csv_to_postgres.py
│
├── data/
│   ├── adventureworks_customer_lookup.csv
│   ├── adventureworks_product_categories_lookup.csv
│   ├── adventureworks_product_lookup.csv
│   ├── adventureworks_product_subcategories_lookup.csv
│   ├── adventureworks_returns_data.csv
│   ├── adventureworks_sales_data_2022.csv
│   └── adventureworks_territory_lookup.csv
│
├── models/
│   ├── staging/
│   │   ├── stg_customers.sql
│   │   ├── stg_product_categories.sql
│   │   ├── stg_product_subcategories.sql
│   │   ├── stg_product.sql
│   │   ├── stg_returns.sql
│   │   ├── stg_sales.sql
│   │   ├── stg_territory.sql
│   │   └── schema.yml
│   │
│   ├── mart/
│   │   ├── dim_customers.sql
│   │   ├── fct_returns.sql
│   │   ├── fct_sales.sql
│   │   └── schema.yml
│
└── dbt_project.yml
```

---

## 🗄️ Raw Layer (PostgreSQL)

Python loads CSV data into the `raw` schema:

- raw.adventureworks_customer_lookup  
- raw.adventureworks_product_categories_lookup  
- raw.adventureworks_product_lookup  
- raw.adventureworks_product_subcategories_lookup  
- raw.adventureworks_returns_data  
- raw.adventureworks_sales_data_2022  
- raw.adventureworks_territory_lookup  

This layer represents the source-aligned raw data.

---

## 🧱 Staging Layer (dbt)

The staging layer:

- Cleans column names
- Applies data type standardization
- Removes inconsistencies
- Prepares data for analytics

Staging models:

- stg_customers
- stg_product_categories
- stg_product_subcategories
- stg_product
- stg_returns
- stg_sales
- stg_territory

---

## ⭐ Mart Layer (Analytics Layer)

The mart layer builds a Star Schema for analytical queries.

### Dimension Tables

- dim_customers

### Fact Tables

- fct_sales
- fct_returns

This layer is optimized for BI and reporting.

---

## 🧪 Data Testing

dbt tests are defined inside `schema.yml` files.

Included tests:

- Not Null tests
- Unique tests
- Relationship tests

Run tests:

```bash
dbt test
```

---

## ▶️ How to Run the Project

### 1️⃣ Load raw data

Run the Python script to load CSV files into PostgreSQL:

```bash
python load_to_adventureworks_calendar_lookup.py
python load_to_adventureworks_customer_lookup.py
python load_to_adventureworks_product_categories_lookup.py
python load_to_adventureworks_product_lookup.py
python load_to_adventureworks_product_subcategories_lookup.py
python load_to_adventureworks_returns_data.py
python load_to_adventureworks_sales_data_2022.py
python load_to_adventureworks_territory_lookup.py
```

### 2️⃣ Run dbt models

```bash
dbt run
```

### 3️⃣ Run tests

```bash
dbt test
```

### 4️⃣ Generate documentation

```bash
dbt docs generate
dbt docs serve
```

---

## 🎯 Key Data Engineering Concepts Demonstrated

- End-to-end ELT pipeline
- Schema separation (raw vs analytics)
- Layered data modeling (staging → mart)
- Star schema design
- Data validation with dbt tests
- Modular SQL transformations
- Version-controlled data project

---

## 🚀 Future Improvements

- Add dbt snapshots
- Add CI/CD pipeline (GitHub Actions)
- Add data quality monitoring
- Add BI dashboard integration

---

## 👤 Author

Garib Hasanov  
Data & Analytics Engineer

---

## 📄 License

This project is for educational and portfolio purposes.
