# Objective

## SQL tutorial
+ Leetcode 50 question study plan.
    + https://www.youtube.com/watch?v=RMtpiiS20jA&list=PLdrw9_aIADIO0O8PYds0sND0ELokLQ4bv&ab_channel=FrederikM%C3%BCller

## SQL interview questions
+ 45 leetcode database challenge.
    + Question list: https://leetcode.com/problem-list/e97a9e5m/
+ 320 leetcode database challenge.
    + Question list: https://leetcode.com/problemset/database/
    + Solutions: https://github.com/mrinal1704/SQL-Leetcode-Challenge?tab=readme-ov-file

## Window function examples
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
