-- 8.1 Facebook: Assume you have the below events table on app analytics. Write a query to get the
-- clickthrough rate per app in 2019.
SELECT
    app_id,
    SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END)/SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END) AS ctr,
FROM
    events
WHERE YEAR(date_time) = 2019
GROUP BY
    app_id;




-- 8.2 Robinhood: Assume you are given the tables below containing information on trades and
-- users. Write a query to list the top three cities that had the most number of completed orders.
SELECT
    u.city,
    COUNT(DISTINCT t_order_id) AS order_cnt
FROM trades t
INNER JOIN users u ON t.user_id = u.user_id
WHERE t.status = "complete"
GROUP BY u.city
ORDER BY COUNT(t_order_id) DESC
LIMIT 3;




-- 8.3 New York Times: Assume that you are given the table below containing information on
--viewership by device type (where the three types are laptop, tablet, and phone). Define
--“mobile” as the sum of tablet and phone viewership numbers. Write a query to compare the
--viewership on laptops versus mobile devices.

SELECT
    SUM(CASE WHEN device_type IN ('Tablet', 'Phone') THEN 1 ELSE 0 END) AS mobile_viewship,
    SUM(CASE WHEN device_type IN ('Laptop') THEN 1 ELSE 0 END) AS laptop_viewship
FROM viewship;


-- 8.4 Amazon: Assume you are given the table below for spending activity by product type.
--Write a query to calculate the cumulative spend so far by date for each product over time in
--chronological order.
SELECT 
    product_id,
    trans_date,
    SUM(spend) OVER (PARTITION BY product_id ORDER BY trans_date ASC) AS cumulative_spend
FROM total_trans
ORDER BY product_id, trans_date ASC;



-- 8.5 eBay: Assume that you are given the table below containing information on various orders
--made by customers. Write a query to obtain the names of the ten customers who have ordered
--the highest number of products among those customers who have spent at least $1000 total.
SELECT 
    user_id,
    COUNT(product_id) AS product_cnt,
    SUM(spend) AS total_spendre
FROM user_transactions
GROUP BY user_id
HAVING SUM(spend) >= 1000
ORDER BY COUNT(product_id) DESC
LIMIT 10;




-- 8.6 Twitter: Assume you are given the table below containing information on tweets. Write a query
-- to obtain a histogram of tweets posted per user in 2020.
WITH total_tweets AS (
    SELECT 
        user_id,
        COUNT(tweet_id) AS tweet_cnt
    FROM tweets
    WHERE YEAR(tweet_date) = 2020
    GROUP BY user_id
)

SELECT 
    tweet_cnt AS tweet_bucket,
    COUNT(*) AS num_users
FROM total_tweets
GROUP BY tweet_cnt
ORDER BY tweet_cnt;



-- 8.7 Stitch Fix: Assume you are given the table below containing information on user purchases.
--Write a query to obtain the number of people who purchased at least one or more of the same
--product on multiple days.
WITH multiple_day_purchase AS (
SELECT 
    user_id,
    product_id,
    COUNT(DISTINCT date(purchase_time)) AS purchase_day_cnt
FROM purchases
GROUP BY user_id, product_id
HAVING COUNT(DISTINCT date(purchase_time)) >= 2
)

SELECT
    COUNT(DISTINCT user_id) AS num_people_mutiple_purchase
FROM multiple_day_purchase;




-- 8.8 Linkedin: Assume you are given the table below that shows the job postings for all companies
--on the platform. Write a query to get the total number of companies that have posted duplicate
--job listings (two jobs at the same company with the same title and description).
WITH duplicate_posting AS (
SELECT 
    company_id,
    title,
    description,
    COUNT(job_id) AS num_posts
FROM job_listings
GROUP BY 1,2,3
HAVING COUNT(job_id) >= 2
)

SELECT 
    COUNT(DISTINCT company_id) AS num_company_duplicate_posts
FROM duplicate_posting




-- 8.9 Etsy: Assume you are given the table below on user transactions. Write a query to obtain the
-- list of customers whose first transaction was valued at $50 or more.
WITH RankedTransactions AS (
    SELECT
        user_id,
        transaction_id,
        product_id,
        spend,
        RANK() OVER (PARTITION BY user_id ORDER BY transaction_date ASC) AS transiction_rank
    FROM user_transactions
)
WITH num_transaction AS (
    SELECT 
        user_id,
        transaction_id,
        product_id,
        spend
    FROM RankedTransactions
    WHERE transiction_rank = 1
)

SELECT
    user_id
FROM num_transaction
WHERE transaction_rank = 1
GROUP BY user_id
HAVING SUM(spend) >= 50;




-- 8.10. Twitter: Assume you are given the table below containing information on each user’s tweets
-- over a period of time. Calculate the 7-day rolling average of tweets by each user for every date.
WITH user_tweet_per_day AS(
    SELECT 
        user_id,
        CAST(tweet_date AS date) AS tweet_date,
        COUNT(tweet_id) AS num_tweet
    FROM tweets
    GROUP BY 1,2
)

SELECT 
    user_id,
    tweet_date,
    AVG(num_tweet) OVER (
        PARTITION BY user_id 
        ORDER BY tweet_date ASC 
        ROWS BETWEEN 6 preceding AND CURRENT ROW
        ) AS rolling_avg_7d
FROM user_tweet_per_day;



--8.11. Uber: Assume you are given the table below on transactions made by users. Write a query to
--obtain the third transaction of every user.
WITH TransactionHistory AS (
    SELECT
        user_id,
        spend,
        transaction_date,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY transaction_date) AS tran_num
    FROM transactions
)
SELECT 
    user_id,
    spend,
    transaction_date
FROM TransactionHistory
WHERE tran_num = 3;




-- 8.12 Amazon: Assume you are given the table below containing information on customer spend on
--products belonging to various categories. Identify the top three highest-grossing items within
--each category in 2020.
WITH product_revenue AS (
    SELECT
        category_id,
        product_id,
        SUM(spend) AS revenue
    FROM product_spend
    WHERE YEAR(transaction_date) = 2000
    GROUP BY 1,2
),
RankedProducts AS (
    SELECT
        category_id,
        product_id,
        revenue,
        RANK() OVER (PARTITION BY category_id ORDER BY revenue DESC) AS product_rank
    FROM product_revenue
)
SELECT 
    category_id, 
    product_id, 
    product_rank
FROM RankedProducts
WHERE product_rank <= 3;




-- 8.13 Walmart: Assume you are given the below table on transactions from users. Bucketing users
--based on their latest transaction date, write a query to obtain the number of users who made a
--purchase and the total number of products bought for each transaction date.
WITH latest date AS (
    SELECT
        transaction date,
        user id,
        product id,
        RANK() OVER (
            PARTITION BY user id
            ORDER BY CAST(transaction_date AS DATE) DESC
        )AS days rank
FROM user transactions
)

SELECT
    transaction date,
    COUNT (DISTINCT user id) AS num_users,
    COUNT (product id) AS total products
FROM
l   atest date
WHERE
    days rank = l
GROUP BY
    transaction date
ORDER BY
    transaction date desc;