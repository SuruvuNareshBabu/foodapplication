package daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import dao.RestaurantDAO;
import model.Restaurant;
import util.DBConnection;

public class RestaurantDAOImpl implements RestaurantDAO {

    private Connection connection;

    public RestaurantDAOImpl() {
        connection = DBConnection.getConnection();
    }

    @Override
    public List<Restaurant> getAllRestaurants() {
        List<Restaurant> restaurants = new ArrayList<>();
        String query = "SELECT * FROM restaurants WHERE is_active=true AND is_approved=true ORDER BY rating DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Restaurant restaurant = new Restaurant();
                restaurant.setRestaurantId(rs.getInt("restaurant_id"));
                restaurant.setOwnerId(rs.getInt("owner_id"));
                restaurant.setName(rs.getString("name"));
                restaurant.setImage(rs.getString("image"));
                restaurant.setDescription(rs.getString("description"));
                restaurant.setAddress(rs.getString("address"));
                restaurant.setCity(rs.getString("city"));
                restaurant.setPhone(rs.getString("phone"));
                restaurant.setRating(rs.getDouble("rating"));
                restaurant.setDeliveryTime(rs.getInt("delivery_time"));
                restaurant.setActive(rs.getBoolean("is_active"));
                restaurant.setApproved(rs.getBoolean("is_approved"));
                restaurant.setCreatedAt(rs.getTimestamp("created_at"));
                restaurants.add(restaurant);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return restaurants;
    }

    @Override
    public Restaurant getRestaurantById(int restaurantId) {
        String query = "SELECT * FROM restaurants WHERE restaurant_id=?";
        try {
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setInt(1, restaurantId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Restaurant restaurant = new Restaurant();
                restaurant.setRestaurantId(rs.getInt("restaurant_id"));
                restaurant.setOwnerId(rs.getInt("owner_id"));
                restaurant.setName(rs.getString("name"));
                restaurant.setImage(rs.getString("image"));
                restaurant.setDescription(rs.getString("description"));
                restaurant.setAddress(rs.getString("address"));
                restaurant.setCity(rs.getString("city"));
                restaurant.setPhone(rs.getString("phone"));
                restaurant.setRating(rs.getDouble("rating"));
                restaurant.setDeliveryTime(rs.getInt("delivery_time"));
                restaurant.setActive(rs.getBoolean("is_active"));
                restaurant.setApproved(rs.getBoolean("is_approved"));
                restaurant.setCreatedAt(rs.getTimestamp("created_at"));
                return restaurant;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean addRestaurant(Restaurant restaurant) {
        String query = "INSERT INTO restaurants (owner_id, name, image, description, address, city, phone, rating, delivery_time, is_active, is_approved) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setInt(1, restaurant.getOwnerId());
            ps.setString(2, restaurant.getName());
            ps.setString(3, restaurant.getImage());
            ps.setString(4, restaurant.getDescription());
            ps.setString(5, restaurant.getAddress());
            ps.setString(6, restaurant.getCity());
            ps.setString(7, restaurant.getPhone());
            ps.setDouble(8, restaurant.getRating());
            ps.setInt(9, restaurant.getDeliveryTime());
            ps.setBoolean(10, restaurant.isActive());
            ps.setBoolean(11, restaurant.isApproved());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean updateRestaurant(Restaurant restaurant) {
        String query = "UPDATE restaurants SET owner_id=?, name=?, image=?, description=?, address=?, city=?, phone=?, rating=?, delivery_time=?, is_active=?, is_approved=? WHERE restaurant_id=?";
        try {
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setInt(1, restaurant.getOwnerId());
            ps.setString(2, restaurant.getName());
            ps.setString(3, restaurant.getImage());
            ps.setString(4, restaurant.getDescription());
            ps.setString(5, restaurant.getAddress());
            ps.setString(6, restaurant.getCity());
            ps.setString(7, restaurant.getPhone());
            ps.setDouble(8, restaurant.getRating());
            ps.setInt(9, restaurant.getDeliveryTime());
            ps.setBoolean(10, restaurant.isActive());
            ps.setBoolean(11, restaurant.isApproved());
            ps.setInt(12, restaurant.getRestaurantId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean deleteRestaurant(int restaurantId) {
        String query = "DELETE FROM restaurants WHERE restaurant_id=?";
        try {
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setInt(1, restaurantId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<Restaurant> searchRestaurant(String keyword) {
        List<Restaurant> restaurants = new ArrayList<>();
        String query = "SELECT * FROM restaurants WHERE name LIKE ? OR description LIKE ? AND is_active=true AND is_approved=true";
        try {
            PreparedStatement ps = connection.prepareStatement(query);
            String wildcard = "%" + keyword + "%";
            ps.setString(1, wildcard);
            ps.setString(2, wildcard);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Restaurant restaurant = new Restaurant();
                restaurant.setRestaurantId(rs.getInt("restaurant_id"));
                restaurant.setOwnerId(rs.getInt("owner_id"));
                restaurant.setName(rs.getString("name"));
                restaurant.setImage(rs.getString("image"));
                restaurant.setDescription(rs.getString("description"));
                restaurant.setAddress(rs.getString("address"));
                restaurant.setCity(rs.getString("city"));
                restaurant.setPhone(rs.getString("phone"));
                restaurant.setRating(rs.getDouble("rating"));
                restaurant.setDeliveryTime(rs.getInt("delivery_time"));
                restaurants.add(restaurant);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return restaurants;
    }

    @Override
    public List<Restaurant> getActiveRestaurants() {
        return getAllRestaurants();
    }
}