USE DataWarehouseAnalytics;
GO

-- Calculate the total sales per month and running total of sales over time
WITH monthly_sales AS(
SELECT 
	DATETRUNC(Month, order_date) as order_date, 
	SUM(sales_amount) as total_sales,
	AVG(price) as average_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(Month, order_date)
)

SELECT
	order_date,
	total_sales,
	SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
	AVG(average_price) OVER (ORDER BY order_date) AS moving_avg_price
FROM monthly_sales;