package com.digitallibrary.dao;

import com.digitallibrary.model.UserInterest;
import com.digitallibrary.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for User Interests and Category preferences.
 */
public class UserInterestDAO {
    private static final Logger LOGGER = Logger.getLogger(UserInterestDAO.class.getName());

    public List<UserInterest> getUserInterests(int userId) {
        List<UserInterest> list = new ArrayList<>();
        String sql = "SELECT ui.*, c.name AS category_name " +
                     "FROM user_interests ui " +
                     "JOIN categories c ON ui.category_id = c.category_id " +
                     "WHERE ui.user_id = ? " +
                     "ORDER BY c.name ASC";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                UserInterest ui = new UserInterest();
                ui.setInterestId(rs.getInt("interest_id"));
                ui.setUserId(rs.getInt("user_id"));
                ui.setCategoryId(rs.getInt("category_id"));
                ui.setCategoryName(rs.getString("category_name"));
                ui.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(ui);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching user interests for user ID: " + userId, e);
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }
        return list;
    }

    public Set<Integer> getUserInterestCategoryIds(int userId) {
        Set<Integer> set = new HashSet<>();
        String sql = "SELECT category_id FROM user_interests WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                set.add(rs.getInt("category_id"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching user interest IDs for user ID: " + userId, e);
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }
        return set;
    }

    public boolean setUserInterests(int userId, List<Integer> categoryIds) {
        String deleteSql = "DELETE FROM user_interests WHERE user_id = ?";
        String insertSql = "INSERT INTO user_interests (user_id, category_id) VALUES (?, ?)";
        Connection conn = null;
        PreparedStatement delStmt = null;
        PreparedStatement insStmt = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Delete old interests
            delStmt = conn.prepareStatement(deleteSql);
            delStmt.setInt(1, userId);
            delStmt.executeUpdate();

            // Insert new interests
            if (categoryIds != null && !categoryIds.isEmpty()) {
                insStmt = conn.prepareStatement(insertSql);
                for (Integer catId : categoryIds) {
                    if (catId != null && catId > 0) {
                        insStmt.setInt(1, userId);
                        insStmt.setInt(2, catId);
                        insStmt.addBatch();
                    }
                }
                insStmt.executeBatch();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating user interests for user ID: " + userId, e);
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ignored) {}
            }
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (SQLException ignored) {}
            }
            if (delStmt != null) {
                try { delStmt.close(); } catch (SQLException ignored) {}
            }
            if (insStmt != null) {
                try { insStmt.close(); } catch (SQLException ignored) {}
            }
            DBConnection.close(conn);
        }
        return false;
    }

    public boolean addUserInterest(int userId, int categoryId) {
        String sql = "INSERT IGNORE INTO user_interests (user_id, category_id) VALUES (?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, categoryId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding user interest", e);
        } finally {
            DBConnection.close(conn, pstmt);
        }
        return false;
    }
}
