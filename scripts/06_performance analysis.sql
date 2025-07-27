USE DataWarehouseAnalytics;
GO

/* Analyze the yearly performance of products by comparing their sales to both the 
average sales performance of the product and the previous year's sales */
WITH yearly_product_sales AS(
SELECT 
	YEAR(order_date) as Year,
	product_name, 
	SUM(sales_amount) AS current_sales
FROM gold.dim_products P
JOIN gold.fact_sales s
ON p.product_key = s.product_key
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), product_name
)

, yearly_aggregation as (
SELECT
	Year,
	product_name,
	current_sales,
	AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,   -- AVERAGE doesn't care about the date order
	LAG(current_sales) OVER (PARTITION BY product_name ORDER BY Year) as previous_sales
FROM yearly_product_sales
)

SELECT 
	Year,
	product_name,
	current_sales,
	current_sales - avg_sales as diff_avg,
	ROUND((CAST(current_sales AS FLOAT) - previous_sales) * 100/previous_sales, 2) as pct_change,
	CASE WHEN current_sales - avg_sales > 0 THEN 'Above Average'
	     WHEN current_sales - avg_sales < 0 THEN 'Below Average'
		 ELSE 'Average'
	END AS avg_change
FROM yearly_aggregation
ORDER BY product_name, Year;