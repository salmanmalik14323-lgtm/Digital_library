-- ====================================================================
-- Digital Library and Recommendation System
-- Database Schema Definition (MySQL 8.x Compatible)
-- ====================================================================

DROP DATABASE IF EXISTS digital_library_db;
CREATE DATABASE digital_library_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE digital_library_db;

-- --------------------------------------------------------------------
-- 1. Categories Table
-- --------------------------------------------------------------------
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    icon_class VARCHAR(50) DEFAULT 'bi-book',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 2. Users Table
-- --------------------------------------------------------------------
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    salt VARCHAR(64) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('USER', 'ADMIN') NOT NULL DEFAULT 'USER',
    phone VARCHAR(20),
    bio TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 3. Books Table
-- --------------------------------------------------------------------
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(150) NOT NULL,
    isbn VARCHAR(30) UNIQUE,
    publisher VARCHAR(150),
    publication_year INT,
    category_id INT NOT NULL,
    description TEXT,
    cover_image_url VARCHAR(500),
    total_copies INT NOT NULL DEFAULT 5,
    available_copies INT NOT NULL DEFAULT 5,
    rating DECIMAL(2,1) DEFAULT 4.5,
    page_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_books_category (category_id),
    INDEX idx_books_title (title),
    INDEX idx_books_author (author)
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 4. User Interests Table (Junction between Users and Categories)
-- --------------------------------------------------------------------
CREATE TABLE user_interests (
    interest_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    category_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY uq_user_category (user_id, category_id)
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 5. Book Activity Table (Tracking Views, Searches, and Actions)
-- --------------------------------------------------------------------
CREATE TABLE book_activity (
    activity_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    book_id INT,
    activity_type ENUM('VIEW', 'SEARCH', 'BORROW_REQUEST') NOT NULL,
    search_query VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_activity_user (user_id),
    INDEX idx_activity_type (activity_type)
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 6. Recommendations Table (Cached content-based recommendations)
-- --------------------------------------------------------------------
CREATE TABLE recommendations (
    recommendation_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    book_id INT NOT NULL,
    match_score DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    reason VARCHAR(255) NOT NULL,
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY uq_user_book_rec (user_id, book_id)
) ENGINE=InnoDB;
