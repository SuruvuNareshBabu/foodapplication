<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Order" %>
<%
    Order order = (Order)request.getAttribute("order");
    String status = (order != null) ? order.getOrderStatus() : "PLACED";
%>
<!DOCTYPE html>
<html>
<head>
<title>Track Order | FoodExpress</title>
<style>
    :root { --primary: #cb202d; --gray: #e0e0e0; --active: #27ae60; }
    .container { max-width: 600px; margin: 40px auto; padding: 20px; }
    
    /* Stepper CSS */
    .stepper { display: flex; justify-content: space-between; margin: 40px 0; }
    .step { flex: 1; text-align: center; position: relative; font-size: 0.8rem; color: #888; }
    .step::before { content: ''; width: 12px; height: 12px; background: var(--gray); border-radius: 50%; display: block; margin: 0 auto 10px; }
    .step.active { color: var(--active); font-weight: bold; }
    .step.active::before { background: var(--active); }
    
    .card { background: #fff; padding: 20px; border-radius: 15px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
</style>
</head>
<body>

<div class="container">
    <div class="card">
        <h3>Order #<%= order.getOrderId() %> Status</h3>
        
        <div class="stepper">
            <div class="step <%= status.equals("PLACED") || status.equals("PREPARING") || status.equals("DELIVERED") ? "active" : "" %>">Placed</div>
            <div class="step <%= status.equals("PREPARING") || status.equals("DELIVERED") ? "active" : "" %>">Preparing</div>
            <div class="step <%= status.equals("DELIVERED") ? "active" : "" %>">Delivered</div>
        </div>

        <p><strong>Delivery Address:</strong> <%= order.getDeliveryAddress() %></p>
        <button onclick="window.location.href='orders?action=history'" style="width:100%; padding:10px;">Back to History</button>
    </div>
</div>

<script>
    // Auto-refresh the page every 30 seconds to update tracking status
    setInterval(() => {
        window.location.reload();
    }, 30000);
</script>
</body>
</html>