-- CREATE VIEWS
CREATE VIEW Sales.V_Monthly_Summary	AS (
	SELECT
		DATETRUNC(month, OrderDate) OrderMonth,
		SUM(Sales) TotalSales,
		COUNT(OrderID) TotalOrders,
		SUM(Quantity) TotalQuantities
	FROM Sales.Orders
	GROUP BY DATETRUNC(month, OrderDate)
)

-- DELETE/DROP VIEWS
DROP VIEW V_Monthly_Summary


CREATE VIEW Sales.V_Order_Details AS (
	-- Provide VIEW that combines details from orders, products, customers,  and employees
	SELECT
		o.OrderID,
		o.OrderDate,
		p.Product,
		p.Category,
		COALESCE(c.FirstName, '') + ' ' + COALESCE(c.LastName, '') CustomerName,
		c.Country CustomerCountry,
		COALESCE(e.FirstName, '') + ' ' + COALESCE(e.LastName, '') SalesFullName,
		e.Department,
		-- SalesPersonID,
		o.Sales,
		o.Quantity
	FROM Sales.Orders o
	LEFT JOIN Sales.Products p
	ON p.ProductID = o.ProductID
	LEFT JOIN Sales.Customers c
	ON c.CustomerID = o.CustomerID
	LEFT JOIN Sales.Employees e
	ON e.EmployeeID = o.SalesPersonID
)