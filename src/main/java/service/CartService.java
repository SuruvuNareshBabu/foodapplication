package service;

import java.util.List;

import dao.CartDAO;
import daoimpl.CartDAOImpl;
import model.Cart;

public class CartService {

    private CartDAO cartDAO;

    public CartService() {
        cartDAO = new CartDAOImpl();
    }

 
    public boolean addToCart(Cart cart) {

        if (cart == null) {
            System.err.println("CartService.addToCart(): cart is null");
            return false;
        }

        Integer existingRestaurantId =
                cartDAO.getCartRestaurantId(
                        cart.getUserId());

        System.out.println("===== SERVICE =====");
        System.out.println("Existing Restaurant ID = " + existingRestaurantId);
        System.out.println("Current Restaurant ID = " + cart.getRestaurantId());
        
        
        System.out.println("Calling addToCart() in DAO...");
        boolean result = cartDAO.addToCart(cart);
        System.out.println("DAO returned: " + result);
       
        if (existingRestaurantId != null &&
            existingRestaurantId != cart.getRestaurantId()) {

            return false;
        }

        Cart existing =
                cartDAO.getCartItem(
                        cart.getUserId(),
                        cart.getMenuId());

        if (existing != null) {

            int quantity = existing.getQuantity() + 1;

            double unitPrice =
                    existing.getTotalPrice()
                    / existing.getQuantity();

            double totalPrice =
                    unitPrice * quantity;

            return cartDAO.updateQuantity(
                    cart.getUserId(),
                    cart.getMenuId(),
                    quantity,
                    totalPrice);
        }

        
        return cartDAO.addToCart(cart);
    }
    
    

    // Get cart items
    public List<Cart> getCartItems(int userId) {
        return cartDAO.getCartItems(userId);
    }

    // Increase quantity
    public boolean increaseQuantity(
            int userId,
            int menuId) {

        Cart cart =
                cartDAO.getCartItem(
                        userId,
                        menuId);

        if (cart == null) {
            return false;
        }

        int quantity =
                cart.getQuantity() + 1;

        double unitPrice =
                cart.getTotalPrice()
                / cart.getQuantity();

        double totalPrice =
                unitPrice * quantity;

        return cartDAO.updateQuantity(
                userId,
                menuId,
                quantity,
                totalPrice);
    }

    // Decrease quantity
    public boolean decreaseQuantity(
            int userId,
            int menuId) {

        Cart cart =
                cartDAO.getCartItem(
                        userId,
                        menuId);

        if (cart == null) {
            return false;
        }

        int quantity =
                cart.getQuantity() - 1;

        if (quantity <= 0) {

            return cartDAO.removeFromCart(
                    userId,
                    menuId);
        }

        double unitPrice =
                cart.getTotalPrice()
                / cart.getQuantity();

        double totalPrice =
                unitPrice * quantity;

        return cartDAO.updateQuantity(
                userId,
                menuId,
                quantity,
                totalPrice);
    }

    // Remove item
    public boolean removeItem(
            int userId,
            int menuId) {

        return cartDAO.removeFromCart(
                userId,
                menuId);
    }

    // Cart Total
    public double getCartTotal(int userId) {
        return cartDAO.getCartTotal(userId);
    }

    // Cart Count
    public int getCartCount(int userId) {
        return cartDAO.getCartCount(userId);
    }

    // Clear Cart
    public void clearCart(int userId) {
        cartDAO.clearCart(userId);
    }
}