package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL =
            "jdbc:mysql://127.0.0.1:3306/foodexpress";

    private static final String USERNAME =
            "root";

    private static final String PASSWORD =
            "naresh6565@";

    private DBConnection() {
    }

    public static Connection getConnection() {

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            return DriverManager.getConnection(
                    URL,
                    USERNAME,
                    PASSWORD);

        } catch (ClassNotFoundException | SQLException e) {
            throw new RuntimeException("Database connection failed", e);
        }
    }
}