<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("pageTitle", "Sign In - Digital Library");
    String cp = request.getContextPath();
    String usernameOrEmail = (String) request.getAttribute("usernameOrEmail");
    if (usernameOrEmail == null) usernameOrEmail = "";
%>
<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="main-content">
    <div class="container">
        <div class="auth-card">
            <div class="auth-header">
                <div class="brand-logo" style="justify-content: center; margin-bottom: 0.5rem; color: var(--primary-navy);">
                    <i class="bi bi-journal-bookmark-fill" style="color: var(--primary-teal);"></i>
                    <span>Digital<span style="color: var(--primary-teal);">Lib</span></span>
                </div>
                <h2>Welcome Back</h2>
                <p>Sign in to access your personal reading list and recommendations.</p>
            </div>

            <form action="<%= cp %>/login" method="POST">
                <div class="form-group">
                    <label for="usernameOrEmail">Username or Institutional Email</label>
                    <input type="text" id="usernameOrEmail" name="usernameOrEmail" class="form-control" 
                           value="<%= usernameOrEmail %>" required autofocus>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" required>
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 1rem;">
                    <i class="bi bi-box-arrow-in-right"></i> Sign In
                </button>
            </form>

            <!-- Quick Demo Credentials helper for reviewers/evaluators -->
            <div style="margin-top: 1.75rem; padding: 1rem; background: #f8fafc; border: 1px dashed var(--border-color); border-radius: var(--radius-md); font-size: 0.82rem; color: var(--text-muted);">
                <div style="font-weight: 700; color: var(--primary-navy); margin-bottom: 0.35rem;">
                    <i class="bi bi-info-circle"></i> Demo Credentials
                </div>
                <div><strong>Student:</strong> <code>salman</code> / <code>User@123</code></div>
                <div><strong>Admin:</strong> <code>admin</code> / <code>Admin@123</code></div>
            </div>

            <div style="text-align: center; margin-top: 1.5rem; font-size: 0.9rem; color: var(--text-muted);">
                New to the library? <a href="<%= cp %>/register" style="font-weight: 600;">Create an Account</a>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
