# SQL-DE — SQL for Data Engineering

A structured reference repository for SQL — from core syntax to advanced data engineering patterns. Built around hands-on scripts, real datasets, and multi-database support.

---

## What's Inside

| Folder | Purpose |
|---|---|
| [scripts/](scripts/) | SQL learning scripts and performance/index optimization |
| [datasets/](datasets/) | Sample CSV data and DB initialization scripts |
| [sql_server/](sql_server/) | SQL Server-specific setup scripts |

---

## Databases Covered

The datasets and initialization scripts support three database systems out of the box:

- **SQL Server** — `.bak` backup files + `init-sqlserver-*.sql` scripts
- **PostgreSQL** — `init-postgres-*.sql` scripts
- **MySQL** — `init-mysql-*.sql` scripts

## Getting Started

### 1. Set Up a Database

Pick your database system and run the matching init script from [datasets/](datasets/):

```sql
-- SQL Server
-- Run: datasets/sql-server/init-sqlserver-salesdb.sql

-- PostgreSQL
-- Run: datasets/postgres/init-postgres-salesdb.sql

-- MySQL
-- Run: datasets/mysql/init-mysql-salesdb.sql
```

### 2. Load Sample Data

The [datasets/](datasets/) folder contains CSV files for manual import if needed:

```
Customers.csv · Employees.csv · Orders.csv · OrdersArchive.csv · Products.csv
```

### 3. Follow the Scripts

Work through [scripts/Learning/](scripts/Learning/) in numbered order — each folder builds on the previous. 

---

## Content

```
SQL Sublanguages        →  DQL · DDL · DML
Filtering & Sorting     →  WHERE · HAVING · ORDER BY · TOP / LIMIT
Joins & Set Ops         →  INNER · LEFT · RIGHT · FULL · CROSS · UNION · INTERSECT · EXCEPT
Functions               →  String · Numeric · DateTime · NULL handling
Conditional Logic       →  CASE / WHEN
Aggregations            →  GROUP BY · aggregate functions
Window Functions        →  ROW_NUMBER · RANK · LEAD/LAG · rolling aggregates
Advanced Queries        →  Subqueries · CTEs · Views · Temp Tables
Programmability         →  Stored Procedures · Triggers
Partitioning            →  Table partitions
Performance             →  30 optimization tips · indexes · execution plans
AI-Assisted SQL         →  Prompt patterns for SQL workflows
```

---

## Repository Structure

```
SQL-DE/
├── datasets/
│   ├── *.csv                        # Raw sample data
│   ├── mysql/                       # MySQL init scripts
│   ├── postgres/                    # PostgreSQL init scripts
│   └── sql-server/                  # SQL Server init scripts + .bak files
│
├── scripts/
│   ├── Learning/                    # 22 numbered SQL topic scripts
│   ├── Indexes/                     # Index types + execution plan examples
│   ├── AI_for_SQL.sql               # AI prompt patterns for SQL
│   └── Performance_Optimization.sql # 30 performance tips
│
└── sql_server/                      # Additional SQL Server setup scripts
```
