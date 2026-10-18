<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.digitallibrary.model.BookActivity" %>
<%
    request.setAttribute("pageTitle", "Admin Dashboard - Digital Library");
    String cp = request.getContextPath();
    Object statTotalBooks = request.getAttribute("statTotalBooks");
    Object statTotalCopies = request.getAttribute("statTotalCopies");
    Object statTotalCategories = request.getAttribute("statTotalCategories");
    Object statTotalUsers = request.getAttribute("statTotalUsers");
    Object statTotalActivities = request.getAttribute("statTotalActivities");
    List<BookActivity> recentActivities = (List<BookActivity>) request.getAttribute("recentActivities");
%>
<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="main-content">
    <div class="container" style="padding-top: 2rem;">
        <div class="dashboard-grid">
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/includes/admin-sidebar.jsp">
                <jsp:param name="activeTab" value="dashboard" />
            </jsp:include>

            <!-- Main Panel -->
            <div>
                <div class="section-header">
                    <div>
                        <h1 class="section-title"><i class="bi bi-speedometer2"></i> Central Operations Dashboard</h1>
                        <p class="section-subtitle">Real-time metrics, catalog inventory telemetry, and live user interaction streams.</p>
                    </div>
                    <div style="display: flex; gap: 0.5rem;">
                        <a href="<%= cp %>/admin/book-add" class="btn btn-primary">
                            <i class="bi bi-plus-lg"></i> Add New Book
                        </a>
                    </div>
                </div>

                <!-- Stats Deck -->
                <div class="stats-card-deck">
                    <div class="stat-box">
                        <div class="stat-box-info">
                            <div class="stat-value"><%= statTotalBooks != null ? statTotalBooks : 0 %></div>
                            <div class="stat-title">Catalog Titles</div>
                        </div>
                        <div class="stat-box-icon">
                            <i class="bi bi-book"></i>
                        </div>
                    </div>

                    <div class="stat-box">
                        <div class="stat-box-info">
                            <div class="stat-value"><%= statTotalCopies != null ? statTotalCopies : 0 %></div>
                            <div class="stat-title">Total Copies</div>
                        </div>
                        <div class="stat-box-icon" style="background: #d1fae5; color: #059669;">
                            <i class="bi bi-stack"></i>
                        </div>
                    </div>

                    <div class="stat-box">
                        <div class="stat-box-info">
                            <div class="stat-value"><%= statTotalCategories != null ? statTotalCategories : 0 %></div>
                            <div class="stat-title">Disciplines</div>
                        </div>
                        <div class="stat-box-icon" style="background: #fef3c7; color: #d97706;">
                            <i class="bi bi-tags"></i>
                        </div>
                    </div>

                    <div class="stat-box">
                        <div class="stat-box-info">
                            <div class="stat-value"><%= statTotalUsers != null ? statTotalUsers : 0 %></div>
                            <div class="stat-title">Registered Accounts</div>
                        </div>
                        <div class="stat-box-icon" style="background: #e0f2fe; color: #0284c7;">
                            <i class="bi bi-people"></i>
                        </div>
                    </div>

                    <div class="stat-box">
                        <div class="stat-box-info">
                            <div class="stat-value"><%= statTotalActivities != null ? statTotalActivities : 0 %></div>
                            <div class="stat-title">Activity Events</div>
                        </div>
                        <div class="stat-box-icon" style="background: #f3e8ff; color: #7c3aed;">
                            <i class="bi bi-activity"></i>
                        </div>
                    </div>
                </div>

                <!-- Real-time Activity Stream -->
                <div style="background: #ffffff; border: 1px solid var(--border-color); border-radius: var(--radius-lg); padding: 1.5rem; box-shadow: var(--shadow-sm); margin-top: 2rem;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.25rem;">
                        <h2 style="font-size: 1.2rem; font-weight: 700; color: var(--primary-navy); display: flex; align-items: center; gap: 0.5rem;">
                            <i class="bi bi-activity"></i> Live Activity Audit Stream
                        </h2>
                        <span class="badge badge-teal">Latest Interactions</span>
                    </div>

                    <div class="table-responsive">
                        <table class="custom-table">
                            <thead>
                                <tr>
                                    <th>Event ID</th>
                                    <th>Scholar / User</th>
                                    <th>Action Type</th>
                                    <th>Resource / Query</th>
                                    <th>Timestamp</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (recentActivities == null || recentActivities.isEmpty()) { %>
                                    <tr>
                                        <td colspan="5" style="text-align: center; color: var(--text-muted); padding: 2rem;">
                                            No activity records registered in database yet.
                                        </td>
                                    </tr>
                                <% } else {
                                    for (BookActivity act : recentActivities) { %>
                                    <tr>
                                        <td style="color: var(--text-muted);">#<%= act.getActivityId() %></td>
                                        <td>
                                            <% if (act.getUsername() != null && !act.getUsername().isEmpty()) { %>
                                                <strong><%= act.getUsername() %></strong>
                                            <% } else { %>
                                                <span style="color: var(--text-muted); font-style: italic;">Anonymous Guest</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <% if ("VIEW".equals(act.getActivityType())) { %>
                                                <span class="badge badge-teal"><i class="bi bi-eye"></i> Book View</span>
                                            <% } else if ("SEARCH".equals(act.getActivityType())) { %>
                                                <span class="badge badge-info"><i class="bi bi-search"></i> Search</span>
                                            <% } else { %>
                                                <span class="badge badge-warning"><i class="bi bi-journal-arrow-down"></i> Borrow</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <% if (act.getBookTitle() != null && !act.getBookTitle().isEmpty()) { %>
                                                <%= act.getBookTitle() %>
                                            <% } else if (act.getSearchQuery() != null && !act.getSearchQuery().isEmpty()) { %>
                                                Keyword: <code>"<%= act.getSearchQuery() %>"</code>
                                            <% } else { %>
                                                &mdash;
                                            <% } %>
                                        </td>
                                        <td style="color: var(--text-muted); font-size: 0.85rem;">
                                            <%= act.getCreatedAt() != null ? act.getCreatedAt().toString().substring(0, 19) : "Just now" %>
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
    </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
