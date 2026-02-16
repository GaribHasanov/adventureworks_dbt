# 🚀 AdventureWorks Data Warehouse with dbt

## 📌 Project Overview

This project implements a modern Data Warehouse using the **AdventureWorks** dataset and **dbt (data build tool)**.

The goal of the project is to transform raw source data into a structured, analytics-ready warehouse following modern data engineering best practices.

This repository demonstrates:
- Layered data modeling (Staging → Mart)
- dbt transformations
- Testing & documentation
- Version control with GitHub
- Analytics-ready star schema modeling

---

## 🏗️ Architecture

The project follows a modern ELT workflow:

1. Raw data loaded into the Data Warehouse
2. dbt transforms raw data into staging models
3. Final marts built for analytics

### Layers:

- **staging** – source-aligned cleaned tables
- **marts** – fact and dimension tables (star schema)

---

## 🧰 Tech Stack

- Python
- dbt
- SQL
- Git & GitHub
- AdventureWorks dataset
- PostgreSQL

---

## 📂 Project Structure

```
models/
├── staging/
│   ├── stg_customers.sql
│   ├── stg_orders.sql
│
├── marts/
│   ├── dim_customers.sql
│   ├── dim_products.sql
│   ├── fact_sales.sql
│
└── schema.yml
```
