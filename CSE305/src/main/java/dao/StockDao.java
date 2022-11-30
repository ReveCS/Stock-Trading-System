package dao;

import java.sql.Connection;
import java.sql.DriverManager;
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
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/demo", "root", "root");
			Statement st = con.createStatement();
			ResultSet rs = st.executeQuery("SELECT t.StockId AS 'Most Actively Traded Stocks', COUNT(*) AS Trades FROM Trade AS t GROUP BY StockId ORDER BY Trades DESC;");

			/*Sample data begins*/
			while(rs.next()) {
		        Stock stock = new Stock();
		        stock.setSymbol(rs.getString("Most Actively Traded Stocks"));
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
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/stonksmaster", "root", "root");
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
        return getDummyStock();
    }

    public String setStockPrice(String stockSymbol, double stockPrice) {
        /*
         * The students code to fetch data from the database will be written here
         * Perform price update of the stock symbol
         */

        return "success";
    }
	
	public List<Stock> getOverallBestsellers() {

		/*
		 * The students code to fetch data from the database will be written here
		 * Get list of bestseller stocks
		 */

		return getDummyStocks();

	}

    public List<Stock> getCustomerBestsellers(String customerID) {

		/*
		 * The students code to fetch data from the database will be written here.
		 * Get list of customer bestseller stocks
		 */

        return getDummyStocks();

    }

	public List getStocksByCustomer(String customerId) {

		/*
		 * The students code to fetch data from the database will be written here
		 * Get stockHoldings of customer with customerId
		 */

		return getDummyStocks();
	}

    public List<Stock> getStocksByName(String name) {

		/*
		 * The students code to fetch data from the database will be written here
		 * Return list of stocks matching "name"
		 */

        return getDummyStocks();
    }

    public List<Stock> getStockSuggestions(String customerID) {

		/*
		 * The students code to fetch data from the database will be written here
		 * Return stock suggestions for given "customerId"
		 */

        return getDummyStocks();

    }

    public List<Stock> getStockPriceHistory(String stockSymbol) {

		/*
		 * The students code to fetch data from the database
		 * Return list of stock objects, showing price history
		 */

        return getDummyStocks();
    }

    public List<String> getStockTypes() {

		/*
		 * The students code to fetch data from the database will be written here.
		 * Populate types with stock types
		 */

        List<String> types = new ArrayList<String>();
        types.add("technology");
        types.add("finance");
        return types;

    }

    public List<Stock> getStockByType(String stockType) {

		/*
		 * The students code to fetch data from the database will be written here
		 * Return list of stocks of type "stockType"
		 */

        return getDummyStocks();
    }
}
