package com.digitallibrary.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Model representing a User's preference/interest in a specific Category.
 */
public class UserInterest implements Serializable {
    private static final long serialVersionUID = 1L;

    private int interestId;
    private int userId;
    private int categoryId;
    private String categoryName;
    private Timestamp createdAt;

    public UserInterest() {
    }

    public UserInterest(int interestId, int userId, int categoryId, String categoryName, Timestamp createdAt) {
        this.interestId = interestId;
        this.userId = userId;
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.createdAt = createdAt;
    }

    public int getInterestId() {
        return interestId;
    }

    public void setInterestId(int interestId) {
        this.interestId = interestId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
