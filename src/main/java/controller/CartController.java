package controller;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Cart;
import model.User;
import service.CartService;

@WebServlet("/cart")
public class CartController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private CartService cartService;

    @Override
    public void init() {
        cartService = new CartService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /** True if the call came from fetch()/XHR rather than a normal page navigation. */
    private boolean isAjax(HttpServletRequest request) {
        return "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
    }

    /** Writes a small JSON body by hand (no extra dependency needed for this shape). */
    private void sendJson(HttpServletResponse response, boolean success, String message,
                           Integer cartCount, Double cartTotal) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        StringBuilder json = new StringBuilder();
        json.append("{\"success\":").append(success);
        if (message != null) {
            json.append(",\"message\":\"").append(message.replace("\"", "'")).append("\"");
        }
        if (cartCount != null) {
            json.append(",\"cartCount\":").append(cartCount);
        }
        if (cartTotal != null) {
            json.append(",\"cartTotal\":").append(cartTotal);
        }
        json.append("}");

        PrintWriter out = response.getWriter();
        out.write(json.toString());
        out.flush();
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("loggedUser") == null) {
            if (isAjax(request)) {
                sendJson(response, false, "Please log in again", null, null);
            } else {
                response.sendRedirect("login.jsp");
            }
            return;
        }

        User user = (User) session.getAttribute("loggedUser");
        String action = request.getParameter("action");

        if ("view".equals(action)) {
            request.setAttribute("cartItems", cartService.getCartItems(user.getUserId()));
            request.setAttribute("cartTotal", cartService.getCartTotal(user.getUserId()));
            request.setAttribute("cartCount", cartService.getCartCount(user.getUserId()));
            request.getRequestDispatcher("/cart.jsp").forward(request, response);
            return;
        }

        int menuId = 0;
        if (request.getParameter("menuId") != null) {
            try {
                menuId = Integer.parseInt(request.getParameter("menuId"));
            } catch (NumberFormatException e) {
                if (isAjax(request)) {
                    sendJson(response, false, "Invalid menu item id", null, null);
                    return;
                }
                response.sendRedirect("cart?action=view");
                return;
            }
        }

        boolean ok = true;
        String errorMessage = null;
        String restaurantId = request.getParameter("restaurantId");

        try {
            if ("add".equals(action)) {
            	System.out.println("ADD REQUEST RECEIVED");
                int restaurantId1 = Integer.parseInt(request.getParameter("restaurantId"));
                double totalPrice = Double.parseDouble(request.getParameter("totalPrice"));

                Cart cart1 = new Cart();
                cart1.setUserId(user.getUserId());
                cart1.setRestaurantId(restaurantId1);
                cart1.setMenuId(menuId);
                cart1.setQuantity(1);
                cart1.setTotalPrice(totalPrice);

                ok = cartService.addToCart(cart1);

            } else if ("plus".equals(action)) {
                ok = cartService.increaseQuantity(user.getUserId(), menuId);

            } else if ("minus".equals(action)) {
                ok = cartService.decreaseQuantity(user.getUserId(), menuId);

            } else if ("remove".equals(action)) {
                ok = cartService.removeItem(user.getUserId(), menuId);

            } else if ("clear".equals(action)) {
                cartService.clearCart(user.getUserId());

            } else {
                ok = false;
                errorMessage = "Unknown cart action: " + action;
            }
        } catch (NumberFormatException e) {
            ok = false;
            errorMessage = "Missing or invalid cart parameters";
        }

        // ── HANDLE FAILURES ──
        if (!ok) {
            if (isAjax(request)) {
                sendJson(
                    response,
                    false,
                    errorMessage != null ? errorMessage : "Cart contains items from another restaurant",
                    null,
                    null
                );
                return;
            }

            session.setAttribute(
                "cartError",
                "You can order from only one restaurant at a time."
            );

            // FIXED: Standardize safety check to prevent appending text "null" to routing targets
            if (restaurantId != null && !restaurantId.trim().isEmpty()) {
                response.sendRedirect("menu?restaurantId=" + restaurantId);
            } else {
                response.sendRedirect("restaurant");
            }
            return;
        }

        // ── SYNC MASTER CONFIGS & ACCOUNT COUNTERS GLOBAL CACHE ──
        int updatedCount = cartService.getCartCount(user.getUserId());
        double updatedTotal = cartService.getCartTotal(user.getUserId());
        
        // FIXED: Sync metrics back into the long-lived session state so tracking layouts stay accurate
        session.setAttribute("headerCartCount", updatedCount);
        session.setAttribute("cartCount", updatedCount);

        // ── HANDLE SUCCESS RESPONSE PIPELINE ──
        if (isAjax(request)) {
            sendJson(response, true, "Success", updatedCount, updatedTotal);
        } else {
            if ("clear".equals(action)) {
                response.sendRedirect("restaurant");
            } else {
                response.sendRedirect("cart?action=view");
            }
        }
    }
}