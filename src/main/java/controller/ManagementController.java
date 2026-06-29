package controller;

import java.io.IOException;

import dao.OrderDAO;
import daoimpl.OrderDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet("/manage")
public class ManagementController extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAOImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // 1. Security Check
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");
        String action = request.getParameter("action"); // e.g., "dashboard" or "list"

        // 2. Fetch data based on role
        if ("ADMIN".equalsIgnoreCase(user.getRole())) {
            request.setAttribute("orders", orderDAO.getAllOrders());
        } else if ("OWNER".equalsIgnoreCase(user.getRole())) {
            request.setAttribute("orders", orderDAO.getOrdersByRestaurant(user.getRestaurantId()));
        } else {
            response.sendRedirect("index.jsp");
            return;
        }
        
        // 3. Routing Logic
        // If action is 'list', go to a table-only view, otherwise default to dashboard
        if ("list".equals(action)) {
            request.getRequestDispatcher("admin_orders.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
        }
    }
    
    

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("updateStatus".equals(action)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String status = request.getParameter("newStatus"); // Ensure this matches JSP name
                
                boolean updated = orderDAO.updateOrderStatus(orderId, status);
                
                // If it's an AJAX request (from your JSP), send a simple success message
                response.setContentType("text/plain");
                response.getWriter().write(updated ? "success" : "error");
            } catch (Exception e) {
                response.getWriter().write("error");
            }
        }
    }
}