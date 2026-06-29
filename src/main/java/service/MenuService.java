package service;

import java.util.List;

import dao.MenuDAO;
import daoimpl.MenuDAOImpl;
import model.Menu;

public class MenuService {

    private MenuDAO menuDAO;

    public MenuService() {
        menuDAO = new MenuDAOImpl();
    }

    public List<Menu> getAllMenuItems() {
        return menuDAO.getAllMenuItems();
    }

    public Menu getMenuItem(int menuId) {
        return menuDAO.getMenuItemById(menuId);
    }

    public List<Menu> getMenuByRestaurant(int restaurantId) {
        return menuDAO.getMenuByRestaurantId(restaurantId);
    }

    public List<Menu> getAvailableMenuByRestaurant(int restaurantId) {
        return menuDAO.getAvailableMenuByRestaurantId(restaurantId);
    }

    public List<Menu> searchMenuItem(String keyword) {
        return menuDAO.searchMenuItem(keyword);
    }

}
