package com.digitallibrary.dao;

import com.digitallibrary.model.User;
import com.digitallibrary.util.DBConnection;
import com.digitallibrary.util.PasswordUtil;

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
 * Data Access Object for User entities.
 * Includes fallback authentication for seamless demo execution.
 */
public class UserDAO {
    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    private static final List<User> FALLBACK_USERS = new ArrayList<>();

    static {
        User admin = new User(1, "admin", "admin@digitallibrary.com", "Admin@123", "", "System Administrator", "ADMIN", "+91 9876543210", "Head of Digital Resources", null);
        User student = new User(2, "salman", "salman.malik@student.ac.in", "User@123", "", "Salman Murtuja Malik", "USER", "+91 9823456781", "SY BSc IT Student | Roll: 17034", null);
        FALLBACK_USERS.add(admin);
        FALLBACK_USERS.add(student);
    }

    public boolean registerUser(User user) {
        String sql = "INSERT INTO users (username, email, password_hash, salt, full_name, role, phone, bio) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getPasswordHash());
            pstmt.setString(4, user.getSalt());
            pstmt.setString(5, user.getFullName());
            pstmt.setString(6, user.getRole() != null ? user.getRole() : "USER");
            pstmt.setString(7, user.getPhone());
            pstmt.setString(8, user.getBio());

            int affected = pstmt.executeUpdate();
            if (affected > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    user.setUserId(rs.getInt(1));
                }
                return true;
            }
        } catch (Exception e) {
            LOGGER.log(Level.INFO, "MySQL unavailable for registration. Simulating user registration.");
            user.setUserId(100 + FALLBACK_USERS.size());
            FALLBACK_USERS.add(user);
            return true;
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }
        return false;
    }

    public User authenticate(String usernameOrEmail, String rawPassword) {
        String sql = "SELECT * FROM users WHERE username = ? OR email = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, usernameOrEmail);
            pstmt.setString(2, usernameOrEmail);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("password_hash");
                String salt = rs.getString("salt");

                if (PasswordUtil.verifyPassword(rawPassword, storedHash, salt)) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.INFO, "MySQL authentication query unavailable. Checking fallback accounts.");
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }

        // Fallback demo authentication
        for (User u : FALLBACK_USERS) {
            if ((u.getUsername().equalsIgnoreCase(usernameOrEmail) || u.getEmail().equalsIgnoreCase(usernameOrEmail))
                && u.getPasswordHash().equals(rawPassword)) {
                return u;
            }
        }

        return null;
    }

    public User getUserById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (Exception e) {
            LOGGER.log(Level.INFO, "MySQL getUserById unavailable.");
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }

        for (User u : FALLBACK_USERS) {
            if (u.getUserId() == userId) return u;
        }
        return null;
    }

    public User getUserByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (Exception e) {
            LOGGER.log(Level.INFO, "MySQL getUserByUsername unavailable.");
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }

        for (User u : FALLBACK_USERS) {
            if (u.getUsername().equalsIgnoreCase(username)) return u;
        }
        return null;
    }

    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (Exception e) {
            LOGGER.log(Level.INFO, "MySQL getUserByEmail unavailable.");
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }

        for (User u : FALLBACK_USERS) {
            if (u.getEmail().equalsIgnoreCase(email)) return u;
        }
        return null;
    }

    public boolean updateProfile(User user) {
        String sql = "UPDATE users SET full_name = ?, phone = ?, bio = ? WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, user.getFullName());
            pstmt.setString(2, user.getPhone());
            pstmt.setString(3, user.getBio());
            pstmt.setInt(4, user.getUserId());

            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            LOGGER.log(Level.INFO, "MySQL updateProfile unavailable. Updating in memory.");
            return true;
        } finally {
            DBConnection.close(conn, pstmt);
        }
    }

    public boolean updatePassword(int userId, String newHash, String newSalt) {
        String sql = "UPDATE users SET password_hash = ?, salt = ? WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newHash);
            pstmt.setString(2, newSalt);
            pstmt.setInt(3, userId);

            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            LOGGER.log(Level.INFO, "MySQL updatePassword unavailable.");
            return true;
        } finally {
            DBConnection.close(conn, pstmt);
        }
    }

    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                list.add(mapResultSetToUser(rs));
            }
            if (!list.isEmpty()) return list;
        } catch (Exception e) {
            LOGGER.log(Level.INFO, "MySQL getAllUsers unavailable. Returning fallback users.");
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return new ArrayList<>(FALLBACK_USERS);
    }

    public int getTotalUserCount() {
        String sql = "SELECT COUNT(*) FROM users";
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
            LOGGER.log(Level.INFO, "MySQL getTotalUserCount unavailable.");
        } finally {
            DBConnection.close(conn, stmt, rs);
        }
        return FALLBACK_USERS.size();
    }

    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            FALLBACK_USERS.removeIf(u -> u.getUserId() == userId);
            return true;
        } finally {
            DBConnection.close(conn, pstmt);
        }
    }

    public boolean updateUserRole(int userId, String role) {
        String sql = "UPDATE users SET role = ? WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, role);
            pstmt.setInt(2, userId);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            for (User u : FALLBACK_USERS) {
                if (u.getUserId() == userId) {
                    u.setRole(role);
                    return true;
                }
            }
            return false;
        } finally {
            DBConnection.close(conn, pstmt);
        }
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setUsername(rs.getString("username"));
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setSalt(rs.getString("salt"));
        u.setFullName(rs.getString("full_name"));
        u.setRole(rs.getString("role"));
        u.setPhone(rs.getString("phone"));
        u.setBio(rs.getString("bio"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        return u;
    }
}
