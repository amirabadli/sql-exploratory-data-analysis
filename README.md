# SQL Exploratory Data Analysis: Sales Performance Analysis

This is a SQL-based Exploratory Data Analysis (EDA) project focused on understanding customer behavior and product performance using structured sales data. The analysis was conducted in SQL Server Management Studio (SSMS), and multiple views were created to organize and summarize insights.

## 📁 Dataset Overview

The project uses three core tables:

- **`dim_products`** – Contains product-level information such as product name, category, cost and price.
- **`dim_customers`** – Contains customer demographic or segmentation data.
- **`fact_sales`** – Contains transactional-level sales data including quantities, amounts, and order dates.

---

## 🎯 Objectives

The main goals of this EDA project are to:

- Explore trends in sales performance over time
- Identify high-performing products and customers
- Segment the data to uncover meaningful patterns
- Perform ranking and proportional analysis to guide decision-making

---

## 🛠️ Tech Stack

- SQL Server Management Studio (SSMS)
- T-SQL for querying and data transformation

---

## 📊 Key Analyses Performed

- **Time Series Analysis**: Tracked sales growth and seasonality trends.
- **Sales Performance Analysis**: Evaluated revenue and quantity sold by product, category, and customer segments.
- **Ranking Analysis**: Ranked top customers and products based on purchase behavior.
- **Cumulative Analysis**: Calculated running totals to observe momentum and identify peak periods.
- **Proportional Analysis**: Assessed the contribution of each segment or product to overall sales.
- **Data Segmentation**: Grouped customers and products to find actionable sub-groups.

---

## 🔍 Views Created

To organize the findings, two SQL views were created:

- `customer_report`: Summarizes sales metrics by customer.
- `product_report`: Summarizes sales performance by product.

These views make it easier to reuse and explore the data without writing repeated logic.

---

## 📌 Next Steps

- Expand the analysis by incorporating time windows (monthly, quarterly).
- Visualize insights using Power BI or Tableau.
- Add calculated fields like profit margin or average basket size for deeper insights.

---

## 📬 Contact

Feel free to connect or reach out if you’d like to discuss this project or data analysis in general.

- 💼 [LinkedIn](https://www.linkedin.com/in/your-profile)  

Thanks for checking out the project! 🙂
