<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Set, com.digitallibrary.model.Recommendation, com.digitallibrary.model.UserInterest, com.digitallibrary.model.Category, com.digitallibrary.model.Book" %>
<%
    request.setAttribute("pageTitle", "Personalized Recommendations - Digital Library");
    String cp = request.getContextPath();
    List<Recommendation> recommendations = (List<Recommendation>) request.getAttribute("recommendations");
    List<UserInterest> userInterests = (List<UserInterest>) request.getAttribute("userInterests");
    Set<Integer> userInterestIds = (Set<Integer>) request.getAttribute("userInterestIds");
    List<Category> allCategories = (List<Category>) request.getAttribute("allCategories");
%>
<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="main-content">
    <div class="container" style="padding-top: 2rem;">
        <div class="section-header">
            <div>
                <span class="badge badge-teal" style="margin-bottom: 0.5rem;">
                    <i class="bi bi-stars"></i> Intelligent Content-Based Filtering
                </span>
                <h1 class="section-title"><i class="bi bi-compass"></i> Recommended For You</h1>
                <p class="section-subtitle">
                    Dynamically ranked books based on your declared academic interests, page-view frequency, and library stock availability.
                </p>
            </div>
            <div style="display: flex; gap: 0.75rem;">
                <a href="<%= cp %>/recommendations?refresh=true" class="btn btn-secondary">
                    <i class="bi bi-arrow-clockwise"></i> Re-Calculate Scores
                </a>
            </div>
        </div>

        <!-- Interest Management Card -->
        <div style="background: #ffffff; border: 1px solid var(--border-color); border-radius: var(--radius-lg); padding: 1.5rem; margin-bottom: 2.5rem; box-shadow: var(--shadow-sm);">
            <div style="display: flex; justify-content: space-between; align-items: flex-start; gap: 1rem; flex-wrap: wrap;">
                <div>
                    <h3 style="font-size: 1.05rem; font-weight: 700; color: var(--primary-navy); margin-bottom: 0.25rem;">
                        Your Active Subject Interests
                    </h3>
                    <p style="font-size: 0.85rem; color: var(--text-muted);">
                        The engine heavily weights these topics (50% match score weight) when proposing reading materials.
                    </p>
                </div>
                <button type="button" class="btn btn-sm btn-outline-teal" onclick="document.getElementById('editInterestsPanel').classList.toggle('hidden');">
                    <i class="bi bi-sliders"></i> Modify Interests
                </button>
            </div>

            <!-- Active Chips -->
            <div style="display: flex; flex-wrap: wrap; gap: 0.5rem; margin-top: 1rem;">
                <% if (userInterests != null && !userInterests.isEmpty()) {
                    for (UserInterest interest : userInterests) { %>
                    <span class="badge badge-navy" style="padding: 0.45rem 0.85rem; font-size: 0.85rem;">
                        <i class="bi bi-bookmark-check-fill" style="color: #2dd4bf;"></i> <%= interest.getCategoryName() %>
                    </span>
                <%   }
                   } else { %>
                    <span style="font-size: 0.88rem; color: var(--text-muted); font-style: italic;">
                        No specific interests selected yet. Recommendations are currently ranked by overall library popularity and rating.
                    </span>
                <% } %>
            </div>

            <!-- Collapsible Edit Interests Form -->
            <div id="editInterestsPanel" class="hidden" style="margin-top: 1.5rem; padding-top: 1.5rem; border-top: 1px solid var(--border-color);">
                <form action="<%= cp %>/recommendations" method="POST">
                    <input type="hidden" name="action" value="updateInterests">
                    <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--primary-navy); margin-bottom: 0.75rem;">
                        Select all academic disciplines you wish to include in your profile:
                    </h4>
                    <div class="interest-chips-container" style="margin-bottom: 1.25rem;">
                        <% if (allCategories != null) {
                            for (Category cat : allCategories) {
                                boolean checked = (userInterestIds != null && userInterestIds.contains(cat.getCategoryId())); %>
                            <label class="chip-label">
                                <input type="checkbox" name="interestCategories" value="<%= cat.getCategoryId() %>" <%= checked ? "checked" : "" %>>
                                <span class="chip-content">
                                    <i class="bi <%= cat.getIconClass() != null ? cat.getIconClass() : "bi-book" %>"></i> <%= cat.getName() %>
                                </span>
                            </label>
                        <%   }
                           } %>
                    </div>
                    <button type="submit" class="btn btn-sm btn-primary">
                        <i class="bi bi-check2"></i> Save &amp; Refresh Recommendations
                    </button>
                </form>
            </div>
        </div>

        <!-- Recommendations Grid -->
        <% if (recommendations == null || recommendations.isEmpty()) { %>
            <div style="text-align: center; padding: 4rem 1rem; background: #ffffff; border-radius: var(--radius-lg); border: 1px dashed var(--border-color);">
                <i class="bi bi-stars" style="font-size: 3rem; color: var(--text-muted); margin-bottom: 1rem; display: block;"></i>
                <h3 style="color: var(--primary-navy); margin-bottom: 0.5rem;">No Recommendations Generated</h3>
                <p style="color: var(--text-muted); max-width: 500px; margin: 0 auto 1.5rem;">
                    Browse a few books in the catalog or select your subject interests above to kickstart your personalized feed.
                </p>
                <a href="<%= cp %>/books" class="btn btn-primary">
                    Explore Book Catalog
                </a>
            </div>
        <% } else { %>
            <div class="book-grid">
                <% for (Recommendation rec : recommendations) {
                    Book book = rec.getBook();
                    if (book == null) continue; %>
                    <div class="rec-card">
                        <!-- Match Score Pill -->
                        <div class="rec-badge-score">
                            <i class="bi bi-lightning-charge-fill"></i>
                            <span><%= Math.round(rec.getMatchScore()) %>% Match</span>
                        </div>

                        <div class="book-card-cover">
                            <img src="<%= book.getCoverImageUrl() %>" alt="<%= book.getTitle() %>" loading="lazy">
                            <span class="book-card-category-badge"><%= book.getCategoryName() != null ? book.getCategoryName() : "General" %></span>
                        </div>

                        <!-- Transparent Explainable Reason -->
                        <div class="rec-explanation-banner">
                            <i class="bi bi-info-circle-fill"></i>
                            <span><%= rec.getReason() %></span>
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
                                    <span><%= book.isAvailable() ? "In Stock" : "Out of Stock" %></span>
                                </div>
                                <a href="<%= cp %>/book-details?id=<%= book.getBookId() %>" class="btn btn-sm btn-navy">
                                    Details
                                </a>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>
</main>

<style>
.hidden { display: none; }
</style>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
