package controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Cart;
import model.Menu;
import model.Restaurant;
import model.User;
import service.CartService;
import service.MenuService;
import service.RestaurantService;

@WebServlet("/menu")
public class MenuController extends HttpServlet {

    private MenuService menuService;
    private RestaurantService restaurantService;
    private CartService cartService;

    @Override
    public void init() {
        menuService = new MenuService();
        restaurantService = new RestaurantService();
        cartService = new CartService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String restaurantIdParam = request.getParameter("restaurantId");
        if (restaurantIdParam == null) {
            response.sendRedirect("restaurant");
            return;
        }

        int restaurantId;
        try {
            restaurantId = Integer.parseInt(restaurantIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("restaurant");
            return;
        }

        Restaurant restaurant = restaurantService.getRestaurant(restaurantId);
        if (restaurant == null) {
            response.sendRedirect("restaurant");
            return;
        }

        List<Menu> menuItems = menuService.getAvailableMenuByRestaurant(restaurantId);

        request.setAttribute("restaurant", restaurant);
        request.setAttribute("menuItems", menuItems);

        // Track user context and extract database quantities
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        Map<Integer, Integer> cartQuantities = new HashMap<>();
        int cartCount = 0;

        
        
        if (user != null) {
            List<Cart> cartItems = cartService.getCartItems(user.getUserId());
            for (Cart c : cartItems) {
                cartQuantities.put(c.getMenuId(), c.getQuantity());
            }
            cartCount = cartService.getCartCount(user.getUserId());
        }

        // Forward state markers down to your view template scope
        request.setAttribute("cartQuantities", cartQuantities);
        request.setAttribute("cartCount", cartCount);
     // ManagementController.java
        // "orders" is the KEY

        request.getRequestDispatcher("/menu.jsp").forward(request, response);
    }
}