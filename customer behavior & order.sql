-- ***************************TOTAL CUSTOMERS **********************************--  

 SELECT 
    COUNT(*) AS TotalCustomers
FROM
    customers

-- *********************************** First purchase date of each customer****************************************-- 
SELECT 
    customerID, MIN(orderdate) AS first_purchase_date
FROM
    orders
GROUP BY customerid;

-- ***********************Returning vs New Customers per month*******************************

with firstpurchase as
(select customerID, min(orderdate) as first_purchase_date
from orders
group by customerid)
select 
orders.OrderDate,
case
WHEN orders.OrderDate = fp.first_purchase_date THEN  " new customer"
ELSE "RETURN  CUSTOMER"
END AS customer_type
from orders
join firstpurchase fp on orders.CustomerID = fp.customerid;


-- **************************************Customer lifetime value (LTV)**********************************************-- 
SELECT 
    orders.CustomerID,
    SUM(orders.OrderAmount) AS customer_lifetime_value
FROM
    orders
GROUP BY CustomerID;

-- Frequency of purchases per customer-- 
select orders.CustomerID,count(*) as purchase_count from orders
group by CustomerID;

-- **************************8 Top 10 customers by order count******************************-- 

SELECT 
    orders.CustomerID, COUNT(*) AS purchase_count
FROM
    orders
GROUP BY CustomerID
ORDER BY purchase_count DESC
LIMIT 10;

-- ************************ Customer orders count greater than 10 items*****************************

select orders.CustomerID,count(*) as purchase_count from orders
group by CustomerID
having purchase_count > "5";

-- *****************************Order counts in a time window (e.g., last 30 days)*******************************-- 

select orders.CustomerID,count(*) as purchase_count from orders
where date_sub(curdate() ,interval 30 day)
group by CustomerID;

-- **********************Total revenue by customer*********************************-- 

SELECT 
    customers.CustomerName,
    SUM(orderdetails.Quantity * orderdetails.Price) AS TotalRevenue
FROM
    customers
        INNER JOIN
    orders ON customers.CustomerID = orders.CustomerID
        INNER JOIN
    orderdetails ON orders.OrderID = orderdetails.OrderID
GROUP BY customers.CustomerName;

-- ********************************Find customers who rated a product they purchased*************************************-- 

SELECT 
    customers.CustomerName,
    ratings_shortdate.ProductName,
    ratings_shortdate.Rating
FROM
    ratings_shortdate
        INNER JOIN
    customers ON ratings_shortdate.CustomerID = customers.CustomerID
        INNER JOIN
    orderdetails ON orderdetails.ProductName = ratings_shortdate.ProductName;


-- ***********************************Orders placed after customer's first purchase date******************************************-- 

SELECT 
    orders.OrderID, orders.OrderDate, customers.CustomerName
FROM
    orders
        INNER JOIN
    (SELECT 
        customerID, MIN(orderdate) AS first_purchase_date
    FROM
        orders
    GROUP BY customerid) fp ON orders.CustomerID = fp.CustomerID
        INNER JOIN
    customers ON customers.CustomerID = orders.CustomerID
WHERE
    orders.OrderDate > fp.first_purchase_date;

-- create a table for products-- 

create table products as 
select distinct orderdetails.ProductName from orderdetails;

-- ********************************find the highest sale done by which product products *************************************** -- 

SELECT 
    productName, SUM(quantity * Price) AS total_sales
FROM
    orderdetails
GROUP BY productName
ORDER BY total_sales DESC
LIMIT 1;

-- *********************************average order value*******************************
select avg(orderamount) as avg_order_value
from orders;

-- **************** Total revenue ***********
SELECT SUM(quantity * price) AS TotalRevenue
FROM OrderDetails;

-- ********************* find the top 5 city which make a highest orders ***************************

select customers.City ,count(orders.OrderID) as highest_order
from customers
inner join orders on customers.CustomerID = orders.CustomerID
group by customers.City 
order by highest_order desc limit 5; 