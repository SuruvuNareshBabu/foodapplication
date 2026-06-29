<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Order"%>
<%
    Order order = (Order)request.getAttribute("order");
    if (order == null) {
        response.sendRedirect("orders?action=history");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Order Confirmed | FoodExpress</title>
    <style>
        :root { --primary: #cb202d; --success: #22c55e; }
        body { font-family: 'Segoe UI', Tahoma, sans-serif; background: #f4f7f6; padding: 20px; }
        
        .container { 
            max-width: 500px; margin: 30px auto; background: white; 
            padding: 30px; border-radius: 16px; box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            text-align: center; border-top: 8px solid var(--success);
        }
        
        .success-icon { font-size: 50px; margin-bottom: 10px; }
        h2 { color: #333; margin-bottom: 5px; }
        
        .order-details { 
            text-align: left; background: #f9f9f9; padding: 20px; 
            border-radius: 10px; margin: 20px 0; border: 1px dashed #ccc;
        }
        
        .order-details p { display: flex; justify-content: space-between; margin: 10px 0; }
        
        .status-badge { 
            background: #dcfce7; color: #166534; padding: 4px 12px; 
            border-radius: 50px; font-size: 0.85rem; font-weight: 600; 
        }
        
        .btn-link { 
            display: inline-block; margin-top: 20px; padding: 12px 25px;
            background: var(--primary); color: white; text-decoration: none;
            border-radius: 8px; font-weight: 600; transition: 0.3s;
        }
        .btn-link:hover { background: #a51a24; }
    </style>
</head>
<body>
    <div class="container">
        <div class="success-icon">🎉</div>
        <h2>Order Confirmed!</h2>
        <p>Your order <strong>#<%=order.getOrderId()%></strong> is confirmed.</p>
        
        <div class="order-details">
            <p><strong>Status:</strong> <span class="status-badge"><%=order.getOrderStatus()%></span></p>
            <p><strong>Total Amount:</strong> <span>₹<%=String.format("%.2f", order.getGrandTotal())%></span></p>
            <p><strong>Address:</strong> <span><%=order.getDeliveryAddress() != null ? order.getDeliveryAddress() : "Not provided"%></span></p>
        </div>
        
        <a href="orders?action=history" class="btn-link">View Order History</a>
    </div>
</body>
</html>