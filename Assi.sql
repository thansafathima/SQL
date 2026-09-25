-- 1. Display sales where the salesperson name starts with 'A'
SELECT *
FROM sales s
JOIN people p ON s.SPID = p.SPID
WHERE p.Salesperson LIKE 'A%';

-- 2. Find all products that have never been sold (use LEFT JOIN)
SELECT *
FROM products pr
LEFT JOIN sales s ON pr.PID = s.PID
WHERE s.PID IS NULL;

-- 3. Show sales records where the product name ends with 's'
SELECT s.*, pr.Product
FROM sales s
JOIN products pr ON s.PID = pr.PID
WHERE pr.Product LIKE '%s';

-- 4. Find total number of unique products sold
SELECT COUNT(DISTINCT PID) AS Unique_Products_Sold
FROM sales;

-- 5. Display the second highest sale amount
SELECT DISTINCT Amount
FROM sales
ORDER BY Amount DESC
LIMIT 1 OFFSET 1;

-- 6. Find the salesperson who has done the least number of sales
SELECT p.Salesperson, COUNT(s.SPID) AS Total_Sales
FROM people p
LEFT JOIN sales s ON p.SPID = s.SPID
GROUP BY p.SPID, p.Salesperson
ORDER BY Total_Sales ASC
LIMIT 1;

-- 7. Display country-wise highest sale amount
SELECT g.Geo AS Country, MAX(s.Amount) AS Max_Sale_Amount
FROM sales s
JOIN geo g ON s.GeoID = g.GeoID
GROUP BY g.Geo;

-- 8. Show the total sales amount for each day (SaleDate wise)
SELECT SaleDate, SUM(Amount) AS Total_Sales_Amount
FROM sales
GROUP BY SaleDate
ORDER BY SaleDate;

-- 9. Find sales records where Boxes are greater than average Boxes
SELECT *
FROM sales
WHERE Boxes > (SELECT AVG(Boxes) FROM sales);

-- 10. Display the product that has the lowest total sales
SELECT pr.Product, SUM(s.Amount) AS Total_Sales
FROM products pr
JOIN sales s ON pr.PID = s.PID
GROUP BY pr.PID, pr.Product
ORDER BY Total_Sales ASC
LIMIT 1;

-- 11. Show the number of sales done in each country
SELECT g.Geo AS Country, COUNT(s.SPID) AS Number_Of_Sales
FROM geo g
JOIN sales s ON g.GeoID = s.GeoID
GROUP BY g.Geo;

-- 12. Find the average sales amount for each team, but only for teams with more than 5 sales
SELECT p.Team, AVG(s.Amount) AS Avg_Sale_Amount
FROM sales s
JOIN people p ON s.SPID = p.SPID
GROUP BY p.Team
HAVING COUNT(s.SPID) > 5;

-- 13. Display sales where Amount is an even number
SELECT *
FROM sales
WHERE Amount % 2 = 0;

-- 14. Find the difference between maximum and minimum sales amount
SELECT MAX(Amount) - MIN(Amount) AS Amount_Difference
FROM sales;

-- 15. Show top 3 countries with highest total sales
SELECT g.Geo AS Country, SUM(s.Amount) AS Total_Sales
FROM sales s
JOIN geo g ON s.GeoID = g.GeoID
GROUP BY g.Geo
ORDER BY Total_Sales DESC
LIMIT 3;

-- 16. Display sales where salesperson belongs to teams starting with 'D'
SELECT s.*, p.Salesperson, p.Team
FROM sales s
JOIN people p ON s.SPID = p.SPID
WHERE p.Team LIKE 'D%';

-- 17. Find all sales that happened on weekends (Saturday/Sunday)
SELECT *
FROM sales
WHERE DAYOFWEEK(SaleDate) IN (1, 7); -- 1 = Sunday, 7 = Saturday (Standard MySQL syntax)

-- 18. Display the earliest and latest sale date
SELECT MIN(SaleDate) AS Earliest_Sale, MAX(SaleDate) AS Latest_Sale
FROM sales;

-- 19. Find the salesperson who sold the maximum number of boxes
SELECT p.Salesperson, SUM(s.Boxes) AS Total_Boxes_Sold
FROM people p
JOIN sales s ON p.SPID = s.SPID
GROUP BY p.SPID, p.Salesperson
ORDER BY Total_Boxes_Sold DESC
LIMIT 1;

-- 20. Show product-wise average boxes sold
SELECT pr.Product, AVG(s.Boxes) AS Avg_Boxes_Sold
FROM products pr
JOIN sales s ON pr.PID = s.PID
GROUP BY pr.PID, pr.Product;

-- 21. Display sales records where country is not 'India'
SELECT s.*, g.Geo AS Country
FROM sales s
JOIN geo g ON s.GeoID = g.GeoID
WHERE g.Geo <> 'India';

-- 22. Find total sales for products whose name contains 'choco'
SELECT SUM(s.Amount) AS Total_Choco_Sales
FROM sales s
JOIN products pr ON s.PID = pr.PID
WHERE pr.Product LIKE '%choco%';

-- 23. Show sales where Amount is divisible by 5
SELECT *
FROM sales
WHERE Amount % 5 = 0;

-- 24. Find the country with the least number of sales
SELECT g.Geo AS Country, COUNT(s.SPID) AS Number_Of_Sales
FROM geo g
LEFT JOIN sales s ON g.GeoID = s.GeoID
GROUP BY g.GeoID, g.Geo
ORDER BY Number_Of_Sales ASC
LIMIT 1;

-- 25. Display cumulative sales amount ordered by SaleDate
SELECT SaleDate, Amount, 
       SUM(Amount) OVER (ORDER BY SaleDate, SPID, GeoID, PID) AS Cumulative_Amount
FROM sales;

-- 26. Find duplicate sales amounts (same Amount appearing multiple times)
SELECT Amount, COUNT(*) AS Frequency
FROM sales
GROUP BY Amount
HAVING COUNT(*) > 1;

-- 27. Show sales where product name has exactly 5 characters
SELECT s.*, pr.Product
FROM sales s
JOIN products pr ON s.PID = pr.PID
WHERE LENGTH(pr.Product) = 5;

-- 28. Display the top selling product in each country
WITH CountryProductSales AS (
    SELECT g.Geo AS Country, pr.Product, SUM(s.Amount) AS Total_Amount,
           ROW_NUMBER() OVER (PARTITION BY g.Geo ORDER BY SUM(s.Amount) DESC) AS rnk
    FROM sales s
    JOIN geo g ON s.GeoID = g.GeoID
    JOIN products pr ON s.PID = pr.PID
    GROUP BY g.Geo, pr.PID, pr.Product
)
SELECT Country, Product, Total_Amount
FROM CountryProductSales
WHERE rnk = 1;

-- 29. Find percentage contribution of each country to total sales
SELECT g.Geo AS Country,
       SUM(s.Amount) AS Country_Sales,
       ROUND((SUM(s.Amount) * 100.0 / (SELECT SUM(Amount) FROM sales)), 2) AS Sales_Percentage
FROM sales s
JOIN geo g ON s.GeoID = g.GeoID
GROUP BY g.Geo;

-- 30. Show sales records where Amount is higher than previous sale (use window function)
WITH SalesWithPrev AS (
    SELECT *, 
           LAG(Amount) OVER (ORDER BY SaleDate) AS Prev_Amount
    FROM sales
)
SELECT * 
FROM SalesWithPrev
WHERE Amount > Prev_Amount;

-- 31. Rank sales based on Amount (highest to lowest)
SELECT *, 
       DENSE_RANK() OVER (ORDER BY Amount DESC) AS Sales_Rank
FROM sales;

-- 32. Find running total of boxes sold per country
SELECT g.Geo AS Country, s.SaleDate, s.Boxes,
       SUM(s.Boxes) OVER (PARTITION BY g.Geo ORDER BY s.SaleDate) AS Running_Total_Boxes
FROM sales s
JOIN geo g ON s.GeoID = g.GeoID;

-- 33. Show the gap between consecutive sale amounts
SELECT SaleDate, Amount,
       Amount - LAG(Amount) OVER (ORDER BY SaleDate) AS Amount_Gap
FROM sales;

-- 34. Find the median sales amount
WITH OrderedSales AS (
    SELECT Amount,
           ROW_NUMBER() OVER (ORDER BY Amount) AS row_num,
           COUNT(*) OVER () AS total_count
    FROM sales
)
SELECT AVG(Amount) AS Median_Amount
FROM OrderedSales
WHERE row_num IN (FLOOR((total_count + 1) / 2.0), CEIL((total_count + 1) / 2.0));

-- 35. Display sales where Amount is in top 10% (use NTILE or PERCENT_RANK)
WITH PercentileSales AS (
    SELECT *, 
           PERCENT_RANK() OVER (ORDER BY Amount DESC) AS pct_rank
    FROM sales
)
SELECT * 
FROM PercentileSales
WHERE pct_rank <= 0.10;

-- 36. Show salesperson-wise ranking within each team
SELECT p.Team, p.Salesperson, SUM(s.Amount) AS Total_Sales,
       DENSE_RANK() OVER (PARTITION BY p.Team ORDER BY SUM(s.Amount) DESC) AS Team_Rank
FROM people p
JOIN sales s ON p.SPID = s.SPID
GROUP BY p.Team, p.SPID, p.Salesperson;

-- 37. Find products that contributed more than 20% of total sales
SELECT pr.Product, SUM(s.Amount) AS Total_Product_Sales
FROM sales s
JOIN products pr ON s.PID = pr.PID
GROUP BY pr.PID, pr.Product
HAVING SUM(s.Amount) > (SELECT SUM(Amount) * 0.20 FROM sales);

-- 38. Display country-wise sales trend (increase or decrease compared to previous record)
WITH CountrySalesTrend AS (
    SELECT g.Geo AS Country, s.SaleDate, s.Amount,
           LAG(s.Amount) OVER (PARTITION BY g.Geo ORDER BY s.SaleDate) AS Prev_Amount
    FROM sales s
    JOIN geo g ON s.GeoID = g.GeoID
)
SELECT Country, SaleDate, Amount, Prev_Amount,
       CASE 
           WHEN Prev_Amount IS NULL THEN 'No Previous Record'
           WHEN Amount > Prev_Amount THEN 'Increase'
           WHEN Amount < Prev_Amount THEN 'Decrease'
           ELSE 'No Change'
       END AS Sales_Trend
FROM CountrySalesTrend;

-- 39. Find the first sale made by each salesperson
WITH SalespersonSales AS (
    SELECT s.*, p.Salesperson,
           ROW_NUMBER() OVER (PARTITION BY s.SPID ORDER BY s.SaleDate ASC) AS rnk
    FROM sales s
    JOIN people p ON s.SPID = p.SPID
)
SELECT * 
FROM SalespersonSales
WHERE rnk = 1;

-- 40. Show last sale made in each country
WITH CountrySales AS (
    SELECT s.*, g.Geo AS Country,
           ROW_NUMBER() OVER (PARTITION BY s.GeoID ORDER BY s.SaleDate DESC) AS rnk
    FROM sales s
    JOIN geo g ON s.GeoID = g.GeoID
)
SELECT * 
FROM CountrySales
WHERE rnk = 1;