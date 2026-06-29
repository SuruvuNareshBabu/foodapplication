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
import model.Order;
import model.User;
import service.CartService;
import service.OrderService;

@WebServlet("/orders")
public class OrderController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderService orderService;
    private CartService cartService;

    @Override
    public void init() {
        orderService = new OrderService();
        cartService = new CartService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        if (loggedUser == null) { response.sendRedirect("login.jsp"); return; }

        String action = request.getParameter("action");

        if ("confirm".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            request.setAttribute("order", orderService.getOrderDetails(orderId));
            request.getRequestDispatcher("/orderConfirmation.jsp").forward(request, response);
        } 
        else if ("history".equals(action)) {
            request.setAttribute("orderHistory", orderService.getUserOrderHistory(loggedUser.getUserId()));
            request.getRequestDispatcher("/orderHistory.jsp").forward(request, response);
        }
        else if ("track".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            request.setAttribute("order", orderService.getOrderDetails(orderId));
            request.getRequestDispatcher("/trackOrder.jsp").forward(request, response);
        }
        else if ("updateStatus".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String newStatus = request.getParameter("newStatus");
            orderService.updateOrderStatus(orderId, newStatus);
            response.sendRedirect("orders?action=adminDashboard");
        }
        
        else if ("adminDashboard".equals(action)) {
            // Ensure your User model has a getRestaurantId() method
            int restaurantId = loggedUser.getRestaurantId(); 
            request.setAttribute("orders", orderService.getOrdersByRestaurant(restaurantId));
            request.getRequestDispatcher("/admin_dashboard.jsp").forward(request, response);
        }
        else {
            response.sendRedirect("orders?action=history");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("placeOrder".equals(action)) {
            HttpSession session = request.getSession(false);
            User loggedUser = (User) session.getAttribute("loggedUser");
            
            try {
                int userId = loggedUser.getUserId();
                int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
                int addressId = Integer.parseInt(request.getParameter("addressId"));
                double grandTotal = Double.parseDouble(request.getParameter("grandTotal"));
                String paymentMode = request.getParameter("paymentMode");
                String deliveryAddress = request.getParameter("deliveryAddress");

                List<Cart> cartItems = cartService.getCartItems(userId);
                if (cartItems == null || cartItems.isEmpty()) {
                    response.sendRedirect("cart?action=view");
                    return;
                }

                Order order = new Order(userId, restaurantId, addressId, 0, 0, 0, 0, grandTotal, "PLACED", 
                                        "COD".equalsIgnoreCase(paymentMode) ? "COD_PENDING" : "PENDING");
                order.setDeliveryAddress(deliveryAddress);

                int orderId = orderService.createOrder(order, cartItems);

                if (orderId > 0) {
                    cartService.clearCart(userId);
                    session.removeAttribute("cartItems");
                    if ("COD".equalsIgnoreCase(paymentMode)) {
                        response.sendRedirect("orders?action=confirm&orderId=" + orderId);
                    } else {
                        response.sendRedirect("payment.jsp?orderId=" + orderId);
                    }
                } else {
                    response.sendRedirect("checkout_page.jsp?error=order_failed");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("checkout_page.jsp?error=server_error");
            }
        }
    }
}