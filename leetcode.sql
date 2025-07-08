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
-- NULL ones also needs to be returned, NULL != 2 will return NULL.
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
