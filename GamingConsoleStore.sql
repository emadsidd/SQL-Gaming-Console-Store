CREATE DATABASE GamingConsoleStore;
SHOW DATABASES;

USE GamingConsoleStore;

CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    CusFirstName VARCHAR(255) NOT NULL,
    CusLastName VARCHAR(255),
    CusEmail VARCHAR(255),
    CusPhone VARCHAR(15),
    CusAddress VARCHAR(255));

DESCRIBE GamingConsoleStore.Customers;

ALTER TABLE Customers AUTO_INCREMENT = 1000001;

INSERT INTO Customers (CusFirstName, CusLastName, CusEmail, CusPhone, CusAddress)
VALUES
    ('Mason', 'Jackson', 'masonjackson@email.e', '028-286-5066', 'Birkenhead Route, 425'),
    ('Macy', 'Osmond', 'macyosmond@email.e', '462-887-1645', 'Duthie Rue, 2534'),
    ('Isabel', 'Owen', 'isabelowen@email.e', '381-152-1768', 'Magnolia Hill, 8051'),
    ('Eryn', 'Stewart', 'erystewart@email.e', '640-021-1713', 'Vine Crossroad, 7244'),
    ('Cristal', 'Dickson', 'cristaldickson@email.e', '028-722-4677', 'Bayberry Vale, 8569'),
    ('Sylvia', 'Whitmore', 'sylviawhitmore@email.e', '116-205-6158', 'Aspen Tunnel, 7276');
    
SELECT * FROM GamingConsoleStore.Customers ORDER BY CustomerID; 

CREATE TABLE Subscriptions (
    SubscriptionID INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    SubscriptionName VARCHAR(255) NOT NULL);

DESCRIBE GamingConsoleStore.Subscriptions;

INSERT INTO Subscriptions (SubscriptionName)
VALUES
    ('Store Promotions via SMS'),
    ('Store Promotions via Email');

SELECT * FROM GamingConsoleStore.Subscriptions ORDER BY SubscriptionID; 


CREATE TABLE CustomersSubscriptions (
    CustomerID INT NOT NULL,
    SubscriptionID INT NOT NULL,
    PRIMARY KEY (CustomerID, SubscriptionID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (SubscriptionID) REFERENCES Subscriptions(SubscriptionID));

DESCRIBE GamingConsoleStore.CustomersSubscriptions;

INSERT INTO CustomersSubscriptions (CustomerID, SubscriptionID)
VALUES
    (1000001, 1), 
    (1000001, 2),
    (1000002, 1), 
    (1000004, 2), 
    (1000006, 1),
    (1000006, 2); 

SELECT * FROM GamingConsoleStore.CustomersSubscriptions ORDER BY CustomerID; 



CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    ProductName VARCHAR(255) NOT NULL,
    Category VARCHAR(255) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL);

DESCRIBE GamingConsoleStore.Products;

ALTER TABLE Products AUTO_INCREMENT = 70001;

INSERT INTO Products (ProductName, Category, Price)
VALUES
    ('PlayStation 5', 'Console', 499.99),
    ('Xbox Series X', 'Console', 499.99),
    ('Xbox Series S', 'Console', 299.99),
    ('Nintendo Switch', 'Console', 299.99),
    ('Sony DualSense', 'Controller', 69.99),
    ('Xbox Wireless Controller', 'Controller', 59.99);

SELECT * FROM GamingConsoleStore.Products ORDER BY ProductID;


CREATE TABLE Employees (
    EmployeeID INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Position VARCHAR(255) NOT NULL,
    Salary DECIMAL(10, 2) NOT NULL);

DESCRIBE GamingConsoleStore.Employees;

ALTER TABLE Employees AUTO_INCREMENT = 3001;

INSERT INTO Employees (FirstName, LastName, Position, Salary)
VALUES
    ('Blake', 'Lynn', 'Sales Associate', 14.00),
    ('Oliver', 'Grady', 'Sales Associate', 14.00),
    ('Georgia', 'Ripley', 'Store Manager', 20.00);

SELECT * FROM GamingConsoleStore.Employees ORDER BY EmployeeID;


CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    CustomerID INT NOT NULL,
    EmployeeID INT NOT NULL,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID));

DESCRIBE GamingConsoleStore.Orders;

ALTER TABLE Orders AUTO_INCREMENT = 50000001;

INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, TotalAmount)
VALUES
    (1000001, 3002, '2023-10-31', 569.98),
    (1000002, 3003, '2023-11-01', 299.99),
    (1000003, 3001, '2023-11-01', 559.98),
    (1000004, 3002, '2023-11-02', 299.99),
    (1000005, 3003, '2023-11-03', 499.99),
    (1000006, 3002, '2023-11-04', 859.97),
    (1000002, 3001, '2023-11-04', 59.99);

SELECT * FROM GamingConsoleStore.Orders ORDER BY OrderID;


CREATE TABLE OrdersProducts (
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID));
    
DESCRIBE GamingConsoleStore.OrdersProducts;

INSERT INTO OrdersProducts (OrderID, ProductID)
VALUES
    (50000001, 70001), 
    (50000001, 70005),
    (50000002, 70003), 
    (50000003, 70002), 
    (50000003, 70006),
    (50000004, 70004),
    (50000005, 70001),
    (50000006, 70002), 
    (50000006, 70006), 
    (50000006, 70004),
    (50000007, 70006);
    
SELECT * FROM GamingConsoleStore.OrdersProducts ORDER BY OrderID;

SHOW Tables;


-- Queries for analysis

-- Join Orders, Customers, and Products to display a complete view of orders
SELECT Orders.OrderID, Customers.CustomerID, Customers.CusFirstName, Customers.CusLastName, Products.ProductID, Products.ProductName, Products.Price
FROM GamingConsoleStore.Orders
INNER JOIN GamingConsoleStore.Customers ON Orders.CustomerID = Customers.CustomerID
INNER JOIN GamingConsoleStore.OrdersProducts ON Orders.OrderID = OrdersProducts.OrderID
INNER JOIN GamingConsoleStore.Products ON OrdersProducts.ProductID = Products.ProductID
ORDER BY Orders.OrderID;


-- Display customers with their subscription preferences
SELECT Customers.CustomerID, Customers.CusFirstName, Customers.CusLastName, Subscriptions.SubscriptionID, Subscriptions.SubscriptionName
FROM GamingConsoleStore.Customers
LEFT JOIN GamingConsoleStore.CustomersSubscriptions ON Customers.CustomerID = CustomersSubscriptions.CustomerID
LEFT JOIN GamingConsoleStore.Subscriptions ON CustomersSubscriptions.SubscriptionID = Subscriptions.SubscriptionID
ORDER BY Customers.CustomerID, Subscriptions.SubscriptionID;


-- Identify customers who have at least one subscription
SELECT CustomerID, CusFirstName, CusLastName
FROM GamingConsoleStore.Customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM GamingConsoleStore.CustomersSubscriptions)
ORDER BY CustomerID;


-- Aggregate order data by customer to analyze purchasing behavior
SELECT Customers.CustomerID,
       CONCAT(Customers.CusFirstName, ' ', Customers.CusLastName) AS FullName,
       COUNT(DISTINCT Orders.OrderID) AS NumberOfOrders,
       SUM(Orders.TotalAmount) AS TotalAmountSpent,
       AVG(Orders.TotalAmount) AS AverageOrderAmount
FROM GamingConsoleStore.Customers
INNER JOIN GamingConsoleStore.Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerID
ORDER BY TotalAmountSpent DESC;


-- Count of orders per customer to understand customer behavior
SELECT Customers.CustomerID, COUNT(Orders.OrderID) AS NumberOfOrders
FROM GamingConsoleStore.Customers
INNER JOIN GamingConsoleStore.Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerID
ORDER BY NumberOfOrders DESC;


-- Subscription trend analysis by counting customers per subscription type
SELECT Subscriptions.SubscriptionName, COUNT(CustomersSubscriptions.CustomerID) AS NumberOfSubscribers
FROM GamingConsoleStore.Subscriptions
INNER JOIN GamingConsoleStore.CustomersSubscriptions ON Subscriptions.SubscriptionID = CustomersSubscriptions.SubscriptionID
GROUP BY Subscriptions.SubscriptionName
ORDER BY NumberOfSubscribers DESC;


-- Segment customers based on their total spending
SELECT CustomerID,
       SUM(TotalAmount) AS TotalSpent,
       CASE
         WHEN SUM(TotalAmount) > 1000 THEN 'High Spender'
         WHEN SUM(TotalAmount) BETWEEN 500 AND 1000 THEN 'Medium Spender'
         ELSE 'Low Spender'
       END AS SpendingCategory
FROM GamingConsoleStore.Orders
GROUP BY CustomerID
ORDER BY TotalSpent DESC;


-- Segment customers based on the type of products they purchase most frequently
SELECT Customers.CustomerID, Products.Category, COUNT(OrdersProducts.ProductID) AS ProductCount
FROM GamingConsoleStore.Customers
INNER JOIN GamingConsoleStore.Orders ON Customers.CustomerID = Orders.CustomerID
INNER JOIN GamingConsoleStore.OrdersProducts ON Orders.OrderID = OrdersProducts.OrderID
INNER JOIN GamingConsoleStore.Products ON OrdersProducts.ProductID = Products.ProductID
GROUP BY Customers.CustomerID, Products.Category
ORDER BY ProductCount DESC;


-- Find customers without subscriptions
SELECT CustomerID, CusFirstName, CusLastName
FROM GamingConsoleStore.Customers
WHERE CustomerID NOT IN (
    SELECT CustomerID
    FROM GamingConsoleStore.CustomersSubscriptions)
ORDER BY CustomerID;


-- Determine the top-selling products
SELECT ProductName, Category, Count(OrdersProducts.ProductID) AS UnitsSold
FROM GamingConsoleStore.Products
INNER JOIN GamingConsoleStore.OrdersProducts ON Products.ProductID = OrdersProducts.ProductID
GROUP BY ProductName, Category
ORDER BY UnitsSold DESC;


-- Calculate the average spend per order for each product category
SELECT Category, AVG(CategoryTotal) AS AvgSpendPerOrderByCategory
FROM (SELECT Orders.OrderID, Products.Category, SUM(Products.Price) AS CategoryTotal
    FROM GamingConsoleStore.Orders
    INNER JOIN GamingConsoleStore.OrdersProducts ON Orders.OrderID = OrdersProducts.OrderID
    INNER JOIN GamingConsoleStore.Products ON OrdersProducts.ProductID = Products.ProductID
    GROUP BY Orders.OrderID, Products.Category
) AS OrderCategoryTotals
GROUP BY Category;


-- Rank customers based on their total spending
SELECT CustomerID, RANK() OVER (ORDER BY SUM(TotalAmount) DESC) AS SpendingRank
FROM GamingConsoleStore.Orders
GROUP BY CustomerID;


-- Evalaute sales performance for each employee
SELECT 
    Employees.EmployeeID, 
    CONCAT(Employees.FirstName, ' ', Employees.LastName) AS FullName, 
    COUNT(Orders.OrderID) AS OrderCount,
    SUM(Orders.TotalAmount) AS TotalSales
FROM GamingConsoleStore.Employees
INNER JOIN GamingConsoleStore.Orders ON Employees.EmployeeID = Orders.EmployeeID
GROUP BY Employees.EmployeeID
ORDER BY TotalSales DESC; 


-- Analyze the impact of subscriptions on customer spending behavior
SELECT 
    'Subscribed' AS SubscriptionStatus,
    COUNT(DISTINCT CustomerID) AS CustomerCount,
    AVG(TotalAmount) AS AverageOrderValue
FROM GamingConsoleStore.Orders
WHERE CustomerID IN (SELECT CustomerID FROM GamingConsoleStore.CustomersSubscriptions)
UNION ALL
SELECT 
    'Not Subscribed' AS SubscriptionStatus,
    COUNT(DISTINCT CustomerID) AS CustomerCount,
    AVG(TotalAmount) AS AverageOrderValue
FROM GamingConsoleStore.Orders
WHERE CustomerID NOT IN (SELECT CustomerID FROM GamingConsoleStore.CustomersSubscriptions);
