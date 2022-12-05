package dao;

import model.*;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class OrderDao {

    public Order getDummyTrailingStopOrder() {
        TrailingStopOrder order = new TrailingStopOrder();

        order.setId(1);
        order.setDatetime(new Date());
        order.setNumShares(5);
        order.setPercentage(12.0);
        return order;
    }

    public Order getDummyMarketOrder() {
        MarketOrder order = new MarketOrder();

        order.setId(1);
        order.setDatetime(new Date());
        order.setNumShares(5);
        order.setBuySellType("buy");
        return order;
    }

    public Order getDummyMarketOnCloseOrder() {
        MarketOnCloseOrder order = new MarketOnCloseOrder();

        order.setId(1);
        order.setDatetime(new Date());
        order.setNumShares(5);
        order.setBuySellType("buy");
        return order;
    }

    public Order getDummyHiddenStopOrder() {
        HiddenStopOrder order = new HiddenStopOrder();

        order.setId(1);
        order.setDatetime(new Date());
        order.setNumShares(5);
        order.setPricePerShare(145.0);
        return order;
    }

    public List<Order> getDummyOrders() {
        List<Order> orders = new ArrayList<Order>();

        for (int i = 0; i < 3; i++) {
            orders.add(getDummyTrailingStopOrder());
        }

        for (int i = 0; i < 3; i++) {
            orders.add(getDummyMarketOrder());
        }

        for (int i = 0; i < 3; i++) {
            orders.add(getDummyMarketOnCloseOrder());
        }

        for (int i = 0; i < 3; i++) {
            orders.add(getDummyHiddenStopOrder());
        }

        return orders;
    }
    
    public Order getTrailingStopOrder() {
        TrailingStopOrder order = new TrailingStopOrder();

        return order;
    }

    public Order getMarketOrder() {
        MarketOrder order = new MarketOrder();

        return order;
    }

    public Order getMarketOnCloseOrder() {
        MarketOnCloseOrder order = new MarketOnCloseOrder();

        return order;
    }

    public Order getHiddenStopOrder() {
        HiddenStopOrder order = new HiddenStopOrder();
        
        return order;
    }

    
    
    public List<Order> getOrders() {
        List<Order> orders = new ArrayList<Order>();
        
        return orders;
    }

    public String submitOrder(Order order, Customer customer, Employee employee, Stock stock, int orderType) {
		/*
		 * Student code to place stock order
		 * Employee can be null, when the order is placed directly by Customer
         * */
    	int orderNumShares;
    	double price;
    	Date orderDate;
    	java.sql.Date sqlDate;
    	double percent;
    	String priceType;
    	String buySellType;
    	String clientId;
    	int accountNum;
    	String symbol;
    	
    	if(orderType == 1) { //market
	    	orderDate = order.getDatetime();
	    	sqlDate = new java.sql.Date(orderDate.getTime());
	    	orderNumShares = order.getNumShares();
	    	buySellType = ((MarketOrder) order).getBuySellType();
	    	
	    	clientId = customer.getClientId();
	    	accountNum = customer.getAccountNumber();

	    	price = stock.getPrice();
	    	symbol = stock.getSymbol();
	    	
	    	if (employee == null) {
	    		try {
	    			Class.forName("com.mysql.jdbc.Driver");
	    			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");
	    			PreparedStatement st = con.prepareStatement("CALL SubmitOrder(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
	    			
	    			st.setInt(1, orderNumShares);
	    			st.setDouble(2, price);
	    			st.setDate(3, sqlDate);
	    			st.setDouble(4, 0);
	    			st.setString(5, "Market");
	    			st.setString(6, buySellType);
	    			st.setInt(7, accountNum);
	    			st.setString(8, clientId);
	    			st.setString(9, "0");
	    			st.setString(10, symbol);

	    			
	    			ResultSet rs = st.executeQuery();
	    		
	    		}catch (Exception e) {
	    			System.out.println(e);
	    			return "failure";
	    		}
	    	}
	    	else {
	    		String employeeId = employee.getEmployeeID();
	        	
	    		try {
	    			Class.forName("com.mysql.jdbc.Driver");
	    			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");
	    			PreparedStatement st = con.prepareStatement("CALL SubmitOrder(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
	    			
	    			st.setInt(1, orderNumShares);
	    			st.setDouble(2, price);
	    			st.setDate(3, sqlDate);
	    			st.setDouble(4, 0);
	    			st.setString(5, "Market");
	    			st.setString(6, buySellType);
	    			st.setInt(7, accountNum);
	    			st.setString(8, clientId);
	    			st.setString(9, employeeId);
	    			st.setString(10, symbol);  	
	    			
	    			ResultSet rs = st.executeQuery();
	    			
	    		}catch (Exception e) {
	    			System.out.println(e);
	    			return "failure";
	    		}
	    	}
    	}
    
		else if(orderType == 2) { //marketOnClose
	    	orderDate = order.getDatetime();
	    	sqlDate = new java.sql.Date(orderDate.getTime());
	    	orderNumShares = order.getNumShares();
	    	buySellType = ((MarketOnCloseOrder) order).getBuySellType();
	    	
	    	clientId = customer.getClientId();
	    	accountNum = customer.getAccountNumber();
	    	
	    	price = stock.getPrice();
	    	symbol = stock.getSymbol();
	    	
	    	if (employee == null) {
	    		try {
	    			Class.forName("com.mysql.jdbc.Driver");
	    			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");
	    			PreparedStatement st = con.prepareStatement("CALL SubmitOrder(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
	    			
	    			st.setInt(1, orderNumShares);
	    			st.setDouble(2, price);
	    			st.setDate(3, sqlDate);
	    			st.setDouble(4, 0);
	    			st.setString(5, "MarketOnClose");
	    			st.setString(6, buySellType);
	    			st.setInt(7, accountNum);
	    			st.setString(8, clientId);
	    			st.setString(9, "0");
	    			st.setString(10, symbol);

	    			
	    			ResultSet rs = st.executeQuery();
	    		
	    		}catch (Exception e) {
	    			System.out.println(e);
	    			return "failure";
	    		}
	    	}
	    	else {
	    		String employeeId = employee.getEmployeeID();
	        	
	    		try {
	    			Class.forName("com.mysql.jdbc.Driver");
	    			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");
	    			PreparedStatement st = con.prepareStatement("CALL SubmitOrder(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
	    			
	    			st.setInt(1, orderNumShares);
	    			st.setDouble(2, price);
	    			st.setDate(3, sqlDate);
	    			st.setDouble(4, 0);
	    			st.setString(5, "MarketOnClose");
	    			st.setString(6, buySellType);
	    			st.setInt(7, accountNum);
	    			st.setString(8, clientId);
	    			st.setString(9, employeeId);
	    			st.setString(10, symbol);  	
	    			
	    			ResultSet rs = st.executeQuery();
	    			
	    		}catch (Exception e) {
	    			System.out.println(e);
	    			return "failure";
	    		}
	    	}
		}

    	
    	else if(orderType == 3) { //trailingStop 
	    	orderDate = order.getDatetime();
	    	sqlDate = new java.sql.Date(orderDate.getTime());
	    	orderNumShares = order.getNumShares();
	    	percent = ((TrailingStopOrder) order).getPercentage();
	    	
	    	clientId = customer.getClientId();
	    	accountNum = customer.getAccountNumber();
	    	
	    	price = stock.getPrice();
	    	symbol = stock.getSymbol();
	    	
	    	if (employee == null) {
	    		try {
	    			Class.forName("com.mysql.jdbc.Driver");
	    			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");
	    			PreparedStatement st = con.prepareStatement("CALL SubmitOrder(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
	    			
	    			st.setInt(1, orderNumShares);
	    			st.setDouble(2, price);
	    			st.setDate(3, sqlDate);
	    			st.setDouble(4, percent);
	    			st.setString(5, "TrailingStop");
	    			st.setString(6, null);
	    			st.setInt(7, accountNum);
	    			st.setString(8, clientId);
	    			st.setString(9, "0");
	    			st.setString(10, symbol);

	    			
	    			ResultSet rs = st.executeQuery();
	    		
	    		}catch (Exception e) {
	    			System.out.println(e);
	    			return "failure";
	    		}
	    	}
	    	else {
	    		String employeeId = employee.getEmployeeID();
	        	
	    		try {
	    			Class.forName("com.mysql.jdbc.Driver");
	    			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");
	    			PreparedStatement st = con.prepareStatement("CALL SubmitOrder(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
	    			
	    			st.setInt(1, orderNumShares);
	    			st.setDouble(2, price);
	    			st.setDate(3, sqlDate);
	    			st.setDouble(4, percent);
	    			st.setString(5, "TrailingStop");
	    			st.setString(6, null);
	    			st.setInt(7, accountNum);
	    			st.setString(8, clientId);
	    			st.setString(9, employeeId);
	    			st.setString(10, symbol);  	
	    			
	    			ResultSet rs = st.executeQuery();
	    			
	    		}catch (Exception e) {
	    			System.out.println(e);
	    			return "failure";
	    		}
	    	}
    	}
    	
    	else { //hiddenStop 
	    	orderDate = order.getDatetime();
	    	sqlDate = new java.sql.Date(orderDate.getTime());
	    	orderNumShares = order.getNumShares();
	    	price = ((HiddenStopOrder) order).getPricePerShare();
	    	
	    	clientId = customer.getClientId();
	    	accountNum = customer.getAccountNumber();
	    	
	    	symbol = stock.getSymbol();
	    	
	    	if (employee == null) {
	    		try {
	    			Class.forName("com.mysql.jdbc.Driver");
	    			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");
	    			PreparedStatement st = con.prepareStatement("CALL SubmitOrder(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
	    			
	    			st.setInt(1, orderNumShares);
	    			st.setDouble(2, price);
	    			st.setDate(3, sqlDate);
	    			st.setDouble(4, 0);
	    			st.setString(5, "HiddenStop");
	    			st.setString(6, null);
	    			st.setInt(7, accountNum);
	    			st.setString(8, clientId);
	    			st.setString(9, "0");
	    			st.setString(10, symbol);

	    			
	    			ResultSet rs = st.executeQuery();
	    		
	    		}catch (Exception e) {
	    			System.out.println(e);
	    			return "failure";
	    		}
	    	}
	    	else {
	    		String employeeId = employee.getEmployeeID();
	        	
	    		try {
	    			Class.forName("com.mysql.jdbc.Driver");
	    			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");
	    			PreparedStatement st = con.prepareStatement("CALL SubmitOrder(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
	    			
	    			st.setInt(1, orderNumShares);
	    			st.setDouble(2, price);
	    			st.setDate(3, sqlDate);
	    			st.setDouble(4, 0);
	    			st.setString(5, "HiddenStop");
	    			st.setString(6, null);
	    			st.setInt(7, accountNum);
	    			st.setString(8, clientId);
	    			st.setString(9, employeeId);
	    			st.setString(10, symbol);  	
	    			
	    			ResultSet rs = st.executeQuery();
	    			
	    		}catch (Exception e) {
	    			System.out.println(e);
	    			return "failure";
	    		}
	    	}
    	}

        return "success";

    }

    public List<Order> getOrderByStockSymbol(String stockSymbol) {
        /*
		 * Student code to get orders by stock symbol
         */
    	
    	List<Order> result = new ArrayList<Order>();
    	
    	try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");
			//Statement st = con.createStatement();
			//ResultSet rs = st.executeQuery("SELECT ord.OrderId, ord.Date, ord.NumShares FROM Trade t INNER JOIN Orders ord ON ord.OrderId = t.OrderId WHERE t.StockId LIKE");
			PreparedStatement st = con.prepareStatement("SELECT ord.OrderId, ord.Date, ord.NumShares FROM Trade t INNER JOIN Orders ord ON ord.OrderId = t.OrderId WHERE t.StockId LIKE ?");
			st.setString(1, stockSymbol);
			ResultSet rs = st.executeQuery();
			
			/*Sample data begins*/
			while(rs.next()) {
				Order order = new Order();
				order.setDatetime(rs.getDate("Date"));
				order.setId(rs.getInt("OrderId"));
				order.setNumShares(rs.getInt("NumShares"));
				result.add(order);
			}
			/*Sample data ends*/
		}catch (Exception e) {
			System.out.println(e);
		}
    	
        return result;
    }

    public List<Order> getOrderByCustomerName(String customerName) {
         /*
		 * Student code to get orders by customer name
         */
    	
    	List<Order> result = new ArrayList<Order>();
    	
    	try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");
			//Statement st = con.createStatement();
			//ResultSet rs = st.executeQuery("SELECT ord.OrderId, ord.Date, ord.NumShares FROM Trade t INNER JOIN Orders ord ON ord.OrderId = t.OrderId INNER JOIN Person p ON p.SSN = t.ClientId WHERE p.LastName = 'Philip'");
			PreparedStatement st = con.prepareStatement("SELECT ord.OrderId, ord.Date, ord.NumShares FROM Trade t INNER JOIN Orders ord ON ord.OrderId = t.OrderId INNER JOIN Person p ON p.SSN = t.ClientId WHERE p.LastName LIKE ?");
			st.setString(1, customerName);
			ResultSet rs = st.executeQuery();
			
			/*Sample data begins*/
			while(rs.next()) {
				Order order = new Order();
				order.setDatetime(rs.getDate("Date"));
				order.setId(rs.getInt("OrderId"));
				order.setNumShares(rs.getInt("NumShares"));
				result.add(order);
			}
			/*Sample data ends*/
		}catch (Exception e) {
			System.out.println(e);
		}
    	
        return result;
    }

    public List<Order> getOrderHistory(String customerId) {
        /*
		 * The students code to fetch data from the database will be written here
		 * Show orders for given customerId
		 */
    	List<Order> result = new ArrayList<Order>();
    	
    	try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");
			//Statement st = con.createStatement();
			//ResultSet rs = st.executeQuery("SELECT ord.OrderId, ord.Date, ord.NumShares FROM Trade t INNER JOIN Orders ord ON ord.OrderId = t.OrderId INNER JOIN Person p ON p.SSN = t.ClientId WHERE t.ClientId LIKE ");
			PreparedStatement st = con.prepareStatement("SELECT ord.OrderId, ord.Date, ord.NumShares FROM Trade t INNER JOIN Orders ord ON ord.OrderId = t.OrderId INNER JOIN Person p ON p.SSN = t.ClientId WHERE t.ClientId LIKE ?");
			st.setString(1, customerId);
			ResultSet rs = st.executeQuery();
			
			/*Sample data begins*/
			while(rs.next()) {
				Order order = new Order();
				order.setDatetime(rs.getDate("Date"));
				order.setId(rs.getInt("OrderId"));
				order.setNumShares(rs.getInt("NumShares"));
				result.add(order);
			}
			/*Sample data ends*/
		}catch (Exception e) {
			System.out.println(e);
		}
    	
        return result;
    }


    public List<OrderPriceEntry> getOrderPriceHistory(String orderId) {

        /*
		 * The students code to fetch data from the database will be written here
		 * Query to view price history of hidden stop order or trailing stop order
		 * Use setPrice to show hidden-stop price and trailing-stop price
		 */
        List<OrderPriceEntry> orderPriceHistory = new ArrayList<OrderPriceEntry>();

        try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");
			PreparedStatement st = con.prepareStatement("");
			st.setString(1, orderId);
			ResultSet rs = st.executeQuery();
			
			/*Sample data begins*/
			while(rs.next()) {
				OrderPriceEntry ope = new OrderPriceEntry();
				ope.setOrderId();
				ope.setDate(null);
				ope.setPrice(0);
				ope.setPricePerShare(0);
				ope.setStockSymbol(orderId);
				orderPriceHistory.add(ope);
			}
			/*Sample data ends*/
		}catch (Exception e) {
			System.out.println(e);
		}
        
        return orderPriceHistory;
    }
}
