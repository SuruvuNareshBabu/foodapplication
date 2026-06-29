package daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dao.CartDAO;
import model.Cart;
import util.DBConnection;

public class CartDAOImpl implements CartDAO {

    @Override
    public Integer getCartRestaurantId(int userId) {

        String sql = "SELECT restaurant_id FROM cart WHERE user_id=? LIMIT 1";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("restaurant_id");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public boolean addToCart(Cart cart) {

        String sql =
                "INSERT INTO cart(user_id,restaurant_id,menu_id,quantity,total_price) VALUES(?,?,?,?,?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, cart.getUserId());
            ps.setInt(2, cart.getRestaurantId());
            ps.setInt(3, cart.getMenuId());
            ps.setInt(4, cart.getQuantity());
            ps.setDouble(5, cart.getTotalPrice());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
        	 System.out.println("Insert into cart failed!");
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public Cart getCartItem(int userId, int menuId) {

        String sql = "SELECT * FROM cart WHERE user_id=? AND menu_id=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, menuId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {

                    Cart cart = new Cart();

                    cart.setCartId(rs.getInt("cart_id"));
                    cart.setUserId(rs.getInt("user_id"));
                    cart.setRestaurantId(rs.getInt("restaurant_id"));
                    cart.setMenuId(rs.getInt("menu_id"));
                    cart.setQuantity(rs.getInt("quantity"));
                    cart.setTotalPrice(rs.getDouble("total_price"));
                    cart.setCreatedAt(rs.getTimestamp("created_at"));

                    return cart;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public boolean updateQuantity(int userId,
                                  int menuId,
                                  int quantity,
                                  double totalPrice) {

        String sql = "UPDATE cart SET quantity=?, total_price=? WHERE user_id=? AND menu_id=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, quantity);
            ps.setDouble(2, totalPrice);
            ps.setInt(3, userId);
            ps.setInt(4, menuId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean removeFromCart(int userId, int menuId) {

        String sql = "DELETE FROM cart WHERE user_id=? AND menu_id=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, menuId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public List<Cart> getCartItems(int userId) {

        List<Cart> cartList = new ArrayList<>();

        String sql =
                "SELECT c.*, " +
                "m.name AS menu_name, " +
                "m.price, " +
                "m.image AS menu_image, " +
                "r.name AS restaurant_name " +
                "FROM cart c " +
                "JOIN menu m ON c.menu_id = m.menu_id " +
                "JOIN restaurants r ON c.restaurant_id = r.restaurant_id " +
                "WHERE c.user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {

                    Cart cart = new Cart();

                    cart.setCartId(rs.getInt("cart_id"));
                    cart.setUserId(rs.getInt("user_id"));
                    cart.setRestaurantId(rs.getInt("restaurant_id"));
                    cart.setMenuId(rs.getInt("menu_id"));
                    cart.setQuantity(rs.getInt("quantity"));
                    cart.setTotalPrice(rs.getDouble("total_price"));
                    cart.setCreatedAt(rs.getTimestamp("created_at"));

                    cart.setMenuName(rs.getString("menu_name"));
                    cart.setImage(rs.getString("menu_image"));
                    cart.setRestaurantName(rs.getString("restaurant_name"));

                    cartList.add(cart);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return cartList;
    }

    @Override
    public double getCartTotal(int userId) {

        String sql = "SELECT SUM(total_price) total FROM cart WHERE user_id=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("total");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    @Override
    public int getCartCount(int userId) {

        String sql = "SELECT SUM(quantity) total FROM cart WHERE user_id=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    @Override
    public void clearCart(int userId) {

        String sql = "DELETE FROM cart WHERE user_id=?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
