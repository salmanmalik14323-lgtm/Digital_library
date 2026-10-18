package com.digitallibrary.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Model representing user activity logs such as viewing a book, searching, or requesting to borrow.
 */
public class BookActivity implements Serializable {
    private static final long serialVersionUID = 1L;

    private int activityId;
    private Integer userId;
    private String username;
    private Integer bookId;
    private String bookTitle;
    private String activityType; // 'VIEW', 'SEARCH', 'BORROW_REQUEST'
    private String searchQuery;
    private Timestamp createdAt;

    public BookActivity() {
    }

    public BookActivity(int activityId, Integer userId, String username, Integer bookId,
                        String bookTitle, String activityType, String searchQuery, Timestamp createdAt) {
        this.activityId = activityId;
        this.userId = userId;
        this.username = username;
        this.bookId = bookId;
        this.bookTitle = bookTitle;
        this.activityType = activityType;
        this.searchQuery = searchQuery;
        this.createdAt = createdAt;
    }

    public int getActivityId() {
        return activityId;
    }

    public void setActivityId(int activityId) {
        this.activityId = activityId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public Integer getBookId() {
        return bookId;
    }

    public void setBookId(Integer bookId) {
        this.bookId = bookId;
    }

    public String getBookTitle() {
        return bookTitle;
    }

    public void setBookTitle(String bookTitle) {
        this.bookTitle = bookTitle;
    }

    public String getActivityType() {
        return activityType;
    }

    public void setActivityType(String activityType) {
        this.activityType = activityType;
    }

    public String getSearchQuery() {
        return searchQuery;
    }

    public void setSearchQuery(String searchQuery) {
        this.searchQuery = searchQuery;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
