package com.digitallibrary.servlet;

import com.digitallibrary.dao.CategoryDAO;
import com.digitallibrary.dao.RecommendationDAO;
import com.digitallibrary.dao.UserDAO;
import com.digitallibrary.dao.UserInterestDAO;
import com.digitallibrary.model.Category;
import com.digitallibrary.model.User;
import com.digitallibrary.util.PasswordUtil;
import com.digitallibrary.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Controller handling user authentication, sign-up, session creation, and logout.
 */
@WebServlet(name = "AuthServlet", urlPatterns = {"/login", "/register", "/logout"})
public class AuthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final UserDAO userDAO = new UserDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final UserInterestDAO userInterestDAO = new UserInterestDAO();
    private final RecommendationDAO recommendationDAO = new RecommendationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/login":
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                break;
            case "/register":
                List<Category> categories = categoryDAO.getAllCategories();
                request.setAttribute("categories", categories);
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                break;
            case "/logout":
                handleLogout(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/home");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/login".equals(path)) {
            handleLogin(request, response);
        } else if ("/register".equals(path)) {
            handleRegister(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String usernameOrEmail = request.getParameter("usernameOrEmail");
        String password = request.getParameter("password");

        if (ValidationUtil.isNullOrEmpty(usernameOrEmail) || ValidationUtil.isNullOrEmpty(password)) {
            request.setAttribute("errorMessage", "Please provide both username/email and password.");
            request.setAttribute("usernameOrEmail", usernameOrEmail);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.authenticate(usernameOrEmail.trim(), password);

        if (user != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("currentUser", user);
            session.setAttribute("successMessage", "Welcome back, " + user.getFullName() + "!");

            if (user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/user-dashboard");
            }
        } else {
            request.setAttribute("errorMessage", "Invalid credentials. Please verify your username and password.");
            request.setAttribute("usernameOrEmail", usernameOrEmail);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String bio = request.getParameter("bio");
        String[] selectedCategories = request.getParameterValues("interestCategories");

        // Validation checks
        if (!ValidationUtil.isValidUsername(username)) {
            forwardRegisterError(request, response, "Username must be alphanumeric (3-30 characters).");
            return;
        }

        if (!ValidationUtil.isValidEmail(email)) {
            forwardRegisterError(request, response, "Please provide a valid email address.");
            return;
        }

        if (ValidationUtil.isNullOrEmpty(fullName)) {
            forwardRegisterError(request, response, "Full Name is required.");
            return;
        }

        if (!ValidationUtil.isStrongPassword(password)) {
            forwardRegisterError(request, response, "Password must be at least 6 characters in length.");
            return;
        }

        if (!password.equals(confirmPassword)) {
            forwardRegisterError(request, response, "Passwords do not match.");
            return;
        }

        if (userDAO.getUserByUsername(username.trim()) != null) {
            forwardRegisterError(request, response, "Username is already registered. Please choose another.");
            return;
        }

        if (userDAO.getUserByEmail(email.trim()) != null) {
            forwardRegisterError(request, response, "An account with this email already exists.");
            return;
        }

        // Salt and hash password
        String salt = PasswordUtil.generateSalt();
        String hash = PasswordUtil.hashPassword(password, salt);

        User newUser = new User();
        newUser.setUsername(username.trim());
        newUser.setEmail(email.trim());
        newUser.setPasswordHash(hash);
        newUser.setSalt(salt);
        newUser.setFullName(fullName.trim());
        newUser.setRole("USER");
        newUser.setPhone(phone != null ? phone.trim() : null);
        newUser.setBio(bio != null ? bio.trim() : null);

        boolean registered = userDAO.registerUser(newUser);

        if (registered) {
            // Save selected interests
            if (selectedCategories != null && selectedCategories.length > 0) {
                List<Integer> catIds = new ArrayList<>();
                for (String catStr : selectedCategories) {
                    try {
                        catIds.add(Integer.parseInt(catStr));
                    } catch (NumberFormatException ignored) {}
                }
                userInterestDAO.setUserInterests(newUser.getUserId(), catIds);
            }

            // Generate initial recommendations
            recommendationDAO.refreshRecommendationsForUser(newUser.getUserId(), 8);

            // Establish session
            HttpSession session = request.getSession(true);
            session.setAttribute("currentUser", newUser);
            session.setAttribute("successMessage", "Account registered successfully! Welcome to Digital Library.");

            response.sendRedirect(request.getContextPath() + "/user-dashboard");
        } else {
            forwardRegisterError(request, response, "Registration failed due to a database error. Please try again.");
        }
    }

    private void forwardRegisterError(HttpServletRequest request, HttpServletResponse response, String error)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", error);
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/login?logout=true");
    }
}
