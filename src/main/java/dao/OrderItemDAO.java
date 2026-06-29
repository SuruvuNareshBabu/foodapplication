package dao;

import java.util.List;
import model.OrderItem;

public interface OrderItemDAO {

    boolean addOrderItem(OrderItem item);

    List<OrderItem> getOrderItemsByOrderId(int orderId);

    boolean deleteOrderItemsByOrderId(int orderId);
}