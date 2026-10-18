package com.digitallibrary.servlet;

import com.digitallibrary.dao.UserDAO;
import com.digitallibrary.model.User;
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
 * Controller for Administrator User Management and Role Assignments.
 */
@WebServlet(name = "AdminUserServlet", urlPatterns = {
    "/admin/users",
    "/admin/user-role",
    "/admin/user-delete"
})
public class AdminUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/admin-users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String path = request.getServletPath();
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if ("/admin/user-role".equals(path)) {
            int targetUserId = ValidationUtil.parseInt(request.getParameter("userId"), -1);
            String newRole = request.getParameter("role");

            if (targetUserId > 0 && ("USER".equals(newRole) || "ADMIN".equals(newRole))) {
                if (currentUser != null && currentUser.getUserId() == targetUserId && "USER".equals(newRole)) {
                    session.setAttribute("errorMessage", "Action Aborted: You cannot demote your own administrator account.");
                } else {
                    boolean updated = userDAO.updateUserRole(targetUserId, newRole);
                    if (updated) {
                        session.setAttribute("successMessage", "User role successfully changed to " + newRole + ".");
                    } else {
                        session.setAttribute("errorMessage", "Failed to update user role.");
                    }
                }
            }
        } else if ("/admin/user-delete".equals(path)) {
            int targetUserId = ValidationUtil.parseInt(request.getParameter("userId"), -1);

            if (targetUserId > 0) {
                if (currentUser != null && currentUser.getUserId() == targetUserId) {
                    session.setAttribute("errorMessage", "Action Aborted: You cannot delete your own account.");
                } else {
                    boolean deleted = userDAO.deleteUser(targetUserId);
                    if (deleted) {
                        session.setAttribute("successMessage", "User account removed.");
                    } else {
                        session.setAttribute("errorMessage", "Failed to delete user.");
                    }
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}
