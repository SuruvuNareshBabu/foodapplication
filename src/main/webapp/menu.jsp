<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.LinkedHashMap"%>
<%@ page import="model.Menu"%>
<%@ page import="model.Restaurant"%>
<%@ page import="model.User"%>

<%
String cartError = (String)session.getAttribute("cartError");
%>

<%
User loggedUser = (User)session.getAttribute("loggedUser");
if(loggedUser == null){
    response.sendRedirect("login.jsp");
    return;
}

Restaurant restaurant = (Restaurant)request.getAttribute("restaurant");
List<Menu> menuItems = (List<Menu>)request.getAttribute("menuItems");

if(restaurant == null){
    response.sendRedirect("restaurant");
    return;
}

@SuppressWarnings("unchecked")
Map<Integer, Integer> cartQuantities = (Map<Integer, Integer>) request.getAttribute("cartQuantities");
if(cartQuantities == null){
    cartQuantities = new java.util.HashMap<>();
}

LinkedHashMap<String, List<Menu>> grouped = new LinkedHashMap<>();
if(menuItems != null){
    for(Menu item : menuItems){
        String cat = item.getCategory() != null ? item.getCategory() : "Other";
        grouped.computeIfAbsent(cat, k -> new java.util.ArrayList<>()).add(item);
    }
}

Object cartCountAttr = request.getAttribute("cartCount");
int initialCartCount = 0;
if (cartCountAttr != null) {
    try {
        initialCartCount = Integer.parseInt(cartCountAttr.toString());
    } catch(NumberFormatException e) {
        initialCartCount = 0;
    }
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%= restaurant.getName() %> | FoodExpress</title>
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
    background: #fff;
    color: #1c1c1c;
    min-height: 100vh;
    padding-top: 92px; 
    overflow-x: hidden;
  }

  /* ── Corporate Navigation System ── */
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
    color: #cb202d; 
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
    gap: 6px;
  }

  .nav-links a:hover {
    color: #cb202d;
  }

  /* ── Clean Fixed Interactive Profile Trigger ── */
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
    background: #ff5722;
    color: #fff;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-weight: 700;
    font-size: 13px;
    overflow: hidden;
    box-shadow: 0 2px 6px rgba(255, 87, 34, 0.2);
  }

  .avatar-circle img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  .welcome-text {
    font-weight: 500;
  }

  /* ── Dynamic Cart Badge Pill ── */
  #cartCount {
    display: <%= initialCartCount > 0 ? "inline-flex" : "none" %>;
    justify-content: center;
    align-items: center;
    background: #cb202d;
    color: white;
    font-size: 11px;
    font-weight: 700;
    border-radius: 50%;
    min-width: 18px;
    height: 18px;
    padding: 0 4px;
    margin-left: 4px;
    transition: transform 0.2s cubic-bezier(0.175, 0.885, 0.32, 1.275);
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

  /* ── System Alerts Banner ── */
  .errorMsg {
    max-width: 850px;
    margin: 15px auto;
    background: #fff5f5;
    border-left: 4px solid #ef4444;
    color: #b91c1c;
    padding: 12px 16px;
    border-radius: 6px;
    font-size: 14px;
    font-weight: 600;
  }

  /* ── Navigation Breadcrumb Row ── */
  .back-bar {
    max-width: 850px;
    margin: 24px auto 0;
    padding: 0 20px;
  }

  .back-link {
    text-decoration: none;
    color: #696969;
    font-size: 14px;
    font-weight: 600;
    display: inline-flex;
    align-items: center;
    gap: 4px;
    transition: color 0.2s;
  }

  .back-link:hover { color: #cb202d; }

  /* ── Restaurant Showcase Header ── */
  .restaurant-header {
    max-width: 850px;
    margin: 15px auto 25px;
    padding: 0 20px;
  }

  .header-card {
    border-bottom: 1px dashed #e8e8e8;
    padding-bottom: 25px;
  }

  .header-card h1 {
    font-size: 36px;
    font-weight: 800;
    color: #1c1c1c;
    letter-spacing: -0.5px;
    margin-bottom: 6px;
  }

  .header-card .desc {
    font-size: 15px;
    color: #696969;
    margin-bottom: 12px;
  }

  .header-meta {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 14px;
    font-weight: 700;
    color: #4f4f4f;
    margin-bottom: 8px;
  }

  .rating-pill {
    background: #267e3e; 
    color: white;
    padding: 2px 6px;
    border-radius: 4px;
    font-size: 12px;
    font-weight: 700;
  }

  .rating-pill.low { background: #db7c38; }
  .header-meta .sep { color: #ccc; margin: 0 4px; }

  .header-address {
    font-size: 13.5px;
    color: #828282;
  }

  /* ── Predictive Input Search Bar ── */
  .menu-search-bar {
    max-width: 850px;
    margin: 0 auto 20px;
    padding: 0 20px;
  }

  .search-wrap {
    position: relative;
    display: flex;
    align-items: center;
    background: #fff;
    border: 1px solid #e8e8e8;
    border-radius: 10px;
    padding: 0 16px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.02);
  }

  .search-wrap svg { color: #828282; margin-right: 12px; }

  .search-wrap input {
    width: 100%;
    height: 46px;
    border: none;
    background: transparent;
    outline: none;
    font-size: 14.5px;
    color: #1c1c1c;
  }

  /* ── Premium Sticky Navigation Chips ── */
  .category-chips {
    max-width: 850px;
    margin: 0 auto 30px;
    padding: 0 20px;
    display: flex;
    gap: 10px;
    overflow-x: auto;
    white-space: nowrap;
  }

  .category-chips::-webkit-scrollbar { display: none; }

  .chip {
    padding: 8px 16px;
    background: #fff;
    border: 1px solid #e8e8e8;
    border-radius: 20px;
    font-size: 14px;
    font-weight: 600;
    color: #4f4f4f;
    cursor: pointer;
    transition: all 0.2s;
  }

  .chip:hover { background: #f8f8f8; color: #1c1c1c; }

  .chip.active {
    background: #fff1f2;
    border-color: #cb202d;
    color: #cb202d;
  }

  /* ── Structural Menu Display Architecture ── */
  .menu-container {
    max-width: 850px;
    margin: 0 auto 80px;
    padding: 0 20px;
  }

  .menu-section {
    margin-bottom: 35px;
  }

  .menu-section h2 {
    font-size: 22px;
    font-weight: 700;
    color: #1c1c1c;
    margin-bottom: 18px;
    border-left: 4px solid #cb202d;
    padding-left: 10px;
  }

  .menu-grid {
    display: flex;
    flex-direction: column;
    gap: 16px;
  }

  /* ── Clean White Food Cards ── */
  .menu-item {
    background: #fff;
    border-radius: 12px;
    border: 1px solid #e8e8e8;
    padding: 20px;
    display: flex;
    justify-content: space-between;
    gap: 30px;
    transition: box-shadow 0.25s;
  }

  .menu-item:hover {
    box-shadow: 0 4px 15px rgba(0,0,0,0.05);
  }

  .menu-item.hidden-by-filter { display: none !important; }

  .item-info { flex: 1; min-width: 0; }
  
  .item-title-wrapper {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 4px;
  }

  .item-info h3 {
    font-size: 18px;
    font-weight: 600;
    color: #1c1c1c;
  }
  
  /* ── Pure Veg / Non-Veg Badges ── */
  .food-type-icon {
    width: 14px;
    height: 14px;
    border: 1.5px solid #267e3e; 
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
    border-radius: 2px;
    background: #fff;
  }
  .food-type-icon::after {
    content: '';
    width: 6px;
    height: 6px;
    background: #267e3e;
    border-radius: 50%;
  }
  .food-type-icon.non-veg {
    border-color: #cb202d; 
  }
  .food-type-icon.non-veg::after {
    background: #cb202d;
    border-radius: 0;
  }

  .item-price {
    font-size: 16px;
    font-weight: 700;
    color: #1c1c1c;
    margin-bottom: 8px;
  }

  .item-desc {
    font-size: 13.5px;
    color: #696969;
    line-height: 1.4;
  }

  /* ── Interactive Image Frame Wrappers ── */
  .item-img-wrap {
    position: relative;
    width: 120px;
    height: 120px;
    flex-shrink: 0;
  }

  .item-img-wrap img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    border-radius: 12px;
    border: 1px solid #f2f2f2;
  }

  .no-img-placeholder {
    width: 100%;
    height: 100%;
    background: #f8f8f8;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 32px;
    color: #d4d5d9;
    border: 1px solid #e8e8e8;
  }

  /* ── Floating Interactive Overlay Controls ── */
  .cart-control {
    position: absolute;
    bottom: -10px;
    left: 50%;
    transform: translateX(-50%);
    width: 90px;
    height: 34px;
    z-index: 10;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  
  .add-btn, .qty-control {
    width: 100%;
    height: 100%;
    background: #fff;
    border: 1px solid #e8e8e8;
    border-radius: 6px;
    box-shadow: 0 3px 8px rgba(0,0,0,0.08);
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .add-btn {
    color: #267e3e;
    font-weight: 700;
    font-size: 13px;
    cursor: pointer;
    letter-spacing: 0.5px;
    transition: all 0.2s ease;
  }
  .add-btn:hover { background: #fcfcfc; border-color: #267e3e; }

  .qty-control {
    justify-content: space-between;
    padding: 0 8px;
    border-color: #e8e8e8;
  }

  .qty-control button {
    background: none;
    border: none;
    color: #1c1c1c;
    font-size: 16px;
    font-weight: 700;
    cursor: pointer;
    width: 20px;
    height: 100%;
    display: inline-flex;
    align-items: center;
    justify-content: center;
  }
  .qty-control button:hover { color: #cb202d; }

  .qty {
    font-size: 13.5px;
    font-weight: 700;
    color: #cb202d;
    min-width: 20px;
    text-align: center;
  }

  /* ── Fallback Terminal Layout States ── */
  .empty-state {
    text-align: center;
    padding: 50px 20px;
    background: #fff;
    border-radius: 12px;
    border: 1px solid #e8e8e8;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 8px;
    margin-top: 20px;
  }
  .empty-state h2 { font-size: 18px; color: #1c1c1c; font-weight: 600; }
  .empty-state p { color: #696969; font-size: 14px; }

  /* ── Modal Popover Architecture Styles ── */
  .modal-overlay {
    position: fixed;
    top: 0; left: 0; width: 100%; height: 100%;
    background: rgba(0, 0, 0, 0.5);
    backdrop-filter: blur(4px);
    display: none; 
    align-items: center; 
    justify-content: center; 
    z-index: 10000; /* Set above fixed header */
  }
  .modal-window {
    background: #fff; border-radius: 24px; width: 90%; max-width: 440px;
    padding: 32px; box-shadow: 0 20px 50px rgba(0,0,0,0.15); position: relative;
  }
  .modal-close { position: absolute; top: 20px; right: 20px; background: none; border: none; font-size: 28px; color: #93959f; cursor: pointer; line-height: 1; }
  .modal-window h3 { font-size: 22px; font-weight: 800; color: #1a1a1a; margin-bottom: 24px; text-align: center; }
  .avatar-upload-area { display: flex; flex-direction: column; align-items: center; gap: 12px; margin-bottom: 24px; }
  .modal-avatar-preview { width: 90px; height: 90px; border-radius: 50%; background: #ff5722; color: #fff; display: flex; align-items: center; justify-content: center; font-size: 32px; font-weight: 800; overflow: hidden; box-shadow: 0 4px 12px rgba(255, 87, 34, 0.2); }
  .modal-avatar-preview img { width: 100%; height: 100%; object-fit: cover; }
  .upload-label { font-size: 13px; font-weight: 700; color: #ff5722; cursor: pointer; background: #fff5f2; padding: 6px 14px; border-radius: 15px; }
  .form-group { margin-bottom: 18px; }
  .form-group label { display: block; font-size: 13px; font-weight: 700; color: #3d4152; margin-bottom: 8px; }
  .form-group input { width: 100%; padding: 12px 16px; border: 2px solid #e1e1e1; border-radius: 12px; font-size: 14px; font-weight: 600; color: #3d4152; outline: none; }
  .form-group input:focus { border-color: #ff5722; }
  .form-group input:disabled { background: #f3f4f6; color: #93959f; cursor: not-allowed; }
  .save-profile-btn { width: 100%; padding: 14px; background: linear-gradient(to right, #ff5722, #ff9800); color: #fff; border: none; border-radius: 12px; font-size: 15px; font-weight: 700; cursor: pointer; box-shadow: 0 4px 12px rgba(255, 87, 34, 0.2); margin-top: 10px; }
  .alert-toast { position: fixed; bottom: 24px; right: 24px; background: #10b981; color: #fff; padding: 16px 24px; border-radius: 12px; box-shadow: 0 10px 25px rgba(16, 185, 129, 0.3); font-weight: 700; z-index: 2000; }

  /* ── Layout Breakpoint Matrices ── */
  @media(max-width: 768px) {
    .navbar { padding: 0 5%; }
    .back-bar, .restaurant-header, .menu-search-bar, .category-chips, .menu-container { padding-left: 5%; padding-right: 5%; }
    .menu-item { gap: 15px; padding: 15px; }
    .item-img-wrap { width: 100px; height: 100px; }
    .nav-links { gap: 15px; }
  }
</style>
</head>
<body>
<header>
    <nav class="navbar">
        <a href="index.jsp" class="logo">FoodExpress</a>
        <ul class="nav-links">
            <li><a href="index.jsp">Home</a></li>
            <li><a href="restaurant">Restaurants</a></li>
            <li>
                <a href="cart?action=view">
                    🛒 Cart
                    <span id="cartCount"><%= initialCartCount %></span>
                </a>
            </li>
            <li><a href="orders?action=history">My Orders</a></li>
            
            <li>
                <button class="profile-trigger" id="openProfileModalBtn" type="button">
                    <div class="avatar-circle">
                        <% if(loggedUser != null && loggedUser.getProfileImage() != null && !loggedUser.getProfileImage().trim().isEmpty()) { %>
                            <img src="<%=request.getContextPath()%>/<%=loggedUser.getProfileImage()%>" alt="Avatar">
                        <% } else { %>
                            <%= (loggedUser != null) ? loggedUser.getFullName().substring(0,1).toUpperCase() : "U" %>
                        <% } %>
                    </div>
                    <span class="welcome-text"> <strong><%= (loggedUser != null) ? loggedUser.getFullName().split(" ")[0] : "Guest" %></strong></span>
                </button>
            </li>
            
            <li><a class="logout-btn" href="user?action=logout">Logout</a></li>
        </ul>
    </nav>
</header>

<div class="modal-overlay" id="profileModal">
  <div class="modal-window">
    <button class="modal-close" id="closeProfileModalBtn">&times;</button>
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




<% if(cartError != null){ %>
<div class="errorMsg">
    <%=cartError%>
</div>
<% session.removeAttribute("cartError"); } %>

<div class="back-bar">
  <a class="back-link" href="restaurant">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
      <polyline points="15 18 9 12 15 6"></polyline>
    </svg>
    Back to Restaurants
  </a>
</div>

<div class="restaurant-header">
  <div class="header-card">
    <div>
      <h1><%=restaurant.getName()%></h1>
      <p class="desc"><%= restaurant.getDescription()!=null ? restaurant.getDescription() : "No description available" %></p>
      <div class="header-meta">
        <span class="rating-pill <%=restaurant.getRating() < 3.5 ? "low" : ""%>">★ <%=restaurant.getRating()%></span>
        <span class="sep">•</span>
        <span><%=restaurant.getDeliveryTime()%> mins delivery</span>
      </div>
      <p class="header-address"><%=restaurant.getAddress()%>, <%=restaurant.getCity()%></p>
    </div>
  </div>
</div>

<div class="menu-search-bar">
  <div class="search-wrap">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
      <circle cx="11" cy="11" r="7"></circle>
      <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
    </svg>
    <input type="text" id="menuSearch" placeholder="Search dishes">
  </div>
</div>

<% if(!grouped.isEmpty()){ %>
<div class="category-chips" id="categoryChips">
  <span class="chip active" data-category="all">All</span>
  <% for(String cat : grouped.keySet()){ %>
  <span class="chip" data-category="<%=cat%>"><%=cat%></span>
  <% } %>
</div>
<% } %>

<div class="menu-container" id="menuContainer">
<%
if(!grouped.isEmpty()){
    for(String cat : grouped.keySet()){
        List<Menu> items = grouped.get(cat);
%>
<div class="menu-section" data-category-section="<%=cat%>">
  <h2><%=cat%></h2>
  <div class="menu-grid">
  <%
  for(Menu item : items){
      Integer qtyInCart = cartQuantities.get(item.getMenuId());
      boolean inCart = qtyInCart != null && qtyInCart > 0;
      
      boolean isNonVeg = false;
      String lowerName = item.getName().toLowerCase();
      if(lowerName.contains("chicken") || lowerName.contains("mutton") || lowerName.contains("egg") || lowerName.contains("fish") || lowerName.contains("meat")) {
          isNonVeg = true;
      }
  %>
  <div class="menu-item" data-name="<%=item.getName().toLowerCase()%>" data-desc="<%=item.getDescription() != null ? item.getDescription().toLowerCase() : ""%>">
    <div class="item-info">
      <div class="item-title-wrapper">
        <span class="food-type-icon <%= isNonVeg ? "non-veg" : "" %>"></span>
        <h3><%=item.getName()%></h3>
      </div>
      <div class="item-price">₹<%=String.format("%.2f", item.getPrice())%></div>
      <p class="item-desc"><%=item.getDescription() != null ? item.getDescription() : ""%></p>
    </div>
    <div class="item-img-wrap">
      <% if(item.getImage()!=null && !item.getImage().trim().isEmpty()){ %>
      <img src="<%=request.getContextPath()%>/<%=item.getImage()%>" alt="<%=item.getName()%>" loading="lazy">
      <% } else { %>
      <div class="no-img-placeholder">🍽️</div>
      <% } %>
      <div class="cart-control">
        <button class="add-btn" style="<%=inCart ? "display:none;" : ""%>" data-menu-id="<%=item.getMenuId()%>" data-menu-name="<%=item.getName()%>" data-price="<%=item.getPrice()%>">ADD</button>
        <div class="qty-control" style="<%=inCart ? "display:flex;" : "display:none;"%>">
            <button class="minus">−</button>
            <span class="qty"><%=inCart ? qtyInCart : 1%></span>
            <button class="plus">+</button>
        </div>
      </div>
    </div>
  </div>
  <% } %>
  </div>
</div>
<%
    }
} else {
%>
<div class="empty-state">
  <svg width="60" height="60" viewBox="0 0 24 24" fill="none" stroke="#cb202d" stroke-width="1.5">
    <path d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-1.5 7h13L17 13"/>
  </svg>
  <h2>No menu items available</h2>
  <p>This restaurant hasn't added any dishes yet.</p>
</div>
<% } %>
</div>

<div class="empty-state" id="noMatchState" style="display:none;">
  <svg width="60" height="60" viewBox="0 0 24 24" fill="none" stroke="#828282" stroke-width="1.5">
    <circle cx="11" cy="11" r="7"></circle>
    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
  </svg>
  <h2>No dishes found</h2>
  <p>Try a different search term.</p>
</div>

<script>
const RESTAURANT_ID = <%=restaurant.getRestaurantId()%>;
const menuSearch = document.getElementById('menuSearch');
const menuContainer = document.getElementById('menuContainer');
const noMatchState = document.getElementById('noMatchState');
const sections = Array.from(document.querySelectorAll('.menu-section'));
const chips = document.querySelectorAll('.chip');

let activeCategory = 'all';

function applyFilters(){
    const term = menuSearch.value.trim().toLowerCase();
    let anyVisible = false;

    sections.forEach(section=>{
        const sectionCategory = section.dataset.categorySection;
        const categoryMatches = activeCategory === 'all' || sectionCategory === activeCategory;
        let sectionHasVisible = false;

        section.querySelectorAll('.menu-item').forEach(item=>{
            const haystack = (item.dataset.name || '') + ' ' + (item.dataset.desc || '');
            const searchMatches = term === '' || haystack.includes(term);
            const visible = categoryMatches && searchMatches;

            item.classList.toggle('hidden-by-filter', !visible);
            if(visible){
                sectionHasVisible = true;
                anyVisible = true;
            }
        });
        section.style.display = sectionHasVisible ? 'block' : 'none';
    });

    noMatchState.style.display = anyVisible ? 'none' : 'block';
    menuContainer.style.display = anyVisible ? 'block' : 'none';
}

if(menuSearch) {
    menuSearch.addEventListener('input', applyFilters);
}

chips.forEach(chip=>{
    chip.addEventListener('click',()=>{
        chips.forEach(c=> c.classList.remove('active'));
        chip.classList.add('active');
        activeCategory = chip.dataset.category;
        applyFilters();
    });
});

function setCartCount(count){
    const badge = document.getElementById('cartCount');
    if(badge) {
        badge.innerText = count;
        badge.style.display = count > 0 ? 'inline-flex' : 'none';
    }
}

document.querySelectorAll('.cart-control').forEach(control => {
    const addBtn = control.querySelector('.add-btn');
    const qtyBox = control.querySelector('.qty-control');
    const plusBtn = control.querySelector('.plus');
    const minusBtn = control.querySelector('.minus');
    const qtyText = control.querySelector('.qty');

    const menuId = addBtn.dataset.menuId;
    const price = addBtn.dataset.price;

    function callCart(action, extraParams){
        const params = extraParams ? extraParams : '';
        return fetch('cart?action=' + action + '&menuId=' + menuId + params, {
            headers: { 'X-Requested-With': 'XMLHttpRequest' }
        }).then(res => res.json());
    }

    addBtn.addEventListener('click', (e) => {
        e.preventDefault();
        callCart('add', '&restaurantId=' + RESTAURANT_ID + '&totalPrice=' + price)
            .then(data => {
                if(data.success){
                    addBtn.style.display = 'none';
                    qtyBox.style.setProperty('display', 'flex', 'important'); 
                    qtyText.innerText = '1';
                    setCartCount(data.cartCount);
                } else {
                    alert(data.message || "Could not add item to cart.");
                }
            })
            .catch(err => console.error(err));
    });

    plusBtn.addEventListener('click', (e) => {
        e.preventDefault();
        callCart('plus')
            .then(data => {
                if(data.success){
                    qtyText.innerText = parseInt(qtyText.innerText, 10) + 1;
                    setCartCount(data.cartCount);
                } else {
                    alert(data.message || "Failed to update quantity.");
                }
            })
            .catch(err => console.error(err));
    });

    minusBtn.addEventListener('click', (e) => {
        e.preventDefault();
        const currentQty = parseInt(qtyText.innerText, 10);
        const newQty = currentQty - 1;
        const action = newQty <= 0 ? 'remove' : 'minus';

        callCart(action)
            .then(data => {
                if(data.success){
                    if(newQty <= 0){
                        qtyBox.style.setProperty('display', 'none', 'important');
                        addBtn.style.setProperty('display', 'inline-flex', 'important');
                    } else {
                        qtyText.innerText = newQty;
                    }
                    setCartCount(data.cartCount);
                } else {
                    alert(data.message || "Failed to update quantity.");
                }
            })
            .catch(err => console.error(err));
    });
});


document.addEventListener("DOMContentLoaded", function() {
    const openBtn = document.getElementById('openProfileModalBtn');
    const closeBtn = document.getElementById('closeProfileModalBtn');
    const modal = document.getElementById('profileModal');

    if (openBtn && modal) {
        openBtn.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation(); // Stops event bubbling issues
            modal.style.display = 'flex';
        });
    }

    if (closeBtn && modal) {
        closeBtn.addEventListener('click', function() {
            modal.style.display = 'none';
        });
    }

    window.addEventListener('click', function(e) {
        if (modal && e.target === modal) {
            modal.style.display = 'none';
        }
    });
});
</script>
</body>
</html>