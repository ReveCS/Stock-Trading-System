package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import java.security.MessageDigest;
import java.math.BigInteger;

import model.Login;
import model.Stock;

public class LoginDao {
	/*
	 * This class handles all the database operations related to login functionality
	 */
	
	
	public Login login(String username, String password, String role) {
		/*
		 * Return a Login object with role as "manager", "customerRepresentative" or "customer" if successful login
		 * Else, return null
		 * The role depends on the type of the user, which has to be handled in the database
		 * username, which is the email address of the user, is given as method parameter
		 * password, which is the password of the user, is given as method parameter
		 * Query to verify the username and password and fetch the role of the user, must be implemented
		 */
		
		if (password.equals("")) {
			Login l = new Login();
			l.setRole(role);
			l.setUsername(username);
		}
		
		Login login = new Login();
		login.setRole(role);
		login.setUsername(username);
		
		try {
			// MD5 Encryption...
			MessageDigest md = MessageDigest.getInstance("MD5");
			byte[] messageDigest = md.digest(password.getBytes());
			BigInteger number = new BigInteger(1, messageDigest);
			String hashtext = number.toString(16);
			
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");
			PreparedStatement st = con.prepareStatement("SELECT * FROM LoginInfo WHERE UserPass=? AND Email=?");
			
			st.setString(1, hashtext);
			st.setString(2, username);
			
			ResultSet rs = st.executeQuery();
			
			if (rs.next()) {
				if (rs.getInt("UserRole") == 0 && role.equals("customer")) {
					return login;
				} else if (rs.getInt("UserRole") == 2 && role.equals("manager")) {
					return login;
				} else if (rs.getInt("UserRole") == 1 && role.equals("customerRepresentative")) {
					return login;
				}
				return null;
			} else {
				return null;
			}
		} catch (Exception e) {
			System.out.println(e);
			return null;
		}
		
	}
	
	public String addUser(Login login) {
		/*
		 * Query to insert a new record for user login must be implemented
		 * login, which is the "Login" Class object containing username and password for the new user, is given as method parameter
		 * The username and password from login can get accessed using getter methods in the "Login" model
		 * e.g. getUsername() method will return the username encapsulated in login object
		 * Return "success" on successful insertion of a new user
		 * Return "failure" for an unsuccessful database operation
		 */

		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");
			PreparedStatement st = con.prepareStatement("CALL Add_Login(?, ?, ?)");
			
			// MD5 Encryption...
			MessageDigest md = MessageDigest.getInstance("MD5");
			byte[] messageDigest = md.digest(login.getPassword().getBytes());
			BigInteger number = new BigInteger(1, messageDigest);
			String hashtext = number.toString(16);
			
			int role = 0;
			if (login.getRole().equals("Employee")) {
				role = 1;
			} else if (login.getRole().equals("Manager")){
				role = 2;
			}
			
			st.setString(1, login.getUsername());
			st.setString(2, hashtext);
			st.setInt(3, role);
			
			ResultSet rs = st.executeQuery();
		}catch (Exception e) {
			System.out.println(e);
			return "failure";
		}
		
		/*Sample data begins*/
		return "success";
		/*Sample data ends*/
	}

}
