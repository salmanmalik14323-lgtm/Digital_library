package com.digitallibrary.servlet;

import com.digitallibrary.dao.CategoryDAO;
import com.digitallibrary.dao.RecommendationDAO;
import com.digitallibrary.dao.UserInterestDAO;
import com.digitallibrary.model.Category;
import com.digitallibrary.model.Recommendation;
import com.digitallibrary.model.User;
import com.digitallibrary.model.UserInterest;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 * Controller for generating and displaying personalized book recommendations.
 */
@WebServlet(name = "RecommendationServlet", urlPatterns = {"/recommendations"})
public class RecommendationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final RecommendationDAO recommendationDAO = new RecommendationDAO();
    private final UserInterestDAO userInterestDAO = new UserInterestDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String refreshParam = request.getParameter("refresh");
        boolean forceRefresh = "true".equalsIgnoreCase(refreshParam);

        List<Recommendation> recommendations;
        if (forceRefresh) {
            recommendations = recommendationDAO.refreshRecommendationsForUser(currentUser.getUserId(), 12);
            request.setAttribute("infoMessage", "Recommendations refreshed based on your latest viewing activity and interests.");
        } else {
            recommendations = recommendationDAO.getCachedRecommendations(currentUser.getUserId(), 12);
            // If cache is empty, generate freshly
            if (recommendations == null || recommendations.isEmpty()) {
                recommendations = recommendationDAO.refreshRecommendationsForUser(currentUser.getUserId(), 12);
            }
        }

        List<UserInterest> userInterests = userInterestDAO.getUserInterests(currentUser.getUserId());
        Set<Integer> userInterestIds = userInterestDAO.getUserInterestCategoryIds(currentUser.getUserId());
        List<Category> allCategories = categoryDAO.getAllCategories();

        request.setAttribute("recommendations", recommendations);
        request.setAttribute("userInterests", userInterests);
        request.setAttribute("userInterestIds", userInterestIds);
        request.setAttribute("allCategories", allCategories);

        request.getRequestDispatcher("/recommendations.jsp").forward(request, response);
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
        if ("updateInterests".equals(action)) {
            String[] selectedCategories = request.getParameterValues("interestCategories");
            List<Integer> catIds = new ArrayList<>();
            if (selectedCategories != null) {
                for (String catStr : selectedCategories) {
                    try {
                        catIds.add(Integer.parseInt(catStr));
                    } catch (NumberFormatException ignored) {}
                }
            }

            userInterestDAO.setUserInterests(currentUser.getUserId(), catIds);
            recommendationDAO.refreshRecommendationsForUser(currentUser.getUserId(), 12);

            session.setAttribute("successMessage", "Your reading interests and recommendations have been updated!");
        }

        response.sendRedirect(request.getContextPath() + "/recommendations");
    }
}
