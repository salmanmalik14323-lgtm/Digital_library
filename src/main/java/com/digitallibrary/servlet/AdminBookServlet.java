package com.digitallibrary.servlet;

import com.digitallibrary.dao.BookDAO;
import com.digitallibrary.dao.CategoryDAO;
import com.digitallibrary.model.Book;
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
 * Controller for Administrator Book Inventory Management (CRUD operations).
 */
@WebServlet(name = "AdminBookServlet", urlPatterns = {
    "/admin/books",
    "/admin/book-add",
    "/admin/book-edit",
    "/admin/book-delete"
})
public class AdminBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final BookDAO bookDAO = new BookDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/admin/book-add":
                request.setAttribute("categories", categoryDAO.getAllCategories());
                request.setAttribute("formAction", "add");
                request.getRequestDispatcher("/admin-book-form.jsp").forward(request, response);
                break;

            case "/admin/book-edit":
                int editId = ValidationUtil.parseInt(request.getParameter("id"), -1);
                if (editId <= 0) {
                    response.sendRedirect(request.getContextPath() + "/admin/books");
                    return;
                }
                Book book = bookDAO.getBookById(editId);
                if (book == null) {
                    request.getSession().setAttribute("errorMessage", "Book not found.");
                    response.sendRedirect(request.getContextPath() + "/admin/books");
                    return;
                }
                request.setAttribute("book", book);
                request.setAttribute("categories", categoryDAO.getAllCategories());
                request.setAttribute("formAction", "edit");
                request.getRequestDispatcher("/admin-book-form.jsp").forward(request, response);
                break;

            case "/admin/books":
            default:
                String q = request.getParameter("q");
                String catParam = request.getParameter("category");
                Integer catId = ValidationUtil.isNullOrEmpty(catParam) ? null : ValidationUtil.parseInt(catParam, 0);
                if (catId != null && catId == 0) catId = null;

                List<Book> books = bookDAO.searchBooks(q, catId, "title", 100, 0);
                List<Category> categories = categoryDAO.getAllCategories();

                request.setAttribute("books", books);
                request.setAttribute("categories", categories);
                request.setAttribute("currentQuery", q);
                request.setAttribute("currentCategory", catId);
                request.getRequestDispatcher("/admin-books.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/admin/book-add":
                handleAddBook(request, response);
                break;
            case "/admin/book-edit":
                handleEditBook(request, response);
                break;
            case "/admin/book-delete":
                handleDeleteBook(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/books");
                break;
        }
    }

    private void handleAddBook(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String isbn = request.getParameter("isbn");
        String publisher = request.getParameter("publisher");
        int year = ValidationUtil.parseInt(request.getParameter("publicationYear"), 2024);
        int categoryId = ValidationUtil.parseInt(request.getParameter("categoryId"), 1);
        String description = request.getParameter("description");
        String coverUrl = request.getParameter("coverImageUrl");
        int totalCopies = ValidationUtil.parseInt(request.getParameter("totalCopies"), 5);
        int availableCopies = ValidationUtil.parseInt(request.getParameter("availableCopies"), totalCopies);
        double rating = ValidationUtil.parseDouble(request.getParameter("rating"), 4.5);
        int pageCount = ValidationUtil.parseInt(request.getParameter("pageCount"), 300);

        if (ValidationUtil.isNullOrEmpty(title) || ValidationUtil.isNullOrEmpty(author)) {
            request.setAttribute("errorMessage", "Book title and author cannot be empty.");
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.setAttribute("formAction", "add");
            request.getRequestDispatcher("/admin-book-form.jsp").forward(request, response);
            return;
        }

        if (ValidationUtil.isNullOrEmpty(coverUrl)) {
            coverUrl = "https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=600&q=80";
        }

        Book book = new Book();
        book.setTitle(title.trim());
        book.setAuthor(author.trim());
        book.setIsbn(isbn != null ? isbn.trim() : null);
        book.setPublisher(publisher != null ? publisher.trim() : null);
        book.setPublicationYear(year);
        book.setCategoryId(categoryId);
        book.setDescription(description != null ? description.trim() : "");
        book.setCoverImageUrl(coverUrl.trim());
        book.setTotalCopies(totalCopies);
        book.setAvailableCopies(availableCopies);
        book.setRating(rating);
        book.setPageCount(pageCount);

        boolean added = bookDAO.addBook(book);
        if (added) {
            request.getSession().setAttribute("successMessage", "Book '" + book.getTitle() + "' added successfully!");
        } else {
            request.getSession().setAttribute("errorMessage", "Failed to add book. Verify that ISBN is unique.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/books");
    }

    private void handleEditBook(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int bookId = ValidationUtil.parseInt(request.getParameter("bookId"), -1);
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String isbn = request.getParameter("isbn");
        String publisher = request.getParameter("publisher");
        int year = ValidationUtil.parseInt(request.getParameter("publicationYear"), 2024);
        int categoryId = ValidationUtil.parseInt(request.getParameter("categoryId"), 1);
        String description = request.getParameter("description");
        String coverUrl = request.getParameter("coverImageUrl");
        int totalCopies = ValidationUtil.parseInt(request.getParameter("totalCopies"), 5);
        int availableCopies = ValidationUtil.parseInt(request.getParameter("availableCopies"), totalCopies);
        double rating = ValidationUtil.parseDouble(request.getParameter("rating"), 4.5);
        int pageCount = ValidationUtil.parseInt(request.getParameter("pageCount"), 300);

        if (bookId <= 0 || ValidationUtil.isNullOrEmpty(title) || ValidationUtil.isNullOrEmpty(author)) {
            request.getSession().setAttribute("errorMessage", "Invalid book information.");
            response.sendRedirect(request.getContextPath() + "/admin/books");
            return;
        }

        Book book = new Book();
        book.setBookId(bookId);
        book.setTitle(title.trim());
        book.setAuthor(author.trim());
        book.setIsbn(isbn != null ? isbn.trim() : null);
        book.setPublisher(publisher != null ? publisher.trim() : null);
        book.setPublicationYear(year);
        book.setCategoryId(categoryId);
        book.setDescription(description != null ? description.trim() : "");
        book.setCoverImageUrl(coverUrl != null ? coverUrl.trim() : "");
        book.setTotalCopies(totalCopies);
        book.setAvailableCopies(availableCopies);
        book.setRating(rating);
        book.setPageCount(pageCount);

        boolean updated = bookDAO.updateBook(book);
        if (updated) {
            request.getSession().setAttribute("successMessage", "Book '" + book.getTitle() + "' updated successfully!");
        } else {
            request.getSession().setAttribute("errorMessage", "Failed to update book.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/books");
    }

    private void handleDeleteBook(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int bookId = ValidationUtil.parseInt(request.getParameter("bookId"), -1);
        if (bookId > 0) {
            boolean deleted = bookDAO.deleteBook(bookId);
            if (deleted) {
                request.getSession().setAttribute("successMessage", "Book removed from library catalogue.");
            } else {
                request.getSession().setAttribute("errorMessage", "Cannot delete book: dependent records exist.");
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/books");
    }
}
