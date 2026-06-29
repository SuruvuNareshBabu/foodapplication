package daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import dao.OrderDAO;
import model.Order;
import model.OrderItem;
import util.DBConnection;

public class OrderDAOImpl implements OrderDAO {


	@Override
	public int insertOrder(Order order, Connection conn) throws SQLException {
	    // 1. ADD delivery_address TO THE SQL STRING
	    String sql = "INSERT INTO orders (user_id, restaurant_id, address_id, total_amount, " +
	                 "delivery_charge, tax, discount, grand_total, order_status, payment_status, " +
	                 "delivery_address, created_at, updated_at) " + // Added delivery_address here
	                 "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())"; // Added one more '?'

	    try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
	        ps.setInt(1, order.getUserId());
	        ps.setInt(2, order.getRestaurantId());
	        ps.setInt(3, order.getAddressId());
	        ps.setDouble(4, order.getTotalAmount());
	        ps.setDouble(5, order.getDeliveryCharge());
	        ps.setDouble(6, order.getTax());
	        ps.setDouble(7, order.getDiscount());
	        ps.setDouble(8, order.getGrandTotal());
	        ps.setString(9, order.getOrderStatus());
	        ps.setString(10, order.getPaymentStatus());
	        ps.setString(11, order.getDeliveryAddress()); // 2. SET THE ADDRESS HERE

	        int affectedRows = ps.executeUpdate();
	        if (affectedRows > 0) {
	            try (ResultSet rs = ps.getGeneratedKeys()) {
	                if (rs.next()) return rs.getInt(1);
	            }
	        }
	    }
	    return -1;
	}
	

    @Override
    public Order getOrderById(int orderId) {
        String orderSql = "SELECT * FROM orders WHERE order_id = ?";
        String itemsSql = "SELECT * FROM order_items WHERE order_id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            Order order = null;

            // 1. Fetch Order Header
            try (PreparedStatement ps = conn.prepareStatement(orderSql)) {
                ps.setInt(1, orderId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        order = extractOrderFromResultSet(rs);
                    }
                }
            }

            // 2. Fetch Order Items (only if order exists)
            if (order != null) {
                try (PreparedStatement ps = conn.prepareStatement(itemsSql)) {
                    ps.setInt(1, orderId);
                    try (ResultSet rs = ps.executeQuery()) {
                        List<OrderItem> items = new ArrayList<>();
                        while (rs.next()) {
                            OrderItem item = new OrderItem();
                            item.setOrderItemId(rs.getInt("order_item_id"));
                            item.setOrderId(rs.getInt("order_id"));
                            item.setMenuId(rs.getInt("menu_id"));
                            item.setMenuName(rs.getString("menu_name"));
                            item.setQuantity(rs.getInt("quantity"));
                            item.setItemPrice(rs.getDouble("item_price"));
                            item.setTotalPrice(rs.getDouble("total_price"));
                            items.add(item);
                        }
                        order.setOrderItems(items); // Attach the list to the order object
                    }
                }
            }
            return order;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orderList = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orderList.add(extractOrderFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orderList;
    }

  
    @Override
    public boolean updateOrderStatus(int orderId, String orderStatus) {
        String sql = "UPDATE orders SET order_status = ?, updated_at = NOW() WHERE order_id = ?";
        try (Connection conn = util.DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderStatus);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateOrderStatus(int orderId, String orderStatus, String paymentStatus) {
        String sql = "UPDATE orders SET order_status = ?, payment_status = ?, updated_at = NOW() WHERE order_id = ?";
        try (Connection conn = util.DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderStatus);
            ps.setString(2, paymentStatus);
            ps.setInt(3, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    
    
    
    

    @Override
    public boolean saveOrderItems(List<OrderItem> orderItems, Connection conn) throws SQLException {
        if (orderItems == null || orderItems.isEmpty()) {
            return false;
        }
        
        String sql = "INSERT INTO order_items (order_id, menu_id, menu_name, quantity, item_price, total_price) VALUES (?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (OrderItem item : orderItems) {
                ps.setInt(1, item.getOrderId());
                ps.setInt(2, item.getMenuId());
                ps.setString(3, item.getMenuName());
                ps.setInt(4, item.getQuantity());
                ps.setDouble(5, item.getItemPrice());
                ps.setDouble(6, item.getTotalPrice());
                ps.addBatch();
            }
            int[] results = ps.executeBatch();
            // Return true if all items were successfully inserted
            return results.length == orderItems.size();
        }
    }

    public List<Order> getOrdersByRestaurant(int restaurantId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE restaurant_id = ? ORDER BY created_at DESC";
        try (Connection conn = util.DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, restaurantId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractOrderFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                orders.add(extractOrderFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    // Helper method to cleanly extract relational database rows into Java Objects
 // Inside OrderDAOImpl.java

    private Order extractOrderFromResultSet(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getInt("order_id"));
        order.setUserId(rs.getInt("user_id"));
        order.setRestaurantId(rs.getInt("restaurant_id"));
        order.setAddressId(rs.getInt("address_id"));
        order.setTotalAmount(rs.getDouble("total_amount"));
        order.setDeliveryCharge(rs.getDouble("delivery_charge"));
        order.setTax(rs.getDouble("tax"));
        order.setDiscount(rs.getDouble("discount"));
        order.setGrandTotal(rs.getDouble("grand_total"));
        order.setOrderStatus(rs.getString("order_status"));
        order.setPaymentStatus(rs.getString("payment_status"));
        
        // THIS IS THE LINE YOU NEED TO ADD:
        order.setDeliveryAddress(rs.getString("delivery_address"));
        
        order.setCreatedAt(rs.getTimestamp("created_at"));
        order.setUpdatedAt(rs.getTimestamp("updated_at"));
        return order;
    }
}