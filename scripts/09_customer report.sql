USE DataWarehouseAnalytics;
GO

/*
=====================================================================
CREATING CUSTOMER REPORT
=====================================================================
Purpose:
	- This report consolidates key customer metrics and behaviors.

Highlights:
1. Gather essential fields such as names, ages, and transaction details.
2. Segment customers into categories (VIP, Regular, New) and age groups.
3. Aggregates customer-level metrics:
	- total orders
	- total sales
	- total quantity purchased
	- lifespan (in months)
4. Calculates valuable KPIs:
	- recency (months since last order)
	- average order value
	- average monthly spend
=====================================================================
*/

-- 1) Base query: retrieve relevant columns from the respective tables
CREATE VIEW gold.customer_report AS
WITH base_query AS(
SELECT 
	dc.customer_key,
	dc.customer_id,
	CONCAT(dc.first_name, ' ', dc.last_name) as customer_name,
	dc.gender,
	DATEDIFF(Year, dc.birthdate, GETDATE()) as age,
	fs.order_number,
	fs.product_key,
	fs.quantity,
	fs.sales_amount,
	fs.order_date
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc
ON fs.customer_key = dc.customer_key
WHERE fs.order_date IS NOT NULL
)

-- 2) Aggregate sales transactions at customer level
, customer_aggregations AS(
SELECT 
	customer_key,
	customer_id,
	customer_name,
	gender,
	age,
	COUNT(DISTINCT order_number) as total_orders,
	SUM(sales_amount) as total_spent,
	SUM(quantity) as total_quantity,
	MAX(order_date) as last_order_date,
	DATEDIFF(Month, MIN(order_date), MAX(order_date)) + 1 as lifespan,  -- first month is inclusive
	DATEDIFF(Month, MAX(order_date), GETDATE()) as recency
FROM base_query
GROUP BY 
	customer_key,
	customer_id,
	customer_name,
	gender,
	age
)

-- final touch
SELECT
	customer_key,
	customer_id,
	customer_name,
	gender,
	age,
	CASE WHEN age < 20 THEN 'Below 20'
		 WHEN age BETWEEN 21 AND 30 THEN '21-30'
		 WHEN age BETWEEN 31 AND 40 THEN '31-40'
		 WHEN age BETWEEN 41 AND 50 THEN '41-50'
		 ELSE 'Above 50'
	END AS age_groups,
	total_orders,
	total_quantity,
	total_spent,
	lifespan,
	recency,
	total_spent / NULLIF(total_orders, 0) as avg_order_value, 
	total_spent / lifespan as avg_monthly_spent,			-- if lifespan is 1 then the avg monthly spent = total spent 
	CASE WHEN lifespan >= 12 AND total_spent > 5000 THEN 'VIP'
		 WHEN lifespan >= 12 AND total_spent <= 5000 THEN 'Regular'
		 ELSE 'New'
	END AS customer_segment
FROM customer_aggregations;
