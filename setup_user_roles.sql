-- User and Role Setup for BookStoreDB

-- 1. Create Admin User with Full Access
-- Ensure the user does not already exist before creating it
DROP USER IF EXISTS 'bookstore_admin'@'localhost';
CREATE USER 'bookstore_admin'@'localhost' IDENTIFIED BY 'AdminPass123!';
GRANT ALL PRIVILEGES ON BookStoreDB.* TO 'bookstore_admin'@'localhost';

-- 2. Create Read-Only User
-- Ensure the user does not already exist before creating it
DROP USER IF EXISTS 'bookstore_reader'@'localhost';
CREATE USER 'bookstore_reader'@'localhost' IDENTIFIED BY 'ReadOnly123!';
GRANT SELECT ON BookStoreDB.* TO 'bookstore_reader'@'localhost';

-- 3. Apply Changes
FLUSH PRIVILEGES;
