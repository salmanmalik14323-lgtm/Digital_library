package com.digitallibrary.util;

import com.digitallibrary.model.Book;
import com.digitallibrary.model.Recommendation;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Deterministic Content-Based Recommendation Engine.
 * 
 * Computes transparent, explainable recommendation scores for candidate books based on:
 * 1. Category Interest Match (up to 50 points):
 *    Direct alignment with user's selected subject categories.
 * 2. Browsing & Interaction History (up to 30 points):
 *    Frequency of views and searches within relevant categories.
 * 3. Book Quality & Stock Bonus (up to 20 points):
 *    Normalized book rating (up to 15 points) and immediate availability (5 points).
 */
public class RecommendationEngine {

    /**
     * Generates personalized recommendations for a user.
     * 
     * @param userId Target user ID
     * @param allBooks List of all catalog books
     * @param declaredInterestCategoryIds Set of category IDs explicitly chosen by the user
     * @param categoryViewCounts Map of Category ID to view frequency count
     * @param limit Maximum number of recommendations to return
     * @return Ranked list of Recommendation beans
     */
    public static List<Recommendation> generateRecommendations(
            int userId,
            List<Book> allBooks,
            Set<Integer> declaredInterestCategoryIds,
            Map<Integer, Integer> categoryViewCounts,
            int limit) {

        List<Recommendation> recommendations = new ArrayList<>();

        if (allBooks == null || allBooks.isEmpty()) {
            return recommendations;
        }

        for (Book book : allBooks) {
            double score = 0.0;
            StringBuilder reasonBuilder = new StringBuilder();

            boolean hasDeclaredInterest = declaredInterestCategoryIds != null && 
                                          declaredInterestCategoryIds.contains(book.getCategoryId());
            int viewCount = (categoryViewCounts != null && categoryViewCounts.containsKey(book.getCategoryId())) 
                            ? categoryViewCounts.get(book.getCategoryId()) : 0;

            // 1. Declared Interest Weight (50%)
            if (hasDeclaredInterest) {
                score += 50.0;
                reasonBuilder.append("Matches your chosen interest in ").append(book.getCategoryName());
            }

            // 2. Behavioral Interaction Weight (30%)
            if (viewCount > 0) {
                double viewScore = Math.min(viewCount * 10.0, 30.0);
                score += viewScore;
                if (reasonBuilder.length() > 0) {
                    reasonBuilder.append(" & based on your reading activity");
                } else {
                    reasonBuilder.append("Recommended because you recently explored ").append(book.getCategoryName());
                }
            }

            // 3. Quality & Availability Weight (20%)
            double ratingScore = (book.getRating() / 5.0) * 15.0;
            score += ratingScore;

            if (book.isAvailable()) {
                score += 5.0;
            }

            // Fallback reason if user has no interests or views yet
            if (reasonBuilder.length() == 0) {
                if (book.getRating() >= 4.7) {
                    reasonBuilder.append("Top-rated selection in ").append(book.getCategoryName());
                } else {
                    reasonBuilder.append("Popular title in ").append(book.getCategoryName());
                }
            }

            // Cap score at 100
            score = Math.min(Math.round(score * 10.0) / 10.0, 100.0);

            Recommendation rec = new Recommendation();
            rec.setUserId(userId);
            rec.setBookId(book.getBookId());
            rec.setBook(book);
            rec.setMatchScore(score);
            rec.setReason(reasonBuilder.toString());
            recommendations.add(rec);
        }

        // Sort descending by recommendation score
        recommendations.sort(Comparator.comparingDouble(Recommendation::getMatchScore).reversed());

        // Slice to limit
        if (recommendations.size() > limit) {
            return new ArrayList<>(recommendations.subList(0, limit));
        }

        return recommendations;
    }
}
