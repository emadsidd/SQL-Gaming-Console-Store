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


SELECT Orders.OrderID, Customers.CustomerID, Customers.CusFirstName, Customers.CusLastName, Products.ProductID, Products.ProductName, Products.Price
FROM GamingConsoleStore.Orders
INNER JOIN GamingConsoleStore.Customers ON Orders.CustomerID = Customers.CustomerID
INNER JOIN GamingConsoleStore.OrdersProducts ON Orders.OrderID = OrdersProducts.OrderID
INNER JOIN GamingConsoleStore.Products ON OrdersProducts.ProductID = Products.ProductID
ORDER BY Orders.OrderID;


SELECT Customers.CustomerID, Customers.CusFirstName, Customers.CusLastName, Subscriptions.SubscriptionID, Subscriptions.SubscriptionName
FROM GamingConsoleStore.Customers
LEFT OUTER JOIN GamingConsoleStore.CustomersSubscriptions ON Customers.CustomerID = CustomersSubscriptions.CustomerID
LEFT OUTER JOIN GamingConsoleStore.Subscriptions ON CustomersSubscriptions.SubscriptionID = Subscriptions.SubscriptionID
ORDER BY Customers.CustomerID, Subscriptions.SubscriptionID;


SELECT OrderID, CustomerID, TotalAmount
FROM GamingConsoleStore.Orders
WHERE TotalAmount = (SELECT MAX(TotalAmount) FROM GamingConsoleStore.Orders)
ORDER BY OrderID;


SELECT CustomerID, CusFirstName, CusLastName
FROM GamingConsoleStore.Customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM GamingConsoleStore.CustomersSubscriptions)
ORDER BY CustomerID;


SELECT Customers.CustomerID,
       CONCAT(Customers.CusFirstName, ' ', Customers.CusLastName) AS FullName,
       COUNT(DISTINCT Orders.OrderID) AS NumberOfOrders,
       SUM(Orders.TotalAmount) AS TotalAmountSpent,
       AVG(Orders.TotalAmount) AS AverageOrderAmount
FROM GamingConsoleStore.Customers
INNER JOIN GamingConsoleStore.Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerID
ORDER BY Customers.CustomerID;


SELECT CustomerID, CusFirstName, CusLastName
FROM GamingConsoleStore.Customers
WHERE CustomerID NOT IN (
    SELECT CustomerID
    FROM GamingConsoleStore.CustomersSubscriptions)
ORDER BY CustomerID;


SELECT OrderID, TotalAmount,
    CASE
        WHEN TotalAmount >= 450 THEN 'High Value'
        WHEN TotalAmount >= 250 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS OrderCategory
FROM GamingConsoleStore.Orders
ORDER BY OrderID;



SELECT Customers.CustomerID, Customers.CusFirstName, Customers.CusLastName
FROM GamingConsoleStore.Customers
WHERE NOT EXISTS (
    SELECT 1
    FROM GamingConsoleStore.CustomersSubscriptions
    WHERE Customers.CustomerID = CustomersSubscriptions.CustomerID)
ORDER BY Customers.CustomerID;



SELECT CustomerID, CusFirstName, CusLastName
FROM GamingConsoleStore.Customers
WHERE CustomerID IN (
	SELECT Customers.CustomerID
    FROM GamingConsoleStore.Customers
    LEFT OUTER JOIN GamingConsoleStore.CustomersSubscriptions ON Customers.CustomerID = CustomersSubscriptions.CustomerID
    LEFT OUTER JOIN GamingConsoleStore.Subscriptions ON CustomersSubscriptions.SubscriptionID = Subscriptions.SubscriptionID
    WHERE Subscriptions.SubscriptionName IS NOT NULL)
ORDER BY CustomerID;

    

