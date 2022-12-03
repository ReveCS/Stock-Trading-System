package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
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

public class EmployeeDao {
	/*
	 * This class handles all the database operations related to the employee table
	 */

    public Employee getDummyEmployee()
    {
        Employee employee = new Employee();

        Location location = new Location();
        location.setCity("Stony Brook");
        location.setState("NY");
        location.setZipCode(11790);

		/*Sample data begins*/
        employee.setEmail("shiyong@cs.sunysb.edu");
        employee.setFirstName("Shiyong");
        employee.setLastName("Lu");
        employee.setLocation(location);
        employee.setAddress("123 Success Street");
        employee.setStartDate("2006-10-17");
        employee.setTelephone("5166328959");
        employee.setEmployeeID("631-413-5555");
        employee.setHourlyRate(100);
		/*Sample data ends*/

        return employee;
    }

    public List<Employee> getDummyEmployees()
    {
       List<Employee> employees = new ArrayList<Employee>();

        for(int i = 0; i < 10; i++)
        {
            employees.add(getDummyEmployee());
        }

        return employees;
    }

	public String addEmployee(Employee employee) {
		/*
		 * All the values of the add employee form are encapsulated in the employee object.
		 * These can be accessed by getter methods (see Employee class in model package).
		 * e.g. firstName can be accessed by employee.getFirstName() method.
		 * The sample code returns "success" by default.
		 * You need to handle the database insertion of the employee details and return "success" or "failure" based on result of the database insertion.
		 */
		
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMMM d, yyyy", Locale.ENGLISH);
		
		/*Sample data begins*/
		String employeeID = employee.getEmployeeID();
		String startDate = employee.getStartDate(); //String -> Date
		float hourlyRate = employee.getHourlyRate();
		String firstName = employee.getFirstName();
		String lastName = employee.getLastName();
		String email = employee.getEmail();
		String ssn = employee.getSsn();
		String address = employee.getAddress();
		Location location = employee.getLocation();
		String city = location.getCity();
		String state = location.getState();
		int zipcode = location.getZipCode();
		String telephone = employee.getTelephone();
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/stonksmaster", "root", "root");
			Statement st = con.createStatement();
			ResultSet rs = st.executeQuery("CALL AddEmployee(\'%" + employeeID + "\'%, \'%" + startDate + "\'%, " + hourlyRate + ", \'%" + lastName + "\'%, \'%" + firstName + "\'%, \'%" + email + "\'%, \'%" + address + "\'%, " + zipcode + ", \'%" + city + "\'%, \'%" + state + "\'%, \\'%" + telephone + "\'%");
			
		}catch (Exception e) {
			System.out.println(e);
			return "failure";
		}
		return "success";
		/*Sample data ends*/

	}

	public String editEmployee(Employee employee) {
		/*
		 * All the values of the edit employee form are encapsulated in the employee object.
		 * These can be accessed by getter methods (see Employee class in model package).
		 * e.g. firstName can be accessed by employee.getFirstName() method.
		 * The sample code returns "success" by default.
		 * You need to handle the database update and return "success" or "failure" based on result of the database update.
		 */
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMMM d, yyyy", Locale.ENGLISH);
		
		/*Sample data begins*/
		String employeeID = employee.getEmployeeID();
		String startDate = employee.getStartDate();
		LocalDate date = LocalDate.parse(startDate, formatter); //String -> Date
		float hourlyRate = employee.getHourlyRate();
		String firstName = employee.getFirstName();
		String lastName = employee.getLastName();
		String email = employee.getEmail();
		String ssn = employee.getSsn();
		String address = employee.getAddress();
		Location location = employee.getLocation();
		String city = location.getCity();
		String state = location.getState();
		int zipcode = location.getZipCode();
		String telephone = employee.getTelephone();
	
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/stonksmaster", "root", "root");
			Statement st = con.createStatement();
			ResultSet rs = st.executeQuery("CALL UpdateEmployee(\'%" + employeeID + "\'%, \'%" + date + "\'%, " + hourlyRate + ", \'%" + lastName + "\'%, \'%" + firstName + "\'%, \'%" + email + "\'%, \'%" + address + "\'%, " + zipcode + ", \'%" + city + "\'%, \'%" + state + "\'%, \\'%" + telephone + "\'%");
			
		}catch (Exception e) {
			System.out.println(e);
			return "failure";
		}
		return "success";
		/*Sample data ends*/

	}

	public String deleteEmployee(String employeeID) {
		/*
		 * employeeID, which is the Employee's ID which has to be deleted, is given as method parameter
		 * The sample code returns "success" by default.
		 * You need to handle the database deletion and return "success" or "failure" based on result of the database deletion.
		 */
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/stonksmaster", "root", "root");
			Statement st = con.createStatement();
			ResultSet rs = st.executeQuery("delete from Employee where employeeID like \'%" + employeeID + "%\'");
		}catch (Exception e) {
			System.out.println(e);
			return "failure";
		}
		return "success";
	}

	
	public List<Employee> getEmployees() {

		/*
		 * The students code to fetch data from the database will be written here
		 * Query to return details about all the employees must be implemented
		 * Each record is required to be encapsulated as a "Employee" class object and added to the "employees" List
		 */

		List<Employee> employees = new ArrayList<Employee>();
		Format formatter = new SimpleDateFormat("yyyy-MM-dd");
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/stonksmaster", "root", "root");
			Statement st = con.createStatement();
			ResultSet rs = st.executeQuery("select * from Employee");
		

			/*Sample data begins*/
			while(rs.next()) {
				Employee employee = new Employee();
				employee.setId(rs.getString("EmpID"));
				employee.setStartDate(formatter.format(rs.getDate("StartDate"))); //Date -> String
				employee.setHourlyRate(rs.getFloat("HourlyRate"));
				employee.setLevel(rs.getString("isManager"));
				/*
				employee.setFirstName(rs.getString("firstName"));
				employee.setLastName(rs.getString("lastName"));
				employee.setEmail(rs.getString("email"));
				employee.setSsn(rs.getString("ssn"));
				employee.setAddress(rs.getString("Address"));
				Location location = new Location();
				location.setCity(rs.getString("City"));
				location.setState(rs.getString("State"));
				location.setZipCode(rs.getInt("ZipCode"));
				employee.setLocation(location);
				employee.setTelephone(rs.getString("telephone"));
				employees.add(employee);
				*/
			}
			/*Sample data ends*/
		}catch (Exception e) {
			System.out.println(e);
		}
	
		return employees;
	}

	public Employee getEmployee(String employeeID) {

		/*
		 * The students code to fetch data from the database based on "employeeID" will be written here
		 * employeeID, which is the Employee's ID who's details have to be fetched, is given as method parameter
		 * The record is required to be encapsulated as a "Employee" class object
		 */
		
		Employee employee = new Employee();
		Format formatter = new SimpleDateFormat("yyyy-MM-dd");
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/stonksmater", "root", "root");
			Statement st = con.createStatement();
			ResultSet rs = st.executeQuery("select * from Employee where employeeID like \'%" + employeeID + "%\'");

			/*Sample data begins*/
			while(rs.next()) {
				employee.setId(rs.getString("employeeID"));
				employee.setStartDate(formatter.format(rs.getString("startDate"))); //Date -> String
				employee.setHourlyRate(rs.getFloat("hourlyRate"));
				employee.setLevel(rs.getString("isManager""));
				employee.setFirstName(rs.getString("firstName"));
				employee.setLastName(rs.getString("lastName"));
				employee.setEmail(rs.getString("email"));
				employee.setSsn(rs.getString("ssn"));
				employee.setAddress(rs.getString("address"));
				Location location = new Location();
				location.setCity(rs.getString("City"));
				location.setState(rs.getString("State"));
				location.setZipCode(rs.getInt("ZipCode"));
				employee.setLocation(location);
				employee.setTelephone(rs.getString("telephone"));
			}
			/*Sample data ends*/
		}catch (Exception e) {
			System.out.println(e);
		}
		return employee;
	}
	
	public Employee getHighestRevenueEmployee() {
		
		/*
		 * The students code to fetch employee data who generated the highest revenue will be written here
		 * The record is required to be encapsulated as a "Employee" class object
		 */
		
		return getDummyEmployee();
	}

	public String getEmployeeID(String username) {
		/*
		 * The students code to fetch data from the database based on "username" will be written here
		 * username, which is the Employee's email address who's Employee ID has to be fetched, is given as method parameter
		 * The Employee ID is required to be returned as a String
		 */
		
		String result = "";	
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/stonksmaster", "root", "root");
			Statement st = con.createStatement();
			ResultSet rs = st.executeQuery("select * from Employee where email like \'%" + username + "%\'");
		

			/*Sample data begins*/
			result = rs.getString("email");
			
			/*Sample data ends*/
		}catch (Exception e) {
			System.out.println(e);
		}
		return result;	
	}

}
