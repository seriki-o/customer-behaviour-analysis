select * from customer;

--Total Revenue, 233081
select sum(purchase_amount)
from customer;

--Total customers, 3900
select count(distinct customer_id)
from customer;

--Average purchase amount, 59.76
select round(avg(Purchase_amount),2)
from customer;

-- average rating, 3.75
select round(avg(review_rating::numeric),2)
from customer;

-- average previous purchases, 25.35
select round(avg(previous_purchases),2)
from customer;

-- revenue by category
SELECT 
    category,
    COUNT(*) AS total_purchases,
    SUM(purchase_amount) AS total_revenue,
    ROUND(AVG(purchase_amount), 2) AS avg_purchase_amount
FROM customer
GROUP BY category
ORDER BY total_revenue DESC;

-- Revenue by season
SELECT 
    season,
    COUNT(*) AS total_purchases,
    SUM(purchase_amount) AS total_revenue,
    ROUND(AVG(purchase_amount), 2) AS avg_purchase_amount
FROM customer
GROUP BY season
ORDER BY total_revenue DESC;

--Discount vs non-discount overall
SELECT 
    discount_applied,
    COUNT(*) AS total_purchases,
    ROUND(AVG(purchase_amount), 2) AS avg_purchase_amount,
    SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY discount_applied
ORDER BY avg_purchase_amount DESC;

--Total revenue by male vs female
select gender, sum(purchase_amount) as rev
from customer
group by gender;

--Purchase frequency vs spending
SELECT 
    frequency_of_purchases,
    purchase_frequency_days,
    COUNT(*) AS total_purchases,
    ROUND(AVG(purchase_amount), 2) AS avg_purchase_amount,
    SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY frequency_of_purchases, purchase_frequency_days
ORDER BY purchase_frequency_days;

-- customers that spent more than average purchase amount while using discount
select customer_id, purchase_amount
from customer
where discount_applied = 'Yes'  and 
	purchase_amount > (select avg(purchase_amount) 
						from customer);

-- top 5 products based on review rating
select item_purchased, round(avg(review_rating::numeric), 2) as avg_review_rating
from customer
group by item_purchased
order by avg_review_rating desc
limit 5;

-- compare purchase amount between shipping types
select shipping_type, round(avg(purchase_amount),2) as avg_purchase_amount
from customer
group by shipping_type
order by avg_purchase_amount desc ;

	-- express shipping vs standard
	select shipping_type, round(avg(purchase_amount),2) as avg_purchase_amount
	from customer
	where shipping_type in ('Express', 'Standard')
	group by shipping_type;

-- who spends more between suscribers and non_suscribers
select subscription_status,
count( distinct customer_id) as total_customers,
round(avg(purchase_amount),2) as average_spend,
sum(purchase_amount) as total_revenue
from customer
group by subscription_status
order by total_revenue, average_spend desc;

-- top products with highest percentage of purchases with discount applied
select item_purchased, 
round(100 * sum(case when discount_applied ='Yes' then 1 else 0 end)/count(*),2) as discount_rate
from customer
group by item_purchased
order by discount_rate desc
limit 5;

--segment customers into new, returning or loyal
with customer_type as(
select customer_id, previous_purchases,
case
	when previous_purchases = 1 then 'New'
	when previous_purchases between 2 and 10 then 'Returning'
	else 'Loyal'
	end as customer_segment
from customer)

select customer_segment, count(*) as "Number of customers"
from customer_type
group by customer_segment;

--top 3 most prurchased product from each category
with item_counts as (
select category, item_purchased, 
count(customer_id) as total_orders,
row_number() over(partition by category order by count(customer_id) desc) as item_rank
from customer
group by category, item_purchased)

select item_rank, category, item_purchased, total_orders
from item_counts
where item_rank <= 3;

-- are repeat buyers likely to suscribe
SELECT
    CASE
        WHEN previous_purchases > 5 THEN 'Repeat Buyer'
        ELSE 'Non-Repeat Buyer'
    END AS buyer_type,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN subscription_status = 'Yes' THEN 1 ELSE 0 END) AS subscribers,
    ROUND(
        100.0 * SUM(CASE WHEN subscription_status = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS subscription_rate
FROM customer
GROUP BY buyer_type
ORDER BY subscription_rate DESC;

-- revenue by age group contribution
select age_group, sum(purchase_amount) as revenue
from customer
group by age_group
order by revenue desc;




