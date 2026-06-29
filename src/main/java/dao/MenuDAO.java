package dao;

import java.util.List;

import model.Menu;

public interface MenuDAO {

    // Add Menu Item
    boolean addMenuItem(Menu menu);

    // Update Menu Item
    boolean updateMenuItem(Menu menu);

    // Delete Menu Item
    boolean deleteMenuItem(int menuId);

    // Get Menu Item By Id
    Menu getMenuItemById(int menuId);

    // Get All Menu Items
    List<Menu> getAllMenuItems();

    // Get Menu Items By Restaurant
    List<Menu> getMenuByRestaurantId(int restaurantId);

    // Search Menu Item
    List<Menu> searchMenuItem(String keyword);

    // Get Available Menu Items By Restaurant
    List<Menu> getAvailableMenuByRestaurantId(int restaurantId);

}
