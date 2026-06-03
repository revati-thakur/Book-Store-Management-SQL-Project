
-- Create Database onlineBookstore
CREATE DATABASE onlineBookstore;

use onlineBookstore;
-- Create Tables
DROP TABLE IF EXISTS Books;


select * from onlinebookstore.orders;

alter table onlinebookstore.orders
rename to orders;

select * from orders;

CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10 , 2 ),
    Stock INT
);

DROP TABLE IF EXISTS customers;
CREATE TABLE Customer (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);


-- 1) Retrieve all books in the "Fiction" genre:

SELECT 
    *
FROM
    Books
WHERE
    Genre = 'Fiction';

-- 2) Find books published after the year 1950:

SELECT 
    *
FROM
    Books
WHERE
    Published_year > 1950;

-- 3) List all customers from the Canada:
SELECT 
    *
FROM
    Customers
WHERE
    country = 'Canada';

-- 4) Show orders placed in November 2023:

SELECT 
    *
FROM
    Orders
WHERE
    order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- - 5) Retrieve the total stock of books available:

SELECT SUM(stock) AS Total_Stock
From Books;

-- 6) Find the details of the most expensive book:
SELECT * FROM Books 
ORDER BY Price DESC 
LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT * FROM Orders 
WHERE quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT * FROM Orders 
WHERE total_amount>20;

-- 9) List all genres available in the Books table:
SELECT DISTINCT genre FROM Books;

-- 10) Find the book with the lowest stock:
SELECT * FROM Books 
ORDER BY stock 
LIMIT 1;

-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(total_amount) As Revenue 
FROM Orders;



-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:

select b.Genre, sum(o.Quantity) as Total_book_sold
from orders o
join books b on 
o.book_id=b.book_id
group by Genre;

-- 2) Find the average price of books in the "Fantasy" genre:
select avg(price) as average_price 
from books
where Genre = 'Fantasy';

select * from customers;

-- 3) List customers who have placed at least 2 orders:

select o.customer_id,c.Name, count(o.order_id) as ORDER_COUNT
from orders o join
customers c on
o.Customer_ID=c.Customer_ID
group by o.Customer_ID , c.Name
having count(o.order_id)>=2;

-- 4) Find the most frequently ordered book:

select o.Book_ID,b.title,count(o.order_id) as most_frequently_ordered_book
from orders o join books b on
o.book_id=b.book_id
group by o.Book_ID,b.title
order by most_frequently_ordered_book Desc
limit 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :

select * from books
where genre = "Fantasy"
order by  Price desc 
limit 3;

-- 6) Retrieve the total quantity of books sold by each author:

SELECT b.author, SUM(o.quantity) AS Total_Books_Sold
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY b.Author;


-- book order by each customer

select c.Name,count(o.order_id) as total_order_each_customer
from customers c join orders o on
c.Customer_ID=o.Customer_ID
group by c.Name;

-- 7) List the cities where customers who spent over $30 are located:
select c.City,o.Total_Amount 
from customers c join orders o on
o.customer_id= c.customer_id
where o.Total_Amount > 30; 

-- 8) Find the customer who spent the most on orders:
select c.customer_id,c.Name,sum(o.Total_Amount) as Total_spent
from customers c join orders o 
on o.customer_ID=c.customer_ID
group by c.customer_id,c.Name
order by Total_spent desc
limit 1;

-- 9) Calculate the stock remaining after fulfilling all orders:

SELECT 
    b.book_id,
    b.title,
    b.stock,
    COALESCE(SUM(o.quantity), 0) AS Order_quantity,
    b.stock - COALESCE(SUM(o.quantity), 0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o
    ON b.book_id = o.book_id
GROUP BY 
    b.book_id,
    b.title,
    b.stock
ORDER BY 
    b.book_id;
    