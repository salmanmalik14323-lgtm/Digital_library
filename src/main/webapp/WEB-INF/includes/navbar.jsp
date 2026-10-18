<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.digitallibrary.model.User" %>
<%
    String cp = request.getContextPath();
    User currentUser = (User) session.getAttribute("currentUser");
    boolean isLoggedIn = (currentUser != null);
    boolean isAdmin = (isLoggedIn && currentUser.isAdmin());
    String initial = "U";
    if (isLoggedIn && currentUser.getFullName() != null && !currentUser.getFullName().trim().isEmpty()) {
        initial = currentUser.getFullName().trim().substring(0, 1).toUpperCase();
    }
%>

<header class="site-header">
    <div class="container">
        <nav class="navbar">
            <a href="<%= cp %>/home" class="brand-logo">
                <i class="bi bi-journal-bookmark-fill"></i>
                <span>Digital<span class="accent">Lib</span></span>
            </a>

            <button class="mobile-menu-btn" aria-label="Toggle navigation" type="button">
                <i class="bi bi-list"></i>
            </button>

            <ul class="nav-links">
                <li><a href="<%= cp %>/home"><i class="bi bi-house-door"></i> Home</a></li>
                <li><a href="<%= cp %>/books"><i class="bi bi-grid"></i> Catalog</a></li>
                
                <% if (isLoggedIn) { %>
                    <li><a href="<%= cp %>/recommendations"><i class="bi bi-stars"></i> For You</a></li>
                    
                    <% if (isAdmin) { %>
                        <li><a href="<%= cp %>/admin/dashboard"><i class="bi bi-speedometer2"></i> Admin Panel</a></li>
                    <% } else { %>
                        <li><a href="<%= cp %>/user-dashboard"><i class="bi bi-person-workspace"></i> My Shelf</a></li>
                    <% } %>
                <% } %>
            </ul>

            <div class="nav-auth">
                <% if (!isLoggedIn) { %>
                    <a href="<%= cp %>/login" class="btn btn-sm btn-secondary">Log In</a>
                    <a href="<%= cp %>/register" class="btn btn-sm btn-primary">Sign Up</a>
                <% } else { %>
                    <div class="user-badge-menu">
                        <button class="user-badge-trigger" type="button">
                            <span class="user-avatar-circle"><%= initial %></span>
                            <span><%= currentUser.getUsername() %></span>
                            <i class="bi bi-chevron-down" style="font-size: 0.75rem;"></i>
                        </button>
                        <div class="dropdown-panel">
                            <a href="<%= cp %>/profile" class="dropdown-item">
                                <i class="bi bi-person"></i> My Profile
                            </a>
                            <% if (!isAdmin) { %>
                                <a href="<%= cp %>/user-dashboard" class="dropdown-item">
                                    <i class="bi bi-bookmarks"></i> Reading Activity
                                </a>
                                <a href="<%= cp %>/recommendations" class="dropdown-item">
                                    <i class="bi bi-sliders"></i> Edit Interests
                                </a>
                            <% } else { %>
                                <a href="<%= cp %>/admin/books" class="dropdown-item">
                                    <i class="bi bi-book"></i> Manage Books
                                </a>
                                <a href="<%= cp %>/admin/categories" class="dropdown-item">
                                    <i class="bi bi-tags"></i> Manage Categories
                                </a>
                                <a href="<%= cp %>/admin/users" class="dropdown-item">
                                    <i class="bi bi-people"></i> Manage Users
                                </a>
                            <% } %>
                            <a href="<%= cp %>/logout" class="dropdown-item" style="color: #ef4444;">
                                <i class="bi bi-box-arrow-right"></i> Log Out
                            </a>
                        </div>
                    </div>
                <% } %>
            </div>
        </nav>
    </div>
</header>

<!-- Global Alert Flash Messages -->
<div class="container" style="margin-top: 1.25rem;">
<%
    String successMsg = (String) session.getAttribute("successMessage");
    if (successMsg != null) {
        session.removeAttribute("successMessage");
%>
    <div class="alert alert-success">
        <i class="bi bi-check-circle-fill"></i>
        <div><%= successMsg %></div>
    </div>
<% } %>

<%
    String reqSuccessMsg = (String) request.getAttribute("successMessage");
    if (reqSuccessMsg != null) {
%>
    <div class="alert alert-success">
        <i class="bi bi-check-circle-fill"></i>
        <div><%= reqSuccessMsg %></div>
    </div>
<% } %>

<%
    String errorMsg = (String) session.getAttribute("errorMessage");
    if (errorMsg != null) {
        session.removeAttribute("errorMessage");
%>
    <div class="alert alert-danger">
        <i class="bi bi-exclamation-triangle-fill"></i>
        <div><%= errorMsg %></div>
    </div>
<% } %>

<%
    String reqErrorMsg = (String) request.getAttribute("errorMessage");
    if (reqErrorMsg != null) {
%>
    <div class="alert alert-danger">
        <i class="bi bi-exclamation-triangle-fill"></i>
        <div><%= reqErrorMsg %></div>
    </div>
<% } %>

<%
    String infoMsg = (String) request.getAttribute("infoMessage");
    if (infoMsg != null) {
%>
    <div class="alert alert-info">
        <i class="bi bi-info-circle-fill"></i>
        <div><%= infoMsg %></div>
    </div>
<% } %>
</div>
