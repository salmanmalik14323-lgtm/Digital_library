package com.digitallibrary.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Thread-safe Database Connection Utility for MySQL JDBC.
 * Reads configurations from db.properties or falls back to sensible defaults.
 * Provides graceful status checks.
 */
public class DBConnection {
    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());

    private static String jdbcUrl;
    private static String jdbcUser;
    private static String jdbcPassword;
    private static String jdbcDriver;
    private static boolean driverLoaded = false;

    static {
        loadProperties();
    }

    private static synchronized void loadProperties() {
        Properties props = new Properties();
        try (InputStream input = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input != null) {
                props.load(input);
                jdbcDriver = props.getProperty("db.driver", "com.mysql.cj.jdbc.Driver");
                jdbcUrl = props.getProperty("db.url", "jdbc:mysql://localhost:3306/digital_library_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8");
                jdbcUser = props.getProperty("db.username", "root");
                jdbcPassword = props.getProperty("db.password", "root");
            } else {
                jdbcDriver = "com.mysql.cj.jdbc.Driver";
                jdbcUrl = "jdbc:mysql://localhost:3306/digital_library_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8";
                jdbcUser = "root";
                jdbcPassword = "root";
            }

            try {
                Class.forName(jdbcDriver);
                driverLoaded = true;
                LOGGER.info("MySQL JDBC Driver registered successfully: " + jdbcDriver);
            } catch (ClassNotFoundException e) {
                driverLoaded = false;
                LOGGER.warning("MySQL JDBC Driver (" + jdbcDriver + ") not found in classpath. In-memory demo fallback will be used.");
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error reading db.properties. Falling back to defaults.", e);
        }
    }

    /**
     * Obtains an active connection to the database.
     * @return Connection object or null if database is unavailable
     */
    public static Connection getConnection() throws SQLException {
        if (!driverLoaded) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                driverLoaded = true;
            } catch (ClassNotFoundException e) {
                throw new SQLException("MySQL JDBC Driver (com.mysql.cj.jdbc.Driver) not found in runtime classpath.", e);
            }
        }
        return DriverManager.getConnection(jdbcUrl, jdbcUser, jdbcPassword);
    }

    /**
     * Checks if MySQL database is reachable.
     */
    public static boolean isConnected() {
        Connection conn = null;
        try {
            conn = getConnection();
            return conn != null && !conn.isClosed();
        } catch (Exception e) {
            return false;
        } finally {
            close(conn);
        }
    }

    /**
     * Safely closes the given database resources.
     */
    public static void close(Connection conn, Statement stmt, ResultSet rs) {
        if (rs != null) {
            try { rs.close(); } catch (SQLException ignored) {}
        }
        if (stmt != null) {
            try { stmt.close(); } catch (SQLException ignored) {}
        }
        if (conn != null) {
            try { conn.close(); } catch (SQLException ignored) {}
        }
    }

    public static void close(Connection conn, Statement stmt) {
        close(conn, stmt, null);
    }

    public static void close(Connection conn) {
        close(conn, null, null);
    }
}
