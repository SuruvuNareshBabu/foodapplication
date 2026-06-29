<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Cart, model.User, java.util.List" %>
<%
    // 1. Session & Security Check
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Safely Retrieve Request Attributes
    List<Cart> cartItems = (List<Cart>) request.getAttribute("cartItems");
    
    Integer cartCountObj = (Integer) request.getAttribute("cartCount");
    int cartCount = (cartCountObj != null) ? cartCountObj : 0;
    
    Double cartTotalObj = (Double) request.getAttribute("cartTotal");
    double cartTotal = (cartTotalObj != null) ? cartTotalObj : 0.0;
    
    // Dynamic fallback check for the restaurant name property
    String restaurantName = (String) request.getAttribute("restaurantName");
    if (restaurantName == null && cartItems != null && !cartItems.isEmpty()) {
        restaurantName = cartItems.get(0).getRestaurantName();
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FoodExpress | Your Shopping Cart</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<style>
  /* ── Core Design Framework Reset & Tokens ── */
  * {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
  }

  body {
    background: #ffffff;
    color: #1c1c1c;
    min-height: 100vh;
    padding-top: 92px; /* Uniform header layout tracking offset */
    overflow-x: hidden;
  }

  /* ── Corporate Unified Navigation System ── */
  header {
    position: fixed;
    top: 0;
    width: 100%;
    z-index: 1000;
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
    border-bottom: 1px solid #f2f2f2;
  }

  .navbar {
    height: 72px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 10%;
    max-width: 1400px;
    margin: 0 auto;
  }

  .logo {
    font-size: 32px;
    font-weight: 800;
    text-decoration: none;
    color: #cb202d; /* Corporate Red Theme */
    letter-spacing: -1px;
  }

  .nav-links {
    list-style: none;
    display: flex;
    gap: 30px;
    align-items: center;
  }

  .nav-links a {
    text-decoration: none;
    font-weight: 500;
    font-size: 16px;
    color: #333;
    transition: color 0.25s;
    display: flex;
    align-items: center;
  }

  .nav-links a:hover {
    color: #cb202d;
  }

  /* ── Integrated Interactive Profile Component ── */
  .profile-trigger {
    background: none;
    border: none;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 4px 8px;
    font-family: inherit;
    font-size: 16px;
    color: #333;
    transition: transform 0.15s ease, color 0.25s;
  }

  .profile-trigger:hover {
    color: #cb202d;
    transform: scale(1.02);
  }

  .profile-trigger:focus {
    outline: none;
  }

  .avatar-circle {
    width: 28px;
    height: 28px;
    border-radius: 50%;
    background: #cb202d;
    color: #fff;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-weight: 700;
    font-size: 13px;
    overflow: hidden;
    box-shadow: 0 2px 6px rgba(203, 32, 45, 0.2);
  }

  .avatar-circle img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  .welcome-text {
    font-weight: 500;
  }

  /* ── Structural Cart Link Alignment ── */
  .cart-link {
    display: flex;
    align-items: center;
    position: relative;
  }

  .cart-link a {
    color: #cb202d !important;
    font-weight: 600;
    gap: 4px;
  }

  .cart-badge {
    background: #cb202d;
    color: #fff;
    font-size: 11px;
    font-weight: 700;
    border-radius: 50%;
    min-width: 18px;
    height: 18px;
    padding: 0 4px;
    margin-left: 4px;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .logout-btn {
    padding: 8px 20px;
    border-radius: 20px;
    font-weight: 600;
    font-size: 15px;
    text-decoration: none;
    border: 1px solid #cb202d;
    color: #cb202d !important;
    transition: all 0.25s;
  }

  .logout-btn:hover {
    background: #cb202d;
    color: #fff !important;
  }

  /* ── Content Framework Architecture ── */
  .container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 24px 40px 60px;
  }

  .page-header h1 {
    font-size: 28px;
    font-weight: 800;
    color: #1c1c1c;
    margin-bottom: 8px;
    letter-spacing: -0.5px;
  }

  .page-header p {
    font-size: 14px;
    color: #696969;
    font-weight: 500;
    margin-bottom: 24px;
  }

  .page-header .restaurant-tag {
    font-size: 13px;
    color: #cb202d;
    font-weight: 700;
    background: #fff1f2;
    padding: 6px 14px;
    border-radius: 15px;
    display: inline-block;
    margin-top: 4px;
  }

  /* ── Twin Column Grid Framework ── */
  .cart-wrapper {
    display: grid;
    grid-template-columns: 1fr 380px;
    gap: 32px;
    align-items: start;
  }

  /* ── Left Column Elements: Items Panel ── */
  .items-panel {
    background: #fff;
    border-radius: 16px;
    padding: 24px;
    border: 1px solid #e8e8e8;
  }

  .cart-item-row {
    display: flex;
    align-items: center;
    gap: 20px;
    padding: 20px 0;
    border-bottom: 1px solid #f2f2f2;
    transition: opacity 0.3s ease, transform 0.3s ease;
  }

  .cart-item-row:last-child {
    border-bottom: none;
  }

  .item-img {
    width: 75px;
    height: 75px;
    background: #f8f8f8;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 28px;
    flex-shrink: 0;
    border: 1px solid #e8e8e8;
    overflow: hidden;
  }

  .item-img img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  .item-details {
    flex: 1;
    min-width: 0;
  }

  .item-details h3 {
    font-size: 17px;
    font-weight: 600;
    color: #1c1c1c;
    margin-bottom: 4px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .item-details .item-price {
    font-size: 14px;
    color: #696969;
    font-weight: 600;
  }

  /* Quantity Modification Control Panel */
  .qty-engine {
    display: flex;
    align-items: center;
    border: 1px solid #e8e8e8;
    border-radius: 8px;
    overflow: hidden;
    background: #fff;
    height: 32px;
    box-shadow: 0 2px 6px rgba(0,0,0,0.02);
  }

  .qty-btn {
    background: none;
    border: none;
    width: 32px;
    height: 100%;
    font-size: 16px;
    font-weight: bold;
    cursor: pointer;
    color: #267e3e; /* Success Green for standard incremental interactive states */
    transition: background 0.2s;
    display: inline-flex;
    align-items: center;
    justify-content: center;
  }

  .qty-btn:hover {
    background: #f8f8f8;
  }

  .qty-val {
    width: 36px;
    text-align: center;
    font-size: 14px;
    font-weight: 700;
    color: #cb202d;
  }

  .item-subtotal {
    font-size: 16px;
    font-weight: 700;
    color: #1c1c1c;
    min-width: 100px;
    text-align: right;
  }

  .remove-btn {
    border: none;
    background: none;
    color: #828282;
    cursor: pointer;
    padding: 6px;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: color .15s, transform .15s;
  }

  .remove-btn:hover { 
    color: #cb202d; 
    transform: scale(1.1);
  }

  /* ── Right Column Elements: Checkout Summary ── */
  .summary-card {
    background: #fff;
    border-radius: 16px;
    padding: 24px;
    border: 1px solid #e8e8e8;
    position: sticky;
    top: 92px;
  }

  .summary-card h2 {
    font-size: 18px;
    font-weight: 700;
    color: #1c1c1c;
    margin-bottom: 20px;
    padding-bottom: 10px;
    border-bottom: 2px solid #f2f2f2;
  }

  .summary-row {
    display: flex;
    justify-content: space-between;
    font-size: 14px;
    font-weight: 600;
    color: #4f4f4f;
    margin-bottom: 14px;
  }

  .summary-row.total {
    font-size: 18px;
    font-weight: 800;
    color: #1c1c1c;
    margin-top: 18px;
    padding-top: 14px;
    border-top: 1px dashed #e8e8e8;
    margin-bottom: 24px;
  }

  .addMoreBtn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 100%;
    padding: 12px;
    background: #fff;
    color: #267e3e;
    text-decoration: none;
    border-radius: 12px;
    font-weight: 700;
    font-size: 14px;
    border: 2px solid #267e3e;
    margin-bottom: 12px;
    transition: all .2s ease-in-out;
  }

  .addMoreBtn:hover {
    background: #f4fdf7;
    transform: translateY(-1px);
  }

  .checkout-btn {
    display: block;
    width: 100%;
    background: #cb202d;
    color: #fff;
    text-align: center;
    border: none;
    padding: 14px;
    border-radius: 12px;
    font-weight: 700;
    font-size: 15px;
    box-shadow: 0 4px 12px rgba(203, 32, 45, 0.2);
    cursor: pointer;
    transition: transform 0.2s, opacity 0.2s;
  }

  .checkout-btn:hover {
    transform: translateY(-1px);
    opacity: 0.95;
  }

  .clear-cart-link {
    display: block;
    text-align: center;
    margin-top: 16px;
    font-size: 13px;
    font-weight: 700;
    color: #828282;
    cursor: pointer;
    background: none;
    border: none;
    width: 100%;
    transition: color 0.2s;
  }

  .clear-cart-link:hover { color: #cb202d; }

  /* ── Fallback Utility Empty States ── */
  .empty-state {
    text-align: center;
    padding: 60px 24px;
    background: #fff;
    border-radius: 16px;
    border: 1px solid #e8e8e8;
  }

  .empty-state .icon {
    font-size: 64px;
    margin-bottom: 16px;
  }

  .empty-state h2 {
    font-size: 22px;
    font-weight: 700;
    color: #1c1c1c;
    margin-bottom: 8px;
  }

  .empty-state p {
    font-size: 14px;
    color: #696969;
    margin-bottom: 24px;
    font-weight: 500;
  }

  .shop-btn {
    display: inline-block;
    background: #cb202d;
    color: #fff;
    text-decoration: none;
    padding: 12px 28px;
    border-radius: 25px;
    font-weight: 700;
    font-size: 14px;
    box-shadow: 0 4px 12px rgba(203, 32, 45, 0.2);
    transition: background 0.2s;
  }

  .shop-btn:hover {
    background: #a81a25;
  }

  .removing {
    opacity: 0;
    transform: translateY(10px);
  }

  /* ── Modal Popover Architecture Styles ── */
  .modal-overlay {
    position: fixed;
    top: 0; left: 0; width: 100%; height: 100%;
    background: rgba(0, 0, 0, 0.5);
    backdrop-filter: blur(4px);
    display: none; 
    align-items: center; 
    justify-content: center; 
    z-index: 10000; /* Forcing display positioning safely above context layout modules */
  }
  .modal-window {
    background: #fff; border-radius: 24px; width: 90%; max-width: 440px;
    padding: 32px; box-shadow: 0 20px 50px rgba(0,0,0,0.15); position: relative;
  }
  .modal-close { position: absolute; top: 20px; right: 20px; background: none; border: none; font-size: 28px; color: #93959f; cursor: pointer; line-height: 1; }
  .modal-window h3 { font-size: 22px; font-weight: 800; color: #1a1a1a; margin-bottom: 24px; text-align: center; }
  .avatar-upload-area { display: flex; flex-direction: column; align-items: center; gap: 12px; margin-bottom: 24px; }
  .modal-avatar-preview { width: 90px; height: 90px; border-radius: 50%; background: #cb202d; color: #fff; display: flex; align-items: center; justify-content: center; font-size: 32px; font-weight: 800; overflow: hidden; box-shadow: 0 4px 12px rgba(203, 32, 45, 0.2); }
  .modal-avatar-preview img { width: 100%; height: 100%; object-fit: cover; }
  .upload-label { font-size: 13px; font-weight: 700; color: #cb202d; cursor: pointer; background: #fff1f2; padding: 6px 14px; border-radius: 15px; }
  .form-group { margin-bottom: 18px; }
  .form-group label { display: block; font-size: 13px; font-weight: 700; color: #3d4152; margin-bottom: 8px; }
  .form-group input { width: 100%; padding: 12px 16px; border: 2px solid #e1e1e1; border-radius: 12px; font-size: 14px; font-weight: 600; color: #3d4152; outline: none; }
  .form-group input:focus { border-color: #cb202d; }
  .form-group input:disabled { background: #f3f4f6; color: #93959f; cursor: not-allowed; }
  .save-profile-btn { width: 100%; padding: 14px; background: #cb202d; color: #fff; border: none; border-radius: 12px; font-size: 15px; font-weight: 700; cursor: pointer; box-shadow: 0 4px 12px rgba(203, 32, 45, 0.2); margin-top: 10px; }
  .alert-toast { position: fixed; bottom: 24px; right: 24px; background: #10b981; color: #fff; padding: 16px 24px; border-radius: 12px; box-shadow: 0 10px 25px rgba(16, 185, 129, 0.3); font-weight: 700; z-index: 2000; }

  /* ── Layout Breakpoint Breakout Matrices ── */
  @media (max-width: 950px) {
    .cart-wrapper {
      grid-template-columns: 1fr;
    }
    .navbar { padding: 0 5%; }
    .nav-links { gap: 15px; }
  }
</style>
</head>
<body>



<header>
  <nav class="navbar">
    <a href="restaurant" class="logo">FoodExpress</a>
    <ul class="nav-links">
      <li><a href="restaurant">Home</a></li>
      <li><a href="restaurant">Restaurants</a></li>
      
      <li>
        <button class="profile-trigger" id="openProfileModalBtn" type="button">
          <div class="avatar-circle">
            <% if(loggedUser != null && loggedUser.getProfileImage() != null && !loggedUser.getProfileImage().trim().isEmpty()) { %>
              <img src="<%=request.getContextPath()%>/<%=loggedUser.getProfileImage()%>" alt="Avatar">
            <% } else { %>
              <%= (loggedUser != null) ? loggedUser.getFullName().substring(0,1).toUpperCase() : "U" %>
            <% } %>
          </div>
          <span class="welcome-text">
               <strong><%= (loggedUser != null) ? loggedUser.getFullName().split(" ")[0] : "Guest" %></strong>
          </span>
        </button>
      </li>

      <li class="cart-link">
        <a href="cart?action=view">🛒 Cart
          <span class="cart-badge" style="display: <%= (cartCount > 0) ? "inline-flex" : "none" %>;">
            <%= cartCount %>
          </span>
        </a>
      </li>
      <li><a class="logout-btn" href="user?action=logout">Logout</a></li>
    </ul>
  </nav>
</header>

<div class="modal-overlay" id="profileModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 9999; align-items: center; justify-content: center;">
  <div class="modal-window" style="background: white; padding: 30px; border-radius: 12px; position: relative; max-width: 400px; width: 100%;">
    <button class="modal-close" id="closeProfileModalBtn" style="position: absolute; top: 10px; right: 15px; background: none; border: none; font-size: 24px; cursor: pointer;">&times;</button>
    <h3>Account Settings</h3>
    
    <% if(loggedUser != null) { %>
    <form action="user?action=updateProfile" method="post" enctype="multipart/form-data">
      <div class="avatar-upload-area">
        <div class="modal-avatar-preview">
          <% if(loggedUser.getProfileImage() != null && !loggedUser.getProfileImage().trim().isEmpty()) { %>
            <img src="<%=request.getContextPath()%>/<%=loggedUser.getProfileImage()%>" id="avatarPreviewImg" alt="Preview">
          <% } else { %>
            <span id="avatarLetter"><%=loggedUser.getFullName().substring(0,1).toUpperCase()%></span>
          <% } %>
        </div>
        <label for="profileImageInput" class="upload-label">Upload New Photo</label>
        <input type="file" id="profileImageInput" name="profileImage" accept="image/*" style="display:none;">
      </div>

      <div class="form-group">
        <label>System Privilege Group</label>
        <input type="text" value="<%=loggedUser.getRole()%>" disabled>
      </div>

      <div class="form-group">
        <label for="inputFullName">Full Name</label>
        <input type="text" id="inputFullName" name="fullName" value="<%=loggedUser.getFullName()%>" required minlength="3">
      </div>

      <div class="form-group">
        <label for="inputEmail">Email Address</label>
        <input type="email" id="inputEmail" name="email" value="<%=loggedUser.getEmail()%>" required>
      </div>

      <div class="form-group">
        <label for="inputPhone">Mobile Number</label>
        <input type="tel" id="inputPhone" name="phone" value="<%=loggedUser.getPhone() != null ? loggedUser.getPhone() : ""%>" maxlength="10" required>
      </div>

      <button type="submit" class="save-profile-btn">Save Changes</button>
    </form>
    <% } %>
  </div>
</div>

<div class="container">
  <div class="page-header">
    <h1>Your Selected Harvest</h1>
    <p>Review your selection items, optimize quantities, and proceed swiftly to a secure checkout experience.</p>
    <% if(restaurantName != null){ %>
    <span class="restaurant-tag">Items from <%=restaurantName%></span>
    <% } %>
  </div>

  <% if (cartItems != null && !cartItems.isEmpty()) { %>
    <div class="cart-wrapper">
      
      <div class="items-panel" id="cartItemsList">
        <% 
        for (Cart item : cartItems) { 
            double unitPrice = item.getQuantity() > 0
                ? item.getTotalPrice() / item.getQuantity()
                : item.getTotalPrice();
        %>
          <div class="cart-item-row" data-menu-id="<%=item.getMenuId()%>" data-unit-price="<%=unitPrice%>">
            <div class="item-img">
              <% if(item.getImage() != null && !item.getImage().trim().isEmpty()){ %>
                <img src="<%=request.getContextPath()%>/<%=item.getImage()%>" alt="<%=item.getMenuName()%>">
              <% } else { %>
                🍲
              <% } %>
            </div>
            
            <div class="item-details">
              <h3><%=item.getMenuName()%></h3>
              <div class="item-price">₹<%=String.format("%.2f", unitPrice)%> each</div>
            </div>
            
            <div class="qty-engine">
              <button class="qty-decrease" onclick="location.href='cart?action=minus&menuId=<%=item.getMenuId()%>'">−</button>
              <span class="qty-val"><%=item.getQuantity()%></span>
              <button class="qty-increase" onclick="location.href='cart?action=plus&menuId=<%=item.getMenuId()%>'">+</button>
            </div>
            
            <div class="item-subtotal">
              ₹<%=String.format("%.2f", item.getTotalPrice())%>
            </div>

            <button class="remove-btn" aria-label="Remove item" onclick="location.href='cart?action=remove&menuId=<%=item.getMenuId()%>'">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2m3 0-1 14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2L4 6"/>
              </svg>
            </button>
          </div>
        <% } %>
      </div>

      <div class="summary-card">
        <h2>Order Summary</h2>
        <div class="summary-row">
          <span>Subtotal</span>
          <span id="subtotalVal">₹<%=String.format("%.2f", cartTotal)%></span>
        </div>
        <div class="summary-row total">
          <span>Total</span>
          <span id="totalVal">₹<%=String.format("%.2f", cartTotal)%></span>
        </div>
        
        <% int restaurantId = cartItems.get(0).getRestaurantId(); %>
        <a href="menu?restaurantId=<%=restaurantId%>" class="addMoreBtn">
            ➕ Add More Items
        </a>
        
		<form action="checkout" method="GET">
    <button type="submit" class="checkout-btn" id="checkoutBtn" style="width:100%; cursor:pointer;">
        Proceed to Checkout
    </button>
</form>
        <a href="cart?action=clear" style="text-decoration: none; display: block; margin-top: 8px;">
            <button class="clear-cart-link" id="clearCartBtn" style="width:100%; cursor:pointer;">Clear cart</button>
        </a>
      </div>

    </div>
  <% } else { %>
    <div class="empty-state">
      <div class="icon">🛒</div>
      <h2>Your cart is currently empty</h2>
      <p>Looks like you haven't added anything to your cart yet. Let's find some delicious food options!</p>
      <a href="${pageContext.request.contextPath}/restaurant" class="shop-btn">
    See Nearby Restaurants
</a>
    </div>
  <% } %>
</div>


<script>
  function postCart(params, onSuccess){
    const body = new URLSearchParams(params);
    fetch('cart', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Requested-With': 'XMLHttpRequest'
      },
      body: body
    })
    .then(r => r.json())
    .then(data => {
      if(data.success){
        if(onSuccess) onSuccess(data);
      } else {
        alert(data.message || "An error occurred with your cart session.");
      }
    })
    .catch(err => console.error('Cart request failed:', err));
  }

  function setCartBadge(count){
    const badge = document.querySelector('.cart-badge');
    if(badge){
      if(count > 0){
        badge.textContent = count;
        badge.style.display = 'flex';
      } else {
        badge.style.display = 'none';
      }
    }
  }

  function recalcTotals(){
    let subtotal = 0;
    const items = document.querySelectorAll('.cart-item-row');
    
    items.forEach(row => {
      const unitPrice = parseFloat(row.dataset.unitPrice);
      const qty = parseInt(row.querySelector('.qty-val').textContent, 10);
      const lineTotal = unitPrice * qty;
      row.querySelector('.item-subtotal').textContent = '₹' + lineTotal.toFixed(2);
      subtotal += lineTotal;
    });

    const subtotalEl = document.getElementById('subtotalVal');
    const totalEl = document.getElementById('totalVal');
    if(subtotalEl) subtotalEl.textContent = '₹' + subtotal.toFixed(2);
    if(totalEl) totalEl.textContent = '₹' + subtotal.toFixed(2);

    if(items.length === 0){
      location.reload(); 
    }
  }

  document.querySelectorAll('.cart-item-row').forEach(row => {
    const menuId = row.dataset.menuId;
    const qtyEl = row.querySelector('.qty-val');
    const decreaseBtn = row.querySelector('.qty-decrease');
    const increaseBtn = row.querySelector('.qty-increase');
    const removeBtn = row.querySelector('.remove-btn');

    increaseBtn.addEventListener('click', () => {
      postCart({ action: 'plus', menuId: menuId }, (data) => {
        qtyEl.textContent = parseInt(qtyEl.textContent, 10) + 1;
        recalcTotals();
        setCartBadge(data.cartCount);
      });
    });

    decreaseBtn.addEventListener('click', () => {
      const newQty = parseInt(qtyEl.textContent, 10) - 1;
      const action = newQty <= 0 ? 'remove' : 'minus';

      postCart({ action: action, menuId: menuId }, (data) => {
        if(newQty <= 0){
          row.classList.add('removing');
          setTimeout(() => {
            row.remove();
            recalcTotals();
          }, 200);
        } else {
          qtyEl.textContent = newQty;
          recalcTotals();
        }
        setCartBadge(data.cartCount);
      });
    });

    removeBtn.addEventListener('click', () => {
      postCart({ action: 'remove', menuId: menuId }, (data) => {
        row.classList.add('removing');
        setTimeout(() => {
          row.remove();
          recalcTotals();
        }, 200);
        setCartBadge(data.cartCount);
      });
    });
  });

  const clearCartBtn = document.getElementById('clearCartBtn');
  if(clearCartBtn){
    clearCartBtn.addEventListener('click', () => {
      if(confirm("Are you sure you want to clear your cart?")) {
        postCart({ action: 'clear' }, () => location.reload());
      }
    });
  }

  const checkoutBtn = document.getElementById('checkoutBtn');
  if(checkoutBtn){
    checkoutBtn.addEventListener('click', () => {
      window.location = 'checkout';
    });
  }
  
  
  
  document.addEventListener("DOMContentLoaded", function() {
	    const openBtn = document.getElementById('openProfileModalBtn');
	    const closeBtn = document.getElementById('closeProfileModalBtn');
	    const modal = document.getElementById('profileModal');
	    const profileImageInput = document.getElementById('profileImageInput');
	    const avatarPreviewImg = document.getElementById('avatarPreviewImg');
	    const avatarLetter = document.getElementById('avatarLetter');

	    // Display/Hide Modal Toggles
	    if (openBtn && modal) {
	        openBtn.addEventListener('click', function(e) {
	            e.preventDefault();
	            modal.style.display = 'flex';
	        });
	    }

	    if (closeBtn && modal) {
	        closeBtn.addEventListener('click', function() {
	            modal.style.display = 'none';
	        });
	    }

	    window.addEventListener('click', function(e) {
	        if (e.target === modal) {
	            modal.style.display = 'none';
	        }
	    });

	    // Real-time Image Upload File Reader Rendering Code
	    if(profileImageInput) {
	        profileImageInput.addEventListener('change', function() {
	            const file = this.files[0];
	            if(file) {
	                const reader = new FileReader();
	                reader.onload = function(e) {
	                    if(avatarPreviewImg) {
	                        avatarPreviewImg.src = e.target.result;
	                    } else if(avatarLetter) {
	                        const newImg = document.createElement('img');
	                        newImg.id = 'avatarPreviewImg';
	                        newImg.src = e.target.result;
	                        avatarLetter.parentNode.replaceChild(newImg, avatarLetter);
	                    }
	                }
	                reader.readAsDataURL(file);
	            }
	        });
	    }
	});
</script>

</body>
</html>