<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.digitallibrary.model.Book, com.digitallibrary.model.User" %>
<%
    Book book = (Book) request.getAttribute("book");
    if (book == null) {
        response.sendRedirect(request.getContextPath() + "/books");
        return;
    }
    request.setAttribute("pageTitle", book.getTitle() + " - Digital Library");
    String cp = request.getContextPath();
    List<Book> relatedBooks = (List<Book>) request.getAttribute("relatedBooks");
    User currentUser = (User) session.getAttribute("currentUser");
    boolean isAdmin = (currentUser != null && currentUser.isAdmin());
%>
<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="main-content">
    <div class="container" style="padding-top: 2rem;">
        <!-- Breadcrumbs -->
        <div style="font-size: 0.88rem; color: var(--text-muted); margin-bottom: 1.5rem; display: flex; align-items: center; gap: 0.5rem;">
            <a href="<%= cp %>/home">Home</a>
            <i class="bi bi-chevron-right" style="font-size: 0.75rem;"></i>
            <a href="<%= cp %>/books">Catalog</a>
            <i class="bi bi-chevron-right" style="font-size: 0.75rem;"></i>
            <a href="<%= cp %>/books?category=<%= book.getCategoryId() %>"><%= book.getCategoryName() != null ? book.getCategoryName() : "Category" %></a>
            <i class="bi bi-chevron-right" style="font-size: 0.75rem;"></i>
            <span style="color: var(--primary-navy); font-weight: 600;"><%= book.getTitle() %></span>
        </div>

        <!-- Book Details Container -->
        <div class="book-details-wrapper">
            <div class="book-details-grid">
                <!-- Cover Column -->
                <div class="book-cover-panel">
                    <img src="<%= book.getCoverImageUrl() %>" alt="<%= book.getTitle() %>">
                    <div style="margin-top: 1.5rem; width: 100%; max-width: 300px;">
                        <% if (book.isAvailable()) { %>
                            <div style="background: var(--success-bg); border: 1px solid #a7f3d0; color: #065f46; padding: 0.75rem; border-radius: var(--radius-md); text-align: center; font-weight: 600; font-size: 0.9rem; margin-bottom: 0.75rem;">
                                <i class="bi bi-check-circle-fill"></i> Available for Checkout (<%= book.getAvailableCopies() %> of <%= book.getTotalCopies() %>)
                            </div>
                        <% } else { %>
                            <div style="background: var(--danger-bg); border: 1px solid #fecaca; color: #991b1b; padding: 0.75rem; border-radius: var(--radius-md); text-align: center; font-weight: 600; font-size: 0.9rem; margin-bottom: 0.75rem;">
                                <i class="bi bi-exclamation-circle-fill"></i> Currently All Copies Checked Out
                            </div>
                        <% } %>

                        <button type="button" class="btn btn-primary" style="width: 100%;" onclick="alert('Borrow request registered for student evaluation tracking.');">
                            <i class="bi bi-journal-arrow-down"></i> Request Physical / Digital Copy
                        </button>
                    </div>
                </div>

                <!-- Info Column -->
                <div>
                    <span class="badge badge-teal" style="margin-bottom: 0.75rem;"><%= book.getCategoryName() != null ? book.getCategoryName() : "General" %></span>
                    <h1 style="font-size: 2.2rem; font-weight: 800; color: var(--primary-navy); line-height: 1.2; margin-bottom: 0.5rem;">
                        <%= book.getTitle() %>
                    </h1>
                    <div style="font-size: 1.15rem; color: var(--text-muted); margin-bottom: 1.25rem;">
                        By <strong style="color: var(--primary-navy);"><%= book.getAuthor() %></strong>
                    </div>

                    <div style="display: flex; align-items: center; gap: 1.5rem; margin-bottom: 1.5rem; padding-bottom: 1.25rem; border-bottom: 1px solid var(--border-color);">
                        <div class="book-rating" style="font-size: 1.1rem;">
                            <i class="bi bi-star-fill"></i>
                            <span class="score" style="font-size: 1.1rem;"><%= book.getRating() %> / 5.0</span>
                        </div>
                        <div style="color: var(--text-muted); font-size: 0.9rem;">
                            <i class="bi bi-calendar3"></i> Published in <strong><%= book.getPublicationYear() %></strong>
                        </div>
                        <div style="color: var(--text-muted); font-size: 0.9rem;">
                            <i class="bi bi-file-earmark-text"></i> <strong><%= book.getPageCount() %></strong> Pages
                        </div>
                    </div>

                    <h3 style="font-size: 1.1rem; font-weight: 700; color: var(--primary-navy); margin-bottom: 0.75rem;">
                        Synopsis &amp; Academic Scope
                    </h3>
                    <div class="book-description-text">
                        <%= book.getDescription() != null ? book.getDescription() : "Comprehensive reference manual for advanced computing coursework." %>
                    </div>

                    <!-- Metadata Table Grid -->
                    <div class="book-meta-list">
                        <div class="book-meta-item">
                            <span class="label">Publisher</span>
                            <span class="value"><%= book.getPublisher() != null ? book.getPublisher() : "Academic Press" %></span>
                        </div>
                        <div class="book-meta-item">
                            <span class="label">ISBN-13</span>
                            <span class="value"><%= book.getIsbn() != null ? book.getIsbn() : "N/A" %></span>
                        </div>
                        <div class="book-meta-item">
                            <span class="label">Subject Classification</span>
                            <span class="value"><%= book.getCategoryName() != null ? book.getCategoryName() : "General" %></span>
                        </div>
                        <div class="book-meta-item">
                            <span class="label">Total Library Copies</span>
                            <span class="value"><%= book.getTotalCopies() %> Copies</span>
                        </div>
                    </div>

                    <div style="margin-top: 1.5rem; display: flex; gap: 1rem;">
                        <a href="<%= cp %>/books" class="btn btn-secondary">
                            <i class="bi bi-arrow-left"></i> Back to Catalog
                        </a>
                        <% if (isAdmin) { %>
                            <a href="<%= cp %>/admin/book-edit?id=<%= book.getBookId() %>" class="btn btn-navy">
                                <i class="bi bi-pencil"></i> Edit Book Details
                            </a>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <!-- Related Recommendations Shelf -->
        <% if (relatedBooks != null && !relatedBooks.isEmpty()) { %>
            <div style="margin-top: 3rem;">
                <div class="section-header">
                    <div>
                        <h2 class="section-title"><i class="bi bi-collection"></i> Related Works in <%= book.getCategoryName() %></h2>
                        <p class="section-subtitle">Complementary academic literature covering related computational paradigms.</p>
                    </div>
                </div>

                <div class="book-grid">
                    <% for (Book relBook : relatedBooks) { %>
                        <div class="book-card">
                            <div class="book-card-cover">
                                <img src="<%= relBook.getCoverImageUrl() %>" alt="<%= relBook.getTitle() %>" loading="lazy">
                                <span class="book-card-category-badge"><%= relBook.getCategoryName() != null ? relBook.getCategoryName() : "General" %></span>
                            </div>
                            <div class="book-card-body">
                                <div class="book-rating">
                                    <i class="bi bi-star-fill"></i>
                                    <span class="score"><%= relBook.getRating() %></span>
                                </div>
                                <h3 class="book-title" title="<%= relBook.getTitle() %>"><%= relBook.getTitle() %></h3>
                                <div class="book-author"><i class="bi bi-person"></i> <%= relBook.getAuthor() %></div>
                                
                                <div class="book-card-footer">
                                    <div class="availability-status <%= relBook.isAvailable() ? "available" : "out" %>">
                                        <i class="bi <%= relBook.isAvailable() ? "bi-check-circle-fill" : "bi-dash-circle-fill" %>"></i>
                                        <span><%= relBook.isAvailable() ? "In Stock" : "Out of Stock" %></span>
                                    </div>
                                    <a href="<%= cp %>/book-details?id=<%= relBook.getBookId() %>" class="btn btn-sm btn-navy">
                                        Details
                                    </a>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
        <% } %>
    </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
