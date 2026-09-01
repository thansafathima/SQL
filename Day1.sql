select *
from sales;  #7617

select *
from people;  #33

select *
from geo;   #6

select *
from products;  #22

select SaleDate,Amount
from sales;    #7617

select SaleDate,Amount,Boxes,Amount/Boxes
from sales;    #7617

select SaleDate,Amount,Boxes,Amount/Boxes as 'Amount per boxes'
from sales;    #7617

-- using where clause in sql

select * from sales
where Amount>10000;    #1240

-- Showing sales data where amount is greater than 10,000 by ascending order

select * from sales
where Amount>10000
order by Amount;     #1240

-- Showing sales data where amount is greater than 10,000 by descending order

select * from sales
where Amount>10000
order by Amount desc;   #1240

-- Showing sales data where geography is g1 by product ID &
-- descending order of amounts

select * from sales
where GeoID='g1'
order by PID,Amount desc;    #1261

-- Working with dates in SQL

select * from sales
where Amount>10000 and SaleDate>='2022-01-01';    #287

-- Using year() function to select all data in a specific year

select SaleDate,Amount from sales
where amount>10000 and year(saledate)=2022
order by Amount desc;      #287


-- BETWEEN condition in SQL with < & > operators
select * from sales
where boxes>=0 and boxes<=50;     #741

-- Using the between operator in SQ
select * from sales
where Boxes between 0 and 50;    #741


-- Using weekday() function in SQL

select SaleDate,Amount,Boxes,weekday(saledate) as 'Dayofweek' 
from sales
where weekday(SaleDate)=4;   #1618

-- Working with People table

select * from people  #33
-- OR operator in SQL

select * from people
where team='Delish' or Team='jucies';    #19

-- IN operator in SQL

select * from people
where team in ('Delish','jucies');   #19


-- LIKE operator in SQL

select * from people
where Salesperson like 'B%';     #4

select * from people
where Salesperson like '%y';    #6

select * from people
where Salesperson like '%B%';    #11

select * from sales;
-- Using CASE to create branching logic in SQL

select SaleDate,Amount,
	case when amount<1000 then 'under 1k'
         when amount<5000 then 'under 5k'
         when amount <10000 then 'under 10k'
		 else '10k and more'
	end as 'amount category'

from sales 
order by Amount;         #7617


 