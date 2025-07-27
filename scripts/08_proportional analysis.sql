USE DataWarehouseAnalytics;
GO

-- Analyze how an individual part is performing compared to the overall

-- Which category contributes the most to the overall sales?
WITH category_sales AS (
SELECT
	p.category,
	SUM(s.sales_amount) as total_sales
FROM gold.fact_sales s
JOIN gold.dim_products p
ON s.product_key = p.product_key
GROUP BY p.category
)

, overall_sales as (
SELECT
	category,
	total_sales,
	SUM(total_sales) OVER () as overall_sales
FROM category_sales
)

SELECT
	category,
	total_sales,
	ROUND((CAST(total_sales AS FLOAT)/overall_sales) * 100, 2) as pct_of_total
FROM overall_sales;