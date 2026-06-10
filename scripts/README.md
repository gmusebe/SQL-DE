# scripts/

SQL scripts organised into two areas: a numbered learning path and performance/indexing deep-dives.

---

## Structure

```
scripts/
├── Learning/
│   ├── 1. SubLanguages/
│   ├── 2. Filtering/
│   ├── 3. Joins & Sets/
│   ├── 4. String & Numeric Functions/
│   ├── 5. DateTime Function & Formats/
│   ├── 6. Nulls/
│   ├── 7. Case Statements/
│   ├── 8. Aggregate Functions/
│   ├── 9. Window Functions/
│   ├── 10. Advanced Queries/
│   ├── 11. Stored Procedures/
│   ├── 12. Partitions/
│   ├── AI_for_SQL.sql
│   └── Performance_Optimization.sql
```

---

## Learning Path

Work through folders **1 → 12** in order. Each folder is a self-contained topic.

| # | Folder | Files | What's covered |
|---|---|---|---|
| 1 | `1. SubLanguages/` | 3 | DQL (SELECT), DDL (CREATE/ALTER/DROP), DML (INSERT/UPDATE/DELETE) |
| 2 | `2. Filtering/` | 1 | WHERE, AND/OR/NOT, BETWEEN, IN, LIKE, HAVING, ORDER BY, TOP |
| 3 | `3. Joins & Sets/` | 2 | INNER/LEFT/RIGHT/FULL/CROSS JOINs; UNION, INTERSECT, EXCEPT |
| 4 | `4. String & Numeric Functions/` | 1 | LEN, TRIM, SUBSTRING, REPLACE, UPPER/LOWER, ROUND, ABS, CAST |
| 5 | `5. DateTime Function & Formats/` | 2 | GETDATE, DATEADD, DATEDIFF, FORMAT; culture and format codes |
| 6 | `6. Nulls/` | 1 | IS NULL, ISNULL, COALESCE, NULLIF, NULL in aggregates |
| 7 | `7. Case Statements/` | 1 | Simple CASE, searched CASE, CASE in ORDER BY and aggregates |
| 8 | `8. Aggregate Functions/` | 1 | COUNT, SUM, AVG, MIN, MAX with GROUP BY and HAVING |
| 9 | `9. Window Functions/` | 4 | Basics; rolling aggregates; RANK/DENSE_RANK/ROW_NUMBER; LEAD/LAG/FIRST_VALUE/LAST_VALUE |
| 10 | `10. Advanced Queries/` | 4 | Subqueries (correlated + non-correlated); CTEs; Views; Temp Tables and CTAs |
| 11 | `11. Stored Procedures/` | 2 | Stored procedures with parameters; DML Triggers (AFTER / INSTEAD OF) |
| 12 | `12. Partitions/` | 1 | Partition functions, schemes, and partition switching |

---
