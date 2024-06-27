-- SAMPLE SUPERSTOREDATA --

--# Show the average sales made for per product category
--# What product category is the best selling product (Metric of best selling is count of sales)
--# What product sub-category yielded that most profit
--# In the furniture product category, what sub-category made the most profit. 
--# Show the total sales made in California, New York, Texas, Washington, Illionois, and Ohio
--# Of All consumer segment in California, what subcategory product has the most orders?
--# What product has most orders in the south region?
--# Find the Price of each product
--# Classify each of the product by their sales according to low, moderate, average, and high end
--# Show all the high end product in california (Choose your threshold of high end)
--# Show all low end product in the Southern and Northern Region (Choose your threshold of low end)
--# What region is the poorest giving the class of product they buy
--# What state should we invest more luxury goods in?
--# What product class is most profitable to sell
--# Classify the profit into low profit, medium profit,and high profit

SELECT *
FROM
	personalwork.samplesuperstore_geographical;
    

--# Show the average sales made for per product category
SELECT 
	Category,
    AVG(Sales) AS Avg_sales
FROM
	personalwork.samplesuperstore_geographical
GROUP BY
	Category
ORDER BY
	Avg_sales DESC;
    
    
# What product category is the best selling product (Metric of best selling is count of sales so as to know how many times each product was  bought)
SELECT 
	Category,
    COUNT(Sales) AS Count_of_sales
FROM
	personalwork.samplesuperstore_geographical
GROUP BY
	Category
ORDER BY
	Count_of_sales DESC;
    
# What product sub-category yielded that most profit
SELECT 
	`Sub-Category`,
    SUM(Profit) AS Total_profit
FROM
	personalwork.samplesuperstore_geographical
GROUP BY 
	`Sub-Category`
ORDER BY
	Total_profit DESC
LIMIT 1;

# In the furniture product category, what sub-category made the most profit. 
SELECT 
	`Sub-Category`,
    SUM(Profit) AS Total_profit
FROM
	personalwork.samplesuperstore_geographical
WHERE 
	Category = 'Furniture'
GROUP BY 
	`Sub-Category`
ORDER BY
	Total_profit DESC
LIMIT 1;

#Show the total sales made in California, New York, Texas, Washington, Illionois, and Ohio
SELECT
	State,
    ROUND(SUM(Sales), 2) AS Total_sales
FROM
	personalwork.samplesuperstore_geographical
WHERE
	State IN ('California','New York', 'Texas', 'Washington', 'Illionois', 'Ohio')
GROUP BY 
	State
ORDER BY
	Total_sales DESC;

# Of All consumer segment in California, what subcategory product has the most orders?
SELECT
	Segment,
    `Sub-Category`,
    SUM(Quantity) AS Sum_of_quantity
FROM 
	personalwork.samplesuperstore_geographical
WHERE
	State = 'California'
AND
	Segment = 'Consumer'
GROUP BY
	`Sub-Category`
ORDER BY
	Sum_of_quantity DESC
LIMIT 1;

# What product has most orders in the south region?
SELECT
	`Sub-Category`,
    SUM(Quantity) AS Most_orders
FROM
	personalwork.samplesuperstore_geographical
WHERE 
	Region = 'South'
GROUP BY
	`Sub-Category`
ORDER BY 
	Most_orders DESC
LIMIT 1;

# Find the Price of each product
SELECT `Sub-Category`,
	Round(Sum((Sales/Quantity)), 2) AS Sum_Price
FROM 
	personalwork.samplesuperstore_geographical
Group by `Sub-Category`;
    
# Classify each of the product by their sales according to low, moderate, average, and high end
SELECT 
	`Sub-Category`,
    ROUND(SUM(Sales), 2) AS Sum_of_sales,
CASE
	WHEN SUM(Sales) < 5000 THEN 'Low Sales'
    WHEN SUM(Sales) BETWEEN 5000 AND 15000 THEN 'Moderate Sales'
    ELSE 'High Sales'
    END AS Sales_class
FROM 
	personalwork.samplesuperstore_geographical
GROUP BY
	`Sub-Category`
ORDER BY
	Sum_of_sales;
    
    
select *
from personalwork.samplesuperstore_geographical
where Sales > 15000;




# Show all the high end product in california (Choose your threshold of high end)
	WITH new_table AS (
SELECT* ,
CASE
	WHEN (Sales/Quantity) <100 THEN 'Low end Goods'
	WHEN (Sales/Quantity) BETWEEN 100 AND 1000 THEN 'Moderate Goods'
	WHEN (Sales/Quantity)  BETWEEN 1000 AND 5000 THEN 'High End Goods'
	ELSE 'Luxury Goods'
	END AS `Product Class`
	FROM personalwork.samplesuperstore_geographical
	)
	SELECT*
	FROM new_table 
	WHERE State = 'California' AND `Product Class` = 'High End Goods';
    

# Show all low end product in the Southern and Northern Region (Choose your threshold of low end)
WITH CTE_Example AS (
SELECT *,
CASE
	WHEN (Sales/Quantity) <100 THEN 'Low end Goods'
	WHEN (Sales/Quantity) BETWEEN 100 AND 1000 THEN 'Moderate Goods'
	WHEN (Sales/Quantity)  BETWEEN 1000 AND 5000 THEN 'High End Goods'
	ELSE 'Luxury Goods'
	END AS "Product Class"
	FROM personalwork.samplesuperstore_geographical
	)
	SELECT *
	FROM CTE_Example 
	WHERE 
		Region IN ('South','North')
        AND `Product Class` = 'Low end Goods';
        
# What region is the poorest giving the class of product they buy
WITH CTE_Example AS (
SELECT *,
CASE
	WHEN (Sales/Quantity) <100 THEN 'Low end Goods'
	WHEN (Sales/Quantity) BETWEEN 100 AND 1000 THEN 'Moderate Goods'
	WHEN (Sales/Quantity)  BETWEEN 1000 AND 5000 THEN 'High End Goods'
	ELSE 'Luxury Goods'
	END AS "Product Class"
	FROM personalwork.samplesuperstore_geographical
	)
	SELECT Region, `Product Class`, COUNT(`Product Class`) AS Count_of_class
	FROM CTE_Example 
	WHERE 
		`Product Class` = 'Low end Goods'
	GROUP BY
		Region, `Product Class`
	ORDER BY 
		Count_of_class ASC
	LIMIT 1;
    

# What state should we invest more luxury goods in?
WITH CTE_Example AS (
SELECT *,
CASE
	WHEN (Sales/Quantity) <100 THEN 'Low end Goods'
	WHEN (Sales/Quantity) BETWEEN 100 AND 1000 THEN 'Moderate Goods'
	WHEN (Sales/Quantity)  BETWEEN 1000 AND 5000 THEN 'High End Goods'
	ELSE 'Luxury Goods'
	END AS "Product Class"
	FROM personalwork.samplesuperstore_geographical
	)
	SELECT State, `Product Class`, COUNT(`Product Class`) AS Count_of_class
	FROM CTE_Example 
	WHERE 
		`Product Class` = 'Luxury Goods'
	GROUP BY
		State, `Product Class`
	ORDER BY 
		Count_of_class DESC
        LIMIT 1;
        
# What product class is most profitable to sell	
WITH CTE_Example AS (
SELECT *,
CASE
	WHEN (Sales/Quantity) <100 THEN 'Low end Goods'
	WHEN (Sales/Quantity) BETWEEN 100 AND 1000 THEN 'Moderate Goods'
	WHEN (Sales/Quantity)  BETWEEN 1000 AND 5000 THEN 'High End Goods'
	ELSE 'Luxury Goods'
	END AS "Product Class"
	FROM personalwork.samplesuperstore_geographical
	)
	SELECT `Product Class`, SUM(`Profit`) AS sum_profit
	FROM CTE_Example 
	GROUP BY
		`Product Class`
	ORDER BY 
		sum_profit DESC
        LIMIT 1;
        
# Classify the profit into low profit, medium profit,and high profit
SELECT *,
CASE
	WHEN Profit < 5 THEN 'No Profit'
    WHEN Profit BETWEEN 5 AND 30 THEN 'Low Profit'
    WHEN Profit BETWEEN 30 AND 50 THEN 'Medium Profit'
    ELSE 'High Profit'
    END AS "Profit Class"
FROM
	personalwork.samplesuperstore_geographical;
    
    

        