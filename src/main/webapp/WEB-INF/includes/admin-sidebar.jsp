<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String cp = request.getContextPath();
    String activeTab = request.getParameter("activeTab");
    if (activeTab == null) activeTab = "";
%>

<aside class="sidebar-panel">
    <div style="display: flex; align-items: center; gap: 0.75rem; margin-bottom: 1.5rem; padding-bottom: 1rem; border-bottom: 1px solid var(--border-color);">
        <div class="user-avatar-circle" style="width: 40px; height: 40px; font-size: 1.1rem;">
            A
        </div>
        <div>
            <div style="font-weight: 700; font-size: 0.95rem; color: var(--primary-navy);">Admin Workspace</div>
            <span class="badge badge-teal" style="font-size: 0.7rem;">System Admin</span>
        </div>
    </div>

    <ul class="sidebar-nav-list">
        <li>
            <a href="<%= cp %>/admin/dashboard" class="sidebar-nav-link <%= "dashboard".equals(activeTab) ? "active" : "" %>">
                <i class="bi bi-speedometer2"></i> Dashboard Overview
            </a>
        </li>
        <li>
            <a href="<%= cp %>/admin/books" class="sidebar-nav-link <%= "books".equals(activeTab) ? "active" : "" %>">
                <i class="bi bi-book"></i> Book Inventory
            </a>
        </li>
        <li>
            <a href="<%= cp %>/admin/book-add" class="sidebar-nav-link <%= "book-add".equals(activeTab) ? "active" : "" %>">
                <i class="bi bi-plus-circle"></i> Add New Book
            </a>
        </li>
        <li>
            <a href="<%= cp %>/admin/categories" class="sidebar-nav-link <%= "categories".equals(activeTab) ? "active" : "" %>">
                <i class="bi bi-tags"></i> Subject Categories
            </a>
        </li>
        <li>
            <a href="<%= cp %>/admin/users" class="sidebar-nav-link <%= "users".equals(activeTab) ? "active" : "" %>">
                <i class="bi bi-people"></i> User Management
            </a>
        </li>
        <li style="margin-top: 1rem; padding-top: 1rem; border-top: 1px solid var(--border-color);">
            <a href="<%= cp %>/books" class="sidebar-nav-link">
                <i class="bi bi-arrow-left-circle"></i> Public Catalog
            </a>
        </li>
    </ul>
</aside>
