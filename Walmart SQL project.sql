create database walmart_db;
show databases;
show tables;
select count(*) from walmart;
select * from walmart;
select 
    payment_method,
    count(*)
from walmart
group by payment_method


select 
    count(distinct branch)
    from walmart;
    
select max(quantity) from walmart;
select min(quantity) from walmart;

---BUSINESS PROBLEMS
---Q1. Find different payment method and number of transaction, number of quantity sold?

select 
    payment_method,
    count(*) as no_payments,
    sum(quantity) as no_qty_sold
from walmart
group by payment_method

Q2. Identify the highest-rated categoy in each branch, displaying the branch, category AVG RATING

SELECT * 
FROM (
    SELECT
        branch,
        category,
        AVG(rating) AS avg_rating,
        RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS rnk
    FROM walmart
    GROUP BY branch, category
) AS sub
WHERE rnk = 1;

Q3. Identify the Business day for each branch based on the number of transactions

select *
from
    (select 
        branch, 
        DATE_FORMAT(STR_TO_DATE(date, '%d/%m/%y'), '%W') as formated_date,
        count(*) as no_transaction,
        rank() over(partition by branch order by count(*) desc) as rnk
    from walmart
    group by 1,2
    ) as sub
where rnk = 1

Q4. Calculate the total quantity of items sold per payment method, list payment_method and total_quantity

select 
    payment_method,
    count(*) as no_payments,
    sum(quantity) as no_qty_sold
from walmart
group by payment_method

Q5. Determine the avg min and max rating of category for each city, List the city avg_rating, min_rating and max_rating

select 
    city, 
    category,
    min(rating) as min_rating,
    max(rating) as max_rating,
    avg(rating) as avg_rating
from walmart
group by 1,2

Q6. Calculate the total profit for each category by considering total_profit as (unit_price * quantity * profit_margin). List category and total_profit, ordered from highest to lowest profit.

select
    category, 
    sum(total) as total_revenue,
    sum(total * profit_margin) as profit
from walmart
group by 1

Q7. Determine the most common payment method for each branch. Display branch and preferred payment_method

WITH cte AS (
    SELECT 
        branch,
        payment_method,
        COUNT(*) AS total_trans,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rnk
    FROM walmart
    GROUP BY branch, payment_method
)

SELECT * 
FROM cte
WHERE rnk = 1;

Q8. Categorize sales into 3 group morning, afternoon, evening. Find out each of the shift and number of invoices 

SELECT 
    branch, 
    CASE 
        WHEN HOUR(CAST(time AS TIME)) < 12 THEN 'morning'
        WHEN HOUR(CAST(time AS TIME)) BETWEEN 12 AND 17 THEN 'afternoon'
        ELSE 'evening'
    END AS day_time,
    COUNT(*) AS transaction_count
FROM walmart
GROUP BY branch, day_time
ORDER BY branch, transaction_count DESC;














