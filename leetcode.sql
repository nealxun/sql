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




----------------------------------------------------------
-- 627 Swap sex of employees
----------------------------------------------------------
-- Write a solution to swap all 'f' and 'm' values 
-- (i.e., change all 'f' values to 'm' and vice versa) with a single update statement and no intermediate temporary tables.
-- Note that you must write a single update statement, do not write any select statement for this problem.
UPDATE Salary
SET
    sex = CASE
            WHEN sex = 'm' THEN 'f'
            WHEN sex = 'f' THEN 'm'
          END;




----------------------------------------------------------
-- 1158 Market analysis I
----------------------------------------------------------
-- Write a solution to find for each user, the join date and the number of orders they made as a buyer in 2019.
SELECT
    u.user_id AS buyer_id,
    u.join_date,
    -- o.order_id,
    COUNT(o.order_id) AS orders_in_2019
FROM Users u
LEFT JOIN Orders o ON u.user_id = o.buyer_id AND EXTRACT(year FROM o.order_date) = '2019'
GROUP BY u.user_id, u.join_date




----------------------------------------------------------
-- 1393 capital gain/loss
----------------------------------------------------------
-- Write a solution to report the Capital gain/loss for each stock.
-- The Capital gain/loss of a stock is the total gain or loss after buying and selling the stock one or many times.
WITH stock_gain_loss AS (
    SELECT
        stock_name,
        operation,
        operation_day,
        price,
        CASE
            WHEN operation = 'Buy' THEN -price
            WHEN operation = 'Sell' THEN price
            ELSE 0
        END AS gain_loss
    FROM Stocks
)

SELECT
    stock_name,
    SUM(gain_loss) AS capital_gain_loss
FROM stock_gain_loss
GROUP BY stock_name;

-- alternative solution
SELECT
    stock_name,
    SUM(CASE
            WHEN operation = 'Buy' THEN -price
            WHEN operation = 'Sell' THEN price
            ELSE 0
        END) AS capital_gain_loss
FROM Stocks
GROUP BY stock_name;




----------------------------------------------------------
-- 1890 The Latest Login in 2020
----------------------------------------------------------
-- Write a solution to report the latest login for all users in the year 2020. Do not include the users who did not login in 2020.
SELECT
    user_id,
    MAX(time_stamp) AS last_stamp
FROM Logins
WHERE EXTRACT(year FROM time_stamp) = '2020'
GROUP BY user_id;




----------------------------------------------------------
-- 577 employee bonus
----------------------------------------------------------
SELECT
    e.name,
    b.bonus
FROM Employee e
LEFT JOIN Bonus b ON e.empId = b.empId
WHERE b.bonus < 1000 OR b.bonus IS NULL;




----------------------------------------------------------
-- 570 Manager with the least 5 direct reports
----------------------------------------------------------
-- Write a solution to find managers with at least five direct reports.
WITH employee_with_direct_report AS (
    SELECT
        e1.id,
        e1.name,
        e2.id AS direct_report
    FROM Employee e1
    LEFT JOIN Employee e2 ON e1.id = e2.managerId
)

SELECT
    --id,
    name
    --COUNT(direct_report) AS num_direct_report
FROM employee_with_direct_report
GROUP BY id
HAVING COUNT(direct_report) >= 5;




----------------------------------------------------------
-- 550 game play analysis IV
----------------------------------------------------------
-- Write a solution to report the fraction of players that logged in again on the day after the day they first logged in, 
-- rounded to 2 decimal places. In other words, you need to determine the number of players 
-- who logged in on the day immediately following their initial login, and divide it by the number of total players.
WITH first_login AS (
    SELECT
        player_id,
        MIN(event_date) AS first_login_date
    FROM Activity
    GROUP BY player_id
),

next_day_login AS (
    SELECT
        fl.player_id
    FROM first_login fl
    JOIN Activity a ON a.player_id = fl.player_id 
        AND a.event_date = DATE_ADD(fl.first_login_date, INTERVAL 1 DAY)
)

SELECT
    ROUND(COUNT(DISTINCT ndl.player_id) / COUNT(DISTINCT fl.player_id), 2) AS fraction
FROM first_login fl
LEFT JOIN next_day_login ndl ON fl.player_id = ndl.player_id;




----------------------------------------------------------
-- 585 investment in 2016
----------------------------------------------------------
-- Write a solution to report the sum of all total investment values in 2016 tiv_2016, for all policyholders who:
-- have the same tiv_2015 value as one or more other policyholders, and
-- are not located in the same city as any other policyholder (i.e., the (lat, lon) attribute pairs must be unique).
WITH same_tiv_2015 AS (
    SELECT
        tiv_2015
    FROM Insurance
    GROUP BY tiv_2015
    HAVING COUNT(pid) > 1
),

distinct_city AS (
    SELECT
        concat(lat, "-", lon) AS location
    FROM Insurance
    GROUP BY lat, lon
    HAVING COUNT(pid) = 1
)

SELECT
    ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM Insurance
WHERE
    tiv_2015 IN (SELECT * FROM same_tiv_2015)
    AND concat(lat, "-", lon) IN (SELECT * FROM distinct_city);




----------------------------------------------------------
-- 602 Friend Requests II: Who Has the Most Friends
----------------------------------------------------------
-- Write a solution to find the people who have the most friends and the most friends number.
WITH ra_comb AS (
    SELECT
        ra1.requester_id AS r_id,
        ra1.accepter_id AS a_id
    FROM RequestAccepted ra1

    UNION ALL

    SELECT
        ra2.accepter_id AS r_id,
        ra2.requester_id AS a_id
    FROM RequestAccepted ra2
)

SELECT
    r_id AS id,
    COUNT(a_id) AS num
FROM
    ra_comb
GROUP BY r_id
ORDER BY COUNT(a_id) DESC
LIMIT 1;




----------------------------------------------------------
-- 610 triangle judgement
----------------------------------------------------------
-- Report for every three line segments whether they can form a triangle.
SELECT
    x,
    y,
    z,
    
    CASE
        WHEN x + y > z AND x + z > y AND y + z > x THEN "Yes"
        ELSE "No"
    END AS triangle

FROM Triangle;




----------------------------------------------------------
-- 619 biggest single number
----------------------------------------------------------
-- Find the largest single number. If there is no single number, report null.
WITH single_num AS (
    SELECT
        num,
        COUNT(num) AS cnt
    FROM MyNumbers
    GROUP BY num
    HAVING COUNT(num) = 1
)

SELECT
    MAX(num) AS num
FROM single_num;




----------------------------------------------------------
-- 1045 customers who brought all products
----------------------------------------------------------
-- Write a solution to report the customer ids from the Customer table that bought all the products in the Product table.
SELECT
    c.customer_id
    -- COUNT(DISTINCT product_key) AS unique_prod_cnt

FROM Customer c
GROUP BY c.customer_id
HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(product_key) FROM Product);



----------------------------------------------------------
-- 1070 product sales analysis III
----------------------------------------------------------
-- Write a solution to find all sales that occurred in the first year each product was sold.
-- For each product_id, identify the earliest year it appears in the Sales table.
-- Return all sales entries for that product in that year.
WITH product_first_year AS (
    SELECT
        product_id,
        min(year) AS first_sales_year
    FROM Sales
    GROUP BY product_id
)

SELECT
    s.product_id,
    pfy.first_sales_year AS first_year,
    s.quantity,
    s.price
FROM Sales s
INNER JOIN product_first_year pfy ON s.product_id = pfy.product_id AND s.year = pfy.first_sales_year;




----------------------------------------------------------
-- 1075 project employees I
----------------------------------------------------------
-- Write an SQL query that reports the average experience years of all the employees for each project, rounded to 2 digits.
SELECT
    p.project_id,
    ROUND(AVG(e.experience_years), 2) AS average_years
FROM Project p
LEFT JOIN Employee e ON p.employee_id = e.employee_id
GROUP BY p.project_id;




----------------------------------------------------------
-- 1164 product price at a given date
----------------------------------------------------------
-- Write a solution to find the prices of all products on the date 2019-08-16.
WITH price_given_date AS (
    SELECT
        product_id,
        max(change_date) AS latest_change_date
    FROM Products
    WHERE change_date <= "2019-08-16"
    GROUP BY product_id
),

product_with_price_change AS (
    SELECT
        p.product_id,
        p.new_price AS price
    FROM Products p 
    INNER JOIN price_given_date pgd ON p.product_id = pgd.product_id AND p.change_date = pgd.latest_change_date
),

product_without_change AS (
    SELECT
        DISTINCT p.product_id,
        10 AS price
    FROM Products p 
    WHERE p.product_id NOT IN (SELECT product_id FROM price_given_date)
)

SELECT * FROM product_with_price_change
UNION
SELECT * FROM product_without_change;



----------------------------------------------------------
-- 1174 immediate food delivery II
----------------------------------------------------------
-- Write a solution to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places.
WITH first_order AS (
    SELECT
        customer_id,
        min(order_date) AS first_order_date
    FROM Delivery
    GROUP BY customer_id
),

first_order_type AS (
    SELECT
        d.delivery_id,
        d.customer_id,
        CASE
            WHEN d.order_date = d.customer_pref_delivery_date THEN "immediate"
            ELSE "scheduled"
        END AS order_type
    FROM Delivery d
    INNER JOIN first_order fo ON d.customer_id = fo.customer_id AND d.order_date = fo.first_order_date
)

SELECT
    ROUND(SUM(CASE WHEN order_type = "immediate" THEN 1 ELSE 0 END) / COUNT(delivery_id) * 100, 2) AS immediate_percentage
FROM first_order_type;




----------------------------------------------------------
-- 1193 monthly transactions I
----------------------------------------------------------
-- Write an SQL query to find for each month and country, the number of transactions and their total amount,
-- the number of approved transactions and their total amount.
SELECT
    SUBSTRING(trans_date, 1, 7) AS month,
    country,
    COUNT(id) AS trans_count,
    COUNT(CASE WHEN state = 'approved' THEN id ELSE NULL END) AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY SUBSTRING(trans_date, 1, 7), country;




----------------------------------------------------------
-- 1204 last person to fit in the bus
----------------------------------------------------------
-- Write a solution to find the person_name of the last person that can 
-- fit on the bus without exceeding the weight limit. The test cases are generated 
-- such that the first person does not exceed the weight limit.
WITH cum_weight AS (
    SELECT
        turn,
        person_id,
        person_name,
        weight,
        SUM(weight) OVER (ORDER BY turn) AS total_weight
    FROM Queue
    ORDER BY turn
)

SELECT person_name 
FROM cum_weight 
WHERE total_weight <= 1000
ORDER BY turn DESC
LIMIT 1;




----------------------------------------------------------
-- 1211 queries quality and percentages
----------------------------------------------------------
-- Write a solution to find each query_name, the quality and poor_query_percentage.
-- Both quality and poor_query_percentage should be rounded to 2 decimal places.
SELECT
    query_name,
    ROUND(AVG(rating/position), 2) AS quality,
    ROUND(SUM(CASE WHEN rating < 3 THEN 1 ELSE 0 END) / COUNT(query_name) * 100, 2) AS poor_query_percentage
FROM Queries
GROUP BY query_name;




----------------------------------------------------------
-- 1251 average selling price
----------------------------------------------------------
-- Write a solution to find the average selling price of each product.
WITH product AS (
    SELECT DISTINCT product_id FROM Prices
), 

product_sell_price AS (
    SELECT
        p.product_id,
        ROUND(SUM(u.units * pr.price) / SUM(u.units), 2) AS average_price0
    FROM product p
    LEFT JOIN UnitsSold u ON p.product_id = u.product_id
    LEFT JOIN Prices pr ON u.product_id = pr.product_id AND u.purchase_date >= pr.start_date AND u.purchase_date <= pr.end_date
    GROUP BY p.product_id
)

SELECT
    product_id,
    CASE WHEN average_price0 IS NULL THEN 0 ELSE average_price0 END AS average_price
FROM product_sell_price;




----------------------------------------------------------
-- 1280 students and examinations
----------------------------------------------------------
WITH attended_exam AS (
    SELECT
        e.student_id,
        s.student_name,
        e.subject_name,
        CONCAT(e.student_id, e.subject_name) AS id_subject,
        COUNT(*) AS attended_exams

    FROM Examinations e
    LEFT JOIN Students s ON e.student_id = s.student_id
    GROUP BY 1,2,3,4
),

student_subject AS (
    SELECT
        st.student_id,
        st.student_name,
        su.subject_name,
        CONCAT(st.student_id, su.subject_name) AS id_subject,
        0 AS attended_exams
    FROM Students st
    JOIN Subjects su ON 1 = 1
)

SELECT
    ss.student_id,
    ss.student_name,
    ss.subject_name,
    CASE WHEN ae.attended_exams IS NULL THEN 0 ELSE ae.attended_exams END AS attended_exams
FROM student_subject ss
LEFT JOIN attended_exam ae ON ss.id_subject = ae.id_subject
ORDER BY ss.student_id, ss.subject_name;




----------------------------------------------------------
-- 1321 restaurant growth
----------------------------------------------------------
WITH unique_visit AS (
    SELECT
        visited_on,
        SUM(amount) AS amount
    FROM Customer
    GROUP BY visited_on
)

SELECT
    c1.visited_on,
    SUM(c2.amount) AS amount,
    ROUND(AVG(c2.amount), 2) AS average_amount
FROM unique_visit c1
--LEFT JOIN unique_visit c2 ON c1.visited_on <= c2.visited_on + 6 AND c1.visited_on >= c2.visited_on
LEFT JOIN unique_visit c2 ON DATEDIFF(c1.visited_on, c2.visited_on) BETWEEN 0 and 6
WHERE c1.visited_on >= DATE_ADD((SELECT MIN(visited_on) FROM Customer), INTERVAL 6 DAY)
GROUP BY 1
ORDER BY c1.visited_on;




----------------------------------------------------------
-- 1327 list the products ordered in a period
----------------------------------------------------------
SELECT
    p.product_name,
    SUM(o.unit) AS unit

FROM Orders o
LEFT JOIN Products p ON o.product_id = p.product_id
#WHERE YEAR(o.order_date) = 2020 AND MONTH(o.order_date) = 2
GROUP BY p.product_name
HAVING SUM(o.unit) >= 100;




----------------------------------------------------------
-- 1341 movie rating
----------------------------------------------------------
# Write your MySQL query statement below
WITH user_rating AS (
    SELECT
        u.user_id,
        u.name,
        COUNT(DISTINCT mr.movie_id) AS cnt_movie_rated
    FROM Users u
    LEFT JOIN MovieRating mr ON u.user_id = mr.user_id
    GROUP BY 1,2
    ORDER BY COUNT(DISTINCT mr.movie_id) DESC, u.name
    LIMIT 1

),

movie_rating AS (
    SELECT
        m.movie_id,
        m.title,
        AVG(rating) AS avg_rating
    FROM Movies m
    LEFT JOIN MovieRating mr ON m.movie_id = mr.movie_id
    WHERE YEAR(mr.created_at) = 2020 AND MONTH(mr.created_at) = 2
    GROUP BY 1,2
    ORDER BY AVG(rating) DESC, m.title
    LIMIT 1
)

SELECT name AS results FROM user_rating
UNION ALL
SELECT title AS results FROM movie_rating;




----------------------------------------------------------
-- 1517 find users with valid e-mails
----------------------------------------------------------
SELECT *
FROM Users
WHERE REGEXP_LIKE(mail, '^[a-z][a-zA-Z0-9_.-]*@leetcode\\.com$', 'c');












