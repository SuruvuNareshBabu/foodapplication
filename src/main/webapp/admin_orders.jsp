<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Order" %>
<% List<Order> orders = (List<Order>) request.getAttribute("orders"); %>
<!DOCTYPE html>
<html>
<head>
    <title>Order Management | FoodExpress</title>
    <style>
        :root { --primary: #cb202d; --bg: #f4f7f6; --text: #333; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: var(--bg); margin: 0; padding: 20px; color: var(--text); }
        .wrapper { max-width: 1200px; margin: auto; background: white; padding: 30px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.05); }
        h1 { margin-top: 0; color: #2d3436; }
        
        /* Professional Table Styles */
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background: #f8f9fa; text-align: left; padding: 15px; border-bottom: 2px solid #eee; font-weight: 600; text-transform: uppercase; font-size: 0.8rem; }
        td { padding: 15px; border-bottom: 1px solid #eee; }
        tr:hover { background: #fdf5f5; transition: 0.2s; }
        
        /* Status Pill */
        .status { padding: 6px 12px; border-radius: 20px; font-size: 0.85rem; font-weight: bold; }
        .status-placed { background: #e3f2fd; color: #1976d2; }
        .status-preparing { background: #fff3e0; color: #f57c00; }
        .status-delivered { background: #e8f5e9; color: #388e3c; }
    </style>
</head>
<body>

    <div class="wrapper">
        <div style="display:flex; justify-content:space-between; align-items:center;">
            <h1>Order Management</h1>
            <a href="manage" style="text-decoration:none; color:var(--primary); font-weight:bold;">&larr; Back to Dashboard</a>
        </div>

        <table>
            <thead>
                <tr><th>ID</th><th>User</th><th>Total</th><th>Address</th><th>Status</th></tr>
            </thead>
            <tbody>
                <% if (orders != null) { for (Order o : orders) { %>
                <tr>
                    <td>#FEX-<%= o.getOrderId() %></td>
                    <td>User-<%= o.getUserId() %></td>
                    <td>₹<%= o.getGrandTotal() %></td>
                    <td><%= o.getDeliveryAddress() %></td>
                    <td>
                        <span class="status status-<%= o.getOrderStatus().toLowerCase() %>">
                            <%= o.getOrderStatus() %>
                        </span>
                    </td>
                </tr>
                <% }} %>
            </tbody>
        </table>
    </div>

    <script>
        // Simple JS to highlight the current row being clicked
        document.querySelectorAll('tr').forEach(row => {
            row.addEventListener('mouseover', () => row.style.cursor = 'pointer');
        });
        console.log("Dashboard UI Loaded Successfully.");
    </script>
</body>
</html>