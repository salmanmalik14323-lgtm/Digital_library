<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.digitallibrary.model.Book, com.digitallibrary.model.Category, com.digitallibrary.model.User, com.digitallibrary.dao.BookDAO, com.digitallibrary.dao.CategoryDAO, com.digitallibrary.dao.UserDAO" %>
<%
    request.setAttribute("pageTitle", "Digital Library & Academic Recommendation System");
    String cp = request.getContextPath();
    
    // Self-healing: if accessed directly without servlet forward, load default dataset
    List<Book> featuredBooks = (List<Book>) request.getAttribute("featuredBooks");
    if (featuredBooks == null) {
        featuredBooks = new BookDAO().getFeaturedBooks(6);
    }
    
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    if (categories == null) {
        categories = new CategoryDAO().getAllCategories();
    }
    
    Object statTotalBooks = request.getAttribute("statTotalBooks");
    if (statTotalBooks == null) {
        statTotalBooks = new BookDAO().getTotalBookCount();
    }
    
    Object statTotalCopies = request.getAttribute("statTotalCopies");
    if (statTotalCopies == null) {
        statTotalCopies = new BookDAO().getTotalCopiesCount();
    }
    
    Object statTotalCategories = request.getAttribute("statTotalCategories");
    if (statTotalCategories == null) {
        statTotalCategories = new CategoryDAO().getTotalCategoryCount();
    }
    
    Object statTotalUsers = request.getAttribute("statTotalUsers");
    if (statTotalUsers == null) {
        statTotalUsers = new UserDAO().getTotalUserCount();
    }
    
    User currentUser = (User) session.getAttribute("currentUser");
%>
<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="main-content">
    <!-- Hero Banner -->
    <section class="hero-banner">
        <div class="container">
            <div class="hero-content">
                <div class="hero-tag">
                    <i class="bi bi-mortarboard-fill"></i> Next-Gen Academic Resource Portal
                </div>
                <h1 class="hero-title">
                    Discover Knowledge with Personalized Recommendations
                </h1>
                <p class="hero-subtitle">
                    Explore curated textbooks, reference materials, and software engineering classics tailored specifically to your academic interests and reading journey.
                </p>

                <!-- Search Bar -->
                <form action="<%= cp %>/books" method="GET" class="hero-search-box">
                    <i class="bi bi-search search-icon"></i>
                    <input type="text" name="q" placeholder="Search by book title, author, topic, or ISBN..." required>
                    <button type="submit" class="btn btn-primary btn-round">
                        Search Catalog
                    </button>
                </form>

                <!-- Live Library Statistics -->
                <div class="hero-stats-row">
                    <div class="hero-stat-item">
                        <div class="num"><%= statTotalBooks != null ? statTotalBooks : "18+" %></div>
                        <div class="label">Book Titles</div>
                    </div>
                    <div class="hero-stat-item">
                        <div class="num"><%= statTotalCopies != null ? statTotalCopies : "150+" %></div>
                        <div class="label">Total Copies</div>
                    </div>
                    <div class="hero-stat-item">
                        <div class="num"><%= statTotalCategories != null ? statTotalCategories : "8" %></div>
                        <div class="label">Disciplines</div>
                    </div>
                    <div class="hero-stat-item">
                        <div class="num"><%= statTotalUsers != null ? statTotalUsers : "100+" %></div>
                        <div class="label">Active Scholars</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Featured Picks Section -->
    <section class="section">
        <div class="container">
            <div class="section-header">
                <div>
                    <h2 class="section-title"><i class="bi bi-star-fill"></i> Top-Rated Selections</h2>
                    <p class="section-subtitle">Highly acclaimed textbooks and essential references across diverse computing fields.</p>
                </div>
                <a href="<%= cp %>/books?sort=rating" class="btn btn-sm btn-outline-teal">
                    View All Top Rated <i class="bi bi-arrow-right"></i>
                </a>
            </div>

            <div class="book-grid">
                <% if (featuredBooks != null && !featuredBooks.isEmpty()) {
                    for (Book book : featuredBooks) { %>
                    <div class="book-card">
                        <div class="book-card-cover">
                            <img src="<%= book.getCoverImageUrl() %>" alt="<%= book.getTitle() %>" loading="lazy">
                            <span class="book-card-category-badge"><%= book.getCategoryName() != null ? book.getCategoryName() : "Computer Science" %></span>
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
                <%   }
                   } else { %>
                    <div style="grid-column: 1 / -1; text-align: center; color: var(--text-muted); padding: 2rem;">
                        No books available to display.
                    </div>
                <% } %>
            </div>
        </div>
    </section>

    <!-- Subject Categories Section -->
    <section class="section" style="background-color: #f1f5f9;">
        <div class="container">
            <div class="section-header">
                <div>
                    <h2 class="section-title"><i class="bi bi-grid-3x3-gap-fill"></i> Academic Disciplines</h2>
                    <p class="section-subtitle">Browse dedicated collections organized by specialized subject tracks.</p>
                </div>
                <a href="<%= cp %>/books" class="btn btn-sm btn-secondary">
                    Browse All Disciplines
                </a>
            </div>

            <div class="category-grid">
                <% if (categories != null && !categories.isEmpty()) {
                    for (Category cat : categories) { %>
                    <a href="<%= cp %>/books?category=<%= cat.getCategoryId() %>" class="category-card">
                        <div class="category-icon-box">
                            <i class="bi <%= cat.getIconClass() != null ? cat.getIconClass() : "bi-book" %>"></i>
                        </div>
                        <div class="category-card-content">
                            <h3><%= cat.getName() %></h3>
                            <p><%= cat.getDescription() != null ? cat.getDescription() : "" %></p>
                            <span class="category-book-count"><%= cat.getBookCount() %> Books Available</span>
                        </div>
                    </a>
                <%   }
                   } %>
            </div>
        </div>
    </section>

    <!-- Recommendation Architecture Spotlight -->
    <section class="section">
        <div class="container">
            <div style="background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%); color: #ffffff; border-radius: var(--radius-lg); padding: 3rem; box-shadow: var(--shadow-xl);">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 3rem; align-items: center;">
                    <div>
                        <span class="badge badge-teal" style="margin-bottom: 1rem;">Algorithmic Transparency</span>
                        <h2 style="font-size: 2.2rem; font-weight: 800; line-height: 1.2; margin-bottom: 1rem;">
                            How Our Content-Based Recommendation Engine Works
                        </h2>
                        <p style="color: #cbd5e1; line-height: 1.7; margin-bottom: 1.5rem;">
                            Rather than relying on black-box opacity or overblown claims, our system utilizes a transparent, weighted content-based filtering model. We compute dynamic relevance scores for every book in the library catalogue:
                        </p>
                        <ul style="list-style: none; display: flex; flex-direction: column; gap: 0.8rem; color: #e2e8f0;">
                            <li style="display: flex; align-items: center; gap: 0.6rem;">
                                <i class="bi bi-check2-circle" style="color: #2dd4bf; font-size: 1.25rem;"></i>
                                <span><strong>50% Interest Alignment:</strong> Directly scores books matching your selected syllabus categories.</span>
                            </li>
                            <li style="display: flex; align-items: center; gap: 0.6rem;">
                                <i class="bi bi-check2-circle" style="color: #2dd4bf; font-size: 1.25rem;"></i>
                                <span><strong>30% Reading Pattern Frequency:</strong> Analyzes the subject domains of books you frequently explore and view.</span>
                            </li>
                            <li style="display: flex; align-items: center; gap: 0.6rem;">
                                <i class="bi bi-check2-circle" style="color: #2dd4bf; font-size: 1.25rem;"></i>
                                <span><strong>20% Quality &amp; Availability:</strong> Prioritizes peer-reviewed high-rating volumes that are currently in stock.</span>
                            </li>
                        </ul>

                        <div style="margin-top: 2rem;">
                            <% if (currentUser != null) { %>
                                <a href="<%= cp %>/recommendations" class="btn btn-primary">
                                    View Your Personalized Feed <i class="bi bi-arrow-right"></i>
                                </a>
                            <% } else { %>
                                <a href="<%= cp %>/register" class="btn btn-primary">
                                    Join &amp; Personalize Your Shelf <i class="bi bi-arrow-right"></i>
                                </a>
                            <% } %>
                        </div>
                    </div>

                    <div style="background: rgba(255, 255, 255, 0.05); border: 1px solid rgba(255, 255, 255, 0.1); border-radius: var(--radius-md); padding: 2rem; backdrop-filter: blur(10px);">
                        <h3 style="font-size: 1.2rem; font-weight: 700; color: #5eead4; margin-bottom: 1rem; display: flex; align-items: center; gap: 0.5rem;">
                            <i class="bi bi-cpu"></i> Recommendation Flowchart
                        </h3>
                        <div style="display: flex; flex-direction: column; gap: 1rem; font-size: 0.9rem;">
                            <div style="background: rgba(255, 255, 255, 0.08); padding: 0.85rem; border-radius: var(--radius-sm); border-left: 4px solid #2dd4bf;">
                                <strong>Step 1: Interest Registration</strong><br>
                                User selects preferred disciplines during signup or profile customization.
                            </div>
                            <div style="background: rgba(255, 255, 255, 0.08); padding: 0.85rem; border-radius: var(--radius-sm); border-left: 4px solid #0284c7;">
                                <strong>Step 2: Activity Tracking</strong><br>
                                Book page visits, detail expansions, and catalog searches are recorded in <code>book_activity</code>.
                            </div>
                            <div style="background: rgba(255, 255, 255, 0.08); padding: 0.85rem; border-radius: var(--radius-sm); border-left: 4px solid #f59e0b;">
                                <strong>Step 3: Scoring &amp; Explanation</strong><br>
                                The engine computes affinity scores and generates a transparent "Why Recommended" badge.
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
