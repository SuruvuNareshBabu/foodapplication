<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Cart, model.Restaurant, model.User"%>
<%
    User loggedUser = (User)session.getAttribute("loggedUser");
    if (loggedUser == null) { response.sendRedirect("login.jsp"); return; }
    
    // Safely retrieve attributes
    List<Cart> cartItems = (List<Cart>)request.getAttribute("cartItems");
    Restaurant restaurant = (Restaurant)request.getAttribute("restaurant");
    
    // Provide default values if attributes are null
    double subtotal = (request.getAttribute("subtotal") != null) ? (Double)request.getAttribute("subtotal") : 0.0;
    double deliveryCharge = (request.getAttribute("deliveryCharge") != null) ? (Double)request.getAttribute("deliveryCharge") : 0.0;
    double tax = (request.getAttribute("tax") != null) ? (Double)request.getAttribute("tax") : 0.0;
    double grandTotal = (request.getAttribute("grandTotal") != null) ? (Double)request.getAttribute("grandTotal") : 0.0;
%>
<!DOCTYPE html>
<html>
<head>
<title>Checkout | FoodExpress</title>
<style>
    :root { --primary: #cb202d; --bg: #f8f8f8; }
    body { font-family: 'Segoe UI', sans-serif; background: var(--bg); margin: 0; padding: 20px; }
    .container { max-width: 1000px; margin: auto; }
    .checkout-grid { display: grid; grid-template-columns: 1fr 350px; gap: 30px; }
    .card { background: white; padding: 20px; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); margin-bottom: 20px; }
    .item-row { display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px solid #eee; }
    .bill-row { display: flex; justify-content: space-between; margin: 10px 0; }
    textarea { width: 100%; height: 80px; border: 1px solid #ccc; border-radius: 8px; padding: 10px; box-sizing: border-box; }
    select { width: 100%; padding: 10px; border-radius: 8px; border: 1px solid #ccc; }
    .btn-submit { background: var(--primary); color: white; width: 100%; padding: 15px; border: none; border-radius: 8px; font-size: 1.1rem; font-weight: bold; cursor: pointer; }
</style>
</head>
<body>

<div class="container">
    <h2>Secure Checkout</h2>
    <form action="${pageContext.request.contextPath}/orders?action=placeOrder" method="post" id="checkoutForm">
        <input type="hidden" name="restaurantId" value="<%= (restaurant != null) ? restaurant.getRestaurantId() : "0" %>">
        <input type="hidden" name="addressId" value="1"> 
        <input type="hidden" name="grandTotal" value="<%= grandTotal %>">

        <div class="checkout-grid">
            <div class="main-content">
                <div class="card">
                    <h3>Order Items from <%= (restaurant != null) ? restaurant.getName() : "Unknown Restaurant" %></h3>
                    <% if (cartItems != null) { 
                        for(Cart item : cartItems) { %>
                        <div class="item-row">
                            <span><%=item.getMenuName()%> x <%=item.getQuantity()%></span>
                            <span>₹<%=String.format("%.2f", item.getTotalPrice())%></span>
                        </div>
                    <% } 
                    } else { %>
                        <p>Your cart is empty.</p>
                    <% } %>
                </div>
                
                <div class="card">
                    <h3>Delivery Address</h3>
                    <textarea name="deliveryAddress" id="deliveryAddress" placeholder="Enter your full delivery address..." required></textarea>
                </div>

                <div class="card">
                    <h3>Payment Method</h3>
                    <select name="paymentMode">
                        <option value="COD">Cash on Delivery (COD)</option>
                        <option value="ONLINE">Online Payment</option>
                    </select>
                </div>
            </div>

            <div class="sidebar">
                <div class="card">
                    <h3>Bill Details</h3>
                    <div class="bill-row"><span>Subtotal</span> <span>₹<%=String.format("%.2f", subtotal)%></span></div>
                    <div class="bill-row"><span>Tax</span> <span>₹<%=String.format("%.2f", tax)%></span></div>
                    <div class="bill-row"><span>Delivery</span> <span>₹<%=String.format("%.2f", deliveryCharge)%></span></div>
                    <hr>
                    <div class="bill-row" style="font-weight:bold; font-size: 1.2rem;"><span>Total</span> <span>₹<%=String.format("%.2f", grandTotal)%></span></div>
                    <button type="submit" class="btn-submit">Place Order</button>
                </div>
            </div>
        </div>
    </form>
</div>

<script>
    document.getElementById('checkoutForm').onsubmit = function() {
        if(document.getElementById('deliveryAddress').value.trim().length < 10) {
            alert("Please enter a valid address (min 10 characters).");
            return false;
        }
        return true;
    };
</script>
</body>
</html>