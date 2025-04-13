-- 1. Create the database
-- Creates the database `BookStoreDB` if it doesn't already exist and sets it as the active database.
CREATE DATABASE IF NOT EXISTS BookStoreDB;
USE BookStoreDB;

-- 2. Book-related tables

-- Publishers
-- Stores information about publishers, including their name and contact details.
CREATE TABLE publisher (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique ID for each publisher
    publisher_name VARCHAR(255) NOT NULL,         -- Name of the publisher
    contact_info VARCHAR(255)                     -- Contact details (e.g., email, phone)
);

-- Book Languages
-- Stores the languages in which books are written.
CREATE TABLE book_language (
    language_id INT AUTO_INCREMENT PRIMARY KEY,   -- Unique ID for each language
    language_name VARCHAR(100) NOT NULL           -- Name of the language (e.g., English, Swahili)
);

-- Books
-- Stores details about books, including their title, publisher, language, price, and publication date.
CREATE TABLE book (
    book_id INT AUTO_INCREMENT PRIMARY KEY,       -- Unique ID for each book
    title VARCHAR(255) NOT NULL,                  -- Title of the book
    publisher_id INT,                             -- Foreign key linking to the publisher table
    language_id INT,                              -- Foreign key linking to the book_language table
    price DECIMAL(10, 2),                         -- Price of the book
    published_date DATE,                          -- Publication date of the book
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id),  -- Links to publisher
    FOREIGN KEY (language_id) REFERENCES book_language(language_id) -- Links to language
);

-- Authors
-- Stores information about authors, including their name and biography.
CREATE TABLE author (
    author_id INT AUTO_INCREMENT PRIMARY KEY,     -- Unique ID for each author
    first_name VARCHAR(100),                      -- First name of the author
    last_name VARCHAR(100),                       -- Last name of the author
    bio TEXT                                      -- Short biography of the author
);

-- Book-Author Relationship (many-to-many)
-- Links books to their authors, allowing many-to-many relationships.
CREATE TABLE book_author (
    book_id INT,                                  -- Foreign key linking to the book table
    author_id INT,                                -- Foreign key linking to the author table
    PRIMARY KEY (book_id, author_id),             -- Composite primary key
    FOREIGN KEY (book_id) REFERENCES book(book_id),  -- Links to book
    FOREIGN KEY (author_id) REFERENCES author(author_id) -- Links to author
);

-- 3. Customer and Address tables

-- Countries
-- Stores the list of countries for addresses.
CREATE TABLE country (
    country_id INT AUTO_INCREMENT PRIMARY KEY,    -- Unique ID for each country
    country_name VARCHAR(100) NOT NULL            -- Name of the country
);

-- Address
-- Stores address details, including street, city, state, postal code, and country.
CREATE TABLE address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,    -- Unique ID for each address
    street VARCHAR(255),                          -- Street address
    city VARCHAR(100),                            -- City
    state VARCHAR(100),                           -- State or region
    postal_code VARCHAR(20),                      -- Postal code
    country_id INT,                               -- Foreign key linking to the country table
    FOREIGN KEY (country_id) REFERENCES country(country_id) -- Links to country
);

-- Address Status
-- Stores the status of addresses (e.g., Current, Old).
CREATE TABLE address_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,     -- Unique ID for each status
    status_name VARCHAR(50)                       -- Name of the status (e.g., Current, Old)
);

-- Customers
-- Stores customer details, including their name, email, and phone number.
CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,   -- Unique ID for each customer
    first_name VARCHAR(100),                      -- First name of the customer
    last_name VARCHAR(100),                       -- Last name of the customer
    email VARCHAR(150) UNIQUE,                    -- Email address (must be unique)
    phone VARCHAR(20)                             -- Phone number
);

-- Customer-Address (many addresses per customer)
-- Links customers to their addresses, allowing multiple addresses per customer.
CREATE TABLE customer_address (
    customer_address_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique ID for each record
    customer_id INT,                                     -- Foreign key linking to the customer table
    address_id INT,                                      -- Foreign key linking to the address table
    status_id INT,                                       -- Foreign key linking to the address_status table
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),  -- Links to customer
    FOREIGN KEY (address_id) REFERENCES address(address_id),     -- Links to address
    FOREIGN KEY (status_id) REFERENCES address_status(status_id) -- Links to address status
);

-- 4. Orders and Shipping

-- Shipping Methods
-- Stores the available shipping methods, including their name and description.
CREATE TABLE shipping_method (
    shipping_method_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique ID for each shipping method
    method_name VARCHAR(100),                           -- Name of the shipping method
    description TEXT                                    -- Description of the shipping method
);

-- Customer Orders
-- Stores customer orders, including the customer, shipping method, and total amount.
CREATE TABLE cust_order (
    order_id INT AUTO_INCREMENT PRIMARY KEY,            -- Unique ID for each order
    customer_id INT,                                    -- Foreign key linking to the customer table
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,      -- Date and time of the order
    shipping_method_id INT,                             -- Foreign key linking to the shipping_method table
    total_amount DECIMAL(10, 2),                        -- Total amount for the order
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),  -- Links to customer
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(shipping_method_id) -- Links to shipping method
);

-- Order Lines (books per order)
-- Stores the details of books in each order, including quantity and price.
CREATE TABLE order_line (
    order_line_id INT AUTO_INCREMENT PRIMARY KEY,       -- Unique ID for each order line
    order_id INT,                                       -- Foreign key linking to the cust_order table
    book_id INT,                                        -- Foreign key linking to the book table
    quantity INT,                                       -- Quantity of the book ordered
    price DECIMAL(10, 2),                               -- Price of the book
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),  -- Links to order
    FOREIGN KEY (book_id) REFERENCES book(book_id)           -- Links to book
);

-- Order Status (status options)
-- Stores the possible statuses of an order (e.g., Pending, Shipped, Delivered).
CREATE TABLE order_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,           -- Unique ID for each status
    status_name VARCHAR(50)                             -- Name of the status
);

-- Order History
-- Tracks the history of orders, including status updates, timestamps, and notes.
CREATE TABLE order_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,          -- Unique ID for each history record
    order_id INT,                                       -- Foreign key linking to the cust_order table
    status_id INT,                                      -- Foreign key linking to the order_status table
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP,     -- Timestamp of the status update
    note TEXT,                                          -- Additional notes about the update
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),  -- Links to order
    FOREIGN KEY (status_id) REFERENCES order_status(status_id) -- Links to order status
);
