package com.digitallibrary.dao;

import com.digitallibrary.model.Category;
import com.digitallibrary.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Book Categories.
 * Includes graceful in-memory fallback data if MySQL is not yet connected.
 */
public class CategoryDAO {
    private static final Logger LOGGER = Logger.getLogger(CategoryDAO.class.getName());

    private static final List<Category> FALLBACK_CATEGORIES = new ArrayList<>();

    static {
        FALLBACK_CATEGORIES.add(new Category(1, "Computer Science & Programming", "Core programming languages, paradigms, object-oriented concepts, and computational theory.", "bi-code-slash", null));
        FALLBACK_CATEGORIES.add(new Category(2, "Web Technologies & Frameworks", "Client and server-side web development, servlets, JSP, APIs, and modern front-end architectures.", "bi-globe", null));
        FALLBACK_CATEGORIES.add(new Category(3, "Artificial Intelligence & Machine Learning", "Machine intelligence, neural networks, computer vision, data analysis, and predictive modeling.", "bi-cpu", null));
        FALLBACK_CATEGORIES.add(new Category(4, "Database Systems & Big Data", "Relational database design, SQL, normalization, transaction management, and NoSQL systems.", "bi-database", null));
        FALLBACK_CATEGORIES.add(new Category(5, "Software Engineering & Architecture", "Software lifecycle, design patterns, agile methodologies, testing, and clean architecture.", "bi-diagram-3", null));
        FALLBACK_CATEGORIES.add(new Category(6, "Cyber Security & Cryptography", "Network security, ethical hacking, cryptography, security protocols, and application defense.", "bi-shield-lock", null));
        FALLBACK_CATEGORIES.add(new Category(7, "Cloud Computing & DevOps", "Virtualization, microservices, containerization, CI/CD pipelines, and cloud platforms.", "bi-cloud", null));
        FALLBACK_CATEGORIES.add(new Category(8, "Data Structures & Algorithms", "Fundamental algorithmic techniques, complexity analysis, trees, graphs, and dynamic programming.", "bi-bezier2", null));
        for (Category c : FALLBACK_CATEGORIES) {
            c.setBookCount(2);
        }
    }

    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT c.*, COUNT(b.book_id) AS book_count " +
                     "FROM categories c " +
                     "LEFT JOIN books b ON c.category_id = b.category_id " +
                     "GROUP BY c.category_id " +
                     "ORDER BY c.name ASC";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                Category cat = new Category();
                cat.setCategoryId(rs.getInt("category_id"));
                cat.setName(rs.getString("name"));
                cat.setDescription(rs.getString("description"));
                cat.setIconClass(rs.getString("icon_class"));
                cat.setCreatedAt(rs.getTimestamp("created_at"));
                cat.setBookCount(rs.getInt("book_count"));
                list.add(cat);
            }
            if (!list.isEmpty()) {
                return list;
            }
        } catch (Exception e) {
            LOGGER.log(Level.INFO, "MySQL categories query unavailable. Returning fallback categories.");
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return new ArrayList<>(FALLBACK_CATEGORIES);
    }

    public Category getCategoryById(int categoryId) {
        String sql = "SELECT c.*, COUNT(b.book_id) AS book_count " +
                     "FROM categories c " +
                     "LEFT JOIN books b ON c.category_id = b.category_id " +
                     "WHERE c.category_id = ? " +
                     "GROUP BY c.category_id";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, categoryId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                Category cat = new Category();
                cat.setCategoryId(rs.getInt("category_id"));
                cat.setName(rs.getString("name"));
                cat.setDescription(rs.getString("description"));
                cat.setIconClass(rs.getString("icon_class"));
                cat.setCreatedAt(rs.getTimestamp("created_at"));
                cat.setBookCount(rs.getInt("book_count"));
                return cat;
            }
        } catch (Exception e) {
            LOGGER.log(Level.INFO, "MySQL category query unavailable for ID: " + categoryId);
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }

        for (Category c : FALLBACK_CATEGORIES) {
            if (c.getCategoryId() == categoryId) return c;
        }
        return null;
    }

    public boolean addCategory(Category category) {
        String sql = "INSERT INTO categories (name, description, icon_class) VALUES (?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, category.getName());
            pstmt.setString(2, category.getDescription());
            pstmt.setString(3, category.getIconClass() != null ? category.getIconClass() : "bi-book");

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting category: " + category.getName(), e);
        } finally {
            DBConnection.close(conn, pstmt);
        }
        return false;
    }

    public boolean updateCategory(Category category) {
        String sql = "UPDATE categories SET name = ?, description = ?, icon_class = ? WHERE category_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, category.getName());
            pstmt.setString(2, category.getDescription());
            pstmt.setString(3, category.getIconClass());
            pstmt.setInt(4, category.getCategoryId());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating category ID: " + category.getCategoryId(), e);
        } finally {
            DBConnection.close(conn, pstmt);
        }
        return false;
    }

    public boolean deleteCategory(int categoryId) {
        String sql = "DELETE FROM categories WHERE category_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, categoryId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting category ID: " + categoryId, e);
        } finally {
            DBConnection.close(conn, pstmt);
        }
        return false;
    }

    public int getTotalCategoryCount() {
        String sql = "SELECT COUNT(*) FROM categories";
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
            LOGGER.log(Level.INFO, "MySQL count categories unavailable. Returning fallback count.");
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return FALLBACK_CATEGORIES.size();
    }
}
