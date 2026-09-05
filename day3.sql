-- manually creating null values

select * from sales;
 
INSERT INTO sales (SaleDate, SPID, PID, Amount, Boxes)
VALUES ('2024-01-01', 'SP110', 'P110', NULL, NULL);

select * from sales;
# basic null handling

SELECT *
FROM sales
WHERE Amount is NULL;

-- COALESCE is a function used to handle NULL values.

-- It returns the first non-NULL value from a list of values.

-- Using COALESCE (replace NULL values)

SELECT  Amount,COALESCE(Amount, 0) AS Clean_Amount
FROM sales;

-- Replace NULL Boxes with 0

SELECT SaleDate, Amount, COALESCE(Boxes, 0) AS Boxes
FROM sales;

select * from people;
INSERT INTO people (Salesperson,SPID,Team,Location)
VALUES ("Kenny",'SP220',NULL,NULL);

-- Replace NULL Team with 'No Team'


select * from people;

SELECT Salesperson, COALESCE(Team, 'No Team') AS Team
FROM people
order by Salesperson;


-- WHERE → filters rows before grouping
-- HAVING → filters groups after aggregation

-- HAVING = filter results after applying aggregate functions (SUM, AVG, COUNT, etc.)-- 

-- Shows only salespersons with total sales > 1500000

SELECT SPID, SUM(Amount) AS Total_Sales
FROM sales
GROUP BY SPID
HAVING SUM(Amount) > 1500000;

-- Count number of sales per SPID-- 
SELECT SPID, COUNT(*) AS Total_Orders
FROM sales
GROUP BY SPID
HAVING COUNT(*) > 300;

-- treating null values in amount column with 0
SELECT SPID, SUM(COALESCE(Amount, 0)) AS Total_Sales
FROM sales
GROUP BY SPID
HAVING SUM(COALESCE(Amount, 0)) > 1500000;


select * from sales;

SELECT SPID,SUM(Amount) AS Total_Sales
FROM sales
WHERE Boxes > 5
GROUP BY SPID
HAVING SUM(Amount) > 200000;



-- LIMIT
-- Show first 5 rows from sales

select * from sales
LIMIT 10;

-- lowest first 5 sales


select *
FROM sales
ORDER BY Amount
LIMIT 20;

-- highest 5 sales
SELECT *
FROM sales
ORDER BY Amount DESC
LIMIT 5;


-- skipping first 5 and extracting next 5 rows
SELECT *
FROM sales
ORDER BY Amount 
LIMIT 5 OFFSET 5;



#TASKS

-- 1. Print details of shipments (sales) where amounts are > 2,000 and boxes are <100?

SELECT * 
FROM sales
WHERE Amount > 2000
AND Boxes < 100;         #125


-- 2. How many shipments (sales) each of the sales persons had in the month of January 2022?
SELECT p.Salesperson,count(s.pid)as shipment
FROM sales s
JOIN people p
ON s.SPID = p.SPID
WHERE s.SaleDate >= '2022-01-01'
  AND s.SaleDate < '2022-02-01'
GROUP BY p.Salesperson;       #25


-- 3. Which product sells more boxes? Milk Bars or Eclairs?

select p.Product,SUM(s.Boxes) AS Total_Boxes
from sales s
JOIN products p
ON s.PID = p.PID
WHERE p.Product IN ('Milk Bars', 'Eclairs')
GROUP BY p.Product
ORDER BY Total_Boxes DESC;


-- 4. Which product sold more boxes in the first 7 days of February 2022? Milk Bars or Eclairs?

SELECT p.Product,
       SUM(s.Boxes) AS Total_Boxes
FROM sales s
JOIN products p
ON s.PID = p.PID
WHERE p.Product IN ('Milk Bars', 'Eclairs')
  AND s.SaleDate between '2022-02-01' and '2022-02-07'
GROUP BY p.Product
ORDER BY Total_Boxes DESC;

-- 5. Which shipments had under 100 customers & under 100 boxes? Did any of them occur on Wednesday?

SELECT spid,s
    *,
    DAYNAME(SaleDate) AS Day_Of_Week,
    CASE 
        WHEN DAYNAME(SaleDate) = 'Wednesday' THEN 'Yes'
        ELSE 'No'
    END AS Is_Wednesday
FROM sales
WHERE Customers < 100 
  AND Boxes < 100;


select *
from sales;

select * from
people;

join p
