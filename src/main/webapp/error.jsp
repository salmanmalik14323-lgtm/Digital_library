<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%
    request.setAttribute("pageTitle", "System Notification - Digital Library");
    String cp = request.getContextPath();
%>
<jsp:include page="/WEB-INF/includes/header.jsp" />
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<main class="main-content">
    <div class="container container-narrow" style="padding-top: 4rem; text-align: center;">
        <div style="background: #ffffff; border: 1px solid var(--border-color); border-radius: var(--radius-lg); padding: 3rem 2rem; box-shadow: var(--shadow-md);">
            <div style="width: 72px; height: 72px; background: #fee2e2; color: #dc2626; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 2.2rem; margin: 0 auto 1.5rem;">
                <i class="bi bi-exclamation-triangle-fill"></i>
            </div>
            
            <h1 style="font-size: 2rem; font-weight: 800; color: var(--primary-navy); margin-bottom: 0.75rem;">
                Page Not Found or Resource Unavailable
            </h1>
            
            <p style="color: var(--text-muted); max-width: 520px; margin: 0 auto 1.5rem; font-size: 1rem; line-height: 1.6;">
                The resource or page you requested could not be resolved or an unexpected exception occurred.
            </p>

            <% if (exception != null) { %>
                <div style="text-align: left; background: #f8fafc; border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 1rem; margin-bottom: 1.5rem; font-size: 0.85rem; color: #991b1b; overflow-x: auto;">
                    <strong>Details:</strong> <%= exception.getMessage() != null ? exception.getMessage() : exception.toString() %>
                </div>
            <% } %>

            <div style="display: flex; justify-content: center; gap: 1rem; flex-wrap: wrap;">
                <a href="<%= cp %>/home" class="btn btn-primary">
                    <i class="bi bi-house"></i> Return to Homepage
                </a>
                <a href="<%= cp %>/books" class="btn btn-secondary">
                    <i class="bi bi-grid"></i> Browse Catalog
                </a>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
