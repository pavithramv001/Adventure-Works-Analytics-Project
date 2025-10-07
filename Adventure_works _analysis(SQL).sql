-- Adventure work analysis
CREATE DATABASE Adventure_works;
USE Adventure_works;

CREATE TABLE Total_sales (
SELECT * FROM factinternetsales UNION SELECT * FROM fact_internet_sales_new
);

SELECT * FROM Total_sales;

-- KPI'S

# 1. TOTAL NUMBER OF PRODUCTS
SELECT COUNT(englishproductname) AS Total_Number_of_Products FROM dimproduct;

# 2. TOTAL NUMBER OF CUSTOMERS
SELECT COUNT(`Customer name`) AS Total_Number_of_Customers FROM dimcustomer;

# 3.TOTAL PRODUCTION COST
SELECT CONCAT(ROUND(SUM(totalproductcost)/1000000,2),'M') AS Total_Production_cost FROM total_sales;

# 4.TOTAL NUMBER OF ORDERS
SELECT COUNT(OrderDateKey) AS Total_orders FROM total_sales;

# 5.TOTAL SALES
SELECT CONCAT(ROUND(SUM(salesamount)/1000000,2),'M') AS total_Sales_amount FROM total_sales;

# 6.TOTAL PROFIT
ALTER TABLE total_sales
ADD COLUMN  totalProfit DECIMAL(10,2);

UPDATE total_sales
SET totalProfit = SalesAmount-TaxAmt-Freight-TotalProductCost;

SELECT CONCAT(ROUND(SUM(TotalProfit)/1000000,2),'M') AS Total_Profit FROM total_sales;

# 7.YEAR WISE SALES
SELECT YEAR(Orderdatekey_d) AS year,
CONCAT(ROUND(SUM(SalesAmount)/1000,2),"K") AS Sales FROM Total_sales
GROUP BY year
ORDER BY year;

# 8.MONTH WISE SALES
SELECT MONTHNAME(Orderdatekey_d) AS Month,
CONCAT(ROUND(SUM(SalesAmount)/1000000,2),"M") AS Sales FROM Total_sales
GROUP BY Month
ORDER BY Sales;

# 9.QUARTER WISE SALES
SELECT CONCAT("Q",QUARTER(Orderdatekey_d)) AS Quarter,
CONCAT(ROUND(SUM(SalesAmount)/1000000,2),"M") AS Sales FROM Total_sales
GROUP BY Quarter
ORDER BY Sales;


# 10.YEAR WISE SALES AND PRODUCTION COST
SELECT YEAR(Orderdatekey_d) AS Year,
CONCAT(ROUND(SUM(SalesAmount)/1000000,2),"M") AS Sales ,
CONCAT(ROUND(SUM(TotalProductCost)/1000000,2),"M")AS Production_cost FROM Total_sales
GROUP BY Year
ORDER BY YEAR,Production_cost ASC;

# 11.SALES AND PROFIT BY GROUPS
SELECT SalesTerritoryGroup AS Groups_,
CONCAT(ROUND(SUM(SalesAmount)/1000000,2),"M") AS Sales ,
CONCAT(ROUND(SUM(totalprofit)/1000000,2),"M") AS Profit FROM Total_sales
JOIN dimsalesterritory
ON(dimsalesterritory.SalesTerritoryKey=Total_sales.SalesTerritoryKey)
GROUP BY Groups_;

# 12.TOP 10 CUSTOMERS BY SALES
SELECT `Customer name`,
CONCAT(ROUND(SUM(SalesAmount)/1000,2),"K") AS Sales FROM dimcustomer
JOIN Total_sales
ON(dimcustomer.CustomerKey=Total_sales.CustomerKey)
GROUP BY `Customer name` ORDER BY Sales DESC LIMIT 10;

# 13.TOP 5 REGIONS BY PROFIT
SELECT SalesTerritoryRegion AS Region ,
CONCAT(ROUND(SUM(totalprofit)/1000,2),"K") AS Profit FROM dimsalesterritory
JOIN Total_sales
ON(dimsalesterritory.SalesTerritoryKey=Total_sales.SalesTerritoryKey)
GROUP BY Region
ORDER BY Profit DESC
LIMIT 5;

# 14. PRODUCT HAVING MORE THAN AVERAGE SALES
SELECT EnglishProductName AS Product_name,
CONCAT(ROUND(SUM(SalesAmount)/1000,2),"K") AS Sales FROM dimproduct
JOIN Total_sales
ON(Total_sales.ProductKey=dimproduct.ProductKey)
WHERE SalesAmount>(SELECT AVG(SalesAmount) FROM Total_sales) 
GROUP BY Product_name ORDER BY Sales;







