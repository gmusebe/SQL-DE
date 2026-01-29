-- STRUCTURED INDEX
-- 1. CLUSTERED
-- 2. NON-CLUSTERED
USE SalesDB;

-- SYNTAX
-- CREATE THE INDEX
-- CREATE [CLUSTERED | NONCLUSTERED] INDEX index_name ON table_name (col1, col2) ...

SELECT *
INTO Sales.DBCustomers
FROM Sales.Customers;

SELECT *
FROM Sales.Customers
WHERE CustomerID = 1;


CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID
ON Sales.DBCustomers(CustomerID);

CREATE CLUSTERED INDEX idx_DBCustomers_FirstName
ON Sales.DBCustomers(FirstName);

--DROP INDEX
DROP INDEX idx_DBCustomers_CustomerID ON Sales.DBCustomers;

-- EXAMPLE 2
SELECT *
FROM Sales.DBCustomers
WHERE LastName = 'Brown';

-- CREATE NON-CLUSTERED INDEX
CREATE NONCLUSTERED INDEX idx_DBCustomers_LastName
ON Sales.DBCustomers(LastName);

-- STORAGE INDEX
-- 1. ROWSTORE INDEX
-- 2. COLUMNSTORE INDEX