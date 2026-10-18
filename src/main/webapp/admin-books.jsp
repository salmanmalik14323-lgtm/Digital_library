<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.digitallibrary.model.Book, com.digitallibrary.model.Category" %>
<%
    request.setAttribute("pageTitle", "Manage Books - Admin Workspace");
    String cp = request.getContextPath();
    List<Book> books = (List<Book>) request.getAttribute("books");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    String currentQuery = (String) request.getAttribute("currentQuery");
    if (currentQuery == null) currentQuery = "";
    Integer currentCategory = (Integer) request.getAttribute("currentCategory");
%>
<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="main-content">
    <div class="container" style="padding-top: 2rem;">
        <div class="dashboard-grid">
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/includes/admin-sidebar.jsp">
                <jsp:param name="activeTab" value="books" />
            </jsp:include>

            <!-- Main Content -->
            <div>
                <div class="section-header">
                    <div>
                        <h1 class="section-title"><i class="bi bi-book"></i> Book Catalogue Inventory</h1>
                        <p class="section-subtitle">Add, update, replenish stock copies, and manage library titles.</p>
                    </div>
                    <div>
                        <a href="<%= cp %>/admin/book-add" class="btn btn-primary">
                            <i class="bi bi-plus-circle"></i> Add New Book
                        </a>
                    </div>
                </div>

                <!-- Search & Filter Filter Form -->
                <div class="catalog-controls">
                    <form action="<%= cp %>/admin/books" method="GET" class="catalog-filter-form" style="grid-template-columns: 2fr 1.5fr auto;">
                        <div class="form-group-inline">
                            <input type="text" name="q" placeholder="Filter by title, author, or ISBN..." 
                                   value="<%= currentQuery %>">
                        </div>

                        <div class="form-group-inline">
                            <select name="category" onchange="this.form.submit()">
                                <option value="">All Disciplines</option>
                                <% if (categories != null) {
                                    for (Category cat : categories) {
                                        boolean isSel = (currentCategory != null && currentCategory == cat.getCategoryId()); %>
                                    <option value="<%= cat.getCategoryId() %>" <%= isSel ? "selected" : "" %>>
                                        <%= cat.getName() %>
                                    </option>
                                <%   }
                                   } %>
                            </select>
                        </div>

                        <div style="display: flex; gap: 0.5rem;">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-search"></i>
                            </button>
                            <% if (!currentQuery.isEmpty() || currentCategory != null) { %>
                                <a href="<%= cp %>/admin/books" class="btn btn-secondary">
                                    <i class="bi bi-x-lg"></i>
                                </a>
                            <% } %>
                        </div>
                    </form>
                </div>

                <!-- Books Table -->
                <div class="table-responsive">
                    <table class="custom-table">
                        <thead>
                            <tr>
                                <th>Cover</th>
                                <th>Title &amp; Author</th>
                                <th>Discipline</th>
                                <th>ISBN</th>
                                <th>Stock (Avail/Total)</th>
                                <th>Rating</th>
                                <th style="text-align: right;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (books == null || books.isEmpty()) { %>
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 3rem; color: var(--text-muted);">
                                        No books found in catalogue matching filter criteria.
                                    </td>
                                </tr>
                            <% } else {
                                for (Book book : books) { %>
                                <tr>
                                    <td style="width: 50px;">
                                        <img src="<%= book.getCoverImageUrl() %>" alt="<%= book.getTitle() %>" 
                                             style="width: 44px; height: 60px; object-fit: cover; border-radius: 4px; box-shadow: var(--shadow-sm);">
                                    </td>
                                    <td>
                                        <a href="<%= cp %>/book-details?id=<%= book.getBookId() %>" style="font-weight: 700; color: var(--primary-navy);">
                                            <%= book.getTitle() %>
                                        </a>
                                        <div style="font-size: 0.82rem; color: var(--text-muted);">By <%= book.getAuthor() %> (<%= book.getPublicationYear() %>)</div>
                                    </td>
                                    <td>
                                        <span class="badge badge-teal"><%= book.getCategoryName() != null ? book.getCategoryName() : "General" %></span>
                                    </td>
                                    <td style="font-size: 0.85rem; font-family: monospace;">
                                        <%= book.getIsbn() != null ? book.getIsbn() : "N/A" %>
                                    </td>
                                    <td>
                                        <span class="badge <%= book.getAvailableCopies() > 0 ? "badge-success" : "badge-danger" %>">
                                            <%= book.getAvailableCopies() %> / <%= book.getTotalCopies() %>
                                        </span>
                                    </td>
                                    <td>
                                        <span style="color: #eab308; font-weight: 600;">
                                            <i class="bi bi-star-fill"></i> <%= book.getRating() %>
                                        </span>
                                    </td>
                                    <td style="text-align: right;">
                                        <div class="action-btn-group" style="justify-content: flex-end;">
                                            <a href="<%= cp %>/admin/book-edit?id=<%= book.getBookId() %>" class="btn btn-sm btn-secondary" title="Edit Book">
                                                <i class="bi bi-pencil-square"></i>
                                            </a>
                                            <form action="<%= cp %>/admin/book-delete" method="POST" onsubmit="return confirm('Are you sure you want to delete this book?');" style="margin: 0;">
                                                <input type="hidden" name="bookId" value="<%= book.getBookId() %>">
                                                <button type="submit" class="btn btn-sm btn-danger" title="Delete Book">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            <%   }
                               } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
