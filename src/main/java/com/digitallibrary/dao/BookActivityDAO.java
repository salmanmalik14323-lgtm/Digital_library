package com.digitallibrary.dao;

import com.digitallibrary.model.BookActivity;
import com.digitallibrary.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for tracking and retrieving user interactions, searches, and book page views.
 */
public class BookActivityDAO {
    private static final Logger LOGGER = Logger.getLogger(BookActivityDAO.class.getName());

    public boolean logActivity(Integer userId, Integer bookId, String activityType, String searchQuery) {
        String sql = "INSERT INTO book_activity (user_id, book_id, activity_type, search_query) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            if (userId != null && userId > 0) {
                pstmt.setInt(1, userId);
            } else {
                pstmt.setNull(1, java.sql.Types.INTEGER);
            }

            if (bookId != null && bookId > 0) {
                pstmt.setInt(2, bookId);
            } else {
                pstmt.setNull(2, java.sql.Types.INTEGER);
            }

            pstmt.setString(3, activityType);
            pstmt.setString(4, searchQuery);

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error logging book activity", e);
        } finally {
            DBConnection.close(conn, pstmt);
        }
        return false;
    }

    public List<BookActivity> getUserRecentActivities(int userId, int limit) {
        List<BookActivity> list = new ArrayList<>();
        String sql = "SELECT a.*, u.username, b.title AS book_title " +
                     "FROM book_activity a " +
                     "LEFT JOIN users u ON a.user_id = u.user_id " +
                     "LEFT JOIN books b ON a.book_id = b.book_id " +
                     "WHERE a.user_id = ? " +
                     "ORDER BY a.created_at DESC " +
                     "LIMIT ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, limit > 0 ? limit : 10);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToActivity(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching user recent activities for user ID: " + userId, e);
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }
        return list;
    }

    public List<BookActivity> getAllRecentActivities(int limit) {
        List<BookActivity> list = new ArrayList<>();
        String sql = "SELECT a.*, u.username, b.title AS book_title " +
                     "FROM book_activity a " +
                     "LEFT JOIN users u ON a.user_id = u.user_id " +
                     "LEFT JOIN books b ON a.book_id = b.book_id " +
                     "ORDER BY a.created_at DESC " +
                     "LIMIT ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit > 0 ? limit : 15);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToActivity(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching all recent activities", e);
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }
        return list;
    }

    /**
     * Aggregates book view activities per category for a given user.
     * Used by RecommendationEngine to calculate behavioral match score.
     */
    public Map<Integer, Integer> getCategoryViewCounts(int userId) {
        Map<Integer, Integer> map = new HashMap<>();
        String sql = "SELECT b.category_id, COUNT(*) AS view_count " +
                     "FROM book_activity a " +
                     "JOIN books b ON a.book_id = b.book_id " +
                     "WHERE a.user_id = ? AND a.activity_type = 'VIEW' " +
                     "GROUP BY b.category_id";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                map.put(rs.getInt("category_id"), rs.getInt("view_count"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error aggregating category view counts for user ID: " + userId, e);
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }
        return map;
    }

    public int getTotalActivityCount() {
        String sql = "SELECT COUNT(*) FROM book_activity";
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
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting total activities", e);
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return 0;
    }

    private BookActivity mapResultSetToActivity(ResultSet rs) throws SQLException {
        BookActivity act = new BookActivity();
        act.setActivityId(rs.getInt("activity_id"));
        int uid = rs.getInt("user_id");
        if (!rs.wasNull()) {
            act.setUserId(uid);
        }
        act.setUsername(rs.getString("username"));
        int bid = rs.getInt("book_id");
        if (!rs.wasNull()) {
            act.setBookId(bid);
        }
        act.setBookTitle(rs.getString("book_title"));
        act.setActivityType(rs.getString("activity_type"));
        act.setSearchQuery(rs.getString("search_query"));
        act.setCreatedAt(rs.getTimestamp("created_at"));
        return act;
    }
}
