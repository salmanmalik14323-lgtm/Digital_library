<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.digitallibrary.model.User" %>
<%
    request.setAttribute("pageTitle", "My Profile - Digital Library");
    String cp = request.getContextPath();
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect(cp + "/login");
        return;
    }
%>
<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="main-content">
    <div class="container container-narrow" style="padding-top: 2rem;">
        <div class="section-header">
            <div>
                <h1 class="section-title"><i class="bi bi-person-circle"></i> Profile &amp; Account Settings</h1>
                <p class="section-subtitle">Manage your personal scholar credentials, contact details, and account security.</p>
            </div>
        </div>

        <div style="background: #ffffff; border: 1px solid var(--border-color); border-radius: var(--radius-lg); padding: 2rem; margin-bottom: 2rem; box-shadow: var(--shadow-sm);">
            <h2 style="font-size: 1.25rem; font-weight: 700; color: var(--primary-navy); margin-bottom: 1.25rem; padding-bottom: 0.75rem; border-bottom: 1px solid var(--border-color);">
                Personal Information
            </h2>

            <form action="<%= cp %>/profile" method="POST">
                <input type="hidden" name="action" value="updateProfile">

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <div class="form-group">
                        <label>Username</label>
                        <input type="text" class="form-control" value="<%= currentUser.getUsername() %>" disabled style="background: #f8fafc;">
                    </div>
                    <div class="form-group">
                        <label>Email Address</label>
                        <input type="email" class="form-control" value="<%= currentUser.getEmail() %>" disabled style="background: #f8fafc;">
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <div class="form-group">
                        <label for="fullName">Full Name</label>
                        <input type="text" id="fullName" name="fullName" class="form-control" 
                               value="<%= currentUser.getFullName() != null ? currentUser.getFullName() : "" %>" required>
                    </div>
                    <div class="form-group">
                        <label for="phone">Contact Number</label>
                        <input type="tel" id="phone" name="phone" class="form-control" 
                               value="<%= currentUser.getPhone() != null ? currentUser.getPhone() : "" %>">
                    </div>
                </div>

                <div class="form-group">
                    <label for="bio">Academic Bio &amp; Research Focus</label>
                    <textarea id="bio" name="bio" class="form-control" rows="3"><%= currentUser.getBio() != null ? currentUser.getBio() : "" %></textarea>
                </div>

                <div style="display: flex; justify-content: flex-end;">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-save"></i> Save Profile Details
                    </button>
                </div>
            </form>
        </div>

        <!-- Security & Password Change -->
        <div style="background: #ffffff; border: 1px solid var(--border-color); border-radius: var(--radius-lg); padding: 2rem; box-shadow: var(--shadow-sm);">
            <h2 style="font-size: 1.25rem; font-weight: 700; color: var(--primary-navy); margin-bottom: 1.25rem; padding-bottom: 0.75rem; border-bottom: 1px solid var(--border-color);">
                Update Password
            </h2>

            <form action="<%= cp %>/profile" method="POST">
                <input type="hidden" name="action" value="changePassword">

                <div class="form-group">
                    <label for="currentPassword">Current Password</label>
                    <input type="password" id="currentPassword" name="currentPassword" class="form-control" required>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <div class="form-group">
                        <label for="newPassword">New Password</label>
                        <input type="password" id="newPassword" name="newPassword" class="form-control" required minlength="6">
                    </div>
                    <div class="form-group">
                        <label for="confirmNewPassword">Confirm New Password</label>
                        <input type="password" id="confirmNewPassword" name="confirmNewPassword" class="form-control" required minlength="6">
                    </div>
                </div>

                <div style="display: flex; justify-content: flex-end;">
                    <button type="submit" class="btn btn-navy">
                        <i class="bi bi-shield-lock"></i> Update Password
                    </button>
                </div>
            </form>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
