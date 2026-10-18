package com.digitallibrary.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;

/**
 * Utility for Cryptographic Password Hashing and Verification.
 * Implements Salted SHA-256 hashing to protect user credentials.
 */
public class PasswordUtil {

    private static final SecureRandom RANDOM = new SecureRandom();

    /**
     * Generates a 16-byte cryptographically secure random hexadecimal salt.
     * @return 32-character hexadecimal salt string
     */
    public static String generateSalt() {
        byte[] saltBytes = new byte[16];
        RANDOM.nextBytes(saltBytes);
        return bytesToHex(saltBytes);
    }

    /**
     * Hashes a plain-text password concatenated with the given salt using SHA-256.
     * @param password Plain-text password
     * @param salt Salt string
     * @return 64-character hexadecimal SHA-256 hash
     */
    public static String hashPassword(String password, String salt) {
        if (password == null || salt == null) {
            throw new IllegalArgumentException("Password and salt cannot be null.");
        }
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            String input = password + salt;
            byte[] hashBytes = digest.digest(input.getBytes(StandardCharsets.UTF_8));
            return bytesToHex(hashBytes);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not available in current JVM.", e);
        }
    }

    /**
     * Verifies whether a given plain-text password matches the stored salted hash.
     * @param rawPassword User-entered password
     * @param storedHash Hash stored in the database
     * @param salt Salt associated with the user
     * @return true if credentials match, false otherwise
     */
    public static boolean verifyPassword(String rawPassword, String storedHash, String salt) {
        if (rawPassword == null || storedHash == null || salt == null) {
            return false;
        }
        String computed = hashPassword(rawPassword, salt);
        return MessageDigest.isEqual(computed.getBytes(StandardCharsets.UTF_8),
                                    storedHash.getBytes(StandardCharsets.UTF_8));
    }

    private static String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder(bytes.length * 2);
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}
