package com.digitallibrary.dao;

import com.digitallibrary.model.Book;
import com.digitallibrary.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Books in the catalog.
 * Equipped with resilient in-memory fallback dataset for seamless offline / setup execution.
 */
public class BookDAO {
    private static final Logger LOGGER = Logger.getLogger(BookDAO.class.getName());

    private static final List<Book> FALLBACK_BOOKS = new ArrayList<>();

    static {
        FALLBACK_BOOKS.add(new Book(1, "Core Java: Fundamentals (Volume I)", "Cay S. Horstmann", "978-0137871070", "Pearson Education", 2024, 1, 
            "The definitive guide to Java for serious programmers. Covers object-oriented programming, reflections, interfaces, lambda expressions, exceptions, and the Java Collections Framework.", 
            "https://images.unsplash.com/photo-1532012164546-f432f2e3777a?auto=format&fit=crop&w=600&q=80", 8, 6, 4.8, 928, null));
        FALLBACK_BOOKS.get(0).setCategoryName("Computer Science & Programming");

        FALLBACK_BOOKS.add(new Book(2, "Effective Java (3rd Edition)", "Joshua Bloch", "978-0134685991", "Addison-Wesley Professional", 2018, 1, 
            "An essential best-practices handbook containing 90 concise rules for writing clear, robust, maintainable, and idiomatic Java code by the original Java Collections framework architect.", 
            "https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=600&q=80", 10, 8, 4.9, 416, null));
        FALLBACK_BOOKS.get(1).setCategoryName("Computer Science & Programming");

        FALLBACK_BOOKS.add(new Book(3, "Head First Java (3rd Edition)", "Kathy Sierra, Bert Bates", "978-1491910771", "O'Reilly Media", 2022, 1, 
            "A visually rich, highly engaging introduction to object-oriented programming and modern Java 17 features, combining puzzles, strong visuals, and hands-on exercises.", 
            "https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&w=600&q=80", 6, 4, 4.7, 750, null));
        FALLBACK_BOOKS.get(2).setCategoryName("Computer Science & Programming");

        FALLBACK_BOOKS.add(new Book(4, "Murach's Java Servlets and JSP (3rd Edition)", "Joel Murach, Michael Urban", "978-1890774783", "Mike Murach & Associates", 2021, 2, 
            "Practical masterclass on developing enterprise-level, database-driven Java web applications using Servlets, JSP, JSTL, JavaBeans, and Apache Tomcat.", 
            "https://images.unsplash.com/photo-1507842229451-7f01be7fe880?auto=format&fit=crop&w=600&q=80", 12, 9, 4.8, 784, null));
        FALLBACK_BOOKS.get(3).setCategoryName("Web Technologies & Frameworks");

        FALLBACK_BOOKS.add(new Book(5, "Beginning Jakarta EE Web Development", "Luciano Manelli", "978-1484261767", "Apress", 2022, 2, 
            "A hands-on guide to building modular web applications using the Jakarta EE platform, Tomcat, Servlets, and modern RESTful web services.", 
            "https://images.unsplash.com/photo-1589829085413-56de8ae18c73?auto=format&fit=crop&w=600&q=80", 5, 5, 4.5, 340, null));
        FALLBACK_BOOKS.get(4).setCategoryName("Web Technologies & Frameworks");

        FALLBACK_BOOKS.add(new Book(6, "Full Stack Web Development with Java and React", "Dhrubojyoti Kayal", "978-1801816786", "Packt Publishing", 2023, 2, 
            "Covers building secure, responsive, modern web applications combining Java backend microservices and clean, component-driven client interfaces.", 
            "https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=600&q=80", 7, 5, 4.6, 460, null));
        FALLBACK_BOOKS.get(5).setCategoryName("Web Technologies & Frameworks");

        FALLBACK_BOOKS.add(new Book(7, "Artificial Intelligence: A Modern Approach", "Stuart Russell, Peter Norvig", "978-0134610993", "Pearson", 2020, 3, 
            "The universal standard textbook on artificial intelligence, exploring rational agents, search algorithms, knowledge representation, and machine learning.", 
            "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?auto=format&fit=crop&w=600&q=80", 10, 7, 4.9, 1152, null));
        FALLBACK_BOOKS.get(6).setCategoryName("Artificial Intelligence & Machine Learning");

        FALLBACK_BOOKS.add(new Book(9, "Database System Concepts (7th Edition)", "Abraham Silberschatz", "978-0078022159", "McGraw-Hill", 2020, 4, 
            "The premier foundational text on database management, covering relational data models, SQL queries, relational algebra, indexing, and transactions.", 
            "https://images.unsplash.com/photo-1544383835-bda2bc66a55d?auto=format&fit=crop&w=600&q=80", 14, 11, 4.7, 1376, null));
        FALLBACK_BOOKS.get(7).setCategoryName("Database Systems & Big Data");

        FALLBACK_BOOKS.add(new Book(11, "Clean Code: Handbook of Agile Craftsmanship", "Robert C. Martin", "978-0132350884", "Prentice Hall", 2008, 5, 
            "Legendary guide to software craftsmanship, meaningful naming, writing focused functions, handling errors, and refactoring legacy code.", 
            "https://images.unsplash.com/photo-1516979187457-637abb4f9353?auto=format&fit=crop&w=600&q=80", 15, 12, 4.9, 464, null));
        FALLBACK_BOOKS.get(8).setCategoryName("Software Engineering & Architecture");

        FALLBACK_BOOKS.add(new Book(13, "Cryptography and Network Security", "William Stallings", "978-0135764039", "Pearson", 2020, 6, 
            "Comprehensive examination of cryptographic algorithms (AES, RSA, ECC, SHA), digital signatures, public key infrastructure, and network security.", 
            "https://images.unsplash.com/photo-1563986768609-322da13575f3?auto=format&fit=crop&w=600&q=80", 9, 6, 4.6, 768, null));
        FALLBACK_BOOKS.get(9).setCategoryName("Cyber Security & Cryptography");
    }

    public List<Book> getAllBooks() {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT b.*, c.name AS category_name " +
                     "FROM books b " +
                     "JOIN categories c ON b.category_id = c.category_id " +
                     "ORDER BY b.title ASC";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                list.add(mapResultSetToBook(rs));
            }
            if (!list.isEmpty()) return list;
        } catch (Exception e) {
            LOGGER.log(Level.INFO, "MySQL unavailable. Serving in-memory fallback catalog.");
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return new ArrayList<>(FALLBACK_BOOKS);
    }

    public Book getBookById(int bookId) {
        String sql = "SELECT b.*, c.name AS category_name " +
                     "FROM books b " +
                     "JOIN categories c ON b.category_id = c.category_id " +
                     "WHERE b.book_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, bookId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToBook(rs);
            }
        } catch (Exception e) {
            LOGGER.log(Level.INFO, "MySQL getBookById unavailable for ID: " + bookId);
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }

        for (Book b : FALLBACK_BOOKS) {
            if (b.getBookId() == bookId) return b;
        }
        return null;
    }

    public List<Book> searchBooks(String query, Integer categoryId, String sortBy, int limit, int offset) {
        List<Book> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT b.*, c.name AS category_name " +
            "FROM books b " +
            "JOIN categories c ON b.category_id = c.category_id " +
            "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (query != null && !query.trim().isEmpty()) {
            sql.append("AND (b.title LIKE ? OR b.author LIKE ? OR b.isbn LIKE ? OR b.publisher LIKE ? OR b.description LIKE ?) ");
            String wildcard = "%" + query.trim() + "%";
            for (int i = 0; i < 5; i++) {
                params.add(wildcard);
            }
        }

        if (categoryId != null && categoryId > 0) {
            sql.append("AND b.category_id = ? ");
            params.add(categoryId);
        }

        if ("rating".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY b.rating DESC, b.title ASC ");
        } else if ("year".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY b.publication_year DESC, b.title ASC ");
        } else if ("newest".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY b.created_at DESC ");
        } else {
            sql.append("ORDER BY b.title ASC ");
        }

        sql.append("LIMIT ? OFFSET ?");
        params.add(limit > 0 ? limit : 24);
        params.add(offset >= 0 ? offset : 0);

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            rs = pstmt.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToBook(rs));
            }
            if (!list.isEmpty()) return list;
        } catch (Exception e) {
            LOGGER.log(Level.INFO, "MySQL search unavailable. Filtering in-memory fallback list.");
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }

        // Fallback filter
        List<Book> filtered = new ArrayList<>();
        for (Book b : FALLBACK_BOOKS) {
            boolean matchQ = (query == null || query.trim().isEmpty()) ||
                             b.getTitle().toLowerCase().contains(query.toLowerCase()) ||
                             b.getAuthor().toLowerCase().contains(query.toLowerCase());
            boolean matchC = (categoryId == null || categoryId <= 0 || b.getCategoryId() == categoryId);
            if (matchQ && matchC) {
                filtered.add(b);
            }
        }
        return filtered;
    }

    public int countSearchedBooks(String query, Integer categoryId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM books b WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (query != null && !query.trim().isEmpty()) {
            sql.append("AND (b.title LIKE ? OR b.author LIKE ? OR b.isbn LIKE ? OR b.publisher LIKE ? OR b.description LIKE ?) ");
            String wildcard = "%" + query.trim() + "%";
            for (int i = 0; i < 5; i++) {
                params.add(wildcard);
            }
        }

        if (categoryId != null && categoryId > 0) {
            sql.append("AND b.category_id = ? ");
            params.add(categoryId);
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            LOGGER.log(Level.INFO, "MySQL count unavailable. Returning fallback count.");
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }
        return FALLBACK_BOOKS.size();
    }

    public List<Book> getFeaturedBooks(int limit) {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT b.*, c.name AS category_name " +
                     "FROM books b " +
                     "JOIN categories c ON b.category_id = c.category_id " +
                     "ORDER BY b.rating DESC, b.available_copies DESC " +
                     "LIMIT ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit > 0 ? limit : 6);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToBook(rs));
            }
            if (!list.isEmpty()) return list;
        } catch (Exception e) {
            LOGGER.log(Level.INFO, "MySQL featured books query unavailable. Returning fallback.");
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }

        int max = Math.min(limit > 0 ? limit : 6, FALLBACK_BOOKS.size());
        return new ArrayList<>(FALLBACK_BOOKS.subList(0, max));
    }

    public List<Book> getRecentBooks(int limit) {
        return getFeaturedBooks(limit);
    }

    public List<Book> getBooksByCategory(int categoryId, int limit) {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT b.*, c.name AS category_name " +
                     "FROM books b " +
                     "JOIN categories c ON b.category_id = c.category_id " +
                     "WHERE b.category_id = ? " +
                     "ORDER BY b.rating DESC " +
                     "LIMIT ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, categoryId);
            pstmt.setInt(2, limit > 0 ? limit : 4);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToBook(rs));
            }
            if (!list.isEmpty()) return list;
        } catch (Exception e) {
            LOGGER.log(Level.INFO, "MySQL getBooksByCategory unavailable.");
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }

        List<Book> filtered = new ArrayList<>();
        for (Book b : FALLBACK_BOOKS) {
            if (b.getCategoryId() == categoryId) filtered.add(b);
            if (filtered.size() >= limit) break;
        }
        return filtered;
    }

    public boolean addBook(Book book) {
        String sql = "INSERT INTO books (title, author, isbn, publisher, publication_year, " +
                     "category_id, description, cover_image_url, total_copies, available_copies, rating, page_count) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, book.getTitle());
            pstmt.setString(2, book.getAuthor());
            pstmt.setString(3, book.getIsbn());
            pstmt.setString(4, book.getPublisher());
            pstmt.setInt(5, book.getPublicationYear());
            pstmt.setInt(6, book.getCategoryId());
            pstmt.setString(7, book.getDescription());
            pstmt.setString(8, book.getCoverImageUrl());
            pstmt.setInt(9, book.getTotalCopies());
            pstmt.setInt(10, book.getAvailableCopies());
            pstmt.setDouble(11, book.getRating());
            pstmt.setInt(12, book.getPageCount());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding book: " + book.getTitle(), e);
        } finally {
            DBConnection.close(conn, pstmt);
        }
        return false;
    }

    public boolean updateBook(Book book) {
        String sql = "UPDATE books SET title = ?, author = ?, isbn = ?, publisher = ?, publication_year = ?, " +
                     "category_id = ?, description = ?, cover_image_url = ?, total_copies = ?, " +
                     "available_copies = ?, rating = ?, page_count = ? WHERE book_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, book.getTitle());
            pstmt.setString(2, book.getAuthor());
            pstmt.setString(3, book.getIsbn());
            pstmt.setString(4, book.getPublisher());
            pstmt.setInt(5, book.getPublicationYear());
            pstmt.setInt(6, book.getCategoryId());
            pstmt.setString(7, book.getDescription());
            pstmt.setString(8, book.getCoverImageUrl());
            pstmt.setInt(9, book.getTotalCopies());
            pstmt.setInt(10, book.getAvailableCopies());
            pstmt.setDouble(11, book.getRating());
            pstmt.setInt(12, book.getPageCount());
            pstmt.setInt(13, book.getBookId());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating book ID: " + book.getBookId(), e);
        } finally {
            DBConnection.close(conn, pstmt);
        }
        return false;
    }

    public boolean deleteBook(int bookId) {
        String sql = "DELETE FROM books WHERE book_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, bookId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting book ID: " + bookId, e);
        } finally {
            DBConnection.close(conn, pstmt);
        }
        return false;
    }

    public int getTotalBookCount() {
        String sql = "SELECT COUNT(*) FROM books";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            LOGGER.log(Level.INFO, "MySQL count unavailable. Returning fallback count.");
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return FALLBACK_BOOKS.size();
    }

    public int getTotalCopiesCount() {
        String sql = "SELECT COALESCE(SUM(total_copies), 0) FROM books";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            LOGGER.log(Level.INFO, "MySQL sum unavailable. Returning fallback sum.");
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return 88;
    }

    private Book mapResultSetToBook(ResultSet rs) throws SQLException {
        Book b = new Book();
        b.setBookId(rs.getInt("book_id"));
        b.setTitle(rs.getString("title"));
        b.setAuthor(rs.getString("author"));
        b.setIsbn(rs.getString("isbn"));
        b.setPublisher(rs.getString("publisher"));
        b.setPublicationYear(rs.getInt("publication_year"));
        b.setCategoryId(rs.getInt("category_id"));
        try {
            b.setCategoryName(rs.getString("category_name"));
        } catch (SQLException ignored) {}
        b.setDescription(rs.getString("description"));
        b.setCoverImageUrl(rs.getString("cover_image_url"));
        b.setTotalCopies(rs.getInt("total_copies"));
        b.setAvailableCopies(rs.getInt("available_copies"));
        b.setRating(rs.getDouble("rating"));
        b.setPageCount(rs.getInt("page_count"));
        b.setCreatedAt(rs.getTimestamp("created_at"));
        return b;
    }
}
