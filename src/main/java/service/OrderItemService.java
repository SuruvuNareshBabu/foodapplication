package service;

import java.util.List;

import dao.OrderItemDAO;
import daoimpl.OrderItemDAOImpl;
import model.OrderItem;

public class OrderItemService {

    private OrderItemDAO orderItemDAO;

    public OrderItemService() {
        orderItemDAO = new OrderItemDAOImpl();
    }

    public boolean addOrderItem(OrderItem item) {
        return orderItemDAO.addOrderItem(item);
    }

    public List<OrderItem> getOrderItemsByOrderId(int orderId) {
        return orderItemDAO.getOrderItemsByOrderId(orderId);
    }

    public boolean deleteOrderItemsByOrderId(int orderId) {
        return orderItemDAO.deleteOrderItemsByOrderId(orderId);
    }
}