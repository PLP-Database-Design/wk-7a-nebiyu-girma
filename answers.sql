#1
  
  -- Split Products into individual rows for 1NF
CREATE TABLE ProductDetail_1NF AS
SELECT 
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', num), ',', -1)) AS Product
FROM ProductDetail
CROSS JOIN (
    SELECT 1 AS num UNION ALL
    SELECT 2 UNION ALL
    SELECT 3
) AS numbers
WHERE num <= LENGTH(Products) - LENGTH(REPLACE(Products, ',', '')) + 1;


#2

-- Create Orders table with customer details
CREATE TABLE Orders AS
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Create OrderProducts table with product and quantity
CREATE TABLE OrderProducts AS
SELECT OrderID, Product, Quantity
FROM OrderDetails;
