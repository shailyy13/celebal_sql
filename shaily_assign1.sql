USE AdventureWorks2019;
-- Q1: Show all customers
SELECT * FROM Sales.Customer;

-- Q2: Customers with company name ending in 'N'
SELECT * 
FROM Sales.Customer c 
JOIN Sales.Store s ON c.StoreID = s.BusinessEntityID 
WHERE s.Name LIKE '%N';

-- Q3: Customers from Berlin or London
SELECT * 
FROM Sales.Customer c 
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID 
JOIN Person.BusinessEntityAddress bea ON p.BusinessEntityID = bea.BusinessEntityID 
JOIN Person.Address a ON bea.AddressID = a.AddressID 
WHERE a.City IN ('Berlin', 'London');

-- Q4: Customers in UK or USA
SELECT * 
FROM Sales.Customer c 
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID 
JOIN Person.BusinessEntityAddress bea ON p.BusinessEntityID = bea.BusinessEntityID 
JOIN Person.Address a ON bea.AddressID = a.AddressID 
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID 
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode 
WHERE cr.Name IN ('United Kingdom', 'United States');

-- Q5: All products sorted by name
SELECT * FROM Production.Product ORDER BY Name;

-- Q6: Products starting with A
SELECT * FROM Production.Product WHERE Name LIKE 'A%';

-- Q7: Customers who placed any order
SELECT DISTINCT c.CustomerID, c.AccountNumber 
FROM Sales.Customer c 
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID;

-- Q8: Customers from London who bought 'Chai'
SELECT DISTINCT c.CustomerID 
FROM Sales.Customer c 
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID 
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID 
JOIN Production.Product p ON p.ProductID = sod.ProductID 
JOIN Person.BusinessEntityAddress bea ON c.PersonID = bea.BusinessEntityID 
JOIN Person.Address a ON bea.AddressID = a.AddressID 
WHERE a.City = 'London' AND p.Name = 'Chai';

-- Q9: Customers who never ordered
SELECT c.CustomerID, c.AccountNumber 
FROM Sales.Customer c 
LEFT JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID 
WHERE soh.CustomerID IS NULL;

-- Q10: Customers who ordered 'Tofu'
SELECT DISTINCT c.CustomerID, c.AccountNumber 
FROM Sales.Customer c 
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID 
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID 
JOIN Production.Product p ON sod.ProductID = p.ProductID 
WHERE p.Name = 'Tofu';

-- Q11: First order ever placed
SELECT TOP 1 * FROM Sales.SalesOrderHeader ORDER BY OrderDate ASC;

-- Q12: Order with highest total
SELECT TOP 1 OrderDate, TotalDue FROM Sales.SalesOrderHeader ORDER BY TotalDue DESC;

-- Q13: Average item qty per order
SELECT SalesOrderID, AVG(OrderQty) AS AvgQty 
FROM Sales.SalesOrderDetail 
GROUP BY SalesOrderID;

-- Q14: Min and max quantity per order
SELECT SalesOrderID, MIN(OrderQty) AS MinQty, MAX(OrderQty) AS MaxQty 
FROM Sales.SalesOrderDetail 
GROUP BY SalesOrderID;

-- Q15: Count employees under each manager
SELECT e2.BusinessEntityID AS ManagerID, COUNT(e1.BusinessEntityID) AS TotalEmployees 
FROM HumanResources.Employee e1 
JOIN HumanResources.Employee e2 ON e1.OrganizationNode.GetAncestor(1) = e2.OrganizationNode 
GROUP BY e2.BusinessEntityID;

-- Q16: Orders with total quantity > 300
SELECT SalesOrderID, SUM(OrderQty) AS TotalQty 
FROM Sales.SalesOrderDetail 
GROUP BY SalesOrderID 
HAVING SUM(OrderQty) > 300;

-- Q17: Orders from 1997 onward
SELECT * FROM Sales.SalesOrderHeader WHERE OrderDate >= '1996-12-31';

-- Q18: Orders shipped to Canada
SELECT soh.* 
FROM Sales.SalesOrderHeader soh 
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID 
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID 
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode 
WHERE cr.Name = 'Canada';

-- Q19: Orders above $200
SELECT * FROM Sales.SalesOrderHeader WHERE TotalDue > 200;

-- Q20: Country-wise total sales
SELECT cr.Name AS Country, SUM(soh.TotalDue) AS TotalSales 
FROM Sales.SalesOrderHeader soh 
JOIN Person.Address a ON soh.BillToAddressID = a.AddressID 
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID 
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode 
GROUP BY cr.Name;

-- Q21: Customer names with their order counts
SELECT p.FirstName + ' ' + p.LastName AS FullName, COUNT(soh.SalesOrderID) AS TotalOrders 
FROM Sales.Customer c 
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID 
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID 
GROUP BY p.FirstName, p.LastName;

-- Q22: Customers with >3 orders
SELECT p.FirstName + ' ' + p.LastName AS FullName, COUNT(soh.SalesOrderID) AS TotalOrders 
FROM Sales.Customer c 
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID 
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID 
GROUP BY p.FirstName, p.LastName 
HAVING COUNT(soh.SalesOrderID) > 3;

-- Q23: Discontinued products ordered on time
SELECT DISTINCT p.Name 
FROM Production.Product p 
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID 
JOIN Sales.SalesOrderHeader soh ON soh.SalesOrderID = sod.SalesOrderID 
WHERE p.SellEndDate IS NOT NULL AND soh.OrderDate <= p.SellEndDate;

-- Q24: Employee with their manager
SELECT e.BusinessEntityID, emp.FirstName + ' ' + emp.LastName AS EmpName, 
       sup.FirstName + ' ' + sup.LastName AS ManagerName 
FROM HumanResources.Employee e 
JOIN Person.Person emp ON e.BusinessEntityID = emp.BusinessEntityID 
JOIN HumanResources.Employee m ON e.OrganizationNode.GetAncestor(1) = m.OrganizationNode 
JOIN Person.Person sup ON m.BusinessEntityID = sup.BusinessEntityID;

-- Q25: Sales made by each salesperson
SELECT soh.SalesPersonID AS EmpID, SUM(soh.TotalDue) AS Sales 
FROM Sales.SalesOrderHeader soh 
WHERE soh.SalesPersonID IS NOT NULL 
GROUP BY soh.SalesPersonID;

-- Q26: Employees with 'a' in first name
SELECT * FROM Person.Person WHERE FirstName LIKE '%a%';

-- Q27: Managers with more than 4 subordinates
SELECT e2.BusinessEntityID AS ManagerID, COUNT(*) AS Reportees 
FROM HumanResources.Employee e1 
JOIN HumanResources.Employee e2 ON e1.OrganizationNode.GetAncestor(1) = e2.OrganizationNode 
GROUP BY e2.BusinessEntityID 
HAVING COUNT(*) > 4;

-- Q28: Order IDs and product names
SELECT soh.SalesOrderID, p.Name AS ProductName 
FROM Sales.SalesOrderHeader soh 
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID 
JOIN Production.Product p ON sod.ProductID = p.ProductID;

-- Q29: Customer with max orders
SELECT TOP 1 soh.CustomerID, COUNT(*) AS Orders 
FROM Sales.SalesOrderHeader soh 
GROUP BY soh.CustomerID 
ORDER BY Orders DESC;

-- Q30: Orders from customers without fax
SELECT soh.* 
FROM Sales.SalesOrderHeader soh 
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID 
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID 
WHERE NOT EXISTS (
    SELECT 1 
    FROM Person.PersonPhone pp 
    JOIN Person.PhoneNumberType pt ON pp.PhoneNumberTypeID = pt.PhoneNumberTypeID 
    WHERE pt.Name = 'Fax' AND pp.BusinessEntityID = p.BusinessEntityID
);

-- Q31: Postal codes where Tofu was delivered
SELECT DISTINCT a.PostalCode 
FROM Sales.SalesOrderHeader soh 
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID 
JOIN Production.Product p ON sod.ProductID = p.ProductID 
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID 
WHERE p.Name = 'Tofu';

-- Q32: Products shipped to France
SELECT DISTINCT p.Name 
FROM Sales.SalesOrderHeader soh 
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID 
JOIN Production.Product p ON sod.ProductID = p.ProductID 
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID 
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID 
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode 
WHERE cr.Name = 'France';

-- Q33: Products from Specialty Biscuits, Ltd.
SELECT p.Name AS Product, pc.Name AS Category 
FROM Production.Product p 
JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID 
JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID 
JOIN Purchasing.ProductVendor pv ON p.ProductID = pv.ProductID 
JOIN Purchasing.Vendor v ON pv.BusinessEntityID = v.BusinessEntityID 
WHERE v.Name = 'Specialty Biscuits, Ltd.';

-- Q34: Products never sold
SELECT p.Name 
FROM Production.Product p 
LEFT JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID 
WHERE sod.ProductID IS NULL;

-- Q35: Low stock and zero reorder
SELECT Name, SafetyStockLevel, ReorderPoint 
FROM Production.Product 
WHERE SafetyStockLevel <= 10 AND ReorderPoint = 0 
ORDER BY SafetyStockLevel, ReorderPoint;

-- Q36: Top 10 countries by total sales
SELECT TOP 10 cr.Name AS Country, SUM(soh.TotalDue) AS TotalSales 
FROM Sales.SalesOrderHeader soh 
JOIN Person.Address a ON soh.BillToAddressID = a.AddressID 
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID 
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode 
GROUP BY cr.Name 
ORDER BY TotalSales DESC;

-- Q37: Orders for customers between A and AO
SELECT e.BusinessEntityID AS EmployeeID, COUNT(*) AS OrdersHandled 
FROM Sales.SalesOrderHeader soh 
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID 
JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID 
JOIN HumanResources.Employee e ON sp.BusinessEntityID = e.BusinessEntityID 
WHERE c.AccountNumber LIKE 'AW%' 
GROUP BY e.BusinessEntityID;

-- Q38: Order with highest value
SELECT TOP 1 OrderDate, TotalDue FROM Sales.SalesOrderHeader ORDER BY TotalDue DESC;

-- Q39: Most revenue-generating product
SELECT p.Name, SUM(sod.LineTotal) AS TotalRevenue 
FROM Sales.SalesOrderDetail sod 
JOIN Production.Product p ON sod.ProductID = p.ProductID 
GROUP BY p.Name 
ORDER BY TotalRevenue DESC;

-- Q40: Suppliers and their product count
SELECT pv.BusinessEntityID AS SupplierID, COUNT(pv.ProductID) AS ProductCount 
FROM Purchasing.ProductVendor pv 
GROUP BY pv.BusinessEntityID;

-- Q41: Top 10 customers by purchase value
SELECT TOP 10 c.CustomerID, SUM(soh.TotalDue) AS TotalValue 
FROM Sales.SalesOrderHeader soh 
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID 
GROUP BY c.CustomerID 
ORDER BY TotalValue DESC;

-- Q42: Total revenue of the company
SELECT SUM(TotalDue) AS TotalRevenue FROM Sales.SalesOrderHeader;
