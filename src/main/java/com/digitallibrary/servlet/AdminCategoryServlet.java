package com.digitallibrary.servlet;

import com.digitallibrary.dao.CategoryDAO;
import com.digitallibrary.model.Category;
import com.digitallibrary.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller for Administrator Category Management.
 */
@WebServlet(name = "AdminCategoryServlet", urlPatterns = {
    "/admin/categories",
    "/admin/category-add",
    "/admin/category-edit",
    "/admin/category-delete"
})
public class AdminCategoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/admin-categories.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/admin/category-add":
                handleAddCategory(request, response);
                break;
            case "/admin/category-edit":
                handleEditCategory(request, response);
                break;
            case "/admin/category-delete":
                handleDeleteCategory(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/categories");
                break;
        }
    }

    private void handleAddCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String iconClass = request.getParameter("iconClass");

        if (ValidationUtil.isNullOrEmpty(name)) {
            request.getSession().setAttribute("errorMessage", "Category name cannot be empty.");
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }

        Category cat = new Category();
        cat.setName(name.trim());
        cat.setDescription(description != null ? description.trim() : "");
        cat.setIconClass(!ValidationUtil.isNullOrEmpty(iconClass) ? iconClass.trim() : "bi-book");

        boolean added = categoryDAO.addCategory(cat);
        if (added) {
            request.getSession().setAttribute("successMessage", "Category '" + cat.getName() + "' created successfully.");
        } else {
            request.getSession().setAttribute("errorMessage", "Failed to add category. Category name must be unique.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }

    private void handleEditCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int categoryId = ValidationUtil.parseInt(request.getParameter("categoryId"), -1);
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String iconClass = request.getParameter("iconClass");

        if (categoryId <= 0 || ValidationUtil.isNullOrEmpty(name)) {
            request.getSession().setAttribute("errorMessage", "Invalid category parameters.");
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }

        Category cat = new Category();
        cat.setCategoryId(categoryId);
        cat.setName(name.trim());
        cat.setDescription(description != null ? description.trim() : "");
        cat.setIconClass(!ValidationUtil.isNullOrEmpty(iconClass) ? iconClass.trim() : "bi-book");

        boolean updated = categoryDAO.updateCategory(cat);
        if (updated) {
            request.getSession().setAttribute("successMessage", "Category updated successfully.");
        } else {
            request.getSession().setAttribute("errorMessage", "Failed to update category.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }

    private void handleDeleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int categoryId = ValidationUtil.parseInt(request.getParameter("categoryId"), -1);
        if (categoryId > 0) {
            boolean deleted = categoryDAO.deleteCategory(categoryId);
            if (deleted) {
                request.getSession().setAttribute("successMessage", "Category deleted successfully.");
            } else {
                request.getSession().setAttribute("errorMessage", "Cannot delete category: Books currently belong to this category.");
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }
}
