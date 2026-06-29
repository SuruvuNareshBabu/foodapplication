package service;

import java.util.List;

import dao.RestaurantDAO;
import daoimpl.RestaurantDAOImpl;
import model.Restaurant;

public class RestaurantService {

    private RestaurantDAO restaurantDAO;

    public RestaurantService() {

        restaurantDAO = new RestaurantDAOImpl();

    }

    public List<Restaurant> getAllRestaurants() {

        return restaurantDAO.getAllRestaurants();

    }

    public Restaurant getRestaurant(int restaurantId) {

        return restaurantDAO.getRestaurantById(restaurantId);

    }
    public Restaurant getRestaurantById(int restaurantId) {
        return restaurantDAO.getRestaurantById(restaurantId);
    }

}