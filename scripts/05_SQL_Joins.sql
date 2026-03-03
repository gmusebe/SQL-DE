/* ==============================================================================
   SQL Joins 
-------------------------------------------------------------------------------
   This document provides an overview of SQL joins, which allow combining data
   from multiple tables to retrieve meaningful insights.

   Table of Contents:
     1. Basic Joins
        - INNER JOIN
        - LEFT JOIN
        - RIGHT JOIN
        - FULL JOIN
     2. Advanced Joins
        - LEFT ANTI JOIN
        - RIGHT ANTI JOIN
        - ALTERNATIVE INNER JOIN
        - FULL ANTI JOIN
        - CROSS JOIN
     3. Multiple Table Joins (4 Tables)
=================================================================================
*/

/* ============================================================================== 
   BASIC JOINS 
=============================================================================== */
USE MyDatabase;

-- No Join
/* Retrieve all data from customers and orders as separate results */
SELECT *
FROM customers;

SELECT *
FROM orders;

-- INNER JOIN
/* Get all customers along with their orders, 
   but only for customers who have placed an order */
SELECT
	id,
	first_name,
	country,
	score,
	sales
FROM customers
INNER JOIN orders
ON customers.id = orders.customer_id

-- Alternative to INNER JOIN using LEFT JOIN
/* Get all customers along with their orders, 
   but only for customers who have placed an order */
SELECT *
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id
WHERE o.customer_id IS NOT NULL

-- LEFT JOIN
/* Get all customers along with their orders, 
   including those without orders */
SELECT
	id,
	first_name,
	o.order_id,
	sales
FROM customers as c
LEFT JOIN orders as o
ON c.id = o.customer_id

-- RIGHT JOIN
/* Get all customers along with their orders, 
   including orders without matching customers */
SELECT
	id,
	first_name,
	o.order_id,
	sales
FROM customers as c
RIGHT JOIN orders as o
ON c.id = o.customer_id

-- Alternative to RIGHT JOIN using LEFT JOIN
/* Get all customers along with their orders, 
   including orders without matching customers */
SELECT
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM orders as o
LEFT JOIN customers as c
ON c.id = o.customer_id


-- FULL JOIN
/* Get all customers and all orders, even if there’s no match */
SELECT
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM orders as o
FULL JOIN customers as c
ON c.id = o.customer_id

/* ============================================================================== 
   ADVANCED JOINS
=============================================================================== */

-- LEFT ANTI JOIN
/* Get all customers who haven't placed any order */
-- Return rows from the left that has no match in Right Table
-- Filter [Combine the data to check.]
SELECT *
FROM customers as c
LEFT JOIN orders as b
ON c.id = b.customer_id
WHERE b.customer_id is NULL;

-- RIGHT ANTI JOIN
/* Get all orders without matching customers */
SELECT * 
FROM customers as c
RIGHT JOIN orders as o
ON c.id = o.customer_id
WHERE c.id is NULL;

-- Alternative to RIGHT ANTI JOIN using LEFT JOIN
/* Get all orders without matching customers */
SELECT *
FROM orders AS o 
LEFT JOIN customers AS c
ON c.id = o.customer_id
WHERE c.id IS NULL

-- FULL ANTI JOIN
/* Find customers without orders and orders without customers */
SELECT *
FROM customers as c
FULL JOIN orders as b
ON c.id = b.customer_id
WHERE b.customer_id is NULL OR c.id is NULL

-- INNER JOIN alternative
/*All customers along with their orders*/
SELECT *
FROM customers as c
FULL JOIN orders as b
ON c.id = b.customer_id
WHERE b.customer_id is NOT NULL AND c.id is NOT NULL

-- CROSS JOIN
/* Generate all possible combinations of customers and orders */
SELECT *
FROM customers
CROSS JOIN orders

/* ============================================================================== 
   MULTIPLE TABLE JOINS (4 Tables)
=============================================================================== */

/* Task: Using SalesDB, Retrieve a list of all orders, along with the related customer, product, 
   and employee details. For each order, display:
   - Order ID
   - Customer's name
   - Product name
   - Sales amount
   - Product price
   - Salesperson's name */

USE SalesDB;

SELECT
	O.OrderID,
	C.FirstName,
	P.Product,
	O.Sales,
	P.Price,
	E.FirstName
FROM Sales.Orders AS O
LEFT JOIN Sales.Customers AS C
ON C.CustomerID = O.CustomerID
LEFT JOIN Sales.Products AS P
ON O.ProductID = P.ProductID
LEFT JOIN Sales.Employees AS E
ON E.EmployeeID = O.SalesPersonID;