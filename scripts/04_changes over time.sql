USE DataWarehouseAnalytics;
GO

-- Analyze sales performance over time
SELECT 
	DATETRUNC(Month, Order_date) As Order_date,
	SUM(sales_amount) as total_sales,
	COUNT(DISTINCT customer_key) as total_customers,
	SUM(quantity) as total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(Month, Order_date)
ORDER BY DATETRUNC(Month, Order_date);