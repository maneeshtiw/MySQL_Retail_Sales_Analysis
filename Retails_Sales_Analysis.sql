-- Create Database.
CREATE DATABASE Data;

-- Use Data Base.
USE Data;

-- Create Table name.
CREATE TABLE Retail_Sales(
transactions_id INT,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender TEXT,
	age INT,
	category TEXT,
	quantiy INT,
	price_per_unit INT,
	cogs INT,
    total_sale INT
);

-- Modify DataType 
ALTER TABLE Retail_Sales MODIFY gender VARCHAR(15), 
MODIFY category VARCHAR(15), 
MODIFY cogs FLOAT;

-- Add Primary Key
ALTER TABLE Retail_Sales ADD PRIMARY KEY(transactions_id);

SHOW CREATE TABLE Retail_Sales;

-- DATA CLEANING
SELECT * FROM Retail_Sales WHERE NULL IN(transactions_id , sale_time, customer_id, gender, age,
                                         category,quantiy,price_per_unit,cogs,total_sale,sale_date);
                                         
-- Data Exploration
-- How many Sales we have?
SELECT 
    COUNT(*)
FROM Retail_Sales;

-- HOW MANY UNIQUE CUSTOMER WE HAVE?
SELECT 
     COUNT(DISTINCT customer_id) AS UNIQUE_CUSTOMER
FROM Retail_Sales;

-- HOW MANY UNIQUE Category and name?

SELECT 
     DISTINCT category AS UNIQUE_category
FROM Retail_Sales;

-- DATA ANALYSIS & BUSINESS KEY PROBLEMS AND ANSWER.
-- MY ANALYSIS AND FINDINGS.

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT * 
FROM Retail_Sales 
WHERE sale_date = '2022-11-05';

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and 
--    the quantity sold is more than or equal to 3 in the month of Nov-2022:
WITH FilteredSales AS (
    SELECT * 
    FROM Retail_Sales
    WHERE category = 'Clothing' 
      AND quantiy >= 4 
      AND MONTH(sale_date) = 11 
      AND YEAR(sale_date) BETWEEN 2022 AND 2023
)
SELECT * 
FROM FilteredSales
ORDER BY sale_date ASC;

-- 3 Write a SQL query to calculate the total sales (total_sale) for each category.
 SELECT category, SUM(total_sale) AS Total_Sales
 FROM Retail_Sales 
 GROUP BY category 
 ORDER BY category ASC;
 
 -- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
 SELECT ROUND(AVG(age), 2) As Age
 FROM Retail_Sales
 WHERE category = 'Beauty';
 
 -- 5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
 SELECT * FROM Retail_Sales
 WHERE total_sale > 1000;
 
 -- 6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
  SELECT category, gender, 
  COUNT(*) AS TOTAL_TRANSACTION 
  FROM Retail_Sales 
  GROUP BY 
        category, gender 
  ORDER BY 1;
  
  -- 7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
  WITH Best_Selling_MONTH
  As(
       SELECT 
       YEAR(sale_date) AS year,
       MONTH(sale_date) AS month,
       AVG(total_sale) AS AVG_SALES,
       RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) as rnk
       FROM Retail_Sales
       GROUP BY 1, 2
       )
SELECT year, month, 
AVG_SALES FROM Best_Selling_MONTH 
WHERE rnk = 1;

-- 8 Write a SQL query to find the top 5 customers based on the highest total sales.
  SELECT customer_id, SUM(total_sale) AS Total_Sales
  FROM Retail_Sales 
  GROUP BY customer_id 
  ORDER BY 2 DESC LIMIT 5;
  
  -- 9 Write a SQL query to find the number of unique customers who purchased items from each category.:
   SELECT COUNT(DISTINCT(customer_id)) AS Unique_Customer, category 
   FROM Retail_Sales GROUP BY category;
   
   -- 10 Write a SQL query to create each shift and number of orders
   -- (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
  WITH DIVIDE_TIME
  AS
  (
  SELECT 
	CASE 
		WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
       -- WHEN HOUR(sale_time) > 17 THEN 'Evening'
	ELSE
        'Evening'
	END AS Shift
FROM Retail_Sales
)
    SELECT Shift,
    COUNT(*) AS total_orders
    FROM DIVIDE_TIME
    GROUP BY Shift;
    
        
        
	
