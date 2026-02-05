USE SalesDB;
GO
 -- Start Typing your SQL query below this line
SELECT *
FROM Sales.Orders; -- GHOST TEXT


-- Write Comment
-- Select Top 3 Customers based on Score
SELECT TOP 3 *
FROM Sales.Customers
ORDER BY Score DESC;

-- Rank Customers based on their Total Order Sales
SELECT 
    *,
    RANK() OVER (ORDER BY TotalOrders DESC) AS SalesRank
FROM Sales.Customers;

-- Inline Shafts (To Trigger press Ctrl + I) 
-- Example:
SELECT 
    c.*,
    RANK() OVER (ORDER BY COUNT(o.OrderID) DESC) AS SalesRank
FROM Sales.Customers c
LEFT JOIN Sales.Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName, c.Score, c.TotalOrders
ORDER BY SalesRank;



-- The Redline below to fix the syntax error
SELECT
    COUNT(*) Score,
    CustomerID
FROM Sales.Customers
GROUP BY CustomerID
ORDER BY Score DESC -- Copilot suggested fix: Move 'GROUP BY' before 'ORDER BY'


-- 6 Components of ChatGPT Prompts for SQL Developers
-- 1. Tasks - Mandatory**
-- 2. Context* 
-- 3. Specifications*
-- 4. Role
-- 5. Tone

-- Examples
/* ==============================================================================
   1. Solve an SQL Task
=================================================================================

In my SQL Server database, we have two tables:
The first table is `orders` with the following columns: order_id, sales, customer_id, product_id.
The second table is `customers` with the following columns: customer_id, first_name, last_name, country.
Do the following:
	- Write a query to rank customers based on their sales.
	- The result should include the customer's customer_id, full name, country, total sales, and their rank.
	- Include comments but avoid commenting on obvious parts.
	- Write three different versions of the query to achieve this task.
	- Evaluate and explain which version is best in terms of readability and performance
*/

-- Version 1: CTE with aggregation + window function
WITH customer_sales AS (
    -- Aggregate once per customer to avoid repeated calculations
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS full_name,
        c.country,
        SUM(o.sales) AS total_sales
    FROM customers c
    JOIN orders o
        ON o.customer_id = c.customer_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name,
        c.country
)
SELECT
    customer_id,
    full_name,
    country,
    total_sales,
    RANK() OVER (ORDER BY total_sales DESC) AS sales_rank
FROM customer_sales;


-- Version 2: Derived table (subquery instead of CTE)
SELECT
    cs.customer_id,
    cs.full_name,
    cs.country,
    cs.total_sales,
    RANK() OVER (ORDER BY cs.total_sales DESC) AS sales_rank
FROM (
    -- Inline aggregation without persisting a CTE
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS full_name,
        c.country,
        SUM(o.sales) AS total_sales
    FROM customers c
    JOIN orders o
        ON o.customer_id = c.customer_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name,
        c.country
) cs;

-- Version 3: Windowed SUM + DISTINCT
SELECT DISTINCT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.country,
    SUM(o.sales) OVER (PARTITION BY c.customer_id) AS total_sales,
    RANK() OVER (
        ORDER BY SUM(o.sales) OVER (PARTITION BY c.customer_id) DESC
    ) AS sales_rank
FROM customers c
JOIN orders o
    ON o.customer_id = c.customer_id;


/* ==============================================================================
   2. Improve the Readability
=================================================================================

The following SQL Server query is long and hard to understand. 
Do the following:
	- Improve its readability.
	- Remove any redundancy in the query and consolidate it.
	- Include comments but avoid commenting on obvious parts.	
	- Explain each improvement to understand the reasoning behind it.
*/

/* ===========================================================================
   3. Optimize the Performance Query
============================================================================== 

The following SQL Server query is slow. 
Do the following:
	- Propose optimizations to improve its performance.
	- Provide the improved SQL query.
	- Explain each improvement to understand the reasoning behind it.
*/


/* ===========================================================================
   4. Optimize Execution Plan
============================================================================== 

The image is the execution plan of SQL Server query.
Do the following:
	- Describe the execution plan step by step.
	- Identify performance bottlenecks and issues.
	- Suggest ways to improve performance and optimize the execution plan.
*/

/* ===========================================================================
   5. Debugging
==============================================================================

The following SQL Server Query causing this error: "Msg 8120, Level 16, State 1, Line 5"
Do the following: 
	- Explain the error massage.
	- Find the root cause of the issue.
	- Suggest how to fix it.
*/

SELECT 
    C.CustomerID,
    C.Country,
    SUM(O.Sales) AS TotalSales,
    RANK() OVER (PARTITION BY C.Country ORDER BY O.Sales DESC) AS RankInCountry
FROM Sales.Customers C
LEFT JOIN Sales.Orders O 
ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID, C.Country;

/* ===========================================================================
   6. Explain the Result
============================================================================== 

I didn't understand the result of the following SQL Server query.
Do the following:
	- Break down how SQL processes the query step by step.
	- Explaining each stage and how the result is formed.
*/
WITH Series AS (
	-- Anchor Query
	SELECT
	1 AS MyNumber
	UNION ALL
	-- Recursive Query
	SELECT
	MyNumber + 1
	FROM Series
	WHERE MyNumber < 20
)
-- Main Query
SELECT *
FROM Series

/* ===========================================================================
   7. Styling & Formatting
============================================================================== 

The following SQL Server query hard to understand. 
Do the following:
	Restyle the code to make it easier to read.
	Align column aliases.
	Keep it compact - do not introduce unnecessary new lines.	
	Ensure the formatting follows best practices.
*/
-- Bad Styled Query
with CTE_Total_Sales as 
(Select 
CustomerID, sum(Sales) as TotalSales 
from Sales.Orders 
group by CustomerID),
cte_customer_segments as 
(SELECT CustomerID, 
case when TotalSales > 100 then 'High Value' 
when TotalSales between 50 and 100 then 'Medium Value' 
else 'Low Value' end as CustomerSegment 
from CTE_Total_Sales)
select c.CustomerID, c.FirstName, c.LastName, 
cts.TotalSales, ccs.CustomerSegment 
FROM sales.customers c 
left join CTE_Total_Sales cts 
ON cts.CustomerID = c.CustomerID 
left JOIN cte_customer_segments ccs ON ccs.CustomerID = c.CustomerID

/* ===========================================================================
   8. Documentations & Comments
==============================================================================

The following SQL Server query lacks comments and documentation.
Do the following:
	Insert a leading comment at the start of the query describing its overall purpose.
	Add comments only where clarification is necessary, avoiding obvious statements.
	Create a separate document explaining the business rules implemented by the query.	
	Create another separate document describing how the query works.
*/

WITH CTE_Total_Sales AS 
(
SELECT 
    CustomerID,
    SUM(Sales) AS TotalSales
FROM Sales.Orders 
GROUP BY CustomerID
),
CTE_Customer_Segements AS (
SELECT 
	CustomerID,
	CASE 
		WHEN TotalSales > 100 THEN 'High Value'
		WHEN TotalSales BETWEEN 50 AND 100 THEN 'Medium Value'
		ELSE 'Low Value'
	END CustomerSegment
FROM CTE_Total_Sales
)

SELECT 
c.CustomerID, 
c.FirstName,
c.LastName,
cts.TotalSales,
ccs.CustomerSegment
FROM Sales.Customers c
LEFT JOIN CTE_Total_Sales cts
ON cts.CustomerID = c.CustomerID
LEFT JOIN CTE_Customer_Segements ccs
ON ccs.CustomerID = c.CustomerID 

/* ===========================================================================
   9. Improve Database DDL
============================================================================== 
The following SQL Server DDL Script has to be optimized.
Do the following:
	- Naming: Check the consistency of table/column names, prefixes, standards.
	- Data Types: Ensure data types are appropriate and optimized.
	- Integrity: Verify the integrity of primary keys and foreign keys.	
	- Indexes: Check that indexes are sufficient and avoid redundancy.
	- Normalization: Ensure proper normalization and avoid redundancy.

==============================================================================
   10. Generate Test Dataset
==============================================================================

I need dataset for testing the following SQL Server DDL 
Do the following:
	- Generate test dataset as Insert statements.
	- Dataset should be realstic.
	- Keep the dataset small.	
	- Ensure all primary/foreign key relationships are valid (use matching IDs).
	- Dont introduce any Null values.

==============================================================================
   11. Create SQL Course
============================================================================== 

Create a comprehensive SQL course with a detailed roadmap and agenda.
Do the following:
	- Start with SQL fundamentals and advance to complex topics.
	- Make it beginner-friendly.
	- Include topics relevant to data analytics.	
	- Focus on real-world data analytics use cases and scenarios.

==============================================================================
   12. Understand SQL Concept
==============================================================================

I want detailed explanation about SQL Window Functions.
Do the following:
	- Explain what Window Functions are.
	- Give an analogy.
	- Describe why we need them and when to use them.	
	- Explain the syntax.
	- Provide simple examples.
	- List the top 3 use cases.

==============================================================================
   13. Comparing SQL Concepts
============================================================================== 

I want to understand the differences between SQL Windows and GROUP BY.
Do the following:
	- Explain the key differences between the two concepts.
	- Describe when to use each concept, with examples.
	- Provide the pros and cons of each concept.	
	- Summarize the comparison in a clear side-by-side table.

==============================================================================
   14. SQL Questions with Options
==============================================================================

Act as an SQL trainer and help me practice SQL Window Functions.
Do the following:
	- Make it interactive Practicing, you provide task and give solution.
	- Provide a sample dataset.
	- Give SQL tasks that gradually increase in difficulty.	
	- Act as an SQL Server and show the results of my queries.
	- Review my queries, provide feedback, and suggest improvements.

==============================================================================
   15. Prepare for a SQL Interview
==============================================================================

Act as Interviewer and prepare me for a SQL interview.
Do the following:
	- Ask common SQL interview questions.
	- Make it interactive Practicing, you provide question and give answer.
	- Gradually progress to advanced topics.
	- Evaluate my answer and give me a feedback.	

==============================================================================
   16. Prepare for a SQL Exam
==============================================================================

Prepare me for a SQL exam
Do the following:
	- Ask common SQL interview questions.
	- Make it interactive Practicing, you provide question and give answer.
	- Gradually progress to advanced topics.
	- Evaluate my answer and give me a feedback.