-- Library Management System Database
-- Created by [Your Name]

-- Create database
DROP DATABASE IF EXISTS library_management;
CREATE DATABASE library_management;
USE library_management;

-- Members table
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    membership_date DATE NOT NULL,
    membership_status ENUM('active', 'expired', 'suspended') DEFAULT 'active',
    CHECK (email LIKE '%@%.%')
);

-- Authors table
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    birth_date DATE,
    nationality VARCHAR(50),
    biography TEXT
);

-- Publishers table
CREATE TABLE publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address TEXT,
    contact_email VARCHAR(100),
    contact_phone VARCHAR(20)
);

-- Books table
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    publication_year INT,
    publisher_id INT,
    category VARCHAR(50),
    total_copies INT NOT NULL DEFAULT 1,
    available_copies INT NOT NULL DEFAULT 1,
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id) ON DELETE SET NULL,
    CHECK (publication_year BETWEEN 1000 AND YEAR(CURRENT_DATE) + 5),
    CHECK (available_copies <= total_copies AND available_copies >= 0)
);

-- Book-Author relationship (M-M)
CREATE TABLE book_authors (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE CASCADE
);

-- Loans table
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    status ENUM('active', 'returned', 'overdue') DEFAULT 'active',
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    CHECK (due_date > loan_date),
    CHECK (return_date IS NULL OR return_date >= loan_date)
);

-- Fines table
CREATE TABLE fines (
    fine_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    issue_date DATE NOT NULL,
    payment_date DATE,
    status ENUM('unpaid', 'paid') DEFAULT 'unpaid',
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id),
    CHECK (amount > 0),
    CHECK (payment_date IS NULL OR payment_date >= issue_date)
);

-- Insert sample data
INSERT INTO members (first_name, last_name, email, phone, address, membership_date, membership_status) VALUES
('John', 'Smith', 'john.smith@email.com', '555-0101', '123 Main St, Anytown', '2022-01-15', 'active'),
('Emily', 'Johnson', 'emily.j@email.com', '555-0102', '456 Oak Ave, Somewhere', '2022-03-22', 'active'),
('Michael', 'Williams', 'michael.w@email.com', NULL, '789 Pine Rd, Nowhere', '2021-11-05', 'expired');

INSERT INTO publishers (name, address, contact_email, contact_phone) VALUES
('Penguin Books', '375 Hudson St, New York, NY', 'info@penguin.com', '212-366-2000'),
('HarperCollins', '195 Broadway, New York, NY', 'contact@harpercollins.com', '212-207-7000');

INSERT INTO authors (name, birth_date, nationality, biography) VALUES
('J.K. Rowling', '1965-07-31', 'British', 'Author of the Harry Potter series'),
('George R.R. Martin', '1948-09-20', 'American', 'Author of A Song of Ice and Fire series'),
('Agatha Christie', '1890-09-15', 'British', 'Famous mystery writer');

INSERT INTO books (title, isbn, publication_year, publisher_id, category, total_copies, available_copies) VALUES
('Harry Potter and the Philosopher''s Stone', '9780747532743', 1997, 1, 'Fantasy', 5, 3),
('A Game of Thrones', '9780553103540', 1996, 2, 'Fantasy', 3, 1),
('Murder on the Orient Express', '9780062073501', 1934, 2, 'Mystery', 2, 2);

INSERT INTO book_authors (book_id, author_id) VALUES
(1, 1),
(2, 2),
(3, 3);

INSERT INTO loans (book_id, member_id, loan_date, due_date, return_date, status) VALUES
(1, 1, '2023-01-10', '2023-01-31', NULL, 'active'),
(2, 2, '2023-01-15', '2023-02-05', '2023-02-01', 'returned'),
(1, 3, '2022-12-01', '2022-12-22', '2022-12-25', 'overdue');

INSERT INTO fines (loan_id, amount, issue_date, payment_date, status) VALUES
(3, 5.00, '2022-12-23', NULL, 'unpaid'),
(3, 2.50, '2022-12-30', '2023-01-05', 'paid');