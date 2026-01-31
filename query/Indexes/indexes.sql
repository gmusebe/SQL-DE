-- STRUCTURED INDEX
-- 1. CLUSTERED
-- 2. NON-CLUSTERED
USE SalesDB;

-- SYNTAX
-- CREATE THE INDEX
-- CREATE [CLUSTERED | NONCLUSTERED] INDEX index_name ON table_name (col1, col2) ...

SELECT *
-- INTO Sales.DBCustomers
FROM Sales.Customers;

SELECT *
FROM Sales.Customers
WHERE CustomerID = 1;


CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID
ON Sales.DBCustomers(CustomerID);

-- CREATE CLUSTERED INDEX idx_DBCustomers_FirstName
-- ON Sales.DBCustomers(FirstName);

--DROP INDEX
DROP INDEX idx_DBCustomers_CustomerID ON Sales.DBCustomers;

-- EXAMPLE 2
SELECT *
FROM Sales.DBCustomers
WHERE LastName = 'Brown';

-- CREATE NON-CLUSTERED INDEX
CREATE NONCLUSTERED INDEX idx_DBCustomers_LastName
ON Sales.DBCustomers(LastName);

-- COMPOSITE INDEX
SELECT *
FROM Sales.DBCustomers
WHERE Country = 'USA' AND Score > 500; --Order very crucial

-- CREATE CLUSTERED INDEX idx_DBCustomers_CountryScore
-- ON Sales.DBCustomers(Country, Score);


-- STORAGE INDEX
-- 1. ROWSTORE INDEX
-- 2. COLUMNSTORE INDEX
-- CREATE [CLUSTERED | NONCLUSTERED | CLUSTERED] [COLUMNSTORE] Index_name ON table_name(col1, col2)
DROP INDEX index_DBCustomers_CS ON Sales.DBCustomers;


-- CREATE CLUSTERED COLUMNSTORE INDEX index_DBCustomers_CS
-- ON Sales.DBCustomers

CREATE NONCLUSTERED COLUMNSTORE INDEX index_DBCustomers_CS_FirstName
ON Sales.DBCustomers(FirstName)



-- Comparing Table Structures
-- 1. HEAP Structure
USE AdventureWorksDW2022;

SELECT *
-- INTO FactInternetSales_HP
FROM FactInternetSales;

-- ROWSTORE INDEX
SELECT *
-- INTO FactInternetSales_RS
FROM FactInternetSales;

-- INDEX
CREATE CLUSTERED INDEX idx_FactInternetSales_RS_PK
ON FactInternetSales_RS (SalesOrderNumber, SalesOrderLineNumber)


-- COLUMNSTORE INDEX
SELECT *
-- INTO FactInternetSales_CS
FROM FactInternetSales;

-- INDEX
CREATE CLUSTERED COLUMNSTORE INDEX idx_FactInternetSales_CS_PK
ON FactInternetSales_CS


-- Check Storages
EXEC sp_spaceused FactInternetSales_HP;

EXEC sp_spaceused FactInternetSales_RS;

EXEC sp_spaceused FactInternetSales_CS;


-- UNIQUE INDEX
-- WRITING Very slow, READING very quick
-- CREATE [UNIQUE] [CLUSTERED | NONCLUSTERED | CLUSTERED] [COLUMNSTORE] Index_name ON table_name(col1, col2)
USE SalesDB;

SELECT *
FROM Sales.Products;

CREATE UNIQUE NONCLUSTERED INDEX idx_Products_Product 
ON Sales.Products (Product)


INSERT INTO Sales.Products (ProductID, Product) VALUES
    (106, 'Caps')


-- FILTER INDEX
-- Include Rows that meet the specified conditions

SELECT *
FROM Sales.Customers
WHERE Country = 'USA';


CREATE NONCLUSTERED INDEX idx_Customers_Country
ON Sales.Customers (Country)
WHERE Country = 'USA';



-- LIST ALL INDEX ON A SPECIFIC TABLE
EXEC sp_helpindex 'Sales.DBCustomers';


-- 1. MONITOR INDEX USAGE 
SELECT
    tbl.name TableName,
    idx.name IndexName,
    idx.type_desc IndexType,
    idx.is_primary_key IsPrimaryKey,
    idx.is_unique IsUnique,
    idx.is_disabled IsDisabled,
    s.user_seeks UserSeeks,
    s.user_scans UserScans,
    s.user_lookups UserLookups,
    s.user_updates UserUpdates,
    COALESCE( s.last_user_seek, s.last_system_scan) LastUpdate
FROM sys.indexes idx
JOIN sys.tables tbl
ON idx.object_id = tbl.object_id
LEFT JOIN sys.dm_db_index_usage_stats s
ON s.object_id = idx.object_id
AND s.index_id = idx.index_id
ORDER BY tbl.name, idx.name

-- DYNAMIC MANAGEMENT VIEW:
SELECT *
FROM sys.dm_db_index_usage_stats


-- 2. MONITOR MISSING INDEX
SELECT *
FROM sys.dm_db_missing_index_details


-- UPDATE STATISTICS
-- METADATA ABOUT DATABASE
SELECT 
    SCHEMA_NAME(t.schema_id) SchemaName,
    t.name TableName,
    s.name StatisticName,
    sp.last_updated LastUpdate,
    DATEDIFF(day, sp.last_updated, GETDATE()) LastUpdateDay,
    sp.rows AS 'Rows',
    sp.modification_counter AS ModificationSinceLastUpdate
FROM sys.stats s
JOIN sys.tables t
ON s.object_id = t.object_id
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) sp
ORDER BY sp.modification_counter DESC;


-- UPDATE
UPDATE STATISTICS Sales.DBCustomers _WA_Sys_00000003_14270015;

-- UPDATE WHOLE TABLE
UPDATE STATISTICS Sales.DBCustomers;

-- UPDATE WHOLE DATABASE
EXEC sp_updatestats;

-- Weekly job to update statistics on Weekends
-- After Migrating Data


-- FRAGMENTATION
-- CHECK HEALTH OF INDEXES
SELECT 
    tbl.name AS TableName,
    idx.name IndexName,
    s.avg_fragmentation_in_percent,
    s.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') s
INNER JOIN sys.tables tbl
ON s.object_id = tbl.object_id
INNER JOIN sys.indexes idx
ON idx.object_id = s.object_id
AND idx.index_id = s.index_id
ORDER BY s.avg_fragmentation_in_percent DESC;

-- WHEN DEFRAGMENT
-- <10% No Action Needed
-- 10 -30% Reorganize
-- > 30% Rebuild Whole Index

-- REORGANIZE
ALTER INDEX idx_DBCustomers_LastName 
ON Sales.DBCustomers
REORGANIZE

-- REBUILD: Drops & Creates anew
ALTER INDEX idx_Products_Product
ON Sales.Products
REBUILD




