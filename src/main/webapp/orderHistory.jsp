<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Order, java.text.SimpleDateFormat" %>
<%
    List<Order> historyList = (List<Order>) request.getAttribute("orderHistory");
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Order History | FoodExpress</title>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
  body { background: #f8f8f8; padding: 40px 20px; }
  .history-container { max-width: 800px; margin: 0 auto; }
  .order-card { background: #fff; border: 1px solid #eee; border-radius: 12px; padding: 20px; margin-bottom: 16px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 5px rgba(0,0,0,0.03); }
  .order-details h3 { color: #cb202d; margin-bottom: 8px; }
  .btn-track { background: #fff; border: 1px solid #cb202d; color: #cb202d; padding: 8px 16px; border-radius: 6px; text-decoration: none; font-weight: bold; font-size: 0.9rem; transition: 0.3s; }
  .btn-track:hover { background: #cb202d; color: white; }
  .status-badge { padding: 5px 12px; border-radius: 20px; font-size: 0.8rem; font-weight: bold; text-transform: uppercase; }
  .status-placed { background: #e0f2f1; color: #00796b; }
  .status-delivered { background: #e8f5e9; color: #2e7d32; }
</style>
</head>
<body>

<div class="history-container">
  <h1>Your Order History</h1>

  <% if (historyList == null || historyList.isEmpty()) { %>
    <div class="empty-state">
      <h2>No Orders Placed Yet</h2>
      <a href="restaurant">Explore Restaurants</a>
    </div>
  <% } else { 
       for (Order o : historyList) { 
  %>
    <div class="order-card">
      <div class="order-details">
        <h3>Order #<%= o.getOrderId() %></h3>
        <p>Placed: <%= o.getCreatedAt() != null ? sdf.format(o.getCreatedAt()) : "N/A" %></p>
        <p>Total: <strong>₹<%= String.format("%.2f", o.getGrandTotal()) %></strong></p>
      </div>
      <div class="order-status">
        <span class="status-badge <%= "DELIVERED".equalsIgnoreCase(o.getOrderStatus()) ? "status-delivered" : "status-placed" %>">
          <%= o.getOrderStatus() %>
        </span>
        <br><br>
        <a href="orders?action=track&orderId=<%= o.getOrderId() %>" class="btn-track">Track Order</a>
      </div>
    </div>
  <%   } 
     } 
  %>
</div>

</body>
</html>