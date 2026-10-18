package com.digitallibrary.servlet;

import com.digitallibrary.dao.BookDAO;
import com.digitallibrary.dao.CategoryDAO;
import com.digitallibrary.dao.UserDAO;
import com.digitallibrary.model.Book;
import com.digitallibrary.model.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller for the Digital Library landing / home page.
 */
@WebServlet(name = "HomeServlet", urlPatterns = {"/home", "/index"})
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final BookDAO bookDAO = new BookDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Book> featuredBooks = bookDAO.getFeaturedBooks(6);
        List<Book> recentBooks = bookDAO.getRecentBooks(6);
        List<Category> categories = categoryDAO.getAllCategories();

        int totalBooks = bookDAO.getTotalBookCount();
        int totalCopies = bookDAO.getTotalCopiesCount();
        int totalUsers = userDAO.getTotalUserCount();
        int totalCategories = categoryDAO.getTotalCategoryCount();

        request.setAttribute("featuredBooks", featuredBooks);
        request.setAttribute("recentBooks", recentBooks);
        request.setAttribute("categories", categories);
        request.setAttribute("statTotalBooks", totalBooks);
        request.setAttribute("statTotalCopies", totalCopies);
        request.setAttribute("statTotalUsers", totalUsers);
        request.setAttribute("statTotalCategories", totalCategories);

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
