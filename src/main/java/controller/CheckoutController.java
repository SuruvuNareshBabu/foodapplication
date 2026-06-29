package controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Cart;
import model.Restaurant;
import model.User;
import service.CartService;
import service.RestaurantService;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CartService cartService;
    private RestaurantService restaurantService;

    @Override
    public void init() {
        cartService = new CartService();
        restaurantService = new RestaurantService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // 1. Security Checkpoint
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");
        
        // 2. Fetch Data
        List<Cart> cartItems = cartService.getCartItems(user.getUserId());

        // 3. Prevent access if cart is empty
        if (cartItems == null || cartItems.isEmpty()) {
            response.sendRedirect("cart?action=view");
            return;
        }

        // 4. Calculate pricing
        double subtotal = cartService.getCartTotal(user.getUserId());
        double deliveryCharge = 40.0;
        double tax = subtotal * 0.05;
        double discount = 0.0;
        double grandTotal = subtotal + deliveryCharge + tax - discount;

        // 5. Fetch Restaurant details
        int restaurantId = cartItems.get(0).getRestaurantId();
        Restaurant restaurant = restaurantService.getRestaurantById(restaurantId);

        // 6. Set attributes for the View
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("restaurant", restaurant);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("deliveryCharge", deliveryCharge);
        request.setAttribute("tax", tax);
        request.setAttribute("discount", discount);
        request.setAttribute("grandTotal", grandTotal);

        // 7. SECURE FORWARD: Use /WEB-INF/ to ensure the page cannot be requested directly
        // Ensure you have moved checkout_view.jsp into /src/main/webapp/WEB-INF/
//        request.getRequestDispatcher("/checkout_page.jsp").forward(request, response);
        
     // Open CheckoutController.java and find the doGet method
     // Change the line to look like this:

     request.getRequestDispatcher("/checkout_page.jsp").forward(request, response);
    }
}