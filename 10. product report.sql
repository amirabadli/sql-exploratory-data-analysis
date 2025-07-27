USE DataWarehouseAnalytics;
GO

/*
=====================================================================
CREATING PRODUCT REPORT
=====================================================================
Purpose:
	- This report consolidates key product metrics and behaviors.

Highlights:
	1. Gathers essential fields such as product name, category, subcategory, and cost.
	2. Segment products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
	3. Aggregates product-level metrics:
		- total orders
		- total sales
		- total quantity sold
		- total customers (unique)
		- lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last sale)
		- average order revenue (AOR)
		- average monthly revenue
=====================================================================
*/

-- 1) Base query: get the relevant columns from the tables
CREATE VIEW gold.product_report AS 
WITH base_query AS(
SELECT 
	dp.product_key,
	dp.product_id, 
	dp.product_name,
	dp.category,
	dp.subcategory, 
	dp.cost,
	fs.order_number,
	fs.sales_amount,
	fs.quantity,
	fs.customer_key,
	fs.order_date
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp
ON fs.product_key = dp.product_key
WHERE fs.order_date IS NOT NULL
)

-- 2) Aggregate product transaction at product level
, product_aggregations AS(
SELECT
	product_key,
	product_id, 
	product_name,
	category,
	subcategory, 
	cost,
	COUNT(DISTINCT order_number) as total_orders,
	COUNT(DISTINCT customer_key) as total_customers,
	SUM(sales_amount) as total_sales,
	SUM(quantity) as total_quantity,
	DATEDIFF(Month, MIN(order_date), MAX(order_date)) + 1 as lifespan,
	DATEDIFF(Month, MAX(order_date), GETDATE()) AS recency
FROM base_query
GROUP BY 
	product_key,
	product_id, 
	product_name,
	category,
	subcategory, 
	cost
)

SELECT 
	product_key,
	product_id, 
	product_name,
	category,
	subcategory, 
	cost,
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	lifespan,
	recency,
	total_sales / NULLIF(total_orders, 0) as avg_order_revenue,
	total_sales / NULLIF(lifespan, 0) as avg_monthly_revenue,
	CASE WHEN total_sales > 50000 THEN 'High-Performer'
		 WHEN total_sales >= 10000 THEN 'Mid-Range'
		 ELSE 'Low-Performer'
	END AS product_segment
FROM product_aggregations;