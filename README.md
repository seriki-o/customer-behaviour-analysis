# Customer Behaviour Analysis

> An end-to-end customer behaviour analysis project using Python, PostgreSQL, SQL, and Power BI to uncover purchasing patterns, customer segments, product performance, and actionable retail insights.

---

## Project Overview

This project analyses customer shopping behaviour to understand purchasing patterns, product and category performance, customer characteristics, discount behaviour, subscription activity, and revenue drivers.

The project follows an end-to-end data analytics workflow, transforming a raw customer dataset into a cleaned and structured dataset, analysing it using SQL, and presenting the resulting insights through an interactive Power BI dashboard.

The analysis covers **3,900 unique customer records** and combines data preparation, relational database management, SQL analysis, data visualisation, and business interpretation.

---

## Business Objective

The objective of this project is to answer key business questions around customer behaviour and sales performance, including:

* Which products and categories generate the most revenue?
* How does customer spending vary across different segments?
* Do discounted purchases have different spending patterns?
* Are repeat buyers more likely to subscribe?
* Which products receive the highest customer ratings?
* How does revenue vary by season, gender, age group, and location?
* How do purchase frequency and subscription status relate to customer behaviour?

---

## Analytical Workflow

```text
Raw Customer Dataset
        ↓
Python & Pandas
        ↓
Data Cleaning & Feature Engineering
        ↓
PostgreSQL
        ↓
SQL Business Analysis
        ↓
Power BI
        ↓
Interactive Dashboard
        ↓
Insights & Recommendations
```

---

## Tools & Technologies

| Tool                 | Purpose                                   |
| -------------------- | ----------------------------------------- |
| **Python**           | Data preparation and transformation       |
| **Pandas**           | Data cleaning and feature engineering     |
| **Jupyter Notebook** | Exploratory analysis and data preparation |
| **PostgreSQL**       | Relational data storage                   |
| **SQL**              | Business analysis                         |
| **Power BI**         | Interactive data visualisation            |
| **GitHub**           | Documentation and version control         |

---

## Data Preparation

The dataset initially contained **3,900 records and 18 columns**.

Key preparation steps included:

* Inspecting the dataset structure and data types
* Identifying and handling missing values
* Imputing 37 missing review ratings using category-level medians
* Standardising column names
* Creating quartile-based customer age groups
* Converting purchase frequency categories into numerical day intervals
* Identifying and removing a redundant promotional-code field
* Validating customer IDs and checking for duplicates
* Loading the processed dataset into PostgreSQL

The final analytical dataset contains **19 columns** after cleaning and feature engineering.

---

## Key Findings

### Sales Performance

* **Total Revenue:** $233,081
* **Total Customers:** 3,900
* **Average Purchase:** $59.76
* **Average Review Rating:** 3.75

### Category Performance

**Clothing** was the strongest revenue-generating category, producing **$104,264**, followed by Accessories at $74,200.

### Seasonal Performance

**Fall** generated the highest seasonal revenue at **$60,018**, with the highest average purchase amount of $61.56.

### Discount Behaviour

Non-discounted purchases generated **$133,670** in revenue compared with $99,411 from discounted purchases.

Average purchase amount was also slightly higher for non-discounted purchases:

**$60.13 vs. $59.28.**

### Subscription Behaviour

Approximately **27%** of customers were subscribed.

Repeat buyers had a higher subscription rate (**27.56%**) than non-repeat buyers (**22.41%**), indicating an association between purchasing history and subscription participation.

### Product Performance

The highest-performing products included:

1. Blouse
2. Shirt
3. Dress
4. Pants
5. Jewelry

The five highest-rated products by average review score were Gloves, Sandals, Boots, Hat, and Skirt.

---

## Power BI Dashboard

The analysis was presented through a two-page Power BI dashboard.

### Dashboard 1 — Customer Behaviour Analysis: Overview

The overview page provides a high-level view of:

* Overall sales performance
* Customer count
* Average spending
* Review ratings
* Category revenue
* Customer demographics
* Top locations
* Top-performing products

<img width="897" height="505" alt="Screenshot 2026-10-07 191533" src="https://github.com/user-attachments/assets/b590b348-402f-4700-9eef-05f4eb655f1a" />

### Dashboard 2 — Customer Behaviour: Deep Dive

The second page explores:

* Previous purchases and purchase amount
* Purchase frequency
* Subscription behaviour
* Sales by product size
* Discounted vs. non-discounted sales

<img width="898" height="499" alt="Screenshot 2026-10-07 191602" src="https://github.com/user-attachments/assets/bec59e33-f772-407d-887b-edf81369fa30" />

---

## Key Business Insights

The analysis suggests several areas that could support further business investigation:

* **Clothing** is the strongest revenue category and may warrant continued attention in merchandising and inventory planning.
* The relatively low **27% subscription penetration** suggests an opportunity to investigate strategies for increasing subscription adoption.
* **Repeat buyers show higher subscription participation**, making them a potentially valuable audience for targeted subscription campaigns.
* The difference between discounted and non-discounted average purchase amounts is relatively small, suggesting that discount effectiveness should be evaluated using additional measures such as profit margin, discount amount, and customer retention.
* **Fall** shows the strongest seasonal performance and could warrant further investigation into seasonal demand and marketing opportunities.

---

## Repository Contents

| File                                | Description                                     |
| ----------------------------------- | ----------------------------------------------- |
| `README.md`                         | Project overview, methodology, and key findings |
| `project_report.md`                 | Detailed analytical project report              |
| `customer_behaviour_analysis.ipynb` | Python data cleaning and preparation            |
| `customer_behaviour_analysis.sql`   | SQL business analysis queries                   |
| `customer_behaviour_dashboard.pbix` | Power BI dashboard                              |

---

## Project Report

For the complete methodology, SQL analysis, findings, recommendations, and limitations, see:

**[Project Report](project_report.md)**

---

## Limitations

The dataset contains one record per unique customer rather than a transaction-level history. As a result, the analysis cannot directly measure customer retention, churn, lifetime value, or time-based purchasing trends.

The `previous_purchases` field represents a historical purchase count supplied within the dataset rather than multiple transactions observed in the data.

Additionally, the dataset does not contain profit margins, transaction dates, or actual discount amounts, limiting the depth of profitability, promotional, and time-series analysis.

---

## Project Outcome

This project demonstrates an end-to-end approach to customer behaviour analysis, combining:

**Data Cleaning → Feature Engineering → PostgreSQL → SQL Analysis → Power BI → Business Insights**

The resulting analysis transforms raw customer data into a structured analytical workflow and interactive business intelligence solution.
