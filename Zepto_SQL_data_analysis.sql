drop table if exits zepto;

create table zepto(
sku_id serial Primary key,
category varchar(120),
name varchar(150) not null,
mrp numeric(8,2),
discountPercent Numeric(5,2),
availableQuantity Integer,
discountedSellingPrice Numeric(8,2),
weightInGms Integer,
outofstock BOOLEAN,
quantity Integer
);

--data exploration 

-- count of rows
select count(*) from zepto;

-- sample data 
Select * from zepto
limit 10;
--null values 
Select * from zepto 
where name is NULL
OR
category is NULL
OR
mrp is NULL
OR
discountpercent IS NULL
OR
discountedsellingprice IS NULL
OR
weightingms IS NULL
OR 
availablequantity IS NULL
OR 
outofstock IS NULL
OR
quantity IS NULL

--different Product Categories

Select DISTINCT category 
from zepto 
Order by category;

--products in stock vs outof stock
Select outofstock,Count(sku_id)
from zepto
Group by outofstock;

--Product names present multiply times 
Select name,COUNT(sku_id) as "Number of SKUs"
from zepto
group BY name 
Having count(sku_id)>1
order by count(sku_id)DESC;

--Data cleaing 
-- product with price = 0
select * from zepto 
where mrp = 0 or discountedsellingprice=0;

delete from zepto 
where mrp = 0;

-- convert paise to rupee
Update zepto 
Set mrp=mrp/100.0;
discountedsellingprice = discountedsellingprice/100.0;

Select mrp,discountedsellingprice from zepto;

--Q1. Find the top 10 best-value products based on the discounted percentage,

Select DISTINCT name,mrp,discountpercent
from zepto 
order by discountPercent desc 
limit 10;

--Q2. What are the Products with High MRP but Out of Stock 

Select DISTINCT name,mrp
from zepto 
where outofstock = TRUE and mrp >300
ORDER BY mrp DESC;

--Q3. Calculate Estimate Revenue for each Category 
Select Category,
SUM(discountedsellingprice * availableQuantity)AS total_revenue 
from zepto 
Group by category 
Order by total_revenue;

--Q4. Find all products where MRP is greater than 500 and discount is less than 10%.
Select DISTINCT name,mrp,discountpercent
from zepto 
where mrp > 500 and discountpercent <10 
ORDER BY mrp DESC,discountpercent DESC;

--Q5. Identify the top 5 categories offering the higest average discount percentage.

Select Category,
Round(AVG(discountpercent),2) AS avg_discount
FROM Zepto 
Group BY category 
Order By avg_discount DESC 
LIMIT 5;

-- Q6. Find the Price per gram for products above 100g sort by best value.
Select DISTINCT name,weightingms,discountedsellingprice,
ROUND(discountedsellingprice/weightingms,2) as price_per_gram
FROM zepto 
Where weightingms >=100
Order by price_per_gram;

--Q7. Group the products into categories like low,Medium,bulk.
Select DISTINCT name,weightingms,
case when weightingms <1000 then 'Low'
  When weightingms < 5000 Then 'Medium'
  ELSE 'Bulk'
  END AS weight_category
  FROM zepto;
-- Q8.What is the Total Inventory Weight Per Categoey 
Select category,
SUM(weightingms*availablequantity) AS total_weight 
FROM zepto 
GROUP BY category 
ORDER BY total_weight ;
