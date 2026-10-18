<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.digitallibrary.model.Book, com.digitallibrary.model.Category" %>
<%
    String formAction = (String) request.getAttribute("formAction");
    boolean isEdit = "edit".equals(formAction);
    Book book = (Book) request.getAttribute("book");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    request.setAttribute("pageTitle", (isEdit ? "Edit Book" : "Add New Book") + " - Admin Workspace");
    String cp = request.getContextPath();
%>
<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="main-content">
    <div class="container container-narrow" style="padding-top: 2rem;">
        <div style="margin-bottom: 1.5rem; display: flex; align-items: center; gap: 0.5rem; font-size: 0.9rem; color: var(--text-muted);">
            <a href="<%= cp %>/admin/dashboard">Admin</a>
            <i class="bi bi-chevron-right" style="font-size: 0.75rem;"></i>
            <a href="<%= cp %>/admin/books">Inventory</a>
            <i class="bi bi-chevron-right" style="font-size: 0.75rem;"></i>
            <span style="color: var(--primary-navy); font-weight: 600;"><%= isEdit ? "Edit Title" : "New Book Entry" %></span>
        </div>

        <div style="background: #ffffff; border: 1px solid var(--border-color); border-radius: var(--radius-lg); padding: 2.5rem; box-shadow: var(--shadow-md);">
            <div style="border-bottom: 1px solid var(--border-color); padding-bottom: 1rem; margin-bottom: 1.75rem;">
                <h1 style="font-size: 1.6rem; font-weight: 800; color: var(--primary-navy);">
                    <i class="bi <%= isEdit ? "bi-pencil-square" : "bi-plus-circle-fill" %>" style="color: var(--primary-teal);"></i>
                    <%= isEdit ? "Edit Book Catalogue Entry" : "Add New Book to Library" %>
                </h1>
                <p style="color: var(--text-muted); font-size: 0.9rem; margin-top: 0.25rem;">
                    Ensure publication details, category classification, and stock metrics are accurately maintained.
                </p>
            </div>

            <form action="<%= cp %>/admin/<%= isEdit ? "book-edit" : "book-add" %>" method="POST">
                <% if (isEdit && book != null) { %>
                    <input type="hidden" name="bookId" value="<%= book.getBookId() %>">
                <% } %>

                <div class="form-group">
                    <label for="title">Book Title *</label>
                    <input type="text" id="title" name="title" class="form-control" 
                           value="<%= (isEdit && book != null) ? book.getTitle() : "" %>" placeholder="e.g. Core Java: Fundamentals" required>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <div class="form-group">
                        <label for="author">Author(s) *</label>
                        <input type="text" id="author" name="author" class="form-control" 
                               value="<%= (isEdit && book != null) ? book.getAuthor() : "" %>" placeholder="e.g. Cay S. Horstmann" required>
                    </div>

                    <div class="form-group">
                        <label for="categoryId">Subject Category / Discipline *</label>
                        <select id="categoryId" name="categoryId" class="form-control" required>
                            <% if (categories != null) {
                                for (Category cat : categories) {
                                    boolean sel = (isEdit && book != null && book.getCategoryId() == cat.getCategoryId()); %>
                                <option value="<%= cat.getCategoryId() %>" <%= sel ? "selected" : "" %>>
                                    <%= cat.getName() %>
                                </option>
                            <%   }
                               } %>
                        </select>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 1rem;">
                    <div class="form-group">
                        <label for="isbn">ISBN-13</label>
                        <input type="text" id="isbn" name="isbn" class="form-control" 
                               value="<%= (isEdit && book != null && book.getIsbn() != null) ? book.getIsbn() : "" %>" placeholder="e.g. 978-0137871070">
                    </div>

                    <div class="form-group">
                        <label for="publisher">Publisher</label>
                        <input type="text" id="publisher" name="publisher" class="form-control" 
                               value="<%= (isEdit && book != null && book.getPublisher() != null) ? book.getPublisher() : "" %>" placeholder="e.g. Pearson">
                    </div>

                    <div class="form-group">
                        <label for="publicationYear">Publication Year</label>
                        <input type="number" id="publicationYear" name="publicationYear" class="form-control" 
                               value="<%= (isEdit && book != null) ? book.getPublicationYear() : 2024 %>" min="1950" max="2030">
                    </div>
                </div>

                <div class="form-group">
                    <label for="description">Book Description &amp; Syllabus Coverage</label>
                    <textarea id="description" name="description" class="form-control" rows="4" 
                              placeholder="Academic synopsis and key topics covered..."><%= (isEdit && book != null && book.getDescription() != null) ? book.getDescription() : "" %></textarea>
                </div>

                <div class="form-group">
                    <label for="coverImageUrl">Cover Image URL</label>
                    <input type="url" id="coverImageUrl" name="coverImageUrl" class="form-control" 
                           value="<%= (isEdit && book != null && book.getCoverImageUrl() != null) ? book.getCoverImageUrl() : "" %>" 
                           placeholder="https://images.unsplash.com/photo-...">
                    <small style="color: var(--text-muted); font-size: 0.8rem; margin-top: 0.25rem; display: block;">
                        Leave blank to use modern generic academic textbook fallback cover.
                    </small>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr 1fr 1fr; gap: 1rem;">
                    <div class="form-group">
                        <label for="totalCopies">Total Copies</label>
                        <input type="number" id="totalCopies" name="totalCopies" class="form-control" 
                               value="<%= (isEdit && book != null) ? book.getTotalCopies() : 5 %>" min="1">
                    </div>

                    <div class="form-group">
                        <label for="availableCopies">Available Copies</label>
                        <input type="number" id="availableCopies" name="availableCopies" class="form-control" 
                               value="<%= (isEdit && book != null) ? book.getAvailableCopies() : 5 %>" min="0">
                    </div>

                    <div class="form-group">
                        <label for="rating">Rating (0.0 - 5.0)</label>
                        <input type="number" step="0.1" id="rating" name="rating" class="form-control" 
                               value="<%= (isEdit && book != null) ? book.getRating() : 4.5 %>" min="1.0" max="5.0">
                    </div>

                    <div class="form-group">
                        <label for="pageCount">Page Count</label>
                        <input type="number" id="pageCount" name="pageCount" class="form-control" 
                               value="<%= (isEdit && book != null) ? book.getPageCount() : 450 %>" min="1">
                    </div>
                </div>

                <div style="display: flex; justify-content: flex-end; gap: 1rem; margin-top: 2rem; padding-top: 1.25rem; border-top: 1px solid var(--border-color);">
                    <a href="<%= cp %>/admin/books" class="btn btn-secondary">
                        Cancel
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-lg"></i> <%= isEdit ? "Update Book" : "Save Book to Catalog" %>
                    </button>
                </div>
            </form>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
