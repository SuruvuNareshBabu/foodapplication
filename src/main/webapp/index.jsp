<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="model.Restaurant"%>
<%@ page import="model.User"%>

<%
User loggedUser = (User)session.getAttribute("loggedUser");
Object cartCountAttr = session.getAttribute("cartCount");
int cartCount = cartCountAttr != null ? (Integer)cartCountAttr : 0;
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FoodExpress | Discover the best food & drinks</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
  * {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
  }

  body {
    background: #fff;
    color: #1c1c1c;
    overflow-x: hidden;
  }

  /* ── 1. Sticky Navigation System ── */
  header {
    position: absolute;
    top: 0;
    width: 100%;
    z-index: 1000;
    transition: background 0.3s, box-shadow 0.3s;
  }

  header.sticky {
    position: fixed;
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(20px);
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
    border-bottom: 1px solid #f2f2f2;
  }

  header.sticky .logo {
    color: #cb202d; /* Zomato Corporate Red */
    background: none;
    -webkit-text-fill-color: initial;
  }

  header.sticky .menu-links a {
    color: #333;
  }

  header.sticky .menu-links .auth-btn.login {
    border-color: #cb202d;
    color: #cb202d;
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
    color: #fff;
    letter-spacing: -1px;
    transition: color 0.3s;
  }

  .menu-links {
    display: flex;
    gap: 30px;
    align-items: center;
  }

  .menu-links a {
    text-decoration: none;
    font-weight: 500;
    font-size: 16px;
    color: #fff;
    transition: color 0.25s;
  }

  .menu-links a:hover {
    color: #ffcbd1;
  }

  header.sticky .menu-links a:hover {
    color: #cb202d;
  }

  .menu-links .welcome-user {
    font-size: 15px;
    font-weight: 500;
    color: #fff;
  }
  header.sticky .welcome-user {
    color: #1c1c1c;
  }

  .cart-pill {
    padding: 8px 18px;
    background: #cb202d;
    color: white !important;
    border-radius: 20px;
    font-weight: 600;
    font-size: 14px;
    display: flex;
    align-items: center;
    gap: 6px;
    box-shadow: 0 4px 12px rgba(203,32,45,0.25);
  }

  .cart-badge {
    background: #fff;
    color: #cb202d;
    border-radius: 50%;
    width: 18px;
    height: 18px;
    font-size: 11px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-weight: 700;
  }

  .auth-btn {
    padding: 8px 20px;
    border-radius: 20px;
    font-weight: 600;
    font-size: 15px;
    transition: all 0.25s;
  }

  .auth-btn.login {
    border: 1px solid #fff;
    color: #fff;
  }

  .auth-btn.register {
    background: #cb202d;
    color: #fff !important;
  }

  /* ── 2. Immersive Zomato Hero Section ── */
  .hero-container {
    position: relative;
    height: 520px;
    background: url('https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=1600&auto=format&fit=crop') center/cover no-repeat;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    text-align: center;
    padding: 0 20px;
  }

  /* Dark Overlay tint matching landing pages */
  .hero-container::before {
    content: '';
    position: absolute;
    top: 0; left: 0; width: 100%; height: 100%;
    background: rgba(0, 0, 0, 0.5);
    z-index: 1;
  }

  .hero-content {
    position: relative;
    z-index: 2;
    max-width: 800px;
    width: 100%;
  }

  .hero-title {
    font-size: 60px;
    font-weight: 800;
    color: #fff;
    margin-bottom: 10px;
    letter-spacing: -1px;
  }

  .hero-subtitle {
    font-size: 32px;
    color: #fff;
    font-weight: 400;
    margin-bottom: 30px;
  }

  /* Dual Input Search Matrix Container */
  .search-matrix {
    background: #fff;
    height: 54px;
    border-radius: 10px;
    display: flex;
    align-items: center;
    box-shadow: 0 8px 20px rgba(0,0,0,0.15);
    padding: 0 10px;
    width: 100%;
  }

  .location-box {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 0 14px;
    width: 30%;
    color: #828282;
    font-size: 14px;
    border-right: 1px solid #e0e0e0;
  }

  .location-box input {
    border: none;
    outline: none;
    width: 100%;
    color: #1c1c1c;
    font-weight: 500;
  }

  .main-search-box {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 0 15px;
    width: 70%;
    color: #828282;
  }

  .main-search-box input {
    border: none;
    outline: none;
    width: 100%;
    font-size: 14px;
    color: #1c1c1c;
  }

  .search-action-btn {
    background: #cb202d;
    color: #fff;
    border: none;
    padding: 10px 24px;
    border-radius: 6px;
    font-weight: 600;
    font-size: 14px;
    cursor: pointer;
    transition: background 0.2s;
  }

  .search-action-btn:hover { background: #b01b26; }

  /* ── 3. High-Fidelity Option Card Grids ── */
  .section-wrap {
    max-width: 1100px;
    margin: 40px auto;
    padding: 0 20px;
  }

  .option-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
    margin-top: 20px;
  }

  .option-card {
    background: #fff;
    border-radius: 12px;
    overflow: hidden;
    border: 1px solid #e8e8e8;
    cursor: pointer;
    text-decoration: none;
    color: inherit;
    transition: transform 0.25s, box-shadow 0.25s;
  }

  .option-card:hover {
    transform: scale(1.02);
    box-shadow: 0 4px 15px rgba(0,0,0,0.08);
  }

  .option-img {
    height: 160px;
    width: 100%;
    object-fit: cover;
  }

  .option-info {
    padding: 14px;
  }

  .option-info h3 {
    font-size: 18px;
    font-weight: 600;
    color: #1c1c1c;
    margin-bottom: 4px;
  }

  .option-info p {
    font-size: 14px;
    color: #4f4f4f;
  }

  /* ── 4. Premium Curated Collections Framework ── */
  .collection-head h2 {
    font-size: 28px;
    font-weight: 600;
  }

  .collection-head p {
    font-size: 16px;
    color: #4f4f4f;
    margin-top: 4px;
  }

  .collection-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 15px;
    margin-top: 24px;
  }

  .collection-card {
    position: relative;
    height: 320px;
    border-radius: 6px;
    overflow: hidden;
    cursor: pointer;
  }

  .collection-card img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  .collection-overlay {
    position: absolute;
    bottom: 0; left: 0; width: 100%; height: 100%;
    background: linear-gradient(to top, rgba(0,0,0,0.85) 0%, rgba(0,0,0,0) 50%);
    display: flex;
    flex-direction: column;
    justify-content: flex-end;
    padding: 16px;
    color: #fff;
  }

  .collection-overlay h4 {
    font-size: 16px;
    font-weight: 600;
  }

  .collection-overlay span {
    font-size: 13px;
    color: #eee;
    margin-top: 2px;
  }

  /* ── 5. Enterprise Zomato Minimalist Footer ── */
  footer {
    background: #f8f8f8;
    padding: 60px 10% 40px;
    border-top: 1px solid #e8e8e8;
    margin-top: 80px;
  }

  .footer-top {
    max-width: 1100px;
    margin: 0 auto 40px;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .footer-top .f-logo {
    font-size: 30px;
    font-weight: 800;
    color: #000;
    text-decoration: none;
  }

  .footer-links-grid {
    max-width: 1100px;
    margin: 0 auto;
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 30px;
    padding-bottom: 40px;
    border-bottom: 1px solid #dfdfdf;
  }

  .f-col h4 {
    font-size: 14px;
    font-weight: 600;
    letter-spacing: 1px;
    text-transform: uppercase;
    margin-bottom: 15px;
    color: #1c1c1c;
  }

  .f-col ul { list-style: none; }
  .f-col ul li { margin-bottom: 10px; }
  .f-col ul li a { text-decoration: none; color: #696969; font-size: 14px; transition: color 0.2s; }
  .f-col ul li a:hover { color: #1c1c1c; }

  .footer-legal {
    max-width: 1100px;
    margin: 24px auto 0;
    font-size: 13px;
    color: #828282;
    line-height: 20px;
  }

  /* ── Responsive Architecture ── */
  @media (max-width: 991px) {
    .option-grid { grid-template-columns: 1fr; }
    .collection-grid { grid-template-columns: repeat(2, 1fr); }
    .footer-links-grid { grid-template-columns: repeat(2, 1fr); }
    .location-box { display: none; }
    .main-search-box { width: 100%; }
    .hero-title { font-size: 42px; }
    .hero-subtitle { font-size: 22px; }
  }
</style>
</head>
<body>

<header id="mainHeader">
  <nav class="navbar">
    <a href="index.jsp" class="logo">FoodExpress</a>
    <div class="menu-links">
      <a href="restaurant">Investor Relations</a>
      <a href="restaurant">Restaurant</a>
      
      <% if (loggedUser != null) { %>
        <span class="welcome-user">👋 Welcome, <strong><%= loggedUser.getFullName() %></strong></span>
        <a href="cart?action=view" class="cart-pill">
          🛒 Cart <% if(cartCount > 0) { %><span class="cart-badge"><%=cartCount%></span><% } %>
        </a>
        <a href="user?action=logout" class="auth-btn register">Logout</a>
      <% } else { %>
        <a href="login.jsp" class="auth-btn login">Log in</a>
        <a href="register.jsp" class="auth-btn register">Sign up</a>
      <% } %>
    </div>
  </nav>
</header>

<section class="hero-container">
  <div class="hero-content">
    <h1 class="hero-title">FoodExpress</h1>
    <h2 class="hero-subtitle">Discover the best food & drinks near you</h2>
    
    <div class="search-matrix">
      <div class="location-box">
        <span>📍</span>
        <input type="text" value="Bengaluru, Karnataka" placeholder="Location...">
      </div>
      <div class="main-search-box">
        <span>🔍</span>
        <input type="text" id="search" placeholder="Search for restaurant, cuisine or a dish">
      </div>
      <button class="search-action-btn" onclick="searchRestaurant()">Search</button>
    </div>
  </div>
</section>

<section class="section-wrap">
  <div class="option-grid">
    <a href="restaurant" class="option-card">
      <img src="https://images.unsplash.com/photo-1555396273-367ea4eb4db5?q=80&w=400&auto=format&fit=crop" class="option-img" alt="Order Online">
      <div class="option-info">
        <h3>Order Online</h3>
        <p>Stay home and order to your doorstep</p>
      </div>
    </a>
    <a href="restaurant" class="option-card">
      <img src="https://images.unsplash.com/photo-1414235077428-338989a2e8c0?q=80&w=400&auto=format&fit=crop" class="option-img" alt="Dining Out">
      <div class="option-info">
        <h3>Dining Out</h3>
        <p>View the city's favourite dining venues</p>
      </div>
    </a>
    <a href="restaurant" class="option-card">
      <img src="https://images.unsplash.com/photo-1543007630-9710e4a00a20?q=80&w=400&auto=format&fit=crop" class="option-img" alt="Nightlife">
      <div class="option-info">
        <h3>Nightlife & Clubs</h3>
        <p>Explore the city's top nightlife spots</p>
      </div>
    </a>
  </div>
</section>

<section class="section-wrap">
  <div class="collection-head">
    <h2>Collections</h2>
    <p>Explore curated lists of top restaurants, cafes, and bars based on trends</p>
  </div>
  
  <div class="collection-grid">
    <div class="collection-card" onclick="window.location='restaurant'">
      <img src="https://images.unsplash.com/photo-1514933651103-005eec06c04b?q=80&w=300&auto=format&fit=crop" alt="Trending">
      <div class="collection-overlay">
        <h4>Top Trending Places</h4>
        <span>32 Places &rarr;</span>
      </div>
    </div>
    <div class="collection-card" onclick="window.location='restaurant'">
      <img src="https://images.unsplash.com/photo-1554118811-1e0d58224f24?q=80&w=300&auto=format&fit=crop" alt="Cafes">
      <div class="collection-overlay">
        <h4>Best Pocket Cafes</h4>
        <span>18 Places &rarr;</span>
      </div>
    </div>
    <div class="collection-card" onclick="window.location='restaurant'">
      <img src="https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?q=80&w=300&auto=format&fit=crop" alt="Pizza">
      <div class="collection-overlay">
        <h4>Legendary Pizzas</h4>
        <span>12 Places &rarr;</span>
      </div>
    </div>
    <div class="collection-card" onclick="window.location='restaurant'">
      <img src="https://images.unsplash.com/photo-1482049016688-2d3e1b311543?q=80&w=300&auto=format&fit=crop" alt="Breakfast">
      <div class="collection-overlay">
        <h4>Great Breakfasts</h4>
        <span>25 Places &rarr;</span>
      </div>
    </div>
  </div>
</section>

<footer>
  <div class="footer-top">
    <a href="index.jsp" class="f-logo">FoodExpress</a>
  </div>
  
  <div class="footer-links-grid">
    <div class="f-col">
      <h4>About FoodExpress</h4>
      <ul>
        <li><a href="#">Who We Are</a></li>
        <li><a href="#">Blog</a></li>
        <li><a href="#">Work With Us</a></li>
        <li><a href="#">Report Fraud</a></li>
      </ul>
    </div>
    <div class="f-col">
      <h4>Foodies</h4>
      <ul>
        <li><a href="#">Code of Conduct</a></li>
        <li><a href="#">Community</a></li>
        <li><a href="#">Verified Profiles</a></li>
      </ul>
    </div>
    <div class="f-col">
      <h4>For Restaurants</h4>
      <ul>
        <li><a href="#">Partner With Us</a></li>
        <li><a href="#">Apps For You</a></li>
      </ul>
    </div>
    <div class="f-col">
      <h4>Learn More</h4>
      <ul>
        <li><a href="#">Privacy Policy</a></li>
        <li><a href="#">Security Terms</a></li>
        <li><a href="#">Terms of Service</a></li>
      </ul>
    </div>
  </div>
  
  <div class="footer-legal">
    By continuing past this page, you agree to our Terms of Service, Cookie Policy, Privacy Policy and Content Policies. All trademarks are properties of their respective owners. &copy; 2026 FoodExpress Ltd. All rights reserved.
  </div>
</footer>

<script>
  // 1. Zomato Header Sticky State Transition Controller
  const header = document.getElementById('mainHeader');
  window.addEventListener('scroll', () => {
    if (window.scrollY > 60) {
      header.classList.add('sticky');
    } else {
      header.classList.remove('sticky');
    }
  });

  // 2. Query Redirection Interceptor
  function searchRestaurant(){
    const value = document.getElementById("search").value.trim();
    if(value === ""){
      window.location = "restaurant";
    } else {
      window.location = "restaurant?search=" + encodeURIComponent(value);
    }
  }
  
  document.getElementById("search").addEventListener("keypress", function(e) {
    if(e.key === "Enter") {
      searchRestaurant();
    }
  });
</script>
</body>
</html>