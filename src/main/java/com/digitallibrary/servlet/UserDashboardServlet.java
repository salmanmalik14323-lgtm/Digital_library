package com.digitallibrary.servlet;

import com.digitallibrary.dao.BookActivityDAO;
import com.digitallibrary.dao.RecommendationDAO;
import com.digitallibrary.dao.UserDAO;
import com.digitallibrary.dao.UserInterestDAO;
import com.digitallibrary.model.BookActivity;
import com.digitallibrary.model.Recommendation;
import com.digitallibrary.model.User;
import com.digitallibrary.model.UserInterest;
import com.digitallibrary.util.PasswordUtil;
import com.digitallibrary.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Controller for the Student/User Dashboard and Profile Management.
 */
@WebServlet(name = "UserDashboardServlet", urlPatterns = {"/user-dashboard", "/profile"})
public class UserDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final UserDAO userDAO = new UserDAO();
    private final UserInterestDAO userInterestDAO = new UserInterestDAO();
    private final BookActivityDAO activityDAO = new BookActivityDAO();
    private final RecommendationDAO recommendationDAO = new RecommendationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();

        if ("/profile".equals(path)) {
            // Refresh current user data from database
            User refreshed = userDAO.getUserById(currentUser.getUserId());
            if (refreshed != null) {
                session.setAttribute("currentUser", refreshed);
            }
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
            return;
        }

        // Default: /user-dashboard
        List<UserInterest> interests = userInterestDAO.getUserInterests(currentUser.getUserId());
        List<BookActivity> recentActivities = activityDAO.getUserRecentActivities(currentUser.getUserId(), 6);
        List<Recommendation> topRecs = recommendationDAO.getCachedRecommendations(currentUser.getUserId(), 4);

        if (topRecs == null || topRecs.isEmpty()) {
            topRecs = recommendationDAO.refreshRecommendationsForUser(currentUser.getUserId(), 4);
        }

        request.setAttribute("userInterests", interests);
        request.setAttribute("recentActivities", recentActivities);
        request.setAttribute("topRecommendations", topRecs);

        request.getRequestDispatcher("/user-dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("updateProfile".equals(action)) {
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String bio = request.getParameter("bio");

            if (ValidationUtil.isNullOrEmpty(fullName)) {
                request.setAttribute("errorMessage", "Full Name cannot be blank.");
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }

            currentUser.setFullName(fullName.trim());
            currentUser.setPhone(phone != null ? phone.trim() : null);
            currentUser.setBio(bio != null ? bio.trim() : null);

            boolean updated = userDAO.updateProfile(currentUser);
            if (updated) {
                session.setAttribute("currentUser", currentUser);
                session.setAttribute("successMessage", "Profile details updated successfully.");
            } else {
                session.setAttribute("errorMessage", "Could not update profile. Please try again.");
            }
            response.sendRedirect(request.getContextPath() + "/profile");

        } else if ("changePassword".equals(action)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmNewPassword = request.getParameter("confirmNewPassword");

            if (!PasswordUtil.verifyPassword(currentPassword, currentUser.getPasswordHash(), currentUser.getSalt())) {
                request.setAttribute("errorMessage", "Current password does not match.");
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }

            if (!ValidationUtil.isStrongPassword(newPassword)) {
                request.setAttribute("errorMessage", "New password must be at least 6 characters.");
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }

            if (!newPassword.equals(confirmNewPassword)) {
                request.setAttribute("errorMessage", "New passwords do not match.");
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }

            String newSalt = PasswordUtil.generateSalt();
            String newHash = PasswordUtil.hashPassword(newPassword, newSalt);

            boolean updated = userDAO.updatePassword(currentUser.getUserId(), newHash, newSalt);
            if (updated) {
                currentUser.setPasswordHash(newHash);
                currentUser.setSalt(newSalt);
                session.setAttribute("currentUser", currentUser);
                session.setAttribute("successMessage", "Password changed successfully.");
            } else {
                session.setAttribute("errorMessage", "Could not update password. Please try again.");
            }
            response.sendRedirect(request.getContextPath() + "/profile");
        } else {
            response.sendRedirect(request.getContextPath() + "/user-dashboard");
        }
    }
}
