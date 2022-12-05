package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;


import model.Stock;

public class StockDao {

    public Stock getDummyStock() {
        Stock stock = new Stock();
        stock.setName("Apple");
        stock.setSymbol("AAPL");
        stock.setPrice(150.0);
        stock.setNumShares(1200);
        stock.setType("Technology");

        return stock;
    }

    public List<Stock> getDummyStocks() {
        List<Stock> stocks = new ArrayList<Stock>();

		/*Sample data begins*/
        for (int i = 0; i < 10; i++) {
            stocks.add(getDummyStock());
        }
		/*Sample data ends*/

        return stocks;
    }

    public List<Stock> getActivelyTradedStocks() {
    	/*
		 * The students code to fetch data from the database will be written here
		 * Query to fetch details of all the stocks has to be implemented
		 * Return list of actively traded stocks
		 */
    	List<Stock> result = new ArrayList<Stock>();
    	
    	try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");
			Statement st = con.createStatement();
			ResultSet rs = st.executeQuery("SELECT t.StockId AS 'Most Actively Traded Stocks', COUNT(*) AS Trades, s.CompanyName, s.Type, s.NumShares FROM Trade AS t INNER JOIN Stock s ON s.StockSymbol = t.StockId GROUP BY StockId ORDER BY Trades DESC;");

			/*Sample data begins*/
			while(rs.next()) {
		        Stock stock = new Stock();
		        stock.setSymbol(rs.getString("Most Actively Traded Stocks"));
		        stock.setName(rs.getString("CompanyName"));
		        stock.setType(rs.getString("Type"));
		        stock.setNumShares(rs.getInt("NumShares"));
				result.add(stock);
			}
			
			/*Sample data ends*/
		}catch (Exception e) {
			System.out.println(e);
		}

        return result;

    }

	public List<Stock> getAllStocks() {
		/*
		 * The students code to fetch data from the database will be written here
		 * Return list of stocks
		 */
		
		List<Stock> result = new ArrayList<Stock>();
    	
    	try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");
			Statement st = con.createStatement();
			ResultSet rs = st.executeQuery("CALL GetAllStocks()");

			/* Create stock for each, then add to stocks list (result) */
			while(rs.next()) {
		        Stock stock = new Stock();
		        stock.setSymbol(rs.getString("StockSymbol"));
		        stock.setName(rs.getString("CompanyName"));
		        stock.setType(rs.getString("Type"));
		        stock.setPrice(rs.getFloat("PricePerShare"));
		        stock.setNumShares(rs.getInt("NumShares"));
				result.add(stock);
			}
			
			/*Sample data ends*/
		}catch (Exception e) {
			System.out.println(e);
		}
		
		return result;

	}

    public Stock getStockBySymbol(String stockSymbol)
    {
        /*
		 * The students code to fetch data from the database will be written here
		 * Return stock matching symbol
		 */
    	Stock result = new Stock();
    	try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");
			//Statement st = con.createStatement();
			//ResultSet rs = st.executeQuery("SELECT * FROM Stock WHERE StockSymbol LIKE \'%" + stockSymbol + "%\\");
			PreparedStatement st = con.prepareStatement("SELECT * FROM Stock WHERE StockSymbol LIKE ?");
			
			st.setString(1, stockSymbol);
			
			ResultSet rs = st.executeQuery();
			
			if (rs.next()) {
				result.setSymbol(rs.getString("StockSymbol"));
			    result.setName(rs.getString("CompanyName"));
			    result.setType(rs.getString("Type"));
			    result.setPrice(rs.getFloat("PricePerShare"));
			    result.setNumShares(rs.getInt("NumShares"));
			}

			return result;
		}catch (Exception e) {
			System.out.println(e);
		}
		
		return result;
    }

    public String setStockPrice(String stockSymbol, double stockPrice) {
        /*
         * The students code to fetch data from the database will be written here
         * Perform price update of the stock symbol
         */
    	try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");
			//ResultSet rs = st.executeQuery("CALL SetSharePrice(" + stockPrice + ", \'%" + stockSymbol + "\'%)");
			PreparedStatement st = con.prepareStatement("CALL SetSharePrice(?, ?)");
			
			st.setDouble(1, stockPrice);
			st.setString(2, stockSymbol);

			ResultSet rs = st.executeQuery();

			/*Sample data ends*/
		}catch (Exception e) {
			System.out.println(e);
			return "failure";
		}

        return "success";
    }
	
	public List<Stock> getOverallBestsellers() {
		
		/*
		 * The students code to fetch data from the database will be written here
		 * Get list of bestseller stocks
		 */

		List<Stock> result = new ArrayList<Stock>();

        try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");
			PreparedStatement st = con.prepareStatement("CALL Best_Seller()");
			ResultSet rs = st.executeQuery();
			
			while(rs.next()) {
				Stock stock = new Stock();
				stock.setSymbol(rs.getString("StockSymbol"));
				stock.setName(rs.getString("CompanyName"));
				stock.setType(rs.getString("Type"));
				stock.setPrice(rs.getDouble("PricePerShare"));
				stock.setNumShares(rs.getInt("NumShares"));
				result.add(stock);
			}

		}catch (Exception e) {
			System.out.println(e);
		}
        
        return result;

	}

    public List<Stock> getCustomerBestsellers(String customerID) {
    	
    	/* student code written within*/
    	List<Stock> result = new ArrayList<Stock>();

        try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");
			Statement st = con.createStatement();
			ResultSet rs = st.executeQuery("CALL Best_Seller()");
			/*
			 
			 if CALL Best_Seller() doesn't work, copy and paste
			 
			 "SELECT StockSymbol, s.CompanyName, s.Type,
			 s.PricePerShare, s.NumShares 
			 FROM Trade     
			 INNER JOIN Stock s ON s.StockSymbol = StockId
			 GROUP BY StockId ORDER BY COUNT(*) DESC"
			 
			 - Joohan
			 
			 */
			while(rs.next()) {
				Stock stock = new Stock();
				stock.setSymbol(rs.getString("StockSymbol"));
				stock.setName(rs.getString("CompanyName"));
				stock.setPrice(rs.getDouble("PricePerShare"));
				stock.setNumShares(rs.getInt("NumShares"));
				stock.setType(rs.getString("Type"));
				
				result.add(stock);
			}

		}catch (Exception e) {
			System.out.println(e);
		}
        
        return result;

    }

	public List<Stock> getStocksByCustomer(String customerId) {

		/*
		 * The students code to fetch data from the database will be written here
		 * Get stockHoldings of customer with customerId
		 */

		List<Stock> result = new ArrayList<Stock>();

        try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");
			//Statement st = con.createStatement();
			//ResultSet rs = st.executeQuery("SELECT sp.ClientId, s.* FROM StockPortfolio sp INNER JOIN Stock s ON sp.Stock = s.StockSymbol WHERE ClientId LIKE \'%" + customerId + "\'%");
			PreparedStatement st = con.prepareStatement("SELECT sp.ClientId, s.* FROM StockPortfolio sp INNER JOIN Stock s ON sp.Stock = s.StockSymbol WHERE ClientId LIKE ?");
			st.setString(1, customerId);
			ResultSet rs = st.executeQuery();
			
			while(rs.next()) {
				Stock stock = new Stock();
				stock.setSymbol(rs.getString("StockSymbol"));
				stock.setName(rs.getString("CompanyName"));
				stock.setNumShares(rs.getInt("NumShares"));
				stock.setPrice(rs.getDouble("PricePerShare"));
				stock.setType(rs.getString("Type"));
				result.add(stock);
			}

		}catch (Exception e) {
			System.out.println(e);
		}
        
        return result;
	}

    public List<Stock> getStocksByName(String name) {

		/*
		 * The students code to fetch data from the database will be written here
		 * Return list of stocks matching "name"
		 */

    	List<Stock> result = new ArrayList<Stock>();

        try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");
			//Statement st = con.createStatement();
			//ResultSet rs = st.executeQuery("SELECT * FROM Stock WHERE CompanyName LIKE \'%" + name + "\'%");
			PreparedStatement st = con.prepareStatement("SELECT * FROM Stock WHERE CompanyName LIKE ?");
			st.setString(1, name);
			ResultSet rs = st.executeQuery();
			
			while(rs.next()) {
				Stock stock = new Stock();
				stock.setSymbol(rs.getString("StockSymbol"));
				stock.setName(rs.getString("CompanyName"));
				stock.setNumShares(rs.getInt("NumShares"));
				stock.setPrice(rs.getDouble("PricePerShare"));
				stock.setType(rs.getString("Type"));
				result.add(stock);
			}

		}catch (Exception e) {
			System.out.println(e);
		}
        
        return result;
    }

    public List<Stock> getStockSuggestions(String customerID) {

		/*
		 * The students code to fetch data from the database will be written here
		 * Return stock suggestions for given "customerId"
		 */
    	List<Stock> result = new ArrayList<Stock>();

        try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");
			PreparedStatement st = con.prepareStatement("CALL SuggestStock(?)");
			st.setString(1, customerID);
			ResultSet rs = st.executeQuery();
			
			
			while(rs.next()) {
				Stock stock = new Stock();
				stock.setSymbol(rs.getString("StockSymbol"));
				stock.setName(rs.getString("CompanyName"));
				stock.setType(rs.getString("Type"));
				stock.setPrice(rs.getDouble("PricePerShare"));
				stock.setNumShares(rs.getInt("NumShares"));
				result.add(stock);
			}

		}catch (Exception e) {
			System.out.println(e);
		}
        
        return result;
    }

    public List<Stock> getStockPriceHistory(String stockSymbol) {

		/*
		 * The students code to fetch data from the database
		 * Return list of stock objects, showing price history
		 */

    	List<Stock> result = new ArrayList<Stock>();

        try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");
			PreparedStatement st = con.prepareStatement("SELECT * FROM PriceHistory WHERE StockSymbol LIKE ?");
			st.setString(1, stockSymbol);
			ResultSet rs = st.executeQuery();
			
			
			while(rs.next()) {
				Stock stock = new Stock();
				stock.setSymbol(rs.getString("StockSymbol"));
				stock.setName(rs.getString("CompanyName"));
				stock.setType(rs.getString("StockType"));
				stock.setPrice(rs.getDouble("PricePerShare"));
				stock.setNumShares(rs.getInt("NumShares"));
				result.add(stock);
			}

		}catch (Exception e) {
			System.out.println(e);
		}
        
        return result;
    }

    public List<String> getStockTypes() {
		/*
		 * The students code to fetch data from the database will be written here.
		 * Populate types with stock types
		 */

        List<String> result = new ArrayList<String>();

        try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");
			Statement st = con.createStatement();
			ResultSet rs = st.executeQuery("SELECT DISTINCT Type FROM Stock");
			
			while(rs.next()) {
				String type = rs.getString("Type");
				result.add(type);
			}

		}catch (Exception e) {
			System.out.println(e);
		}
        
        return result;
    }

    public List<Stock> getStockByType(String stockType) {
		/*
		 * The students code to fetch data from the database will be written here
		 * Return list of stocks of type "stockType"
		 */

    	List<Stock> result = new ArrayList<Stock>();

        try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");
			//Statement st = con.createStatement();
			//ResultSet rs = st.executeQuery("SELECT * FROM Stock WHERE Type LIKE \'%" + stockType + "\'%");
			PreparedStatement st = con.prepareStatement("SELECT * FROM Stock WHERE Type LIKE ?");
			st.setString(1, stockType);
			ResultSet rs = st.executeQuery();
			
			while(rs.next()) {
				Stock stock = new Stock();
				stock.setSymbol(rs.getString("StockSymbol"));
				stock.setName(rs.getString("CompanyName"));
				stock.setNumShares(rs.getInt("NumShares"));
				stock.setPrice(rs.getDouble("PricePerShare"));
				stock.setType(rs.getString("Type"));
				result.add(stock);
			}

		}catch (Exception e) {
			System.out.println(e);
		}
        
        return result;
    }
}
