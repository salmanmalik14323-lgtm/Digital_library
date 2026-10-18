<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.digitallibrary.model.Book, com.digitallibrary.model.Category" %>
<%
    request.setAttribute("pageTitle", "Library Catalog - Digital Library");
    String cp = request.getContextPath();
    List<Book> books = (List<Book>) request.getAttribute("books");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    String currentQuery = (String) request.getAttribute("currentQuery");
    if (currentQuery == null) currentQuery = "";
    Integer currentCategory = (Integer) request.getAttribute("currentCategory");
    String currentSort = (String) request.getAttribute("currentSort");
    if (currentSort == null) currentSort = "title";
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    if (currentPage == null) currentPage = 1;
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    if (totalPages == null) totalPages = 1;
    Integer totalCount = (Integer) request.getAttribute("totalCount");
    if (totalCount == null) totalCount = (books != null ? books.size() : 0);
%>
<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="main-content">
    <div class="container" style="padding-top: 2rem;">
        <!-- Header -->
        <div class="section-header">
            <div>
                <h1 class="section-title"><i class="bi bi-book-half"></i> Library Catalog</h1>
                <p class="section-subtitle">Browse academic textbooks, reference works, and technical monographs.</p>
            </div>
            <div>
                <span class="badge badge-teal" style="font-size: 0.85rem; padding: 0.4rem 0.85rem;">
                    Showing <%= totalCount %> Result<%= totalCount == 1 ? "" : "s" %>
                </span>
            </div>
        </div>

        <!-- Filter & Search Controls Bar -->
        <div class="catalog-controls">
            <form action="<%= cp %>/books" method="GET" class="catalog-filter-form">
                <div class="form-group-inline">
                    <input type="text" name="q" placeholder="Search by title, author, keyword, or ISBN..." 
                           value="<%= currentQuery %>">
                </div>

                <div class="form-group-inline">
                    <select name="category">
                        <option value="">All Academic Disciplines</option>
                        <% if (categories != null) {
                            for (Category cat : categories) {
                                boolean isSel = (currentCategory != null && currentCategory == cat.getCategoryId()); %>
                            <option value="<%= cat.getCategoryId() %>" <%= isSel ? "selected" : "" %>>
                                <%= cat.getName() %> (<%= cat.getBookCount() %>)
                            </option>
                        <%   }
                           } %>
                    </select>
                </div>

                <div class="form-group-inline">
                    <select name="sort">
                        <option value="title" <%= "title".equals(currentSort) ? "selected" : "" %>>Sort by Title (A-Z)</option>
                        <option value="rating" <%= "rating".equals(currentSort) ? "selected" : "" %>>Highest Rated</option>
                        <option value="year" <%= "year".equals(currentSort) ? "selected" : "" %>>Publication Year</option>
                        <option value="newest" <%= "newest".equals(currentSort) ? "selected" : "" %>>Recently Added</option>
                    </select>
                </div>

                <div style="display: flex; gap: 0.5rem;">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-search"></i> Filter
                    </button>
                    <% if (!currentQuery.isEmpty() || currentCategory != null || !"title".equals(currentSort)) { %>
                        <a href="<%= cp %>/books" class="btn btn-secondary" title="Reset Filters">
                            <i class="bi bi-x-circle"></i>
                        </a>
                    <% } %>
                </div>
            </form>
        </div>

        <!-- Catalog Grid -->
        <% if (books == null || books.isEmpty()) { %>
            <div style="text-align: center; padding: 4rem 1rem; background: #ffffff; border-radius: var(--radius-lg); border: 1px dashed var(--border-color);">
                <i class="bi bi-search" style="font-size: 3rem; color: var(--text-muted); margin-bottom: 1rem; display: block;"></i>
                <h3 style="color: var(--primary-navy); margin-bottom: 0.5rem;">No Books Found</h3>
                <p style="color: var(--text-muted); max-width: 500px; margin: 0 auto 1.5rem;">
                    We couldn't find any books matching your search query or selected category filter.
                </p>
                <a href="<%= cp %>/books" class="btn btn-primary">
                    Clear All Filters
                </a>
            </div>
        <% } else { %>
            <div class="book-grid">
                <% for (Book book : books) { %>
                    <div class="book-card">
                        <div class="book-card-cover">
                            <img src="<%= book.getCoverImageUrl() %>" alt="<%= book.getTitle() %>" loading="lazy">
                            <span class="book-card-category-badge"><%= book.getCategoryName() != null ? book.getCategoryName() : "General" %></span>
                        </div>
                        <div class="book-card-body">
                            <div class="book-rating">
                                <i class="bi bi-star-fill"></i>
                                <span class="score"><%= book.getRating() %></span>
                                <span style="color: var(--text-muted); font-size: 0.78rem;">(<%= book.getPublicationYear() %>)</span>
                            </div>
                            <h3 class="book-title" title="<%= book.getTitle() %>"><%= book.getTitle() %></h3>
                            <div class="book-author"><i class="bi bi-person"></i> <%= book.getAuthor() %></div>
                            
                            <div class="book-card-footer">
                                <div class="availability-status <%= book.isAvailable() ? "available" : "out" %>">
                                    <i class="bi <%= book.isAvailable() ? "bi-check-circle-fill" : "bi-dash-circle-fill" %>"></i>
                                    <span><%= book.isAvailable() ? "In Stock (" + book.getAvailableCopies() + ")" : "Out of Stock" %></span>
                                </div>
                                <a href="<%= cp %>/book-details?id=<%= book.getBookId() %>" class="btn btn-sm btn-navy">
                                    Details
                                </a>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>

            <!-- Pagination -->
            <% if (totalPages > 1) { %>
                <div style="display: flex; justify-content: center; gap: 0.5rem; margin-top: 3rem;">
                    <% for (int p = 1; p <= totalPages; p++) { %>
                        <a href="<%= cp %>/books?page=<%= p %>&q=<%= currentQuery %>&category=<%= currentCategory != null ? currentCategory : "" %>&sort=<%= currentSort %>" 
                           class="btn btn-sm <%= p == currentPage ? "btn-primary" : "btn-secondary" %>">
                            <%= p %>
                        </a>
                    <% } %>
                </div>
            <% } %>
        <% } %>
    </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
