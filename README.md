# Project Overview
This project involves a comprehensive analysis of a retail database consisting of customer, product, and transaction data. The goal is 
to perform data cleaning, exploration, and derive business insights such as customer demographics, sales performance by category, 
and return trends using SQL Server (T-SQL).

**Database Schema**
The analysis is performed on three primary tables:
Customer: Demographic information including Gender, City, and DOB.
prod_cat_info: Information regarding product categories and sub-categories.
Transactions: Transactional details including quantity, amount, dates, and store types.

**Data Preparation & Cleaning**
Before the analysis, the following preparation steps were taken:
Standardized date formats for tran_date and DOB using CONVERT.
Handled data types using ALTER TABLE to ensure proper date calculations.
Filtered out null values where necessary to maintain data integrity.


**Key Business Questions Addressed**
1. Data Understanding
Total row counts across all tables to understand data volume.
Calculation of the total number of returns (where Qty < 0).
Extraction of the time range of available data in days, months, and years.

2. Customer Insights
Distribution of customers based on Gender.
Identifying cities with the highest customer concentration.
Filtering high-value customers (those with >10 transactions).
Targeted analysis for specific age groups (e.g., 25–35 years old).

3. Sales & Product Analysis
Identification of the most frequently used sales channels (Store Types).
Revenue breakdown by categories like Electronics and Books.
Percentage of sales vs. returns for top-performing sub-categories.
Identifying categories where the average revenue exceeds the overall company average.

4. Advanced Analytics
Trend Analysis: Returns identified within the last 3 months of the dataset.
Efficiency Metrics: Identifying store types that lead in both quantity sold and total revenue.
Sub-Category Performance: Deep dive into the top 5 product categories by quantity sold.
