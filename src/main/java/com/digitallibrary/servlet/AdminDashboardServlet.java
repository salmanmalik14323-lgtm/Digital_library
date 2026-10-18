package com.digitallibrary.servlet;

import com.digitallibrary.dao.BookActivityDAO;
import com.digitallibrary.dao.BookDAO;
import com.digitallibrary.dao.CategoryDAO;
import com.digitallibrary.dao.UserDAO;
import com.digitallibrary.model.BookActivity;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller for the Administrator Central Analytics Dashboard.
 */
@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin", "/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final BookDAO bookDAO = new BookDAO();
    private final UserDAO userDAO = new UserDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final BookActivityDAO activityDAO = new BookActivityDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int totalBooks = bookDAO.getTotalBookCount();
        int totalCopies = bookDAO.getTotalCopiesCount();
        int totalUsers = userDAO.getTotalUserCount();
        int totalCategories = categoryDAO.getTotalCategoryCount();
        int totalActivities = activityDAO.getTotalActivityCount();

        List<BookActivity> recentActivities = activityDAO.getAllRecentActivities(10);

        request.setAttribute("statTotalBooks", totalBooks);
        request.setAttribute("statTotalCopies", totalCopies);
        request.setAttribute("statTotalUsers", totalUsers);
        request.setAttribute("statTotalCategories", totalCategories);
        request.setAttribute("statTotalActivities", totalActivities);
        request.setAttribute("recentActivities", recentActivities);

        request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
    }
}
