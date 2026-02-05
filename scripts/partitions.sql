USE SalesDB;

-- PARTITIONS 
-- 1. CREATE PARTITION FUNCTION
-- Define the logic  on how to divide your data into partitions: PARTITION KEY
CREATE PARTITION FUNCTION PartitionByYear(DATE)
AS RANGE LEFT FOR VALUES ('2023-12-31', '2024-12-31', '2025-12-31');


-- ACCESS DETAILS OF PARTITION
SELECT
	name,
	function_id,
	type,
	type_desc,
	boundary_value_on_right
FROM sys.partition_functions;


-- 2. CREATE FILE GROUPS
ALTER DATABASE SalesDB ADD FILEGROUP FG_2023;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2024;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2025;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2026;


-- TO DELETE/REMOVE
ALTER DATABASE SalesDB REMOVE FILEGROUP FG_2023;

-- QUERY ALL EXISTING FILEGROUPS
SELECT *
FROM sys.filegroups
WHERE type = 'FG'


-- CREATE DATA FILES
-- Add .ndf files to each Filesgroup

ALTER DATABASE SalesDB ADD FILE
(
	NAME = P_2023, -- Logical Name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\ P_2023.ndf'
) TO FILEGROUP FG_2023;

ALTER DATABASE SalesDB ADD FILE
(
	NAME = P_2024, -- Logical Name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\ P_20234.ndf'
) TO FILEGROUP FG_2024;

ALTER DATABASE SalesDB ADD FILE
(
	NAME = P_2025, -- Logical Name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\ P_2025.ndf'
) TO FILEGROUP FG_2025;

ALTER DATABASE SalesDB ADD FILE
(
	NAME = P_2026, -- Logical Name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\ P_2026.ndf'
) TO FILEGROUP FG_2026;

-- METADATA
SELECT
	fg.name FileGroupName,
	mf.name LogicalFileName,
	mf.physical_name PhysicalFilePath,
	mf.size / 128 SizeInMB
FROM
	sys.filegroups fg
JOIN
	sys.master_files mf ON fg.data_space_id = mf.data_space_id
WHERE
	mf.data_space_id=DB_ID('SalesDB');

-- CREATE PARTITION SCHEMA
CREATE PARTITION SCHEME SchemePartitionByYear
AS PARTITION PartitionByYear
TO (FG_2023, FG_2024, FG_2025, FG_2026)


-- CFREATE PARTITION TABLE	
CREATE TABLE Sales.Orders_Partitioned
(
	OrderID INT,
	OrderDate DATE,
	Sales INT
) ON SchemePartitionByYear (OrderDate)


-- INSERT DATA INTO THE TABLE
INSERT INTO Sales.Orders_Partitioned
VALUES
	-- (1, '2023-05-15', 1000),
	(2, '2024-05-15', 20),
	(3, '2025-05-15', 50)

SELECT *
FROM Sales.Orders_Partitioned


-- WHICH PARTITION IS THE DATA STORED IN?
SELECT
	p.partition_number PartitionNumber,
	f.name PartitionFileGroup,
	p.rows NumberOfRows
FROM sys.partitions P
JOIN sys.destination_data_spaces dds ON p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(p.object_id) = 'Orders_Partitioned';