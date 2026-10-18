<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.digitallibrary.model.User, com.digitallibrary.model.UserInterest, com.digitallibrary.model.BookActivity, com.digitallibrary.model.Recommendation, com.digitallibrary.model.Book" %>
<%
    request.setAttribute("pageTitle", "Student Dashboard - Digital Library");
    String cp = request.getContextPath();
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect(cp + "/login");
        return;
    }
    List<UserInterest> userInterests = (List<UserInterest>) request.getAttribute("userInterests");
    List<BookActivity> recentActivities = (List<BookActivity>) request.getAttribute("recentActivities");
    List<Recommendation> topRecommendations = (List<Recommendation>) request.getAttribute("topRecommendations");
    
    String initial = "U";
    if (currentUser.getFullName() != null && !currentUser.getFullName().trim().isEmpty()) {
        initial = currentUser.getFullName().trim().substring(0, 1).toUpperCase();
    }
%>
<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="main-content">
    <div class="container" style="padding-top: 2rem;">
        <!-- Welcome Card -->
        <div style="background: linear-gradient(135deg, var(--primary-navy) 0%, #1e3a8a 100%); color: #ffffff; border-radius: var(--radius-lg); padding: 2.5rem; margin-bottom: 2.5rem; box-shadow: var(--shadow-lg);">
            <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1.5rem;">
                <div style="display: flex; align-items: center; gap: 1.5rem;">
                    <div class="user-avatar-circle" style="width: 64px; height: 64px; font-size: 1.8rem;">
                        <%= initial %>
                    </div>
                    <div>
                        <span class="badge badge-teal" style="margin-bottom: 0.4rem;">Student Portal</span>
                        <h1 style="font-size: 1.85rem; font-weight: 800; line-height: 1.2;">
                            Welcome back, <%= currentUser.getFullName() %>!
                        </h1>
                        <p style="color: #cbd5e1; font-size: 0.92rem; margin-top: 0.25rem;">
                            SY BSc IT | Academic Year: 2026–27 | Roll No: 17034
                        </p>
                    </div>
                </div>

                <div style="display: flex; gap: 0.75rem;">
                    <a href="<%= cp %>/profile" class="btn btn-secondary">
                        <i class="bi bi-person-gear"></i> Account Settings
                    </a>
                    <a href="<%= cp %>/recommendations" class="btn btn-primary">
                        <i class="bi bi-stars"></i> Recommendations
                    </a>
                </div>
            </div>
        </div>

        <!-- Student Summary Cards -->
        <div class="stats-card-deck">
            <div class="stat-box">
                <div class="stat-box-info">
                    <div class="stat-value"><%= userInterests != null ? userInterests.size() : 0 %></div>
                    <div class="stat-title">Selected Interests</div>
                </div>
                <div class="stat-box-icon">
                    <i class="bi bi-tags-fill"></i>
                </div>
            </div>

            <div class="stat-box">
                <div class="stat-box-info">
                    <div class="stat-value"><%= recentActivities != null ? recentActivities.size() : 0 %></div>
                    <div class="stat-title">Recent Interactions</div>
                </div>
                <div class="stat-box-icon" style="background: #e0f2fe; color: #0284c7;">
                    <i class="bi bi-clock-history"></i>
                </div>
            </div>

            <div class="stat-box">
                <div class="stat-box-info">
                    <div class="stat-value"><%= topRecommendations != null ? topRecommendations.size() : 0 %></div>
                    <div class="stat-title">Ranked Recommendations</div>
                </div>
                <div class="stat-box-icon" style="background: #fef3c7; color: #d97706;">
                    <i class="bi bi-award-fill"></i>
                </div>
            </div>
        </div>

        <!-- Top Recommendations Shelf -->
        <div style="margin-bottom: 3rem;">
            <div class="section-header">
                <div>
                    <h2 class="section-title"><i class="bi bi-stars"></i> Highlighted For Your Study Plan</h2>
                    <p class="section-subtitle">Top algorithmic matches derived from your subject preferences.</p>
                </div>
                <a href="<%= cp %>/recommendations" class="btn btn-sm btn-outline-teal">
                    View Complete Recommendation Feed <i class="bi bi-arrow-right"></i>
                </a>
            </div>

            <div class="book-grid">
                <% if (topRecommendations != null && !topRecommendations.isEmpty()) {
                    for (Recommendation rec : topRecommendations) {
                        Book book = rec.getBook();
                        if (book == null) continue; %>
                    <div class="rec-card">
                        <div class="rec-badge-score">
                            <i class="bi bi-lightning-charge-fill"></i>
                            <span><%= Math.round(rec.getMatchScore()) %>% Match</span>
                        </div>
                        <div class="book-card-cover">
                            <img src="<%= book.getCoverImageUrl() %>" alt="<%= book.getTitle() %>" loading="lazy">
                            <span class="book-card-category-badge"><%= book.getCategoryName() != null ? book.getCategoryName() : "General" %></span>
                        </div>
                        <div class="rec-explanation-banner">
                            <i class="bi bi-info-circle-fill"></i>
                            <span><%= rec.getReason() %></span>
                        </div>
                        <div class="book-card-body">
                            <h3 class="book-title" title="<%= book.getTitle() %>"><%= book.getTitle() %></h3>
                            <div class="book-author"><i class="bi bi-person"></i> <%= book.getAuthor() %></div>
                            <div class="book-card-footer">
                                <span class="availability-status <%= book.isAvailable() ? "available" : "out" %>">
                                    <i class="bi <%= book.isAvailable() ? "bi-check-circle-fill" : "bi-dash-circle-fill" %>"></i>
                                    <span><%= book.isAvailable() ? "In Stock" : "Out of Stock" %></span>
                                </span>
                                <a href="<%= cp %>/book-details?id=<%= book.getBookId() %>" class="btn btn-sm btn-navy">
                                    View
                                </a>
                            </div>
                        </div>
                    </div>
                <%   }
                   } else { %>
                    <div style="grid-column: 1 / -1; text-align: center; color: var(--text-muted); padding: 2rem;">
                        No recommendations generated yet.
                    </div>
                <% } %>
            </div>
        </div>

        <!-- Recent Reading & Activity History -->
        <div>
            <div class="section-header">
                <div>
                    <h2 class="section-title"><i class="bi bi-clock-history"></i> Your Recent Activity Log</h2>
                    <p class="section-subtitle">Real-time interaction history recorded across catalog views and searches.</p>
                </div>
            </div>

            <% if (recentActivities == null || recentActivities.isEmpty()) { %>
                <div style="background: #ffffff; border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 2rem; text-align: center; color: var(--text-muted);">
                    <i class="bi bi-journal" style="font-size: 2rem; margin-bottom: 0.5rem; display: block;"></i>
                    No recorded reading or search activities yet. Browse books to log your learning path!
                </div>
            <% } else { %>
                <div class="table-responsive">
                    <table class="custom-table">
                        <thead>
                            <tr>
                                <th>Interaction Type</th>
                                <th>Subject / Title</th>
                                <th>Details / Query</th>
                                <th>Logged Timestamp</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (BookActivity act : recentActivities) { %>
                                <tr>
                                    <td>
                                        <% if ("VIEW".equals(act.getActivityType())) { %>
                                            <span class="badge badge-teal"><i class="bi bi-eye"></i> Book View</span>
                                        <% } else if ("SEARCH".equals(act.getActivityType())) { %>
                                            <span class="badge badge-info"><i class="bi bi-search"></i> Catalog Search</span>
                                        <% } else { %>
                                            <span class="badge badge-warning"><i class="bi bi-journal-arrow-down"></i> Borrow Action</span>
                                        <% } %>
                                    </td>
                                    <td style="font-weight: 600;">
                                        <% if (act.getBookTitle() != null && !act.getBookTitle().isEmpty()) { %>
                                            <a href="<%= cp %>/book-details?id=<%= act.getBookId() %>">
                                                <%= act.getBookTitle() %>
                                            </a>
                                        <% } else { %>
                                            <span style="color: var(--text-muted);">&mdash;</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if (act.getSearchQuery() != null && !act.getSearchQuery().isEmpty()) { %>
                                            <code>"<%= act.getSearchQuery() %>"</code>
                                        <% } else { %>
                                            <span style="color: var(--text-muted);">Viewed Detailed Specs</span>
                                        <% } %>
                                    </td>
                                    <td style="color: var(--text-muted); font-size: 0.85rem;">
                                        <%= act.getCreatedAt() != null ? act.getCreatedAt().toString().substring(0, 19) : "Just now" %>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
