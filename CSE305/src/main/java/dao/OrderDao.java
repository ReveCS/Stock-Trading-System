package dao;

import model.*;

import java.sql.Connection;
import java.sql.DriverManager;
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

    public String submitOrder(Order order, Customer customer, Employee employee, Stock stock) {

		/*
		 * Student code to place stock order
		 * Employee can be null, when the order is placed directly by Customer
         * */

		/*Sample data begins*/
        return "success";
		/*Sample data ends*/

    }

    public List<Order> getOrderByStockSymbol(String stockSymbol) {
        /*
		 * Student code to get orders by stock symbol
         */
    	
    	List<Order> result = new ArrayList<Order>();
    	
    	try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/Stonksmaster", "root", "root");
			Statement st = con.createStatement();
			ResultSet rs = st.executeQuery("SELECT ord.OrderId, ord.Date, ord.NumShares FROM Trade t INNER JOIN Orders ord ON ord.OrderId = t.OrderId WHERE t.StockId = 'IBM'");

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
        return getDummyOrders();
    }

    public List<Order> getOrderHistory(String customerId) {
        /*
		 * The students code to fetch data from the database will be written here
		 * Show orders for given customerId
		 */
        return getDummyOrders();
    }


    public List<OrderPriceEntry> getOrderPriceHistory(String orderId) {

        /*
		 * The students code to fetch data from the database will be written here
		 * Query to view price history of hidden stop order or trailing stop order
		 * Use setPrice to show hidden-stop price and trailing-stop price
		 */
        List<OrderPriceEntry> orderPriceHistory = new ArrayList<OrderPriceEntry>();

        for (int i = 0; i < 10; i++) {
            OrderPriceEntry entry = new OrderPriceEntry();
            entry.setOrderId(orderId);
            entry.setDate(new Date());
            entry.setStockSymbol("aapl");
            entry.setPricePerShare(150.0);
            entry.setPrice(100.0);
            orderPriceHistory.add(entry);
        }
        return orderPriceHistory;
    }
}
