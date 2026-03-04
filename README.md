# Objective

## SQL tutorial
+ Leetcode 50 question study plan.
    + https://www.youtube.com/watch?v=RMtpiiS20jA&list=PLdrw9_aIADIO0O8PYds0sND0ELokLQ4bv&ab_channel=FrederikM%C3%BCller

## SQL interview questions
+ 45 leetcode database challenge.
    + Question list: https://leetcode.com/problem-list/e97a9e5m/
+ 103 leetcode database questions, without premium
    + Question list: https://leetcode.com/problem-list/whzhtem1/
    + Solutions: https://walkccc.me/LeetCode/problems/3451/
+ 320 leetcode database challenge.
    + Question list: https://leetcode.com/problemset/database/
    + Solutions: https://github.com/mrinal1704/SQL-Leetcode-Challenge?tab=readme-ov-file

## Window function examples
ROW_NUMBER()	❌ (Assigns unique number)	No gaps, simply continues sequence	1, 2, 3, 4
RANK()	✅ (Same rank to ties)	Skips subsequent numbers (leaves gaps)	1, 2, 2, 4
DENSE_RANK()	✅ (Same rank to ties)	No gaps, continues with the next consecutive number	1, 2, 2, 3

In MySQL, while your use of the RANK() window function is syntactically correct for modern MySQL (version 8.0+), you cannot use window functions directly in a WHERE clause.

To calculate a running total of sales ordered by date
```sql
SELECT
    sales_month,
    sales,
    SUM(sales) OVER (ORDER BY sales_month) AS running_total
FROM
    sales;
```

To calculate the total salary for each department and display it next to each employee's details
```sql
SELECT
    name,
    dept_id,
    salary,
    SUM(salary) OVER (PARTITION BY dept_id) AS total_department_salary
FROM
    employees;
```

The following query ranks employees by salary within each department
```sql
SELECT
    Name,
    Department,
    Salary,
    RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS DeptRank
FROM
    Employees
ORDER BY
    Department, DeptRank;
```

The following query calculate the 7-day rolling average of tweets by each user for every date.
```sql
SELECT 
    user_id,
    tweet_date,
    AVG(num_tweet) OVER (
        PARTITION BY user_id 
        ORDER BY tweet_date ASC 
        ROWS BETWEEN 6 preceding AND CURRENT ROW
        ) AS rolling_avg_7d
FROM user_tweet_per_day;
```

## Regular expression examples
The prefix name is a string that may contain letters (upper or lower case), digits, underscore '_', period '.', and/or dash '-'. The prefix name must start with a letter.
The domain is '@leetcode.com'.
c means case sensitive, i means case insensitive
```sql
SELECT
    *
FROM Users
WHERE REGEXP_LIKE(mail, '^[a-z][a-zA-Z0-9_.-]*@leetcode\\.com$', 'c');
```

## Date functions

```sql
EXTRACT(month FROM OrderDate)
DATE_ADD(OrderDate, INTERVAL 30 DAY) AS OrderPayDate
DATEDIFF(date1, date2) -- return # of days between two date values.
```

