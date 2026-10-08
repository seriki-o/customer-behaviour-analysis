# Customer Behaviour Analysis

## 1. Executive Summary

This project analyses customer shopping behaviour to identify purchasing patterns, product and category performance, customer characteristics, discount behaviour, and subscription trends.

The analysis follows an end-to-end data analytics workflow, beginning with data exploration and preparation in Python, followed by relational data storage and business analysis using PostgreSQL. The resulting dataset was then connected to Power BI to develop an interactive dashboard for exploring customer behaviour and sales performance.

The dataset contains **3,900 unique customer records** covering purchasing characteristics, demographics, product information, spending, review ratings, subscription status, shipping preferences, discounts, previous purchases, and purchase frequency.

Key findings include:

* Total recorded sales amounted to **$233,081**, with an average purchase amount of **$59.76**.
* **Clothing** generated the highest category revenue at **$104,264**, accounting for approximately 45% of total revenue.
* Customers who did not receive a discount had a slightly higher average purchase amount (**$60.13**) than customers who received one (**$59.28**).
* Subscribers represented approximately **27%** of customers.
* Repeat buyers had a higher subscription rate (**27.56%**) than non-repeat buyers (**22.41%**).
* The customer base was predominantly classified as **Loyal** under the project's purchase-history segmentation, with 3,116 customers having more than 10 previous purchases.
* **Fall** generated the highest seasonal revenue at **$60,018**.
* Among the products analysed, **Blouse** generated the highest overall product revenue.
* Customers receiving express shipping spent slightly more on average than those using standard shipping (**$60.48 vs. $58.46**).

The findings provide a basis for improving customer engagement, evaluating discount strategies, understanding product demand, and exploring opportunities to strengthen subscription adoption.

---

## 2. Business Problem

Retail businesses generate large volumes of customer and purchasing data, but raw data alone does not provide clear answers to important business questions.

The objective of this project was to transform customer shopping data into actionable insights that could help answer questions such as:

* Which products and categories generate the most revenue?
* What customer groups contribute most to revenue?
* Do discounted purchases have different spending patterns?
* Do subscribers behave differently from non-subscribers?
* Are customers with more previous purchases more likely to subscribe?
* Which products receive the highest customer ratings?
* How does purchasing behaviour vary by season, shipping method, and purchase frequency?
* Which products have the highest exposure to discounts?

### Project Objective

> **To analyse customer shopping behaviour and identify trends that can support customer engagement, marketing, product, pricing, and subscription strategies.**

---

## 3. Dataset Overview

The project uses a customer shopping behaviour dataset containing **3,900 records and 18 original columns**.

Each record represents a unique customer profile, identified by `customer_id`. A validation check confirmed that all 3,900 customer IDs were unique, meaning there were no duplicate customer records in the dataset.

### Original Variables

| Variable               | Description                             |
| ---------------------- | --------------------------------------- |
| Customer ID            | Unique customer identifier              |
| Age                    | Customer age                            |
| Gender                 | Customer gender                         |
| Item Purchased         | Product purchased                       |
| Category               | Product category                        |
| Purchase Amount (USD)  | Amount spent                            |
| Location               | Customer location                       |
| Size                   | Product size                            |
| Color                  | Product colour                          |
| Season                 | Season associated with the purchase     |
| Review Rating          | Customer product rating                 |
| Subscription Status    | Whether the customer has a subscription |
| Shipping Type          | Shipping method selected                |
| Discount Applied       | Whether a discount was applied          |
| Promo Code Used        | Whether a promotional code was used     |
| Previous Purchases     | Number of previous purchases            |
| Payment Method         | Payment method                          |
| Frequency of Purchases | Customer purchase frequency             |

### Dataset Profile

| Metric                     |    Value |
| -------------------------- | -------: |
| Customer records           |    3,900 |
| Unique customers           |    3,900 |
| Original columns           |       18 |
| Average age                |    44.07 |
| Age range                  |    18–70 |
| Average purchase amount    |   $59.76 |
| Purchase amount range      | $20–$100 |
| Average review rating      |     3.75 |
| Average previous purchases |    25.35 |

### Categorical Coverage

The dataset includes:

* 25 products
* 4 product categories
* 50 locations
* 4 seasons
* 4 sizes
* 25 colours
* 2 genders
* 2 subscription statuses
* 6 shipping types
* 6 payment methods
* 7 purchase-frequency categories

<img width="1358" height="483" alt="Screenshot 2026-10-07 194812" src="https://github.com/user-attachments/assets/42d5a0de-105a-44dd-ba43-840c0dff0788" />


---

# 4. Analytical Approach

The project followed an end-to-end analytics workflow:

```text
Raw CSV Dataset
       ↓
Python / Pandas
       ↓
Data Quality Assessment
       ↓
Data Cleaning
       ↓
Feature Engineering
       ↓
PostgreSQL
       ↓
Business Analysis
       ↓
Power BI
       ↓
Interactive Dashboard
       ↓
Business Insights & Recommendations
```

The workflow was designed to separate data preparation, analytical querying, and visual reporting while maintaining a reproducible process.

### Tools Used

| Tool             | Purpose                                      |
| ---------------- | -------------------------------------------- |
| Python           | Data preparation and feature engineering     |
| Pandas           | Data manipulation and analysis               |
| Jupyter Notebook | Python analysis environment                  |
| PostgreSQL       | Relational data storage                      |
| Power BI         | Data visualisation and dashboard development |
| GitHub           | Project documentation and version control    |

---

# 5. Data Cleaning and Preparation

## 5.1 Initial Data Inspection

The dataset was first reviewed to understand its structure, data types, categorical variables, numerical ranges, and potential data quality issues.

The data was imported into a Jupyter Notebook using Pandas.

```python
import pandas as pd

df = pd.read_csv("customer_behavior.csv")
```

Initial inspection focused on:

* Dataset dimensions
* Column names
* Data types
* Missing values
* Duplicate records
* Numerical distributions
* Categorical values

<img width="1129" height="524" alt="Screenshot 2026-10-07 195501" src="https://github.com/user-attachments/assets/3287632d-da60-47d8-84c3-f730db00a7b9" />

---

## 5.2 Missing Value Treatment

A missing-value assessment showed that **Review Rating** was the only variable containing missing values.

There were **37 missing review ratings**.

Rather than replacing the missing values with a global average, category-level median imputation was used:

```python
df['Review Rating'] = df.groupby('Category')['Review Rating'].transform(
    lambda x: x.fillna(x.median())
)
```

This approach preserved differences in rating distributions between product categories while avoiding the assumption that all categories have the same typical rating.

A second missing-value check confirmed that no missing review ratings remained after the transformation.

---

## 5.3 Column Standardisation

Column names were standardised to improve consistency when working across Python, PostgreSQL, and Power BI.

For example:

```text
Customer ID              → customer_id
Item Purchased           → item_purchased
Purchase Amount (USD)    → purchase_amount
Review Rating            → review_rating
Previous Purchases       → previous_purchases
```

The `purchase_amount_(usd)` field was also simplified to `purchase_amount`.

This created cleaner and more consistent field names for downstream SQL analysis.

---

# 6. Feature Engineering

Two additional features were created to support the analysis.

## 6.1 Age Group

Customers were grouped into four age groups using quartile-based segmentation:

* Young Adult
* Adult
* Middle-aged
* Senior

The segmentation was created using `pd.qcut()`.

```python
labels = ['Young Adult', 'Adult', 'Middle-aged', 'Senior']

df['age_group'] = pd.qcut(
    df['age'],
    q=4,
    labels=labels
)
```

### Important analytical note

These categories are **quartile-based**, rather than conventional demographic age ranges. Each group therefore represents a segment of the dataset based on the distribution of customer ages.

This distinction is important when interpreting the results.

---

## 6.2 Purchase Frequency in Days

The original `frequency_of_purchases` variable contained categorical values such as:

* Weekly
* Bi-Weekly
* Fortnightly
* Monthly
* Quarterly
* Every 3 Months
* Annually

A numerical representation was created to support analysis:

| Frequency      | Days |
| -------------- | ---: |
| Weekly         |    7 |
| Bi-Weekly      |   14 |
| Fortnightly    |   14 |
| Monthly        |   30 |
| Quarterly      |   90 |
| Every 3 Months |   90 |
| Annually       |  365 |

The original categorical variable was retained for reporting purposes.

---

# 7. Redundant Data Removal

The dataset contained both:

* `discount_applied`
* `promo_code_used`

A comparison showed that the two fields contained identical information across the dataset.

```python
(df['discount_applied'] == df['promo_code_used']).all()
```

The result was `True`.

Because keeping both columns would duplicate the same information, `promo_code_used` was removed.

After cleaning and feature engineering, the final dataset contained **19 columns**.

### Final Dataset Structure

The final dataset consisted of:

* 17 retained original variables
* 2 engineered variables

The resulting table was then prepared for PostgreSQL.

---

# 8. Data Validation

Several checks were performed before loading the data into PostgreSQL.

### Customer ID Validation

The number of rows was compared with the number of distinct customer IDs.

```sql
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM customer;
```

The result confirmed:

* Total rows: **3,900**
* Unique customers: **3,900**

A second query was used to identify duplicate customer IDs:

```sql
SELECT
    customer_id,
    COUNT(*) AS occurrences
FROM customer
GROUP BY customer_id
HAVING COUNT(*) > 1;
```

No duplicate customer IDs were returned.

This confirms that the dataset contains one record per customer rather than multiple transaction records for the same customer.

---

# 9. PostgreSQL Integration

A PostgreSQL database named `customer_behaviour` was created to store the prepared dataset.

The cleaned Pandas DataFrame was loaded into a PostgreSQL table named `customer`.

The Python workflow used SQLAlchemy and `psycopg2` to establish the database connection and transfer the data.

Conceptually, the pipeline was:

```text
CSV
 ↓
Pandas DataFrame
 ↓
Cleaning & Feature Engineering
 ↓
PostgreSQL Database
 ↓
customer Table
```

The database provided a structured environment for performing SQL-based business analysis.

<img width="1357" height="631" alt="Screenshot 2026-10-07 194158" src="https://github.com/user-attachments/assets/61e8da23-5c4d-4c01-9156-c8f5e67fdb69" />

---

# 10. SQL Business Analysis

SQL was used to answer a series of business questions based on the cleaned customer dataset.

The analysis focused on customer spending, product performance, discount behaviour, subscription activity, purchasing history, and revenue contribution.

## 10.1 Overall Performance

The overall dataset KPIs were:

| Metric                     |   Result |
| -------------------------- | -------: |
| Total Revenue              | $233,081 |
| Customers                  |    3,900 |
| Average Purchase           |   $59.76 |
| Average Review Rating      |     3.75 |
| Average Previous Purchases |    25.35 |

These figures provide the baseline against which other customer and product segments were compared.

---

## 10.2 Revenue by Gender

| Gender |  Revenue |
| ------ | -------: |
| Female |  $75,191 |
| Male   | $157,890 |

Male customers contributed the larger share of recorded revenue in the dataset.

However, revenue differences should be interpreted alongside the number of customers in each group rather than treated as evidence that one gender inherently spends more.

---

## 10.3 Highest-Rated Products

The five products with the highest average review ratings were:

| Product | Average Rating |
| ------- | -------------: |
| Gloves  |           3.86 |
| Sandals |           3.84 |
| Boots   |           3.82 |
| Hat     |           3.80 |
| Skirt   |           3.78 |

The relatively narrow rating range suggests that there were no extreme differences in average product ratings among the highest-rated products.

---

## 10.4 Shipping Method and Average Purchase

Average purchase amounts by shipping type were:

| Shipping Type  | Average Purchase |
| -------------- | ---------------: |
| 2-Day Shipping |           $60.73 |
| Express        |           $60.48 |
| Free Shipping  |           $60.41 |
| Store Pickup   |           $59.89 |
| Next Day Air   |           $58.63 |
| Standard       |           $58.46 |

Express shipping had an average purchase amount of **$60.48**, compared with **$58.46** for standard shipping.

The difference is relatively small, so the result should not be interpreted as evidence that express shipping causes higher spending.

---

## 10.5 Subscription Performance

Subscription behaviour was compared using customer count, average purchase amount, and revenue.

| Subscription | Customers | Average Purchase |  Revenue |
| ------------ | --------: | ---------------: | -------: |
| Yes          |     1,053 |           $59.49 |  $62,645 |
| No           |     2,847 |           $59.87 | $170,436 |

Subscribers represented approximately **27%** of the customer base.

Interestingly, subscribers had a slightly lower average purchase amount than non-subscribers. This suggests that subscription status alone was not associated with substantially higher individual purchase values within this dataset.

---

## 10.6 Products with Highest Discount Rates

The products with the highest proportion of discounted purchases were:

| Product  | Discounted Purchase Rate |
| -------- | -----------------------: |
| Hat      |                      50% |
| Sneakers |                      49% |
| Coat     |                      49% |
| Sweater  |                      48% |
| Pants    |                      47% |

These products may warrant further investigation to determine whether discounts are being used as a deliberate promotional strategy or whether they reflect differences in product demand.

---

## 10.7 Customer Purchase-History Segmentation

Customers were segmented according to their recorded previous purchase count:

* **New:** 1 previous purchase
* **Returning:** 2–10 previous purchases
* **Loyal:** More than 10 previous purchases

The resulting distribution was:

| Segment   | Customers |
| --------- | --------: |
| New       |        83 |
| Returning |       701 |
| Loyal     |     3,116 |

The dataset is therefore heavily concentrated in the Loyal segment under this definition.

### Analytical Caveat

This segmentation is based on the `previous_purchases` value supplied in the dataset. It does **not** represent repeated transactions observed across the dataset itself.

---

## 10.8 Top Products Within Each Category

The three highest-volume products within each category were:

### Accessories

| Product    | Purchases |
| ---------- | --------: |
| Jewelry    |       171 |
| Sunglasses |       161 |
| Belt       |       161 |

### Clothing

| Product | Purchases |
| ------- | --------: |
| Blouse  |       171 |
| Pants   |       171 |
| Shirt   |       169 |

### Footwear

| Product  | Purchases |
| -------- | --------: |
| Sandals  |       160 |
| Shoes    |       150 |
| Sneakers |       145 |

### Outerwear

| Product | Purchases |
| ------- | --------: |
| Jacket  |       163 |
| Coat    |       161 |

The results highlight products that could receive further attention in inventory planning, merchandising, and promotional decisions.

---

## 10.9 Repeat Buyers and Subscription

Repeat buyers were defined as customers with more than five previous purchases.

| Customer Group   | Customers | Subscribers | Subscription Rate |
| ---------------- | --------: | ----------: | ----------------: |
| Repeat Buyer     |     3,476 |         958 |            27.56% |
| Non-Repeat Buyer |       424 |          95 |            22.41% |

Repeat buyers had a subscription rate approximately **5.15 percentage points higher** than non-repeat buyers.

This indicates an association between previous purchasing activity and subscription participation.

However, the analysis does not establish that repeat purchasing causes customers to subscribe.

---

## 10.10 Revenue Contribution by Age Group

| Age Group   | Revenue |
| ----------- | ------: |
| Young Adult | $62,143 |
| Middle-aged | $59,197 |
| Adult       | $55,978 |
| Senior      | $55,763 |

The Young Adult segment generated the highest recorded revenue under the quartile-based age segmentation.

---

# 11. Additional Analysis

Additional queries were performed to strengthen the analysis beyond the original business questions.

## 11.1 Revenue by Category

| Category    | Purchases |  Revenue | Average Purchase |
| ----------- | --------: | -------: | ---------------: |
| Clothing    |     1,737 | $104,264 |           $60.03 |
| Accessories |     1,240 |  $74,200 |           $59.84 |
| Footwear    |       599 |  $36,093 |           $60.26 |
| Outerwear   |       324 |  $18,524 |           $57.17 |

Clothing was the strongest category, generating approximately **45% of total revenue**.

Outerwear generated the lowest revenue and had the lowest average purchase amount among the four categories.

---

## 11.2 Revenue by Season

| Season | Purchases | Revenue | Average Purchase |
| ------ | --------: | ------: | ---------------: |
| Fall   |       975 | $60,018 |           $61.56 |
| Spring |       999 | $58,679 |           $58.74 |
| Winter |       971 | $58,607 |           $60.36 |
| Summer |       955 | $55,777 |           $58.41 |

Fall generated the highest revenue, while Summer generated the lowest.

Fall also had the highest average purchase amount at **$61.56**.

---

## 11.3 Discounted vs. Non-Discounted Purchases

| Discount Applied | Purchases | Average Purchase |  Revenue |
| ---------------- | --------: | ---------------: | -------: |
| No               |     2,223 |           $60.13 | $133,670 |
| Yes              |     1,677 |           $59.28 |  $99,411 |

Non-discounted purchases generated substantially more total revenue and had a slightly higher average purchase amount.

The difference in average purchase amount was approximately **$0.85**.

This suggests that discounts did not correspond with higher average purchase values in this dataset.

---

## 11.4 Purchase Frequency and Spending

| Purchase Frequency | Average Purchase | Revenue |
| ------------------ | ---------------: | ------: |
| Weekly             |           $58.97 | $31,786 |
| Bi-Weekly          |           $60.69 | $33,200 |
| Fortnightly        |           $59.05 | $32,007 |
| Monthly            |           $59.33 | $32,810 |
| Quarterly          |           $59.98 | $33,771 |
| Every 3 Months     |           $60.08 | $35,088 |
| Annually           |           $60.17 | $34,419 |

Average purchase amounts remained relatively close across the different purchase-frequency groups.

The highest average purchase was recorded among Bi-Weekly customers at **$60.69**, while Weekly customers had the lowest at **$58.97**.

The relatively narrow range suggests that purchase frequency alone was not strongly associated with purchase value in this dataset.

---

# 12. Power BI Dashboard

The cleaned PostgreSQL dataset was connected to Power BI to create an interactive two-page dashboard.

The dashboard was designed to move from a high-level overview of performance into a deeper examination of customer purchasing behaviour.

---

## 12.1 Dashboard 1 — Customer Behaviour Analysis: Overview

The first dashboard provides a high-level summary of store performance, revenue drivers, and customer demographics.

<img width="897" height="505" alt="Screenshot 2026-10-07 191533" src="https://github.com/user-attachments/assets/bfddfa07-40b6-4491-8ca3-a21070a59b68" />

### Key Performance Indicators

The dashboard presents four headline metrics:

* **Total Sales:** $233K
* **Total Customers:** 3.9K
* **Average Spend:** $59.76
* **Average Review Rating:** 3.75

These KPIs provide an immediate summary of the dataset's overall performance.

### Interactive Filters

The dashboard includes slicers for:

* Season
* Gender
* Discounted

These filters allow users to explore how the main performance metrics and visuals change across customer and purchasing segments.

### Sales by Category

A bar chart compares revenue across the four product categories.

Clothing is the strongest revenue contributor, followed by Accessories, Footwear, and Outerwear.

This visual provides a quick way to identify which product categories contribute most to overall revenue.

### Customer Demographics

A stacked bar chart breaks customer volume down by age group and gender.

The visual allows users to compare the composition of the customer base across the four quartile-based age groups.

### Top Locations by Revenue

A horizontal bar chart ranks the top 10 customer locations by revenue.

Montana appears at the top of the displayed ranking, followed by the other leading locations.

This view provides a geographic perspective on customer revenue concentration.

### Top Products

The dashboard also highlights the five highest-performing products:

1. Blouse
2. Shirt
3. Dress
4. Pants
5. Jewelry

The relatively close performance of these products suggests that the top-performing product group is not dominated by a single product.

---

## 12.2 Dashboard 2 — Customer Behaviour: Deep Dive

The second dashboard focuses on purchasing behaviour, customer frequency, subscriptions, product size, and discount activity.

<img width="898" height="499" alt="Screenshot 2026-10-07 191602" src="https://github.com/user-attachments/assets/bad6be0e-5832-4ed7-a119-ff3c6e7fed8e" />

### Previous Purchases vs. Purchase Amount

A scatter plot examines the relationship between customers' previous purchase counts and purchase amount.

The visual allows the user to investigate whether customers with greater purchasing history also demonstrate different spending patterns.

Because the dataset contains one record per customer, this visual should be interpreted as a cross-sectional comparison rather than a longitudinal analysis of individual transaction histories.

### Purchase Frequency

A line chart compares purchase-frequency patterns by subscription status.

Subscription status is split between subscribed and non-subscribed customers, allowing users to explore whether subscription participation differs across purchasing-frequency groups.

### Sales by Body Size

A bar chart compares revenue across the available product sizes:

* XL
* S
* L
* M

Medium-sized products generated the highest sales volume in the dashboard.

This can provide a useful starting point for inventory and product assortment discussions.

### Subscription Status

A donut chart shows the distribution of subscription status.

Approximately:

* **73%** of customers are not subscribed.
* **27%** are subscribed.

This highlights a sizeable potential audience for subscription-focused customer engagement strategies.

### Sales by Discount Applied

A bar chart compares revenue between discounted and non-discounted purchases.

The dashboard shows higher aggregate revenue from non-discounted purchases, consistent with the SQL analysis:

* Non-discounted revenue: **$133,670**
* Discounted revenue: **$99,411**

This result suggests that discounts should be evaluated based on their incremental business value rather than assumed to increase customer spending.

---

# 13. Key Findings

The combined SQL and Power BI analysis produced several notable findings.

### 1. Clothing is the dominant revenue category

Clothing generated **$104,264**, representing approximately 45% of total recorded revenue.

This makes clothing the strongest category in the dataset and a potential priority for merchandising and inventory planning.

### 2. Non-discounted purchases generated more revenue

Non-discounted purchases generated **$133,670**, compared with **$99,411** for discounted purchases.

Average purchase value was also slightly higher without a discount:

**$60.13 vs. $59.28.**

The result does not prove that discounts negatively affect revenue, because the dataset does not contain the information needed to measure the counterfactual outcome of offering versus not offering a discount.

### 3. Subscription penetration is relatively low

Only approximately **27%** of customers were subscribed.

This indicates that subscription adoption could represent an opportunity for customer retention and engagement initiatives.

### 4. Repeat buyers show higher subscription participation

Customers classified as repeat buyers had a **27.56% subscription rate**, compared with **22.41%** among non-repeat buyers.

This association suggests that customers with stronger purchasing histories may be more receptive to subscription programmes.

### 5. Seasonal performance varies

Fall generated the highest revenue at **$60,018**, while Summer generated the lowest at **$55,777**.

Fall also had the highest average purchase amount.

### 6. Purchase frequency has limited variation in spending

Average purchase values ranged from **$58.97 to $60.69** across purchase-frequency groups.

This relatively narrow range suggests that frequency alone does not explain substantial differences in individual purchase value.

### 7. The customer dataset is heavily weighted toward the Loyal segment

Using the project's definition of loyalty — more than 10 previous purchases — **3,116 customers** were classified as Loyal.

This is an important characteristic of the dataset but should not be interpreted as evidence of observed long-term customer retention because previous purchase history is provided as a single attribute rather than a transaction history.

---

# 14. Business Recommendations

Based on the findings, several areas could be considered for further business action.

## 14.1 Prioritise High-Performing Categories

Clothing accounts for the largest share of revenue.

The business could prioritise strong-performing clothing products through:

* Inventory availability
* Product placement
* Seasonal merchandising
* Cross-selling
* Targeted campaigns

However, inventory decisions should also consider margin, stock levels, and demand trends, which are not available in the current dataset.

---

## 14.2 Re-evaluate Discount Strategy

Discounted purchases had a lower average purchase amount than non-discounted purchases.

Rather than assuming discounts increase spending, the business could evaluate:

* Which products benefit from discounts
* Whether discounts increase purchase frequency
* Whether discounts attract new customers
* Whether discounted customers have higher long-term value
* The profitability impact of each discount campaign

A future dataset containing actual discount amounts and profit margins would allow this analysis to be strengthened.

---

## 14.3 Target High-Value Repeat Customers for Subscription Offers

Repeat buyers had a higher subscription rate than non-repeat buyers.

This suggests that customers demonstrating stronger purchasing histories may be an appropriate audience for targeted subscription campaigns.

Potential strategies could include:

* Personalised subscription offers
* Loyalty rewards
* Exclusive product access
* Subscription discounts
* Early access to promotions

---

## 14.4 Investigate Seasonal Demand

Fall generated the highest revenue and average purchase value.

The business could investigate whether seasonal campaigns, product availability, customer demand, or promotional activity contribute to this difference.

This could support more targeted seasonal marketing and inventory planning.

---

## 14.5 Investigate Product-Level Discount Dependence

Hat, Sneakers, Coat, Sweater, and Pants had the highest proportions of discounted purchases.

These products could be investigated further to determine whether frequent discounting reflects:

* High demand
* Low demand
* Promotional strategy
* Excess inventory
* Product positioning

The current dataset cannot determine which explanation applies, but it identifies products worth investigating.

---

# 15. Limitations

Several limitations should be considered when interpreting the findings.

### 15.1 Cross-sectional customer data

The dataset contains one record per unique customer and does not provide a transaction-level history.

Therefore, the analysis cannot directly measure:

* Customer lifetime value
* Actual repeat transaction behaviour
* Retention over time
* Churn
* Month-over-month purchasing trends

### 15.2 Previous purchases are historical attributes

`previous_purchases` represents a supplied count rather than multiple historical transactions contained in the dataset.

Consequently, the project uses this field for segmentation and association analysis rather than claiming to observe repeat purchases directly.

### 15.3 No transaction dates

The dataset does not contain transaction dates.

This prevents detailed time-series analysis such as:

* Monthly revenue trends
* Year-over-year growth
* Customer retention curves
* Cohort analysis
* Purchase seasonality over multiple years

The available `Season` field represents a categorical attribute rather than a chronological time series.

### 15.4 No profit or margin data

Revenue is available, but cost and profit information are not.

Therefore, high revenue should not automatically be interpreted as high profitability.

### 15.5 Limited discount information

The dataset identifies whether a discount was applied but does not provide the discount amount or percentage.

This limits the ability to measure the financial effectiveness of individual discount campaigns.

### 15.6 Quartile-based age groups

The age groups were created using quartiles rather than predefined demographic boundaries.

Consequently, the labels describe segments of this particular dataset rather than universally defined age categories.

---

# 16. Conclusion

This project demonstrates an end-to-end approach to customer behaviour analysis, combining Python-based data preparation, PostgreSQL data management, SQL business analysis, and Power BI visualisation.

The analysis identified several meaningful patterns, including the strong contribution of the Clothing category, relatively low subscription penetration, higher subscription participation among repeat buyers, differences in seasonal revenue, and the relatively small difference in average purchase value between discounted and non-discounted purchases.

The project also demonstrates the importance of analytical context. Several findings show associations rather than causal relationships, and the limitations of the underlying dataset prevent conclusions about customer retention, profitability, or the long-term effectiveness of promotional strategies.

Rather than treating the dashboard as the final product, the project uses the dashboard as the final layer of a broader analytical workflow:

```text
Data
  ↓
Cleaning
  ↓
Transformation
  ↓
Database
  ↓
SQL Analysis
  ↓
Visualisation
  ↓
Insights
  ↓
Business Recommendations
```

This approach ensures that the visualisations are supported by validated data and analytical reasoning.

---

## Project Outcome

The completed project transforms a raw customer dataset into a structured analytical workflow and interactive business intelligence solution, demonstrating practical skills across **data cleaning, feature engineering, SQL analysis, relational databases, business intelligence, data visualisation, and analytical storytelling**.
