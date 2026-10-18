<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.digitallibrary.model.Category" %>
<%
    request.setAttribute("pageTitle", "Create Account - Digital Library");
    String cp = request.getContextPath();
    List<Category> categories = (List<Category>) request.getAttribute("categories");
%>
<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="main-content">
    <div class="container">
        <div class="auth-card" style="max-width: 640px;">
            <div class="auth-header">
                <div class="brand-logo" style="justify-content: center; margin-bottom: 0.5rem; color: var(--primary-navy);">
                    <i class="bi bi-journal-bookmark-fill" style="color: var(--primary-teal);"></i>
                    <span>Digital<span style="color: var(--primary-teal);">Lib</span></span>
                </div>
                <h2>Student Registration</h2>
                <p>Join the digital library network and personalize your academic book recommendations.</p>
            </div>

            <form action="<%= cp %>/register" method="POST" class="register-form">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <div class="form-group">
                        <label for="fullName">Full Name *</label>
                        <input type="text" id="fullName" name="fullName" class="form-control" 
                               placeholder="e.g. Salman Murtuja Malik" required>
                    </div>

                    <div class="form-group">
                        <label for="username">Username *</label>
                        <input type="text" id="username" name="username" class="form-control" 
                               placeholder="e.g. salman17034" required pattern="[a-zA-Z0-9_]{3,30}"
                               title="3 to 30 alphanumeric characters or underscores">
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <div class="form-group">
                        <label for="email">Institutional Email *</label>
                        <input type="email" id="email" name="email" class="form-control" 
                               placeholder="name@college.ac.in" required>
                    </div>

                    <div class="form-group">
                        <label for="phone">Contact Number</label>
                        <input type="tel" id="phone" name="phone" class="form-control" 
                               placeholder="+91 9876543210">
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <div class="form-group">
                        <label for="password">Password *</label>
                        <input type="password" id="password" name="password" class="form-control" 
                               placeholder="At least 6 characters" required minlength="6">
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password *</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" 
                               placeholder="Re-type password" required minlength="6">
                    </div>
                </div>

                <div class="form-group">
                    <label for="bio">Academic Background / Bio</label>
                    <textarea id="bio" name="bio" class="form-control" rows="2" 
                              placeholder="e.g., SY BSc IT student interested in Enterprise Java, Cloud, and Database Engineering."></textarea>
                </div>

                <!-- Reading Interests (Used by Recommendation Engine) -->
                <div class="form-group" style="margin-top: 1.5rem; padding: 1.25rem; background: #f8fafc; border-radius: var(--radius-md); border: 1px solid var(--border-color);">
                    <label style="margin-bottom: 0.25rem; display: flex; align-items: center; gap: 0.4rem;">
                        <i class="bi bi-stars" style="color: var(--primary-teal);"></i>
                        Select Your Subject Interests
                    </label>
                    <p style="font-size: 0.82rem; color: var(--text-muted); margin-bottom: 0.75rem;">
                        Our content-based algorithm will tailor your book recommendations based on these preferences:
                    </p>
                    <div class="interest-chips-container">
                        <% if (categories != null) {
                            for (Category cat : categories) { %>
                            <label class="chip-label">
                                <input type="checkbox" name="interestCategories" value="<%= cat.getCategoryId() %>">
                                <span class="chip-content">
                                    <i class="bi <%= cat.getIconClass() != null ? cat.getIconClass() : "bi-book" %>"></i> <%= cat.getName() %>
                                </span>
                            </label>
                        <%   }
                           } %>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 1.25rem;">
                    <i class="bi bi-person-check-fill"></i> Complete Registration
                </button>
            </form>

            <div style="text-align: center; margin-top: 1.5rem; font-size: 0.9rem; color: var(--text-muted);">
                Already have an account? <a href="<%= cp %>/login" style="font-weight: 600;">Sign In</a>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
