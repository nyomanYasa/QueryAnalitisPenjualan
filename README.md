# 📊 SQL Data Analysis & Database Portfolio

This repository contains a collection of SQL case studies and portfolio projects demonstrating my ability to extract, transform, analyze, and optimize data using **PostgreSQL** to drive strategic business decisions.

---

## 🛠️ Tech Stack & Tools
* **Database Management System:** PostgreSQL (via Docker)
* **Query & Management Tool:** pgAdmin 4 / psql CLI
* **Version Control:** Git & GitHub

---

## 📂 Portfolio Projects

### 1. E-Commerce Sales & Customer Analytics
* **Description:** Analyzed retail transaction data (*Online Retail*) to identify purchasing behaviors, monthly revenue trends, and top-performing products.
* **SQL Techniques Used:**
  * Complex `JOIN`s to combine customer, product, and transaction data.
  * `Window Functions` (`DENSE_RANK()`) for ranking top customers per category.
  * *Date Manipulation* (`DATE_TRUNC`, `LAG()`) for Month-over-Month growth analysis.
* **Related File:** [`ecommerce_analysis.sql`](./ecommerce_analysis.sql)

### 2. Customer Segmentation using RFM Analysis
* **Description:** Performed customer segmentation (*Champions, At Risk, Lost Customers*) using the **RFM (Recency, Frequency, Monetary)** framework to support targeted marketing strategies.
* **SQL Techniques Used:**
  * Chained *Common Table Expressions (CTE)* to break down complex logic into structured steps.
  * `NTILE(4)` for quartile scoring distribution.
  * *Conditional Logic* (`CASE WHEN`) for customer segment labeling.
* **Related File:** [`rfm_analysis.sql`](./rfm_analysis.sql)

---

## 💡 Query Snippet

Below is a snippet from the RFM analysis query I created to segment customers based on their spending value (*Monetary*) and purchase frequency:

```sql
WITH rfm_raw AS (
    SELECT
        customer_id,
        (DATE '2011-12-10' - MAX(invoice_date::DATE)) AS recency_days,
        COUNT(DISTINCT invoice_no) AS frequency_count, 
        SUM(quantity * unit_price) AS monetary_value
    FROM supermarketsales
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id 
),
rfm_scores AS (
    SELECT
        customer_id,
        recency_days,
        frequency_count,
        monetary_value,
        NTILE(4) OVER (ORDER BY recency_days DESC) AS r_score, 
        NTILE(4) OVER (ORDER BY frequency_count ASC) AS f_score,
        NTILE(4) OVER (ORDER BY monetary_value ASC) AS m_score
    FROM rfm_raw
)
SELECT 
    customer_id, 
    monetary_value,
    (r_score + f_score + m_score) AS rfm_total_score
FROM rfm_scores
ORDER BY monetary_value DESC;
