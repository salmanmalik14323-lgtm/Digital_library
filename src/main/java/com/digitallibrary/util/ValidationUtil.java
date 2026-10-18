package com.digitallibrary.util;

import java.util.regex.Pattern;

/**
 * Utility for Input Validation, Data Sanitization, and XSS Prevention.
 */
public class ValidationUtil {

    private static final Pattern EMAIL_PATTERN = Pattern.compile(
        "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$"
    );

    private static final Pattern USERNAME_PATTERN = Pattern.compile("^[a-zA-Z0-9_]{3,30}$");

    private static final Pattern PHONE_PATTERN = Pattern.compile("^[+]?[0-9\\s-]{7,15}$");

    public static boolean isNullOrEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    public static boolean isValidEmail(String email) {
        if (isNullOrEmpty(email)) return false;
        return EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    public static boolean isValidUsername(String username) {
        if (isNullOrEmpty(username)) return false;
        return USERNAME_PATTERN.matcher(username.trim()).matches();
    }

    public static boolean isValidPhone(String phone) {
        if (isNullOrEmpty(phone)) return true; // Optional field
        return PHONE_PATTERN.matcher(phone.trim()).matches();
    }

    public static boolean isStrongPassword(String password) {
        if (isNullOrEmpty(password)) return false;
        // At least 6 characters
        return password.length() >= 6;
    }

    /**
     * Sanitizes string by escaping HTML characters to prevent Cross-Site Scripting (XSS).
     */
    public static String sanitize(String input) {
        if (input == null) return null;
        return input.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#x27;")
                    .replace("/", "&#x2F;");
    }

    public static int parseInt(String str, int defaultValue) {
        if (isNullOrEmpty(str)) return defaultValue;
        try {
            return Integer.parseInt(str.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    public static double parseDouble(String str, double defaultValue) {
        if (isNullOrEmpty(str)) return defaultValue;
        try {
            return Double.parseDouble(str.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}
