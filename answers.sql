-- --------------------------------------------------------
-- Question 1: Achieving 1NF
-- --------------------------------------------------------

-- Step 1: Create normalized table
CREATE TABLE IF NOT EXISTS ProductDetail1NF (
    OrderID INT NOT NULL,
    CustomerName VARCHAR(255) NOT NULL,
    Product VARCHAR(100) NOT NULL,
    PRIMARY KEY (OrderID, Product)
);

-- Step 2: Insert split data from original table
INSERT INTO ProductDetail1NF (OrderID, CustomerName, Product)
SELECT 
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n.digit + 1), ',', -1)) AS Product
FROM 
    ProductDetail
JOIN 
    (SELECT 0 AS digit UNION ALL SELECT 1 UNION ALL SELECT 2) n
WHERE 
    LENGTH(Products) - LENGTH(REPLACE(Products, ',', '')) >= n.digit
ORDER BY 
    OrderID, Product;

-- --------------------------------------------------------
-- Question 2: Achieving 2NF
-- --------------------------------------------------------

-- Step 1: Create Orders table to remove partial dependency
CREATE TABLE IF NOT EXISTS Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255) NOT NULL
);

-- Step 2: Create OrderProducts table for full dependency
CREATE TABLE IF NOT EXISTS OrderProducts (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Step 3: Populate normalized tables
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

INSERT INTO OrderProducts (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;
