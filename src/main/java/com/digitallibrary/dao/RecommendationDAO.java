package com.digitallibrary.dao;

import com.digitallibrary.model.Book;
import com.digitallibrary.model.Recommendation;
import com.digitallibrary.util.DBConnection;
import com.digitallibrary.util.RecommendationEngine;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for persisting and querying Recommendations.
 */
public class RecommendationDAO {
    private static final Logger LOGGER = Logger.getLogger(RecommendationDAO.class.getName());

    private final BookDAO bookDAO = new BookDAO();
    private final UserInterestDAO userInterestDAO = new UserInterestDAO();
    private final BookActivityDAO bookActivityDAO = new BookActivityDAO();

    public List<Recommendation> getCachedRecommendations(int userId, int limit) {
        List<Recommendation> list = new ArrayList<>();
        String sql = "SELECT r.*, b.title, b.author, b.isbn, b.publisher, b.publication_year, " +
                     "b.category_id, b.description, b.cover_image_url, b.total_copies, " +
                     "b.available_copies, b.rating, b.page_count, c.name AS category_name " +
                     "FROM recommendations r " +
                     "JOIN books b ON r.book_id = b.book_id " +
                     "JOIN categories c ON b.category_id = c.category_id " +
                     "WHERE r.user_id = ? " +
                     "ORDER BY r.match_score DESC " +
                     "LIMIT ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, limit > 0 ? limit : 12);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Recommendation rec = new Recommendation();
                rec.setRecommendationId(rs.getInt("recommendation_id"));
                rec.setUserId(rs.getInt("user_id"));
                rec.setBookId(rs.getInt("book_id"));
                rec.setMatchScore(rs.getDouble("match_score"));
                rec.setReason(rs.getString("reason"));
                rec.setGeneratedAt(rs.getTimestamp("generated_at"));

                Book book = new Book();
                book.setBookId(rs.getInt("book_id"));
                book.setTitle(rs.getString("title"));
                book.setAuthor(rs.getString("author"));
                book.setIsbn(rs.getString("isbn"));
                book.setPublisher(rs.getString("publisher"));
                book.setPublicationYear(rs.getInt("publication_year"));
                book.setCategoryId(rs.getInt("category_id"));
                book.setCategoryName(rs.getString("category_name"));
                book.setDescription(rs.getString("description"));
                book.setCoverImageUrl(rs.getString("cover_image_url"));
                book.setTotalCopies(rs.getInt("total_copies"));
                book.setAvailableCopies(rs.getInt("available_copies"));
                book.setRating(rs.getDouble("rating"));
                book.setPageCount(rs.getInt("page_count"));
                rec.setBook(book);

                list.add(rec);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching cached recommendations for user ID: " + userId, e);
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }
        return list;
    }

    public boolean saveRecommendations(int userId, List<Recommendation> recommendations) {
        String deleteSql = "DELETE FROM recommendations WHERE user_id = ?";
        String insertSql = "INSERT INTO recommendations (user_id, book_id, match_score, reason) VALUES (?, ?, ?, ?) " +
                           "ON DUPLICATE KEY UPDATE match_score = VALUES(match_score), reason = VALUES(reason)";
        Connection conn = null;
        PreparedStatement delStmt = null;
        PreparedStatement insStmt = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            delStmt = conn.prepareStatement(deleteSql);
            delStmt.setInt(1, userId);
            delStmt.executeUpdate();

            if (recommendations != null && !recommendations.isEmpty()) {
                insStmt = conn.prepareStatement(insertSql);
                for (Recommendation rec : recommendations) {
                    insStmt.setInt(1, userId);
                    insStmt.setInt(2, rec.getBookId());
                    insStmt.setDouble(3, rec.getMatchScore());
                    insStmt.setString(4, rec.getReason());
                    insStmt.addBatch();
                }
                insStmt.executeBatch();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error saving recommendations for user ID: " + userId, e);
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

    /**
     * Recomputes recommendations using content-based algorithm, updates database cache, and returns fresh results.
     */
    public List<Recommendation> refreshRecommendationsForUser(int userId, int limit) {
        List<Book> allBooks = bookDAO.getAllBooks();
        Set<Integer> userInterests = userInterestDAO.getUserInterestCategoryIds(userId);
        Map<Integer, Integer> categoryViews = bookActivityDAO.getCategoryViewCounts(userId);

        List<Recommendation> computed = RecommendationEngine.generateRecommendations(
            userId, allBooks, userInterests, categoryViews, limit > 0 ? limit : 12
        );

        saveRecommendations(userId, computed);
        return computed;
    }
}
