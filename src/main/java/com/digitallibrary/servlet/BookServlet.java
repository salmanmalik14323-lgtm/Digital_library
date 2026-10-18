package com.digitallibrary.servlet;

import com.digitallibrary.dao.BookActivityDAO;
import com.digitallibrary.dao.BookDAO;
import com.digitallibrary.dao.CategoryDAO;
import com.digitallibrary.model.Book;
import com.digitallibrary.model.Category;
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
 * Controller for browsing the book catalog, search filtering, and detailed book inspection.
 */
@WebServlet(name = "BookServlet", urlPatterns = {"/books", "/book-details"})
public class BookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final BookDAO bookDAO = new BookDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final BookActivityDAO activityDAO = new BookActivityDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/book-details".equals(path)) {
            handleBookDetails(request, response);
        } else {
            handleCatalog(request, response);
        }
    }

    private void handleCatalog(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String query = request.getParameter("q");
        String categoryParam = request.getParameter("category");
        String sort = request.getParameter("sort");
        String pageParam = request.getParameter("page");

        Integer categoryId = null;
        if (!ValidationUtil.isNullOrEmpty(categoryParam)) {
            try {
                categoryId = Integer.parseInt(categoryParam.trim());
            } catch (NumberFormatException ignored) {}
        }

        int page = 1;
        if (!ValidationUtil.isNullOrEmpty(pageParam)) {
            try {
                page = Math.max(1, Integer.parseInt(pageParam.trim()));
            } catch (NumberFormatException ignored) {}
        }

        int pageSize = 12;
        int offset = (page - 1) * pageSize;

        // Fetch catalog results
        List<Book> books = bookDAO.searchBooks(query, categoryId, sort, pageSize, offset);
        int totalBooks = bookDAO.countSearchedBooks(query, categoryId);
        int totalPages = (int) Math.ceil((double) totalBooks / pageSize);

        List<Category> categories = categoryDAO.getAllCategories();

        // Track search activity if user searched for something
        if (query != null && !query.trim().isEmpty()) {
            HttpSession session = request.getSession(false);
            User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
            Integer userId = (currentUser != null) ? currentUser.getUserId() : null;
            activityDAO.logActivity(userId, null, "SEARCH", query.trim());
        }

        request.setAttribute("books", books);
        request.setAttribute("categories", categories);
        request.setAttribute("currentQuery", query != null ? query.trim() : "");
        request.setAttribute("currentCategory", categoryId);
        request.setAttribute("currentSort", sort != null ? sort : "title");
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCount", totalBooks);

        request.getRequestDispatcher("/books.jsp").forward(request, response);
    }

    private void handleBookDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (ValidationUtil.isNullOrEmpty(idParam)) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        int bookId;
        try {
            bookId = Integer.parseInt(idParam.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        Book book = bookDAO.getBookById(bookId);
        if (book == null) {
            request.setAttribute("errorMessage", "The requested book was not found in our catalog.");
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        // Track view activity
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        Integer userId = (currentUser != null) ? currentUser.getUserId() : null;
        activityDAO.logActivity(userId, book.getBookId(), "VIEW", null);

        // Fetch related books from the same category
        List<Book> relatedBooks = bookDAO.getBooksByCategory(book.getCategoryId(), 4);
        // Exclude the current book from related recommendations
        relatedBooks.removeIf(b -> b.getBookId() == book.getBookId());

        request.setAttribute("book", book);
        request.setAttribute("relatedBooks", relatedBooks);

        request.getRequestDispatcher("/book-details.jsp").forward(request, response);
    }
}
