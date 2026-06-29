<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User"%>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if(loggedUser == null){
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Placed Successfully | FoodExpress</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; font-family:'Segoe UI', sans-serif; }
        body { background: #f8f8f8; min-height: 100vh; }
        
        /* Header Style */
        .navbar { background: white; padding: 15px 5%; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        .logo { font-size: 1.5rem; font-weight: bold; color: #cb202d; }
        .nav-links a { margin-left: 20px; text-decoration: none; color: #333; font-weight: 500; }
        
        .main-container { display: flex; justify-content: center; align-items: center; min-height: 80vh; }
        .card { width: 500px; background: white; padding: 50px; border-radius: 20px; text-align: center; box-shadow: 0 10px 30px rgba(0,0,0,.1); }
        
        .success { width: 100px; height: 100px; margin: auto; background: #22c55e; border-radius: 50%; display: flex; justify-content: center; align-items: center; font-size: 55px; color: white; }
        h1 { margin-top: 25px; color: #22c55e; }
        .info { margin-top: 25px; padding: 20px; background: #f8f8f8; border-radius: 10px; color: #555; }
        .buttons { margin-top: 35px; display: flex; justify-content: center; gap: 20px; }
        .btn { padding: 14px 28px; border-radius: 30px; text-decoration: none; font-weight: bold; transition: .3s; }
        .primary { background: #ff5722; color: white; }
        .secondary { border: 2px solid #ff5722; color: #ff5722; }
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="logo">FoodExpress</div>
        <div class="nav-links">
            <a href="restaurant">Menu</a>
            <a href="orders?action=history">My Orders</a>
            <a href="user?action=logout">Logout</a>
        </div>
    </nav>

    <div class="main-container">
        <div class="card">
            <div class="success">✓</div>
            <h1>Order Placed!</h1>
            <p>Thank you <b><%=loggedUser.getFullName()%></b> for ordering.</p>
            <div class="info">
                Your order has been received. Restaurant is preparing your food.
                <br><br> Estimated delivery: <b>30 - 40 Minutes</b>
            </div>
            <div class="buttons">
                <a href="orders?action=history" class="btn primary">My Orders</a>
                <a href="restaurant" class="btn secondary">Continue Shopping</a>
            </div>
        </div>
    </div>

</body>
</html>