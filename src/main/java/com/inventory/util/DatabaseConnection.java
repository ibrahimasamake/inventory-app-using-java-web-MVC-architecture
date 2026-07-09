package com.inventory.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DatabaseConnection {

    private static String url;
    private static String username;
    private static String password;

    static {
        try (InputStream input = DatabaseConnection.class.getClassLoader()
                .getResourceAsStream("database.properties")) {
            Properties props = new Properties();
            props.load(input);
            Class.forName(props.getProperty("db.driver"));
            url = props.getProperty("db.url");
            username = props.getProperty("db.username");
            password = props.getProperty("db.password");
        } catch (Exception e) {
            e.printStackTrace();
            throw new ExceptionInInitializerError("Failed to load database properties");
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, username, password);
    }
}
