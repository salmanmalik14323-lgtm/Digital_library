package com.digitallibrary.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Model representing a generated book recommendation for a user.
 */
public class Recommendation implements Serializable {
    private static final long serialVersionUID = 1L;

    private int recommendationId;
    private int userId;
    private int bookId;
    private Book book; // Attached Book details
    private double matchScore;
    private String reason;
    private Timestamp generatedAt;

    public Recommendation() {
    }

    public Recommendation(int recommendationId, int userId, int bookId, Book book,
                          double matchScore, String reason, Timestamp generatedAt) {
        this.recommendationId = recommendationId;
        this.userId = userId;
        this.bookId = bookId;
        this.book = book;
        this.matchScore = matchScore;
        this.reason = reason;
        this.generatedAt = generatedAt;
    }

    public int getRecommendationId() {
        return recommendationId;
    }

    public void setRecommendationId(int recommendationId) {
        this.recommendationId = recommendationId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public Book getBook() {
        return book;
    }

    public void setBook(Book book) {
        this.book = book;
    }

    public double getMatchScore() {
        return matchScore;
    }

    public void setMatchScore(double matchScore) {
        this.matchScore = matchScore;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public Timestamp getGeneratedAt() {
        return generatedAt;
    }

    public void setGeneratedAt(Timestamp generatedAt) {
        this.generatedAt = generatedAt;
    }
}
