package dao;

import java.sql.*;
import java.text.Format;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import model.Customer;
import model.Employee;
import model.Location;
import model.Stock;

import java.util.stream.IntStream;

public class CustomerDao {
	/*
	 * This class handles all the database operations related to the customer table
	 */

    public Customer getDummyCustomer() {
        Location location = new Location();
        location.setZipCode(11790);
        location.setCity("Stony Brook");
        location.setState("NY");

        Customer customer = new Customer();
        customer.setId("111-11-1111");
        customer.setAddress("123 Success Street");
        customer.setLastName("Lu");
        customer.setFirstName("Shiyong");
        customer.setEmail("shiyong@cs.sunysb.edu");
        customer.setLocation(location);
        customer.setTelephone("5166328959");
        customer.setCreditCard("1234567812345678");
        customer.setRating(1);

        return customer;
    }
    public List<Customer> getDummyCustomerList() {
        /*Sample data begins*/
        List<Customer> customers = new ArrayList<Customer>();

        for (int i = 0; i < 10; i++) {
            customers.add(getDummyCustomer());
        }
		/*Sample data ends*/

        return customers;
    }

    /**
	 * @param String searchKeyword
	 * @return ArrayList<Customer> object
	 */
	public List<Customer> getCustomers(String searchKeyword) {
		/*
		 * This method fetches one or more customers based on the searchKeyword and returns it as an ArrayList
		 */
		
		/*
		 * The students code to fetch data from the database based on searchKeyword will be written here
		 * Each record is required to be encapsulated as a "Customer" class object and added to the "customers" List
		 */
		
		List<Customer> customers = new ArrayList<Customer>();
		Format formatter = new SimpleDateFormat("yyyy-MM-dd");
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/stonksmaster", "root", "root");
			Statement st = con.createStatement();
			ResultSet rs = st.executeQuery("SELECT ");

			/*Sample data begins*/
			while(rs.next()) {
				Customer customer = new Customer();
				
				customers.add();
			}
			
			/*Sample data ends*/
		}catch (Exception e) {
			System.out.println(e);
		}
		
		return customers;
	}


	public Customer getHighestRevenueCustomer() {
		/*
		 * This method fetches the customer who generated the highest total revenue and returns it
		 * The students code to fetch data from the database will be written here
		 * The customer record is required to be encapsulated as a "Customer" class object
		 */

		return getDummyCustomer();
	}

	public Customer getCustomer(String customerID) {

		/*
		 * This method fetches the customer details and returns it
		 * customerID, which is the Customer's ID who's details have to be fetched, is given as method parameter
		 * The students code to fetch data from the database will be written here
		 * The customer record is required to be encapsulated as a "Customer" class object
		 */
		
		Customer customer = new Customer();
		Format formatter = new SimpleDateFormat("yyyy-MM-dd");
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/stonksmaster", "root", "root");
			Statement st = con.createStatement();
			ResultSet rs = st.executeQuery("SELECT acc.ClientId, c.CreditCardNumber, c.Rating, acc.AccNum, acc.DateOpened FROM Clients c INNER JOIN Account acc ON c.ClientId = acc.ClientId WHERE c.ClientId = \'%" + customerID + "\'%");

			/*Sample data begins*/
			while(rs.next()) {
				customer.setClientId(rs.getString("ClientId"));
				customer.setCreditCard(Integer.toString(rs.getInt("CreditCardNumber")));
				customer.setAccountCreationTime(formatter.format(rs.getDate("DateOpened")));
				customer.setAccountNumber(rs.getInt("AccNum"));
				customer.setRating(rs.getInt("Rating"));
			}
			
			/*Sample data ends*/
		}catch (Exception e) {
			System.out.println(e);
		}
		
		return customer;

	}
	
	public String deleteCustomer(String customerID) {

		/*
		 * This method deletes a customer returns "success" string on success, else returns "failure"
		 * The students code to delete the data from the database will be written here
		 * customerID, which is the Customer's ID who's details have to be deleted, is given as method parameter
		 */

		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/stonksmaster", "root", "root");
			Statement st = con.createStatement();
			ResultSet rs = st.executeQuery("delete from Clients where ClientId like \'%" + customerID + "%\'");
		}catch (Exception e) {
			System.out.println(e);
			return "failure";
		}
		return "success";
		
	}


	public String getCustomerID(String email) {
		/*
		 * This method returns the Customer's ID based on the provided email address
		 * The students code to fetch data from the database will be written here
		 * username, which is the email address of the customer, who's ID has to be returned, is given as method parameter
		 * The Customer's ID is required to be returned as a String
		 */
		
		String result = "";
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/stonksmaster", "root", "root");
			Statement st = con.createStatement();
			ResultSet rs = st.executeQuery("SELECT c.ClientId, p.Email FROM Clients c INNER JOIN Person p ON c.ClientId = p.SSN WHERE p.Email = \'%" + email + "\'%");

			/*Sample data begins*/
			while(rs.next()) {
				result = rs.getString("Email");
			}
			
			/*Sample data ends*/
		}catch (Exception e) {
			System.out.println(e);
		}

		return result;
	}


	public String addCustomer(Customer customer) {
		/*
		 * All the values of the add customer form are encapsulated in the customer object.
		 * These can be accessed by getter methods (see Customer class in model package).
		 * e.g. firstName can be accessed by customer.getFirstName() method.
		 * The sample code returns "success" by default.
		 * You need to handle the database insertion of the customer details and return "success" or "failure" based on result of the database insertion.
		 */
		
		/*Sample data begins*/
		String clientId = customer.getClientId();
		clientId = "Information";
		String creditCard = customer.getCreditCard();
		int rating = customer.getRating();
		String firstName = customer.getFirstName();
		String lastName = customer.getLastName();
		String email = customer.getEmail();	
		String address = customer.getAddress();
		Location location = customer.getLocation();
		String city = location.getCity();
		String state = location.getState();
		int zipcode = location.getZipCode();
		String telephone = customer.getTelephone();
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			System.out.println("huh?");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");

			PreparedStatement st = con.prepareStatement("CALL AddCustomer(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
			
			st.setString(1, clientId);
			st.setString(2, creditCard);
			st.setInt(3, rating);
			st.setString(4, lastName);
			st.setString(5, firstName);
			st.setString(6, email);
			st.setString(7, address);
			st.setInt(8, zipcode);
			st.setString(9, city);
			st.setString(10, state);
			st.setString(11, telephone);
			
			ResultSet rs = st.executeQuery();
			
		}catch (Exception e) {
			System.out.println(e);
			return "failure";
		}
		return "success";

	}

	public String editCustomer(Customer customer) {
		/*
		 * All the values of the edit customer form are encapsulated in the customer object.
		 * These can be accessed by getter methods (see Customer class in model package).
		 * e.g. firstName can be accessed by customer.getFirstName() method.
		 * The sample code returns "success" by default.
		 * You need to handle the database update and return "success" or "failure" based on result of the database update.
		 */
		
		/*Sample data begins*/
		String clientId = customer.getClientId();
		String creditCard = customer.getCreditCard();
		int rating = customer.getRating();
		String firstName = customer.getFirstName();
		String lastName = customer.getLastName();
		String email = customer.getEmail();
		String address = customer.getAddress();
		Location location = customer.getLocation();
		String city = location.getCity();
		String state = location.getState();
		int zipcode = location.getZipCode();
		String telephone = customer.getTelephone();
	
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");
			Statement st = con.createStatement();
			ResultSet rs = st.executeQuery("CALL UpdateCustomer(\'%" + clientId + "\'%, \'%" + creditCard + "\'%, " + rating + ", \'%" + lastName + "\'%, \'%" + firstName + "\'%, \'%" + email + "\'%, \'%" + address + "\'%, " + zipcode + ", \'%" + city + "\'%, \'%" + state + "\'%, \\'%" + telephone + "\'%");
			
		}catch (Exception e) {
			System.out.println(e);
			return "failure";
		}
		return "success";
		/*Sample data ends*/
	}

    public List<Customer> getCustomerMailingList() {

		/*
		 * This method fetches the all customer mailing details and returns it
		 * The students code to fetch data from the database will be written here
		 */
    	
    	List<Customer> result = new ArrayList<Customer>();
		Format formatter = new SimpleDateFormat("yyyy-MM-dd");

    	try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");
			Statement st = con.createStatement();
			ResultSet rs = st.executeQuery("SELECT c.*, acc.*, p.*, l.City, l.State FROM Clients c INNER JOIN Account acc ON acc.ClientId = c.ClientId INNER JOIN Person p ON p.SSN = c.ClientId JOIN Location l ON l.ZipCode = p.ZipCode");
			
			while(rs.next()) {
				Customer customer = new Customer();
				customer.setClientId(rs.getString("ClientId"));
				customer.setCreditCard(rs.getString("CreditCardNumber"));
				customer.setRating(rs.getInt("Rating"));
				customer.setAccountNumber(rs.getInt("AccNum"));
				customer.setAccountCreationTime(formatter.format(rs.getDate("DateOpened")));
				customer.setFirstName(rs.getString("FirstName"));
				customer.setLastName(rs.getString("LastName"));
				customer.setEmail(rs.getString("Email"));
				customer.setSsn(rs.getString("Ssn"));
				customer.setAddress(rs.getString("Address"));
				Location location = new Location();
				location.setCity(rs.getString("City"));
				location.setState(rs.getString("State"));
				location.setZipCode(rs.getInt("ZipCode"));
				customer.setLocation(location);
				customer.setTelephone(rs.getString("Telephone"));
				result.add(customer);
			}
		}catch (Exception e) {
			System.out.println(e);
		}
    	
    	return result;
    }

    public List<Customer> getAllCustomers() {
        /*
		 * This method fetches returns all customers
		 */
    	
    	List<Customer> customers = new ArrayList<Customer>();
		Format formatter = new SimpleDateFormat("yyyy-MM-dd");
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");
			Statement st = con.createStatement();
			ResultSet rs = st.executeQuery("select * from Clients IN");
		
			/*Sample data begins*/
			while(rs.next()) {
				Customer customer = new Customer();
				customer.setClientId(rs.getString("ClientId"));
				customer.setCreditCard(rs.getString("CreditCardNumber"));
				customer.setAccountCreationTime(formatter.format(rs.getDate("DateOpened")));
				customer.setAccountNumber(rs.getInt("AccNum"));
				customer.setRating(rs.getInt("Rating"));
				customer.setFirstName(rs.getString("FirstName"));
				customer.setLastName(rs.getString("LastName"));
				customer.setEmail(rs.getString("Email"));
				customer.setSsn(rs.getString("Ssn"));
				customer.setAddress(rs.getString("Address"));
				Location location = new Location();
				location.setCity(rs.getString("City"));
				location.setState(rs.getString("State"));
				location.setZipCode(rs.getInt("ZipCode"));
				customer.setLocation(location);
				customer.setTelephone(rs.getString("Telephone"));
				customers.add(customer);
			}
			/*Sample data ends*/
		}catch (Exception e) {
			System.out.println(e);
		}
	
		return customers;
    }
}
