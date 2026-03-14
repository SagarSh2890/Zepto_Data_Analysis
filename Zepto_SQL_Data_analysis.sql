drop table if exists zepto;

create table zepto(
sku_id SERIAL Primary Key,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discount_percent NUMERIC(5,2),
available_quantity INTEGER,
discounted_selling_price NUMERIC(8,2),
weight_in_gms Integer,
out_of_stock Boolean,
quantity Integer
);

--data exploration

--count of rows 
SELECT COUNT(*) FROM zepto;

--sample data 
SELECT * FROM zepto 
LIMIT 10;

--null values
SELECT * FROM zepto
WHERE name IS NULL
OR 
category is NULL
OR
mrp is NULL
OR
discount_percent is NULL
OR
available_quantity is NULL
OR
discounted_selling_price is NULL
OR
weight_in_gms is NULL
OR
out_of_stock is NULL
OR
quantity is NULL;

--different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--products in stock vs out of stock 
SELECT out_of_stock, COUNT(sku_id)
FROM zepto
GROUP BY out_of_stock;

--product names present multiple times 
SELECT name, COUNT(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY count(sku_id) DESC;

--data cleaning 

--products with price = 0
SELECT * From zepto
WHERE mrp = 0
OR 
discounted_selling_price = 0;

DELETE FROM zepto
WHERE mrp = 0;

--convert paise to rupees
UPDATE zepto
SET mrp = mrp/100.0,
discounted_selling_price = discounted_selling_price/100.0;

SELECT mrp,discounted_selling_price FROM zepto;

--Q1.Find the top-10 best value products based on the discount percentage.
SELECT DISTINCT name,mrp, discount_percent
FROM zepto
ORDER by discount_percent DESC
LIMIT 10;

--Q2.Which are the products with high MRP but out of stock.
SELECT DISTINCT name, mrp
FROM zepto
WHERE out_of_stock = True and mrp > 300
ORDER BY mrp DESC;

--Q3.Calculate estimated revenue for each category.
SELECT category,
SUM(discounted_selling_price * available_quantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

--Q4.Find all producs where MRP is greater than 500 and discount is less than 10%.
SELECT DISTINCT name, mrp, discount_percent
FROM zepto
WHERE mrp > 500 AND discount_percent < 10
ORDER by mrp DESC, discount_percent DESC;

--Q5.Identify the top 5 categories offering the highest average discount percentage.
SELECT category,
ROUND(AVG(discount_percent),2) AS avg_discount
FROM zepto
GROUP BY category 
ORDER BY avg_discount DESC
LIMIT 5;

--Q6.Find the price per gram for products above 100gm and sort by best value.
SELECT DISTINCT name, weight_in_gms, discounted_selling_price, 
ROUND(discounted_selling_price/weight_in_gms,2) AS price_per_gram
FROM zepto
WHERE weight_in_gms >=100
ORDER BY price_per_gram;

--Q7.Group the products into categories like low, medium, bulk.
SELECT DISTINCT name, weight_in_gms,
CASE WHEN weight_in_gms <1000 THEN 'Low'
	WHEN weight_in_gms <5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
	FROM zepto;

--Q8.What is the Total Inventory Weight Per Category
SELECT Category,
SUM(weight_in_gms * available_quantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;

