package com.instafoo.connection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
	

	private static String getEnv(String key, String defaultValue) {
		String value = System.getenv(key);
		return (value != null) ? value : defaultValue;
	}
		
	public static Connection getConnection() {
		String dbHost = getEnv("DB_HOST", "localhost");
		String dbPort = getEnv("DB_PORT", "3306");
		String dbName = getEnv("DB_NAME", "instafoods");
		String dbUser = getEnv("DB_USER", "root");
		String dbPassword = getEnv("DB_PASSWORD", "newpassword123");

		String url = "jdbc:mysql://" + dbHost + ":" + dbPort + "/" + dbName;
		Connection conn=null;
			
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn=DriverManager.getConnection(url,dbUser,dbPassword);
			
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return conn;
	}

	

}
