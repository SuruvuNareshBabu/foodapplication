package dao;

import java.util.List;
import model.Cart;

public interface CartDAO {

    boolean addToCart(Cart cart);

    Cart getCartItem(int userId,int menuId);

    boolean updateQuantity(
            int userId,
            int menuId,
            int quantity,
            double totalPrice);

    boolean removeFromCart(
            int userId,
            int menuId);

    List<Cart> getCartItems(int userId);

    double getCartTotal(int userId);

    int getCartCount(int userId);

    void clearCart(int userId);

	Integer getCartRestaurantId(int userId);
	

}