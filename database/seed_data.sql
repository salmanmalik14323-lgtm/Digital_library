-- ====================================================================
-- Digital Library and Recommendation System
-- Seed Data (Realistic Academic Sample Data)
-- ====================================================================

USE digital_library_db;

-- --------------------------------------------------------------------
-- 1. Insert Categories
-- --------------------------------------------------------------------
INSERT INTO categories (category_id, name, description, icon_class) VALUES
(1, 'Computer Science & Programming', 'Core programming languages, paradigms, object-oriented concepts, and computational theory.', 'bi-code-slash'),
(2, 'Web Technologies & Frameworks', 'Client and server-side web development, servlets, JSP, APIs, and modern front-end architectures.', 'bi-globe'),
(3, 'Artificial Intelligence & Machine Learning', 'Machine intelligence, neural networks, computer vision, data analysis, and predictive modeling.', 'bi-cpu'),
(4, 'Database Systems & Big Data', 'Relational database design, SQL, normalization, transaction management, and NoSQL systems.', 'bi-database'),
(5, 'Software Engineering & Architecture', 'Software lifecycle, design patterns, agile methodologies, testing, and clean architecture.', 'bi-diagram-3'),
(6, 'Cyber Security & Cryptography', 'Network security, ethical hacking, cryptography, security protocols, and application defense.', 'bi-shield-lock'),
(7, 'Cloud Computing & DevOps', 'Virtualization, microservices, containerization, CI/CD pipelines, and cloud platforms.', 'bi-cloud'),
(8, 'Data Structures & Algorithms', 'Fundamental algorithmic techniques, complexity analysis, trees, graphs, and dynamic programming.', 'bi-bezier2');

-- --------------------------------------------------------------------
-- 2. Insert Users
-- Default passwords:
-- Admin: 'Admin@123'
-- User:  'User@123'
-- Note: Stored as SHA-256(password + salt)
-- --------------------------------------------------------------------
INSERT INTO users (user_id, username, email, password_hash, salt, full_name, role, phone, bio) VALUES
(1, 'admin', 'admin@digitallibrary.com', 'a3f65e2361d7634f59e9cfa4d23a6be7b1e5f88b90753cdba30896ff6d9341aa', 'salt_admin_secret_key_2026', 'System Administrator', 'ADMIN', '+91 9876543210', 'Head of Digital Resources and Library Information Systems.'),
(2, 'salman', 'salman.malik@student.ac.in', 'cf82813fb1a0ecb8f4d99c4384e5b7e9b0d1e3458ef8e583c4856f7e41d8e09f', 'salt_student_salman_17034', 'Salman Murtuja Malik', 'USER', '+91 9823456781', 'SY BSc IT Student | Roll: 17034 | Interested in Java, Web Technologies, and Databases.'),
(3, 'priya', 'priya.sharma@student.ac.in', '0d32bb3f9e9cfb231d6e1fa5b6c8e31245a789ef23cba948d7120e53a1d94cf2', 'salt_student_priya_17035', 'Priya Sharma', 'USER', '+91 9812345672', 'Computer Science enthusiast exploring Algorithms and Cyber Security.');

-- --------------------------------------------------------------------
-- 3. Insert Books
-- --------------------------------------------------------------------
INSERT INTO books (book_id, title, author, isbn, publisher, publication_year, category_id, description, cover_image_url, total_copies, available_copies, rating, page_count) VALUES
-- Category 1: Computer Science & Programming
(1, 'Core Java: Fundamentals (Volume I)', 'Cay S. Horstmann', '978-0137871070', 'Pearson Education', 2024, 1, 
'The definitive guide to Java for serious programmers. Covers object-oriented programming, reflections, interfaces, lambda expressions, exceptions, and the Java Collections Framework with industrial-grade depth.', 
'https://images.unsplash.com/photo-1532012164546-f432f2e3777a?auto=format&fit=crop&w=600&q=80', 8, 6, 4.8, 928),

(2, 'Effective Java (3rd Edition)', 'Joshua Bloch', '978-0134685991', 'Addison-Wesley Professional', 2018, 1, 
'An essential best-practices handbook containing 90 concise rules for writing clear, robust, maintainable, and idiomatic Java code by the original Java Collections framework architect.', 
'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=600&q=80', 10, 8, 4.9, 416),

(3, 'Head First Java (3rd Edition)', 'Kathy Sierra, Bert Bates, Trisha Gee', '978-1491910771', 'O''Reilly Media', 2022, 1, 
'A visually rich, highly engaging introduction to object-oriented programming and modern Java 17 features, combining puzzles, strong visuals, and hands-on exercises.', 
'https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&w=600&q=80', 6, 4, 4.7, 750),

-- Category 2: Web Technologies & Frameworks
(4, 'Murach''s Java Servlets and JSP (3rd Edition)', 'Joel Murach, Michael Urban', '978-1890774783', 'Mike Murach & Associates', 2021, 2, 
'Practical masterclass on developing enterprise-level, database-driven Java web applications using Servlets, JSP, JSTL, JavaBeans, and Apache Tomcat.', 
'https://images.unsplash.com/photo-1507842229451-7f01be7fe880?auto=format&fit=crop&w=600&q=80', 12, 9, 4.8, 784),

(5, 'Beginning Jakarta EE Web Development', 'Luciano Manelli', '978-1484261767', 'Apress', 2022, 2, 
'A hands-on guide to building modular web applications using the Jakarta EE platform, Tomcat, Servlets, and modern RESTful web services.', 
'https://images.unsplash.com/photo-1589829085413-56de8ae18c73?auto=format&fit=crop&w=600&q=80', 5, 5, 4.5, 340),

(6, 'Full Stack Web Development with Java and React', 'Dhrubojyoti Kayal', '978-1801816786', 'Packt Publishing', 2023, 2, 
'Covers building secure, responsive, modern web applications combining Java backend microservices and clean, component-driven client interfaces.', 
'https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=600&q=80', 7, 5, 4.6, 460),

-- Category 3: AI & Machine Learning
(7, 'Artificial Intelligence: A Modern Approach (4th Edition)', 'Stuart Russell, Peter Norvig', '978-0134610993', 'Pearson', 2020, 3, 
'The universal standard textbook on artificial intelligence, exploring rational agents, search algorithms, knowledge representation, probabilistic inference, and machine learning.', 
'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?auto=format&fit=crop&w=600&q=80', 10, 7, 4.9, 1152),

(8, 'Hands-On Machine Learning with Scikit-Learn and TensorFlow', 'Aurélien Géron', '978-1098125974', 'O''Reilly Media', 2022, 3, 
'Concrete examples, minimal theory, and production-ready Python code to build intelligent systems using modern neural networks and deep learning.', 
'https://images.unsplash.com/photo-1555949963-aa79dcee981c?auto=format&fit=crop&w=600&q=80', 8, 4, 4.8, 856),

-- Category 4: Database Systems & Big Data
(9, 'Database System Concepts (7th Edition)', 'Abraham Silberschatz, Henry Korth, S. Sudarshan', '978-0078022159', 'McGraw-Hill Education', 2020, 4, 
'The premier foundational text on database management, covering relational data models, SQL queries, relational algebra, indexing, B+ trees, concurrency control, and transactions.', 
'https://images.unsplash.com/photo-1544383835-bda2bc66a55d?auto=format&fit=crop&w=600&q=80', 14, 11, 4.7, 1376),

(10, 'High Performance MySQL (4th Edition)', 'Silvia Botros, Jeremy Tinley', '978-1492080510', 'O''Reilly Media', 2021, 4, 
'In-depth guide to scaling MySQL in production environments, index optimization, query execution plans, transactions, replication, and performance tuning.', 
'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?auto=format&fit=crop&w=600&q=80', 6, 5, 4.7, 360),

-- Category 5: Software Engineering & Architecture
(11, 'Clean Code: A Handbook of Agile Software Craftsmanship', 'Robert C. Martin', '978-0132350884', 'Prentice Hall', 2008, 5, 
'Legendary guide to software craftsmanship, meaningful naming, writing focused functions, handling errors, refactoring legacy code, and unit testing.', 
'https://images.unsplash.com/photo-1516979187457-637abb4f9353?auto=format&fit=crop&w=600&q=80', 15, 12, 4.9, 464),

(12, 'Design Patterns: Elements of Reusable Object-Oriented Software', 'Erich Gamma, Richard Helm, Ralph Johnson, John Vlissides', '978-0201633610', 'Addison-Wesley', 1994, 5, 
'The iconic Gang of Four (GoF) book establishing 23 core object-oriented software design patterns categorized into Creational, Structural, and Behavioral patterns.', 
'https://images.unsplash.com/photo-1457369804613-52c61a468e7d?auto=format&fit=crop&w=600&q=80', 8, 7, 4.8, 416),

-- Category 6: Cyber Security & Cryptography
(13, 'Cryptography and Network Security: Principles and Practice', 'William Stallings', '978-0135764039', 'Pearson', 2020, 6, 
'Comprehensive examination of cryptographic algorithms (AES, RSA, ECC, SHA), digital signatures, public key infrastructure, network authentication, and defensive security.', 
'https://images.unsplash.com/photo-1563986768609-322da13575f3?auto=format&fit=crop&w=600&q=80', 9, 6, 4.6, 768),

(14, 'The Web Application Hacker''s Handbook', 'Dafydd Stuttard, Marcus Pinto', '978-1118026472', 'Wiley', 2011, 6, 
'Authoritative guide to discovering, exploiting, and mitigating security flaws in web applications, including SQL injection, XSS, CSRF, and broken access controls.', 
'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?auto=format&fit=crop&w=600&q=80', 7, 4, 4.8, 912),

-- Category 7: Cloud Computing & DevOps
(15, 'Cloud Computing: Concepts, Technology & Architecture', 'Thomas Erl, Ricardo Puttini, Zaigham Mahmood', '978-0133387520', 'Prentice Hall', 2019, 7, 
'Comprehensive, vendor-neutral breakdown of cloud models (IaaS, PaaS, SaaS), virtualization mechanisms, multi-tenancy architectures, and cloud security metrics.', 
'https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&w=600&q=80', 6, 5, 4.5, 528),

(16, 'The DevOps Handbook', 'Gene Kim, Jez Humble, Patrick Debois, John Willis', '978-1942788003', 'IT Revolution Press', 2021, 7, 
'Practical manual on how to integrate product management, software development, IT operations, and information security to increase agility and reliability.', 
'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=600&q=80', 8, 8, 4.7, 480),

-- Category 8: Data Structures & Algorithms
(17, 'Introduction to Algorithms (4th Edition)', 'Thomas H. Cormen, Charles E. Leiserson, Ronald L. Rivest, Clifford Stein', '978-0262046305', 'MIT Press', 2022, 8, 
'The globally renowned CLRS standard algorithm reference text, spanning sorting algorithms, dynamic programming, greedy algorithms, graph algorithms, and NP-completeness.', 
'https://images.unsplash.com/photo-1509228468518-180dd4864904?auto=format&fit=crop&w=600&q=80', 12, 10, 4.9, 1312),

(18, 'Grokking Algorithms: An Illustrated Guide', 'Aditya Bhargava', '978-1617292231', 'Manning Publications', 2016, 8, 
'A friendly, highly illustrated introduction to common algorithms and data structures, breaking down binary search, recursion, hash tables, and breadth-first search.', 
'https://images.unsplash.com/photo-1517842645767-c639042777db?auto=format&fit=crop&w=600&q=80', 10, 7, 4.8, 256);

-- --------------------------------------------------------------------
-- 4. Insert User Interests (Initial preferences for demo user Salman)
-- Salman is interested in Computer Science (1), Web Tech (2), and Databases (4)
-- --------------------------------------------------------------------
INSERT INTO user_interests (user_id, category_id) VALUES
(2, 1),
(2, 2),
(2, 4),
(3, 1),
(3, 6),
(3, 8);

-- --------------------------------------------------------------------
-- 5. Insert Sample Book Activities
-- --------------------------------------------------------------------
INSERT INTO book_activity (user_id, book_id, activity_type, search_query) VALUES
(2, 1, 'VIEW', NULL),
(2, 4, 'VIEW', NULL),
(2, 9, 'VIEW', NULL),
(2, NULL, 'SEARCH', 'Java Servlets'),
(2, 2, 'VIEW', NULL),
(3, 17, 'VIEW', NULL),
(3, 13, 'VIEW', NULL);

-- --------------------------------------------------------------------
-- 6. Insert Initial Recommendations for Salman (User ID 2)
-- --------------------------------------------------------------------
INSERT INTO recommendations (user_id, book_id, match_score, reason) VALUES
(2, 2, 95.00, 'Matches your interest in Computer Science & Programming and high rating (4.9/5)'),
(2, 5, 90.00, 'Matches your interest in Web Technologies & Frameworks'),
(2, 10, 85.00, 'Matches your interest in Database Systems & Big Data'),
(2, 3, 80.00, 'Based on your recent viewing of Core Java: Fundamentals');
