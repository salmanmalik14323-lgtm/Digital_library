<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.digitallibrary.model.User" %>
<%
    request.setAttribute("pageTitle", "User Management - Admin Workspace");
    String cp = request.getContextPath();
    List<User> users = (List<User>) request.getAttribute("users");
    User currentUser = (User) session.getAttribute("currentUser");
%>
<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="main-content">
    <div class="container" style="padding-top: 2rem;">
        <div class="dashboard-grid">
            <!-- Sidebar -->
            <jsp:include page="/WEB-INF/includes/admin-sidebar.jsp">
                <jsp:param name="activeTab" value="users" />
            </jsp:include>

            <!-- Main Panel -->
            <div>
                <div class="section-header">
                    <div>
                        <h1 class="section-title"><i class="bi bi-people"></i> Registered Scholars &amp; Staff</h1>
                        <p class="section-subtitle">Manage institutional member permissions, inspect credentials, and assign administrative roles.</p>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="custom-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Scholar / Name</th>
                                <th>Institutional Email</th>
                                <th>Role</th>
                                <th>Phone</th>
                                <th>Registered</th>
                                <th style="text-align: right;">Authorization</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (users != null) {
                                for (User u : users) { %>
                                <tr>
                                    <td style="color: var(--text-muted);">#<%= u.getUserId() %></td>
                                    <td>
                                        <div style="font-weight: 700; color: var(--primary-navy);"><%= u.getFullName() %></div>
                                        <div style="font-size: 0.82rem; color: var(--text-muted);">@<%= u.getUsername() %></div>
                                    </td>
                                    <td style="font-size: 0.88rem;"><%= u.getEmail() %></td>
                                    <td>
                                        <span class="badge <%= u.isAdmin() ? "badge-navy" : "badge-teal" %>">
                                            <%= u.getRole() %>
                                        </span>
                                    </td>
                                    <td style="font-size: 0.85rem; color: var(--text-muted);">
                                        <%= u.getPhone() != null ? u.getPhone() : "&mdash;" %>
                                    </td>
                                    <td style="font-size: 0.85rem; color: var(--text-muted);">
                                        <%= u.getCreatedAt() != null ? u.getCreatedAt().toString().substring(0, 10) : "2026-10-18" %>
                                    </td>
                                    <td style="text-align: right;">
                                        <div class="action-btn-group" style="justify-content: flex-end;">
                                            <form action="<%= cp %>/admin/user-role" method="POST" style="margin: 0;">
                                                <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                                <% if (u.isAdmin()) { %>
                                                    <input type="hidden" name="role" value="USER">
                                                    <button type="submit" class="btn btn-sm btn-secondary" 
                                                            title="Demote to Regular User"
                                                            <%= (currentUser != null && currentUser.getUserId() == u.getUserId()) ? "disabled" : "" %>>
                                                        <i class="bi bi-person-down"></i>
                                                    </button>
                                                <% } else { %>
                                                    <input type="hidden" name="role" value="ADMIN">
                                                    <button type="submit" class="btn btn-sm btn-outline-teal" title="Promote to Administrator">
                                                        <i class="bi bi-shield-lock-fill"></i>
                                                    </button>
                                                <% } %>
                                            </form>

                                            <% if (currentUser != null && currentUser.getUserId() != u.getUserId()) { %>
                                                <form action="<%= cp %>/admin/user-delete" method="POST" 
                                                      onsubmit="return confirm('Are you sure you want to permanently delete this user account?');" style="margin: 0;">
                                                    <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                                    <button type="submit" class="btn btn-sm btn-danger" title="Delete User">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </form>
                                            <% } %>
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
