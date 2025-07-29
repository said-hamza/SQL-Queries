create table Books(
	Book_Id	serial primary key,
	Title  varchar(100) ,
	Author varchar(100),
	Genre  varchar(50),
	Published_year int,
	price numeric(10,2),
	stock int);

CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150));

CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2));

select * from Books;
select * from Customers;
select * from Orders;

copy Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
from 'D:/learning material/SQL/sql by satish dhawale/All Excel Practice Files/Books.csv'
csv header;

COPY Customers(Customer_ID, Name, Email, Phone, City, Country) 
FROM  'D:\learning material\SQL\sql by satish dhawale\All Excel Practice Files\Customers.csv'
CSV HEADER;

COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount) 
FROM  'D:\learning material\SQL\sql by satish dhawale\All Excel Practice Files\Orders.csv'
CSV HEADER;

select * from Books;
select * from Customers;
select * from Orders;

-- 1) Retrieve all books in the "Fiction" genre:

select * from Books
where Genre = 'Fiction';

select * from Books
where Genre is not distinct from 'Fiction';

-- 2) Find books published after the year 1950:
SELECT * FROM Books 
WHERE Published_year>1950;

-- 3) List all customers from the Canada:
select * from Customers
where country is not distinct from 'Canada';

select * from Customers
where country = 'Canada';

select * from Customers
where country ilike 'canada';

-- 4) Show orders placed in November 2023:
select * from Orders
where order_date between '2023-11-01' and '2023-11-30';

select * from Orders
where extract (month from order_date) = 11;

select * from orders
where date_trunc('month',order_date) =date'2023-11-01';

-- 5) Retrieve the total stock of books available:

select sum(Stock) as total_stock
from Books;

-- 6) Find the details of the most expensive book:

select * from Books 
order by price desc
limit 1;

select max(price) as exp_book
from Books;

select * from Books 
where price =(select max(price) from books);

-- 7) Show all customers who ordered more than 1 quantity of a book:

SELECT * FROM Orders 
WHERE quantity>1;

SELECT o.Customer_id,c.name,o.quantity
FROM Orders o 
join Customers c
on o.customer_id = c.customer_id
where quantity>1 order by quantity asc;

-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT * FROM Orders 
WHERE total_amount>20 and total_amount<30
order by total_amount asc;

-- 9) List all genres available in the Books table:
select distinct on(genre) * from Books;

SELECT DISTINCT genre FROM Books;

select genre, min(published_year) as published_year
from Books
group by genre;

-- 10) Find the book with the lowest stock:
select * from books 
order by stock
limit 1;

select min(stock) as min_stock
from books;

select * from books
where stock=(select min(stock) from books);

-- 11) Calculate the total revenue generated from all orders:
select sum(total_amount) as revenue
From orders;

-- 1) Retrieve the total number of books sold for each genre:
select b.genre, sum(o.quantity) as total_sales
from orders o
join books b on o.book_id=b.book_id
group by b.genre;

-- 2) Find the average price of books in the "Fantasy" genre:
select avg(price) as average_price
from Books
where genre in ('Fantasy');

-- 3) List customers who have placed at least 2 orders:
select o.customer_id, count(o.order_id) as order_count,c.name
FROM orders o
join customers c
on o.customer_id = c.customer_id
group by o.customer_id, c.name
having count(o.order_id) >=2 
order by o.customer_id;

-- 4) Find the most frequently ordered book or books;
select book_id, count(order_id) as order_count
from orders 
group by book_id
having count(order_id) = (select max(order_count)
						  from
                         (select count(order_id) as order_count
						 from orders 
						 group by book_id) 
						 );

select book_id, count(order_id) as order_count
from orders 
group by book_id
order by order_count desc
limit 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT book_id,genre,price FROM books
WHERE genre ='Fantasy'
ORDER BY price DESC LIMIT 3;


-- 6) Retrieve the total quantity of books sold by each author:
select distinct b.author, sum(o.quantity) as total_books_sold
from orders o
join books b 
on o.book_id = b.book_id
group by b.author;


-- 7) List the cities where customers who spent over $30 are located:
select distinct c.city, o.total_amount
from orders o
join customers c
on o.customer_id=c.customer_id
where o.total_amount > 470;

-- 8) Find the customer who spent the most on orders:
select c.customer_id, c.name, sum(o.total_amount) as total_spent
from orders o
join customers c on c.customer_id=o.customer_id
group by c.customer_id, c.name
order by total_spent desc limit 1;

--9) Calculate the stock remaining after fulfilling all orders:
select b.book_id, b.title, b.stock, coalesce(sum(o.quantity),0) as order_quantity,
						   b.stock -  coalesce(sum(o.quantity),0) as remaining_stock

from books b
left join orders o 
on b.book_id=o.book_id
group by b.book_id
order by b.book_id;


select datname from pg_database;












































