package com.digitallibrary.filter;

import com.digitallibrary.model.User;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Role-Based Access Control (RBAC) Security Filter.
 * Restricts access to administrator areas and authenticated user dashboards.
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String contextPath = request.getContextPath();
        String uri = request.getRequestURI().substring(contextPath.length());

        // Static resources and public pages
        if (uri.startsWith("/css/") || uri.startsWith("/js/") || uri.startsWith("/images/") ||
            uri.startsWith("/webjars/") || uri.equals("/favicon.ico")) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        // 1. Admin endpoints protection
        if (uri.startsWith("/admin")) {
            if (currentUser == null) {
                request.getSession(true).setAttribute("errorMessage", "Authentication required to access administrator features.");
                response.sendRedirect(contextPath + "/login");
                return;
            } else if (!currentUser.isAdmin()) {
                request.getSession(true).setAttribute("errorMessage", "Access Denied: You do not possess Administrator privileges.");
                response.sendRedirect(contextPath + "/user-dashboard");
                return;
            }
        }

        // 2. Protected user endpoints
        if (uri.equals("/user-dashboard") || uri.equals("/recommendations") || uri.equals("/profile")) {
            if (currentUser == null) {
                request.getSession(true).setAttribute("errorMessage", "Please log in to access your personal dashboard and recommendations.");
                response.sendRedirect(contextPath + "/login");
                return;
            }
        }

        // 3. Prevent logged-in users from accessing login/register again
        if ((uri.equals("/login") || uri.equals("/register")) && currentUser != null) {
            if (currentUser.isAdmin()) {
                response.sendRedirect(contextPath + "/admin/dashboard");
            } else {
                response.sendRedirect(contextPath + "/user-dashboard");
            }
            return;
        }

        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {
    }
}
