USE DataWarehouseAnalytics;
GO


-- Find top 5 products by total sales
WITH product_sales AS(
SELECT
	product_name,
	SUM(sales_amount) as total_sales,
	ROW_NUMBER() OVER(ORDER BY SUM(sales_amount) DESC) AS row_num
FROM gold.dim_products a
JOIN gold.fact_sales b
ON a.product_key = b.product_key
GROUP BY product_name
)

SELECT *
FROM product_sales
WHERE row_num <=5;

-- Find the top 10 customers who have generated the highest revenue
WITH revenue_by_customers AS(
SELECT
	CONCAT(first_name,' ', last_name) as full_name,
	SUM(sales_amount) as total_revenue,
	ROW_NUMBER() OVER(ORDER BY SUM(sales_amount) DESC) AS row_num
FROM gold.dim_customers a
JOIN gold.fact_sales b
ON a.customer_key = b.customer_key
GROUP BY CONCAT(first_name,' ', last_name)
) 

SELECT *
FROM revenue_by_customers
WHERE row_num <= 10