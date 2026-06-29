package daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dao.MenuDAO;
import model.Menu;
import util.DBConnection;

public class MenuDAOImpl implements MenuDAO {

    private Connection connection;

    public MenuDAOImpl() {

        connection = DBConnection.getConnection();

       

    }

    @Override
    public boolean addMenuItem(Menu menu) {

        return false;

    }

    @Override
    public boolean updateMenuItem(Menu menu) {

        return false;

    }

    @Override
    public boolean deleteMenuItem(int menuId) {

        return false;

    }

    @Override
    public Menu getMenuItemById(int menuId) {

        String query =
                "SELECT * FROM menu WHERE menu_id=?";

        try {

            PreparedStatement ps =
                    connection.prepareStatement(query);

            ps.setInt(1, menuId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Menu menu = new Menu();

                menu.setMenuId(rs.getInt("menu_id"));
                menu.setRestaurantId(rs.getInt("restaurant_id"));
                menu.setName(rs.getString("name"));
                menu.setDescription(rs.getString("description"));
                menu.setCategory(rs.getString("category"));
                menu.setPrice(rs.getDouble("price"));
                menu.setImage(rs.getString("image"));
                menu.setAvailable(rs.getBoolean("is_available"));
                menu.setCreatedAt(rs.getTimestamp("created_at"));
                menu.setUpdatedAt(rs.getTimestamp("updated_at"));

                return menu;

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return null;

    }

    @Override
    public List<Menu> getAllMenuItems() {

        List<Menu> menuItems = new ArrayList<>();

        String query =
                "SELECT * FROM menu ORDER BY category, name";

        try {

            PreparedStatement ps =
                    connection.prepareStatement(query);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Menu menu = new Menu();

                menu.setMenuId(rs.getInt("menu_id"));
                menu.setRestaurantId(rs.getInt("restaurant_id"));
                menu.setName(rs.getString("name"));
                menu.setDescription(rs.getString("description"));
                menu.setCategory(rs.getString("category"));
                menu.setPrice(rs.getDouble("price"));
                menu.setImage(rs.getString("image"));
                menu.setAvailable(rs.getBoolean("is_available"));
                menu.setCreatedAt(rs.getTimestamp("created_at"));
                menu.setUpdatedAt(rs.getTimestamp("updated_at"));

                menuItems.add(menu);

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return menuItems;

    }

    @Override
    public List<Menu> getMenuByRestaurantId(int restaurantId) {

        List<Menu> menuItems = new ArrayList<>();

        String query =
                "SELECT * FROM menu WHERE restaurant_id=? ORDER BY category, name";

        try {

            PreparedStatement ps =
                    connection.prepareStatement(query);

            ps.setInt(1, restaurantId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Menu menu = new Menu();

                menu.setMenuId(rs.getInt("menu_id"));
                menu.setRestaurantId(rs.getInt("restaurant_id"));
                menu.setName(rs.getString("name"));
                menu.setDescription(rs.getString("description"));
                menu.setCategory(rs.getString("category"));
                menu.setPrice(rs.getDouble("price"));
                menu.setImage(rs.getString("image"));
                menu.setAvailable(rs.getBoolean("is_available"));
                menu.setCreatedAt(rs.getTimestamp("created_at"));
                menu.setUpdatedAt(rs.getTimestamp("updated_at"));

                menuItems.add(menu);

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return menuItems;

    }

    @Override
    public List<Menu> searchMenuItem(String keyword) {

        List<Menu> menuItems = new ArrayList<>();

        String query =
                "SELECT * FROM menu WHERE name LIKE ?";

        try {

            PreparedStatement ps =
                    connection.prepareStatement(query);

            ps.setString(1, "%" + keyword + "%");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Menu menu = new Menu();

                menu.setMenuId(rs.getInt("menu_id"));
                menu.setRestaurantId(rs.getInt("restaurant_id"));
                menu.setName(rs.getString("name"));
                menu.setDescription(rs.getString("description"));
                menu.setCategory(rs.getString("category"));
                menu.setPrice(rs.getDouble("price"));
                menu.setImage(rs.getString("image"));
                menu.setAvailable(rs.getBoolean("is_available"));
                menu.setCreatedAt(rs.getTimestamp("created_at"));
                menu.setUpdatedAt(rs.getTimestamp("updated_at"));

                menuItems.add(menu);

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return menuItems;

    }

    @Override
    public List<Menu> getAvailableMenuByRestaurantId(int restaurantId) {

        List<Menu> menuItems = new ArrayList<>();

        String query =
                "SELECT * FROM menu WHERE restaurant_id=? AND is_available=true ORDER BY category, name";

        try {

            PreparedStatement ps =
                    connection.prepareStatement(query);

            ps.setInt(1, restaurantId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Menu menu = new Menu();

                menu.setMenuId(rs.getInt("menu_id"));
                menu.setRestaurantId(rs.getInt("restaurant_id"));
                menu.setName(rs.getString("name"));
                menu.setDescription(rs.getString("description"));
                menu.setCategory(rs.getString("category"));
                menu.setPrice(rs.getDouble("price"));
                menu.setImage(rs.getString("image"));
                menu.setAvailable(rs.getBoolean("is_available"));
                menu.setCreatedAt(rs.getTimestamp("created_at"));
                menu.setUpdatedAt(rs.getTimestamp("updated_at"));

                menuItems.add(menu);

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return menuItems;

    }

}
