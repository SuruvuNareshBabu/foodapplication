package service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dao.OrderDAO;
import daoimpl.OrderDAOImpl;
import model.Cart;
import model.Order;
import model.OrderItem;
import util.DBConnection;

public class OrderService {
    private OrderDAO orderDAO = new OrderDAOImpl();

    
    public int createOrder(Order order, List<Cart> cartItems) {
        // Fail-fast check
        if (order == null || cartItems == null || cartItems.isEmpty()) {
            return -1; 
        }

        Connection conn = null;
        int orderId = -1;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start Transaction

            orderId = orderDAO.insertOrder(order, conn);

            if (orderId != -1) {
                List<OrderItem> orderItemsList = new ArrayList<>();
                for (Cart cartItem : cartItems) {
                    OrderItem item = new OrderItem();
                    item.setOrderId(orderId);
                    item.setMenuId(cartItem.getMenuId());
                    item.setMenuName(cartItem.getMenuName());
                    item.setQuantity(cartItem.getQuantity());
                    // Avoid division by zero if quantity is somehow 0
                    double unitPrice = (cartItem.getQuantity() > 0) ? (cartItem.getTotalPrice() / cartItem.getQuantity()) : 0;
                    item.setItemPrice(unitPrice);
                    item.setTotalPrice(cartItem.getTotalPrice());
                    orderItemsList.add(item);
                }
                
                // Validate that saveOrderItems succeeds
                boolean itemsSaved = orderDAO.saveOrderItems(orderItemsList, conn);
                if (!itemsSaved) {
                    throw new SQLException("Failed to save order items.");
                }
            } else {
                throw new SQLException("Failed to create order header.");
            }
            
            conn.commit();
        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            return -1; // Return -1 on failure
        } finally {
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return orderId;
    }
    

    public Order getOrderDetails(int orderId) {
        return orderDAO.getOrderById(orderId);
    }

    public List<Order> getUserOrderHistory(int userId) {
        return orderDAO.getOrdersByUserId(userId);
    }

    public boolean updatePaymentAndStatus(int orderId, String orderStatus, String paymentStatus) {
        return orderDAO.updateOrderStatus(orderId, orderStatus, paymentStatus);
    }
    
 // Add this method to service/OrderService.java
    public boolean updateOrderStatus(int orderId, String newStatus) {
        return orderDAO.updateOrderStatus(orderId, newStatus);
    }
    
 // service/OrderService.java
    public List<Order> getOrdersByRestaurant(int restaurantId) {
        return orderDAO.getOrdersByRestaurant(restaurantId);
    }
}