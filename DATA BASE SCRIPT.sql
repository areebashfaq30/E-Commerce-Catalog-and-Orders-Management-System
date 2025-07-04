-- 1. Create Database
CREATE DATABASE IF NOT EXISTS ECommerceD;

-- 2. Use the Database
USE ECommerceD;

-- 3. Drop Tables if Already Exist
DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;

-- 4. Create Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10, 2),
    Stock INT
);

-- 5. Create Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    OrderDate DATE
);

-- 6. Create OrderDetails Table
CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- 7. Insert Data into Products
INSERT INTO Products VALUES
(1, 'Laptop', 'Electronics', 1000.00, 10),
(2, 'Headphones', 'Electronics', 200.00, 30),
(3, 'Chair', 'Furniture', 150.00, 20),
(4, 'Desk', 'Furniture', 300.00, 15),
(5, 'Mouse', 'Electronics', 50.00, 50);

-- 8. Insert Data into Orders
INSERT INTO Orders VALUES
(101, 'Alice', '2025-06-01'),
(102, 'Bob', '2025-06-02'),
(103, 'Charlie', '2025-06-03');

-- 9. Insert Data into OrderDetails
INSERT INTO OrderDetails VALUES
(101, 1, 1),
(101, 2, 2),
(102, 3, 4),
(103, 5, 3);

-- ------------------------
-- 🔍 Complex Queries
-- ------------------------

-- 10. Total Price for Each Order
SELECT 
    o.OrderID,
    o.CustomerName,
    SUM(p.Price * od.Quantity) AS TotalAmount
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY o.OrderID, o.CustomerName;

-- 11. Top Selling Product by Quantity
SELECT 
    p.ProductName,
    SUM(od.Quantity) AS TotalSold
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY TotalSold DESC
LIMIT 1;

-- 12. Products That Were Never Ordered
SELECT * 
FROM Products
WHERE ProductID NOT IN (
    SELECT DISTINCT ProductID FROM OrderDetails
);

-- 13. Customers Who Ordered Electronics
SELECT DISTINCT o.CustomerName
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE p.Category = 'Electronics';

-- 14. Get Order Count and Total Quantity per Customer
SELECT 
    o.CustomerName,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    SUM(od.Quantity) AS TotalItemsOrdered
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY o.CustomerName;

-- 15. Total Sales Revenue per Category
SELECT 
    p.Category,
    SUM(p.Price * od.Quantity) AS TotalRevenue
FROM Products p
JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.Category
ORDER BY TotalRevenue DESC;

-- 16. Top 3 Most Expensive Products
SELECT * 
FROM Products 
ORDER BY Price DESC
LIMIT 3;

-- 17. Low Stock Products (less than 10 in stock)
SELECT * 
FROM Products
WHERE Stock < 10;

-- 18. Orders with More Than 2 Different Products
SELECT 
    o.OrderID,
    o.CustomerName,
    COUNT(od.ProductID) AS ProductCount
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY o.OrderID, o.CustomerName
HAVING COUNT(od.ProductID) > 2;

-- 19. Total Quantity Ordered per Product
SELECT 
    p.ProductName,
    SUM(od.Quantity) AS TotalOrdered
FROM Products p
JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY TotalOrdered DESC;

-- 20. Average Order Value
SELECT 
    AVG(TotalAmount) AS AverageOrderValue
FROM (
    SELECT 
        o.OrderID,
        SUM(p.Price * od.Quantity) AS TotalAmount
    FROM Orders o
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY o.OrderID
) AS OrderTotals;

-- 21. Products Ordered in More Than One Order
SELECT 
    p.ProductName,
    COUNT(DISTINCT od.OrderID) AS OrdersCount
FROM Products p
JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductName
HAVING COUNT(DISTINCT od.OrderID) > 1;

SELECT 
    p.ProductName,
    COUNT(DISTINCT od.OrderID) AS OrdersAppearedIn
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY OrdersAppearedIn DESC
LIMIT 1;

SELECT 
    p.ProductName,
    SUM(p.Price * od.Quantity) AS TotalRevenue
FROM Products p
JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductName
HAVING SUM(p.Price * od.Quantity) > 500;