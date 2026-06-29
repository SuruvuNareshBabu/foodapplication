<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Order" %>
<% List<Order> orders = (List<Order>) request.getAttribute("orders"); %>

<% if (orders == null || orders.isEmpty()) { %>
    <div class="empty-state">
        <img src="assets/no-orders.svg" alt="No Orders">
        <p>Everything is caught up! No active orders.</p>
    </div>
<% } %>


<!DOCTYPE html>
<html>
<head>
    <title>Dashboard | FoodExpress Admin</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root { --sidebar-bg: #1c1c1c; --accent-red: #cb202d; --bg-main: #f8f8f8; }
        body { margin: 0; display: flex; font-family: 'Segoe UI', sans-serif; background: var(--bg-main); }
        
        /* Sidebar & Layout */
        .sidebar { width: 260px; height: 100vh; background: var(--sidebar-bg); color: white; position: fixed; }
        .sidebar a { display: block; padding: 18px 25px; color: #a3a3a3; text-decoration: none; }
        .sidebar a:hover { background: var(--accent-red); color: white; }
        .main-content { margin-left: 260px; width: calc(100% - 260px); padding: 30px; }
        
        /* KPI Cards */
        .kpi-container { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 30px; }
        .kpi-card { background: white; padding: 20px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); text-align: center; }
        .kpi-card h3 { font-size: 0.9rem; color: #828282; margin: 0; }
        .kpi-card p { font-size: 1.8rem; font-weight: bold; margin: 10px 0 0; }
        
        /* Table & Chart */
        .card { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { text-transform: uppercase; font-size: 0.75rem; color: #828282; padding: 12px; border-bottom: 2px solid #eee; }
        td { padding: 15px; border-bottom: 1px solid #eee; }
    </style>
</head>
<body>

    <nav class="sidebar">
        <div style="padding: 20px; font-weight:bold; font-size: 1.5rem;">FoodExpress</div>
        <a href="admin_dashboard.jsp" style="color:white; background:var(--accent-red);">Dashboard</a>
        <a href="admin_orders.jsp">Order Management</a>
    </nav>

    <main class="main-content">
        <div class="kpi-container">
            <div class="kpi-card"><h3>Total Revenue</h3><p>₹4.2L</p></div>
            <div class="kpi-card"><h3>Active Orders</h3><p>24</p></div>
            <div class="kpi-card"><h3>New Users</h3><p>156</p></div>
        </div>

        <div class="card" style="margin-bottom: 30px;">
            <canvas id="revenueChart" height="80"></canvas>
        </div>

        <div class="card">
            <h1>Recent Orders</h1>
            <table>
                <thead><tr><th>ID</th><th>Customer</th><th>Status</th><th>Action</th></tr></thead>
                <tbody>
                    <% if (orders != null) { for (Order o : orders) { %>
                    <tr id="row-<%= o.getOrderId() %>">
                        <td>#FEX-<%= o.getOrderId() %></td>
                        <td>User-<%= o.getUserId() %></td>
                        <td><span id="status-<%= o.getOrderId() %>"><%= o.getOrderStatus() %></span></td>
                        <td>
                            <select onchange="updateStatus(<%= o.getOrderId() %>, this.value)">
                                <option value="PLACED">Placed</option>
                                <option value="PREPARING">Preparing</option>
                                <option value="DELIVERED">Delivered</option>
                            </select>
                        </td>
                    </tr>
                    <% }} %>
                </tbody>
            </table>
        </div>
    </main>

    <script>
        // Analytics Chart
        const ctx = document.getElementById('revenueChart').getContext('2d');
        new Chart(ctx, { type: 'line', data: { labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'], datasets: [{ label: 'Revenue', data: [5000, 8000, 6000, 12000, 15000], borderColor: '#cb202d' }] } });

        // AJAX Update (Fixes page reload issue)
      			function updateStatus(orderId, status) {
    // Send to ManagementController (mapped to /manage)
    fetch('manage?action=updateStatus&orderId=' + orderId + '&newStatus=' + status, {
        method: 'POST' 
    })
    .then(response => response.text())
    .then(data => {
        if(data === 'success') {
            document.getElementById('status-' + orderId).innerText = status;
            // Optional: Add a simple toast notification here
        }
    });
        }
    </script>
</body>
</html>