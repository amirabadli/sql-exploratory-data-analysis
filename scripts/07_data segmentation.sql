USE DataWarehouseAnalytics;
GO

-- Segment products into cost ranges and count how many products fall into each segment
WITH product_segments AS (
SELECT 
	product_key,
	product_name,
	cost,
	CASE WHEN cost < 100 THEN 'Below 100'
		 WHEN cost BETWEEN 100 AND 500 THEN '100-500'
		 WHEN cost BETWEEN 501 AND 1000 THEN '501-1000'
		 ELSE 'Above 1000'
	END AS cost_range
FROM gold.dim_products p 
)

SELECT 
	cost_range,
	COUNT(product_key) as total_products
FROM product_segments
GROUP BY cost_range;

/*
Group customers into 3 segments based on their spending behavior:
- VIP: Customers with at least 12 months of history and spending more than $5000.
- Regular: Customers with at least 12 months of history but spending $5000 or less.
- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

WITH customer_segment AS (
SELECT
	c.customer_key,
	SUM(s.sales_amount) as total_spent,
	MIN(s.order_date) as first_order_date,
	MAX(s.order_date) as last_order_date
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key
)

, customer_behavior AS(
SELECT
	customer_key,
	total_spent,
	first_order_date,
	last_order_date,
	DATEDIFF(Month, first_order_date, last_order_date) + 1 as lifespan
FROM customer_segment
)

, result AS (
SELECT
	customer_key,
	CASE WHEN lifespan >= 12 AND total_spent > 5000 THEN 'VIP'
		 WHEN lifespan >= 12 AND total_spent <= 5000 THEN 'Regular'
		 WHEN lifespan < 12 THEN 'New'
		 ELSE 'UNDEFINED'
	END AS customer_category
FROM customer_behavior
)

SELECT 
	customer_category,
	COUNT(customer_key) as cust_count
FROM result
GROUP BY customer_category
ORDER BY COUNT(customer_key) DESC;