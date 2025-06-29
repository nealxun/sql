-- SQL samples in w3school.com SQL tutorial

-- find which customer orders most

select customerID, count(*) from orders
group by customerID
order by count(*) DESC;

select orders.customerID, count(*), cu.customername
from orders
join customers as cu
on cu.customerID = orders.customerID
group by orders.customerID
order by count(*) DESC;


-- find the most popular product
select orderdetails.productID, sum(quantity), products.productname
from orderdetails
join products on products.productID = orderdetails.productID
group by orderdetails.productID
order by sum(quantity) desc;