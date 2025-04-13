-- 1. Get all books and their authors
-- This query retrieves the title of each book along with the full name of its author(s).
-- It uses a JOIN between the `book`, `book_author`, and `author` tables to establish the relationship between books and their authors.
SELECT b.title, CONCAT(a.first_name, ' ', a.last_name) AS author
FROM book b
JOIN book_author ba ON b.book_id = ba.book_id  -- Links books to their authors
JOIN author a ON ba.author_id = a.author_id;  -- Retrieves author details

-- 2. Find all customers and their current addresses
-- This query retrieves the full name of each customer along with their current address details.
-- It joins the `customer`, `customer_address`, `address`, `address_status`, and `country` tables to fetch the required information.
SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer,  -- Full name of the customer
       a.street, a.city, a.state, co.country_name          -- Address details
FROM customer c
JOIN customer_address ca ON c.customer_id = ca.customer_id  -- Links customers to their addresses
JOIN address a ON ca.address_id = a.address_id              -- Retrieves address details
JOIN address_status s ON ca.status_id = s.status_id         -- Filters by address status
JOIN country co ON a.country_id = co.country_id             -- Retrieves country details
WHERE s.status_name = 'Current';                            -- Only include current addresses

-- 3. Show all orders with total amount and shipping method
-- This query retrieves all orders, including the total amount, shipping method, and order date.
-- It joins the `cust_order`, `customer`, and `shipping_method` tables to fetch the required details.
SELECT o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer,  -- Order ID and customer name
       o.total_amount, s.method_name AS shipping_method, o.order_date  -- Order details
FROM cust_order o
JOIN customer c ON o.customer_id = c.customer_id            -- Links orders to customers
JOIN shipping_method s ON o.shipping_method_id = s.shipping_method_id;  -- Retrieves shipping method details

-- 4. List the books in each customer’s order
-- This query retrieves the details of books in each customer's order, including the quantity and price.
-- It joins the `order_line`, `cust_order`, `customer`, and `book` tables to fetch the required information.
SELECT o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer,  -- Order ID and customer name
       b.title, ol.quantity, ol.price                                  -- Book details and order line info
FROM order_line ol
JOIN cust_order o ON ol.order_id = o.order_id            -- Links order lines to orders
JOIN customer c ON o.customer_id = c.customer_id         -- Links orders to customers
JOIN book b ON ol.book_id = b.book_id;                   -- Retrieves book details

-- 5. Track the order history and its current status
-- This query retrieves the history of all orders, including their status, update time, and any notes.
-- It joins the `order_history` and `order_status` tables to fetch the required details.
SELECT oh.order_id, os.status_name, oh.update_time, oh.note  -- Order history details
FROM order_history oh
JOIN order_status os ON oh.status_id = os.status_id          -- Links order history to status
ORDER BY oh.update_time DESC;                                -- Orders by the most recent update

-- 6. Find total revenue generated from each book
-- This query calculates the total revenue generated from each book by summing the product of quantity and price for each order line.
-- It groups the results by book and orders them by total sales in descending order.
SELECT b.title, SUM(ol.quantity * ol.price) AS total_sales  -- Book title and total revenue
FROM book b
JOIN order_line ol ON b.book_id = ol.book_id               -- Links books to order lines
GROUP BY b.book_id                                         -- Groups by book
ORDER BY total_sales DESC;                                 -- Orders by total revenue in descending order

-- 7. Which customer spent the most money?
-- This query identifies the customer who has spent the most money by summing the total amount of their orders.
-- It groups the results by customer and orders them by total spent in descending order, limiting the result to the top customer.
SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer,  -- Customer name
       SUM(o.total_amount) AS total_spent                  -- Total amount spent
FROM customer c
JOIN cust_order o ON c.customer_id = o.customer_id         -- Links customers to their orders
GROUP BY c.customer_id                                     -- Groups by customer
ORDER BY total_spent DESC                                  -- Orders by total spent in descending order
LIMIT 1;                                                   -- Limits the result to the top customer

-- 8. Books written in Swahili or Sheng (local vibes only)
-- This query retrieves the titles of books written in either Swahili or Sheng.
-- It joins the `book` and `book_language` tables to fetch the required details.
SELECT b.title, l.language_name                            -- Book title and language
FROM book b
JOIN book_language l ON b.language_id = l.language_id      -- Links books to their languages
WHERE l.language_name IN ('Swahili', 'Sheng');             -- Filters for Swahili or Sheng
