package dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import model.Order;
import model.OrderItem;

public interface OrderDAO {
    int insertOrder(Order order, Connection conn) throws SQLException;
    boolean saveOrderItems(List<OrderItem> orderItems, Connection conn) throws SQLException;
    Order getOrderById(int orderId);
    List<Order> getOrdersByUserId(int userId);
    boolean updateOrderStatus(int orderId, String orderStatus, String paymentStatus);
    // Add these for full functionality
    boolean updateOrderStatus(int orderId, String orderStatus);
    List<Order> getOrdersByRestaurant(int restaurantId);
    List<Order> getAllOrders();
}