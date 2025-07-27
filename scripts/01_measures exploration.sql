USE DataWarehouseAnalytics;
GO

-- Generate report that shows all key metrics of the business
SELECT 'Total Sales' as measure_name, FORMAT(SUM(sales_amount),'N2') AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', FORMAT(SUM(quantity),'N2') FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', FORMAT(AVG(price), 'N2') FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', FORMAT(COUNT(DISTINCT order_number), 'N2') FROM gold.fact_sales
UNION ALL
SELECT 'Total Products', FORMAT(COUNT(product_name), 'N2') FROM gold.dim_products
UNION ALL
SELECT 'Total Customers', FORMAT(COUNT(customer_key), 'N2') FROM gold.dim_customers