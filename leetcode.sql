-- leetcode questions
-- referece: Leetcode SQL 50 study plan 
-- https://www.youtube.com/watch?v=RMtpiiS20jA&list=PLdrw9_aIADIO0O8PYds0sND0ELokLQ4bv&ab_channel=FrederikM%C3%BCller




----------------------------------------------------------
-- leetcode 1757 recyclable and low fat products
----------------------------------------------------------
-- Write a solution to find the ids of products that are both low fat and recyclable.
SELECT
    product_id
FROM Products
WHERE
    low_fats = 'Y' AND recyclable = 'Y';




----------------------------------------------------------
-- leetcode 584 find customer referee
----------------------------------------------------------
-- Find the names of the customer that are not referred by the customer with id = 2.
-- NULL ones also needs to be returned, NULL != 2 will return NULL therefore not be included in the result.
SELECT
    name
FROM Customer
WHERE referee_id != 2 OR referee_id IS NULL;

SELECT
    name
FROM Customer
WHERE COALESCE(referee_id, 0) != 2;




----------------------------------------------------------
-- leetcode 595 big countries
----------------------------------------------------------
-- Write a solution to find the name, population, and area of the big countries.
SELECT
    name,
    population,
    area
FROM World
WHERE
    area >= 3000000 OR population >= 25000000;




----------------------------------------------------------
-- leetcode 1148 article views I
----------------------------------------------------------
-- Write a solution to find all the authors that viewed at least one of their own articles.
SELECT
    DISTINCT author_id as id
FROM Views
WHERE
    author_id = viewer_id
ORDER BY id;




----------------------------------------------------------
-- leetcode 1683 invalid tweets
----------------------------------------------------------
-- Write a solution to find the IDs of the invalid tweets. 
-- The tweet is invalid if the number of characters used in the content of the tweet is strictly greater than 15.
-- LENGTH() will count some characters as 2 or higher, such as ü.
SELECT
    tweet_id
FROM Tweets
WHERE
    CHAR_LENGTH(content) > 15;




----------------------------------------------------------
-- leetcode 177 Nth highest salary
----------------------------------------------------------
-- Write a solution to find the nth highest distinct salary from the Employee table. 
-- If there are less than n distinct salaries, return null.
SELECT
    DISTINCT a.salary
FROM 
    (
        SELECT 
            salary,
            DENSE_RANK() OVER (ORDER BY salary DESC) AS salary_rank
        FROM Employee
    ) a
WHERE a.salary_rank = N;




----------------------------------------------------------
-- leetcode 178 rank scores
----------------------------------------------------------
-- Write a solution to find the rank of the scores. The ranking should be calculated according to the following rules:
-- The scores should be ranked from the highest to the lowest.
-- If there is a tie between two scores, both should have the same ranking.
-- After a tie, the next ranking number should be the next consecutive integer value. In other words, 
-- there should be no holes between ranks.
SELECT
    score,
    DENSE_RANK() OVER (ORDER BY score DESC) AS 'rank'
FROM Scores
ORDER BY score DESC;



----------------------------------------------------------
-- leetcode 180 consecutive numbers
----------------------------------------------------------
-- Find all numbers that appear at least three times consecutively.
-- self joins
SELECT 
    DISTINCT a.num AS ConsecutiveNums
FROM Logs a 
JOIN Logs b ON a.id = b.id+1 AND a.num = b.num
JOIN Logs c ON a.id = c.id+2 AND a.num = c.num;




----------------------------------------------------------
-- leetcode 1378 Replace Employee ID With The Unique Identifier
----------------------------------------------------------
-- Write a solution to show the unique ID of each user, If a user does not have a unique ID replace just show null.
SELECT
    euni.unique_id,
    e.name
FROM Employees e
LEFT JOIN EmployeeUNI euni ON e.id = euni.id;




----------------------------------------------------------
-- leetcode 1068. Product Sales Analysis I
----------------------------------------------------------
-- Write a solution to report the product_name, year, and price for each sale_id in the Sales table.
SELECT
    p.product_name,
    s.year,
    s.price
FROM Sales s
LEFT JOIN Product p ON s.product_id = p.product_id;




----------------------------------------------------------
-- 1581. Customer Who Visited but Did Not Make Any Transactions
----------------------------------------------------------
-- Write a solution to find the IDs of the users who visited without making any transactions 
-- and the number of times they made these types of visits.
SELECT
    v.customer_id,
    COUNT(*) AS count_no_trans
FROM visits v
LEFT JOIN transactions t ON v.visit_id = t.visit_id
WHERE 
    t. transaction_id IS NULL
GROUP BY v.customer_id;




----------------------------------------------------------
-- 1407 Top Travellers
----------------------------------------------------------
-- Write a solution to find the top three travellers who have visited the most number of unique cities.
-- return the result table ordered by the number of unique cities visited in descending order.
SELECT
    u.name,
    SUM(coalesce(r.distance, 0)) AS travelled_distance
FROM Users u
LEFT JOIN Rides r ON r.user_id = u.id
GROUP BY u.id -- people can have same name
ORDER BY travelled_distance DESC, u.name;



----------------------------------------------------------
-- 1527 Patients With a Condition
----------------------------------------------------------
-- Write a solution to find the patient_id, patient_name, and conditions of the patients who have Type I Diabetes. 
-- Type I Diabetes always starts with DIAB1 prefix.
-- Return the result table in any order.
SELECT
    patient_id,
    patient_name,
    conditions
FROM Patients
WHERE conditions LIKE "% DIAB1%" OR conditions LIKE "DIAB1%";



----------------------------------------------------------
-- 1667 Fix Names in a Table
----------------------------------------------------------
-- Write a solution to fix the names so that only the first character is uppercase and the rest are lowercase.
SELECT
    user_id,
    CONCAT(UPPER(SUBSTRING(name, 1, 1)), LOWER(SUBSTRING(name, 2))) AS name
FROM Users
ORDER BY user_id;




----------------------------------------------------------
-- 1179 Reformat Department Table
----------------------------------------------------------
-- Reformat the table such that there is a department id column and a revenue column for each month.
-- pivot talbe
SELECT
    id,
    SUM(CASE WHEN month = 'Jan' THEN revenue ELSE NULL END) AS Jan_Revenue,
    SUM(CASE WHEN month = 'Feb' THEN revenue ELSE NULL END) AS Feb_Revenue,
    SUM(CASE WHEN month = 'Mar' THEN revenue ELSE NULL END) AS Mar_Revenue,
    SUM(CASE WHEN month = 'Apr' THEN revenue ELSE NULL END) AS Apr_Revenue,
    SUM(CASE WHEN month = 'May' THEN revenue ELSE NULL END) AS May_Revenue,
    SUM(CASE WHEN month = 'Jun' THEN revenue ELSE NULL END) AS Jun_Revenue,
    SUM(CASE WHEN month = 'Jul' THEN revenue ELSE NULL END) AS Jul_Revenue,
    SUM(CASE WHEN month = 'Aug' THEN revenue ELSE NULL END) AS Aug_Revenue,
    SUM(CASE WHEN month = 'Sep' THEN revenue ELSE NULL END) AS Sep_Revenue,
    SUM(CASE WHEN month = 'Oct' THEN revenue ELSE NULL END) AS Oct_Revenue,
    SUM(CASE WHEN month = 'Nov' THEN revenue ELSE NULL END) AS Nov_Revenue,
    SUM(CASE WHEN month = 'Dec' THEN revenue ELSE NULL END) AS Dec_Revenue
FROM Department
GROUP BY id;




----------------------------------------------------------
-- 1084 Sales Analysis III
----------------------------------------------------------
-- Write a solution to report the products that were only sold in the first quarter of 2019. 
-- That is, between 2019-01-01 and 2019-03-31 inclusive.
SELECT
    DISTINCT
    s.product_id,
    p.product_name
FROM Sales s
LEFT JOIN Product p ON p.product_id = s.product_id
WHERE 
    s.sale_date BETWEEN '2019-01-01' AND '2019-03-31'
    AND s.product_id NOT IN (
        SELECT DISTINCT product_id
        FROM sales
        WHERE sale_date NOT BETWEEN '2019-01-01' AND '2019-03-31'
        );




----------------------------------------------------------
-- 511 game play analysis I
----------------------------------------------------------
-- Write a solution to find the first login date for each player.
SELECT
    player_id,
    min(event_date) AS first_login
FROM Activity
GROUP BY player_id;




----------------------------------------------------------
-- 1795 rearrange products table
----------------------------------------------------------
-- Write a solution to rearrange the Products table so that each row has (product_id, store, price). 
-- If a product is not available in a store, 
-- do not include a row with that product_id and store combination in the result table.
-- unpivot table, use UNION FUNCTION
SELECT
    p1.product_id,
    'store1' AS store,
    p1.store1 AS price
FROM Products p1
WHERE p1.store1 IS NOT NULL

UNION

SELECT
    p2.product_id,
    'store2' AS store,
    p2.store2 AS price
FROM Products p2
WHERE p2.store2 IS NOT NULL

UNION

SELECT
    p3.product_id,
    'store3' AS store,
    p3.store3 AS price
FROM Products p3
WHERE p3.store3 IS NOT NULL;




----------------------------------------------------------
-- 1693 Daily Leads and Partners
----------------------------------------------------------
-- For each date_id and make_name, find the number of distinct lead_id's and distinct partner_id's.
SELECT
    date_id,
    make_name,
    COUNT(DISTINCT lead_id) AS unique_leads,
    COUNT(DISTINCT partner_id) AS unique_partners
FROM DailySales
GROUP BY date_id, make_name;



----------------------------------------------------------
-- 1965 employees with missing information
----------------------------------------------------------
-- Write a solution to report the IDs of all the employees with missing information.
-- MySQL does not support full outer join
-- UNION: Removes duplicate rows from the final result set.	
-- UNION ALL: Retains all duplicate rows, including those from different tables.
SELECT
    e.employee_id
FROM Employees e
LEFT JOIN Salaries s ON s.employee_id = e.employee_id
WHERE s.salary IS NULL

UNION ALL

SELECT
    s.employee_id
FROM Salaries s
LEFT JOIN Employees e ON e.employee_id = s.employee_id
WHERE e.employee_id IS NULL

ORDER BY employee_id;



----------------------------------------------------------
-- 1587 bank account summary II
----------------------------------------------------------
-- Write a solution to report the name and balance of users with a balance higher than 10000. 
-- The balance of an account is equal to the sum of the amounts of all transactions involving that account.
SELECT
    u.name,
    SUM(t.amount) AS balance
FROM Transactions t
LEFT JOIN Users u ON u.account = t.account
GROUP BY t.account
HAVING balance > 10000;



----------------------------------------------------------
-- 586 customer placing the largest number of orders
----------------------------------------------------------
--Write a solution to find the customer_number for the customer who has placed the largest number of orders.
SELECT
    customer_number
FROM Orders
GROUP BY customer_number
HAVING COUNT(order_number) = (SELECT MAX(order_count) FROM (
    SELECT
    customer_number,
    COUNT(order_number) AS order_count
FROM Orders
GROUP BY customer_number
    ) a 
);

-- alternative solution
WITH customer_order_count AS (SELECT
    customer_number,
    COUNT(order_number) AS order_count
FROM Orders
GROUP BY customer_number
)

SELECT
    customer_number
FROM customer_order_count
WHERE order_count = (SELECT MAX(order_count) FROM customer_order_count);



----------------------------------------------------------
-- 596 classes more than 5 students
----------------------------------------------------------
-- Write a solution to find all the classes that have at least five students.
SELECT
    class
FROM Courses
GROUP BY class
HAVING COUNT(student) >= 5;



----------------------------------------------------------
-- 1729 find followers count
----------------------------------------------------------
-- Write a solution that will, for each user, return the number of followers.
SELECT
    user_id,
    COUNT(follower_id) AS followers_count
FROM Followers
GROUP BY user_id
ORDER BY user_id;



----------------------------------------------------------
-- 601 human traffic of stadium
----------------------------------------------------------
-- Write a solution to display the records with three or more rows with consecutive id's, 
-- and the number of people is greater than or equal to 100 for each.
SELECT
    s1.id,
    s1.visit_date,
    s1.people
    --s2.people AS people_offset_neg1,
    --s3.people AS people_offset_neg2,
    --s4.people AS people_offset_pos1,
    --s5.people AS people_offset_pos2

FROM Stadium s1
LEFT JOIN Stadium s2 ON s1.id = (s2.id + 1)
LEFT JOIN Stadium s3 ON s1.id = (s3.id + 2)
LEFT JOIN Stadium s4 ON s1.id = (s4.id - 1)
LEFT JOIN Stadium s5 ON s1.id = (s5.id - 2)

WHERE
    (s1.people >= 100 AND s2.people>= 100 AND s3.people >= 100)
    OR (s1.people >= 100 AND s2.people >= 100 AND s4.people >= 100)
    OR (s1.people >= 100 AND s4.people >= 100 AND s5.people >= 100)
    
ORDER BY s1.visit_date;




----------------------------------------------------------
-- 1484 group sold products by the date
----------------------------------------------------------
-- Write a solution to find for each date the number of different products sold and their names
SELECT
    sell_date,
    COUNT(DISTINCT product) AS num_sold,
    GROUP_CONCAT(DISTINCT product ORDER BY product SEPARATOR ',') AS products
FROM Activities
GROUP BY sell_date
ORDER BY sell_date;




----------------------------------------------------------
-- 1141 user activity for the past 30 days I
----------------------------------------------------------
-- Write a solution to find the daily active user count for a period of 30 days ending 2019-07-27 inclusively. 
-- A user was active on someday if they made at least one activity on that day.
SELECT
    activity_date AS day,
    COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date BETWEEN ("2019-07-27" - INTERVAL 29 DAY) AND "2019-07-27"
GROUP BY activity_date
HAVING COUNT(DISTINCT user_id) > 0;




----------------------------------------------------------
-- 607 Sales person
----------------------------------------------------------
-- Write a solution to find the names of all the salespersons 
-- who did not have any orders related to the company with the name "RED".
WITH sales_red AS (
    SELECT
        o.sales_id,
        o.com_id,
        c.name
    FROM Orders o
    LEFT JOIN Company c ON c.com_id = o.com_id
    WHERE c.name = 'RED'
)

SELECT
    sp.name
FROM SalesPerson sp
WHERE sp.sales_id NOT IN (SELECT sales_id FROM sales_red);




----------------------------------------------------------
-- 608 tree node
----------------------------------------------------------
-- Write a solution to report the type of each node in the tree.
WITH tree_nest AS (
    SELECT
        t1.id,
        t1.p_id,
        t2.p_id AS pp_id,
        t3.id AS c_id
    FROM Tree t1
    LEFT JOIN Tree t2 ON t1.p_id = t2.id
    LEFT JOIN Tree t3 ON t1.id = t3.p_id
)

SELECT DISTINCT id, type
FROM (
    SELECT
        id,
        CASE
            WHEN p_id IS NULL THEN "Root"
            WHEN p_id IS NOT NULL AND c_id IS NULL THEN "Leaf"
            WHEN p_id IS NOT NULL AND c_id IS NOT NULL THEN "Inner"
            ELSE "Other"
        END AS type
    FROM tree_nest
) tree_type;




----------------------------------------------------------
-- 1741 find total time spent by each employee
----------------------------------------------------------
-- Write a solution to calculate the total time in minutes spent by each employee on each day at the office. 
-- Note that within one day, an employee can enter and leave more than once. 
-- The time spent in the office for a single entry is out_time - in_time.
SELECT
    event_day AS day,
    emp_id,
    SUM(out_time - in_time) AS total_time
FROM Employees
GROUP BY emp_id, event_day;




----------------------------------------------------------
-- 1873 calculate special bonus
----------------------------------------------------------
-- Write a solution to calculate the bonus of each employee. 
-- The bonus of an employee is 100% of their salary if the ID of the employee is an odd number 
-- and the employee's name does not start with the character 'M'. The bonus of an employee is 0 otherwise.
SELECT
    employee_id,
    CASE 
        WHEN employee_id % 2 = 1 AND name NOT LIKE 'M%' THEN salary
        ELSE 0
    END AS bonus
FROM Employees
ORDER BY employee_id;




----------------------------------------------------------
-- 620 not Boring Movies
----------------------------------------------------------
-- Write a solution to report the movies with an odd-numbered ID and a description that is not "boring".
SELECT
    *
FROM Cinema
WHERE 
    id % 2 = 1 
    AND description != 'boring'
ORDER BY rating DESC;




----------------------------------------------------------
-- 1050 actors and directors who cooperated at least three times
----------------------------------------------------------
-- Write a solution to find all the pairs (actor_id, director_id) 
-- where the actor has cooperated with the director at least three times.
SELECT
    actor_id,
    director_id
    -- COUNT(timestamp) AS coop_count
FROM ActorDirector
GROUP BY actor_id, director_id
HAVING COUNT(timestamp) >= 3;




----------------------------------------------------------
-- 626 exchange seats
----------------------------------------------------------
-- Write a solution to swap the seat id of every two consecutive students. 
-- If the number of students is odd, the id of the last student is not swapped.
WITH seat_swap AS (
    SELECT
        s1.id,
        s1.student AS current_student,
        s2.id AS next_seat_id,
        s2.student AS next_student,
        s3.id AS previous_seat_id,
        s3.student AS previous_student
    FROM Seat s1
    LEFT JOIN Seat s2 ON s1.id = s2.id - 1
    LEFT JOIN Seat s3 ON s1.id = s3.id + 1
)

SELECT
    id,
    CASE
        WHEN id % 2 = 1 AND next_student IS NOT NULL THEN next_student
        WHEN id % 2 = 0 THEN previous_student
        ELSE current_student
    END AS student
FROM seat_swap;




