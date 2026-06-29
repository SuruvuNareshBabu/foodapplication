package daoimpl;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import dao.OrderItemDAO;
import model.OrderItem;
import util.DBConnection;

public class OrderItemDAOImpl implements OrderItemDAO {

    private Connection connection;

    public OrderItemDAOImpl() {
        connection = DBConnection.getConnection();
    }

    @Override
    public boolean addOrderItem(OrderItem item) {

        String sql =
            "INSERT INTO order_items " +
            "(order_id, menu_id, menu_name, quantity, item_price, total_price) " +
            "VALUES (?, ?, ?, ?, ?, ?)";

        try {

            PreparedStatement ps =
                    connection.prepareStatement(sql);

            ps.setInt(1, item.getOrderId());
            ps.setInt(2, item.getMenuId());
            ps.setString(3, item.getMenuName());
            ps.setInt(4, item.getQuantity());
            ps.setDouble(5, item.getItemPrice());
            ps.setDouble(6, item.getTotalPrice());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public List<OrderItem> getOrderItemsByOrderId(int orderId) {

        List<OrderItem> list = new ArrayList<>();

        String sql =
            "SELECT * FROM order_items WHERE order_id=?";

        try {

            PreparedStatement ps =
                    connection.prepareStatement(sql);

            ps.setInt(1, orderId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                OrderItem item = new OrderItem();

                item.setOrderItemId(rs.getInt("order_item_id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setMenuId(rs.getInt("menu_id"));
                item.setMenuName(rs.getString("menu_name"));
                item.setQuantity(rs.getInt("quantity"));
                item.setItemPrice(rs.getDouble("item_price"));
                item.setTotalPrice(rs.getDouble("total_price"));

                list.add(item);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public boolean deleteOrderItemsByOrderId(int orderId) {

        String sql =
            "DELETE FROM order_items WHERE order_id=?";

        try {

            PreparedStatement ps =
                    connection.prepareStatement(sql);

            ps.setInt(1, orderId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}