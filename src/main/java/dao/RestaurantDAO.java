package dao;

import java.util.List;

import model.Restaurant;

public interface RestaurantDAO {

    // Add Restaurant
    boolean addRestaurant(Restaurant restaurant);

    // Update Restaurant
    boolean updateRestaurant(Restaurant restaurant);

    // Delete Restaurant
    boolean deleteRestaurant(int restaurantId);

    // Get Restaurant By Id
    Restaurant getRestaurantById(int restaurantId);

    // Get All Restaurants
    List<Restaurant> getAllRestaurants();

    // Search Restaurant
    List<Restaurant> searchRestaurant(String keyword);

    // Active Restaurants
    List<Restaurant> getActiveRestaurants();

}