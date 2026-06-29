<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Restaurant" %>
<%@ page import="model.User" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FoodExpress | Restaurants with online food delivery</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
  /* ── Core Design Token Reset & Base ── */
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
    padding-top: 102px; /* Smooth padding gap to offset the fixed corporate navbar */
    overflow-x: hidden;
  }

  /* ── Corporate Branded Fixed Navigation System ── */
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
    transition: background 0.3s, box-shadow 0.3s;
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
    color: #cb202d; /* Corporate Red */
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
  }

  .nav-links a:hover {
    color: #cb202d;
  }

  /* ── Profile Trigger Matching Corporate Typography ── */
  .profile-trigger {
    background: transparent;
    border: none;
    display: flex;
    align-items: center;
    gap: 10px;
    cursor: pointer;
    padding: 4px 0;
  }

  .avatar-circle {
    width: 34px;
    height: 34px;
    border-radius: 50%;
    background: #cb202d;
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 700;
    font-size: 14px;
    overflow: hidden;
  }

  .avatar-circle img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  .welcome-text {
    font-size: 15px;
    font-weight: 500;
    color: #1c1c1c;
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

  /* ── Alert Toast Component ── */
  .alert-toast {
    position: fixed;
    bottom: 25px;
    right: 25px;
    background: #1c1c1c;
    color: white;
    padding: 14px 24px;
    border-radius: 8px;
    font-weight: 500;
    box-shadow: 0 8px 24px rgba(0,0,0,0.15);
    z-index: 1100;
  }

  /* ── Account Settings Modular Window ── */
  .modal-overlay {
    position: fixed;
    top: 0; left: 0; width: 100%; height: 100%;
    background: rgba(0, 0, 0, 0.5);
    backdrop-filter: blur(4px);
    display: none;
    align-items: center;
    justify-content: center;
    z-index: 2000;
  }

  .modal-window {
    background: #fff;
    padding: 35px;
    border-radius: 12px;
    width: 100%;
    max-width: 440px;
    position: relative;
    box-shadow: 0 10px 30px rgba(0,0,0,0.15);
    border: 1px solid #e8e8e8;
  }

  .modal-close {
    position: absolute;
    top: 20px; right: 20px;
    background: none; border: none;
    font-size: 26px; color: #828282;
    cursor: pointer;
  }
  .modal-close:hover { color: #1c1c1c; }

  .modal-window h3 {
    font-size: 22px; font-weight: 600;
    margin-bottom: 25px; color: #1c1c1c;
  }

  .avatar-upload-area {
    display: flex; flex-direction: column;
    align-items: center; gap: 12px; margin-bottom: 20px;
  }

  .modal-avatar-preview {
    width: 80px; height: 80px; border-radius: 50%;
    background: #cb202d; display: flex; align-items: center; justify-content: center;
    font-size: 32px; color: white; font-weight: 700; overflow: hidden;
  }
  .modal-avatar-preview img { width: 100%; height: 100%; object-fit: cover; }

  .upload-label {
    font-size: 13px; font-weight: 600; color: #cb202d;
    cursor: pointer; padding: 6px 14px; background: #fff1f2;
    border-radius: 6px; transition: 0.2s;
  }
  .upload-label:hover { background: #ffe4e6; }

  .form-group {
    margin-bottom: 16px; display: flex; flex-direction: column; gap: 6px;
  }
  .form-group label { font-size: 13px; font-weight: 600; color: #4f4f4f; }
  
  .form-group input {
    width: 100%; padding: 11px 14px; border: 1px solid #e8e8e8;
    border-radius: 8px; font-size: 14.5px; outline: none;
    background: #fff; transition: border-color 0.2s;
    color: #1c1c1c;
  }
  .form-group input:focus { border-color: #cb202d; }
  .form-group input:disabled { background: #f8f8f8; color: #828282; cursor: not-allowed; }

  .save-profile-btn {
    width: 100%; background: #cb202d; color: white; border: none;
    padding: 13px; border-radius: 8px; font-size: 15px; font-weight: 600;
    cursor: pointer; transition: background 0.2s; margin-top: 10px;
  }
  .save-profile-btn:hover { background: #b01b26; }

  /* ── Structural Grid Headers ── */
  .page-header {
    max-width: 1100px; margin: 40px auto 15px; padding: 0 20px;
    display: flex; align-items: baseline; gap: 12px;
  }
  .page-header h1 { font-size: 28px; font-weight: 600; color: #1c1c1c; }
  .page-header .count { font-size: 16px; font-weight: 500; color: #4f4f4f; }

  /* ── Search Input Matrix Format ── */
  .search-bar { max-width: 1100px; margin: 0 auto 20px; padding: 0 20px; }
  .search-wrap {
    position: relative; display: flex; align-items: center;
    background: #fff; border: 1px solid #e8e8e8; border-radius: 10px;
    padding: 0 18px; box-shadow: 0 4px 15px rgba(0,0,0,0.03);
  }
  .search-wrap svg { color: #828282; margin-right: 12px; }
  .search-wrap input {
    width: 100%; height: 52px; border: none; background: transparent;
    outline: none; font-size: 15px; color: #1c1c1c;
  }
  .clear-btn {
    background: none; border: none; font-size: 22px; color: #828282;
    cursor: pointer; display: none;
  }

  /* ── Filter Sorting Bar Systems ── */
  .sort-bar {
    max-width: 1100px; margin: 0 auto 25px; padding: 0 20px;
    display: flex; gap: 12px; align-items: center;
  }
  .sort-wrapper { position: relative; }
  .sort-btn {
    background: #fff; border: 1px solid #e8e8e8; padding: 10px 20px;
    border-radius: 8px; font-weight: 500; font-size: 14px;
    display: flex; align-items: center; gap: 8px; cursor: pointer; color: #4f4f4f;
  }
  .sort-btn:hover { border-color: #cb202d; color: #cb202d; }

  .sort-dropdown {
    position: absolute; top: 48px; left: 0; width: 230px;
    background: white; border-radius: 8px; padding: 8px;
    box-shadow: 0 8px 24px rgba(0,0,0,0.12); border: 1px solid #e8e8e8;
    display: none; flex-direction: column; gap: 2px; z-index: 500;
  }
  .sort-option {
    padding: 10px 12px; font-size: 14px; font-weight: 500; color: #4f4f4f;
    border-radius: 6px; cursor: pointer; display: flex; justify-content: space-between; align-items: center;
  }
  .sort-option:hover { background: #f8f8f8; color: #1c1c1c; }
  .sort-option.selected { color: #cb202d; background: #fff1f2; font-weight: 600; }
  .radio-dot { width: 8px; height: 8px; border-radius: 50%; background: transparent; }
  .sort-option.selected .radio-dot { background: #cb202d; }
  
  .apply-btn {
    background: #cb202d; color: white; border: none; padding: 8px;
    border-radius: 6px; font-weight: 600; font-size: 13px; cursor: pointer; margin-top: 4px;
  }

  .clear-filter-btn {
    background: #1c1c1c; color: white; border: none; padding: 10px 16px;
    border-radius: 8px; font-weight: 600; font-size: 13px; cursor: pointer;
    display: none; align-items: center; gap: 4px;
  }

  /* ── High-Fidelity Marketplace Container Grid ── */
  .restaurant-container {
    max-width: 1100px; margin: 0 auto; padding: 0 20px 60px;
    display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px;
  }

  /* ── Interactive Brand Display Cards ── */
  .restaurant-card {
    background: #fff; border-radius: 12px; border: 1px solid #e8e8e8;
    overflow: hidden; text-decoration: none; color: inherit;
    display: flex; flex-direction: column; transition: transform 0.25s, box-shadow 0.25s;
  }

  .restaurant-card:hover {
    transform: scale(1.02);
    box-shadow: 0 4px 15px rgba(0,0,0,0.08);
  }

  .card-img-wrap { position: relative; width: 100%; height: 170px; background: #f8f8f8; overflow: hidden; }
  .card-img-wrap img {
    position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: cover;
    opacity: 0; transition: opacity 0.3s ease;
  }
  .card-img-wrap img.loaded { opacity: 1; }

  .card-body { padding: 16px; display: flex; flex-direction: column; flex: 1; }
  .card-body h2 { font-size: 18px; font-weight: 600; color: #1c1c1c; margin-bottom: 4px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
  
  .card-meta { display: flex; align-items: center; gap: 8px; font-size: 14px; font-weight: 600; margin-bottom: 10px; color: #4f4f4f; }
  .rating-dot { background: #267e3e; color: white; padding: 2px 6px; border-radius: 4px; font-size: 12px; display: inline-flex; align-items: center; font-weight: 700; }
  .rating-dot.low { background: #db7c38; }
  .sep { color: #e0e0e0; }

  .card-desc { font-size: 14px; color: #696969; line-height: 1.4; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; height: 38px; }

  /* ── Skeletons & Fallbacks ── */
  .skeleton-card { background: #fff; border-radius: 12px; padding: 14px; border: 1px solid #e8e8e8; }
  .skeleton-img { width: 100%; height: 150px; background: #f8f8f8; border-radius: 6px; margin-bottom: 12px; }
  .skeleton-line { height: 12px; background: #f8f8f8; border-radius: 4px; margin-bottom: 8px; }
  .w80 { width: 80%; } .w40 { width: 40%; } .w60 { width: 60%; }
  
  .empty-state {
    text-align: center; padding: 60px 20px; background: #fff;
    border-radius: 12px; border: 1px solid #e8e8e8;
    grid-column: 1 / -1; display: flex; flex-direction: column; align-items: center; gap: 10px;
  }
  .empty-state h2 { font-size: 20px; color: #1c1c1c; font-weight: 600; }
  .empty-state p { color: #4f4f4f; font-size: 14px; }
  .reset-link { background: none; border: none; color: #cb202d; font-weight: 600; font-size: 14px; cursor: pointer; text-decoration: underline; margin-top: 5px; }

  /* ── Responsive Columns Framework ── */
  @media (max-width: 991px) {
    .restaurant-container { grid-template-columns: repeat(2, 1fr); }
  }
  @media(max-width: 768px) {
    .navbar { padding: 0 5%; }
    .page-header, .search-bar, .sort-bar, .restaurant-container { padding-left: 5%; padding-right: 5%; }
    .restaurant-container { grid-template-columns: 1fr; gap: 20px; }
  }
</style>
</head>
<body>

<header>
  <nav class="navbar">
    <a href="index.jsp" class="logo">FoodExpress</a>
    <ul class="nav-links">
      <li><a href="index.jsp">Home</a></li>
      <li><a href="restaurant" style="color: #cb202d;">Restaurants</a></li>
      
      <li>
        <button class="profile-trigger" id="openProfileModalBtn">
          <div class="avatar-circle">
            <% if(loggedUser != null && loggedUser.getProfileImage() != null && !loggedUser.getProfileImage().trim().isEmpty()) { %>
              <img src="<%=request.getContextPath()%>/<%=loggedUser.getProfileImage()%>" alt="Avatar">
            <% } else { %>
              <%= (loggedUser != null) ? loggedUser.getFullName().substring(0,1).toUpperCase() : "U" %>
            <% } %>
          </div>
          <span class="welcome-text"> <%= (loggedUser != null) ? loggedUser.getFullName().split(" ")[0] : "Guest" %></span>
        </button>
      </li>
      
      <li><a class="logout-btn" href="user?action=logout">Logout</a></li>
    </ul>
  </nav>
</header>

<% if("profileUpdated".equals(request.getParameter("success"))) { %>
  <div class="alert-toast" id="toastNotification">✓ Profile metrics updated successfully!</div>
  <script>
    setTimeout(() => {
      const toast = document.getElementById('toastNotification');
      if(toast) toast.style.display = 'none';
    }, 4000);
  </script>
<% } %>

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

<div class="page-header">
  <h1>Restaurants with online food delivery</h1>
  <span class="count" id="resultCount"></span>
</div>

<div class="search-bar">
  <div class="search-wrap">
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
      <circle cx="11" cy="11" r="7"></circle>
      <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
    </svg>
    <input type="text" id="searchInput" placeholder="Search restaurants or cuisine">
    <button class="clear-btn" id="clearSearch" aria-label="Clear search">&times;</button>
  </div>
</div>

<div class="sort-bar">
  <div class="sort-wrapper">
    <div class="sort-btn" id="sortBtn">
      Sort By
      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
        <polyline points="6 9 12 15 18 9"></polyline>
      </svg>
    </div>

    <div class="sort-dropdown" id="sortDropdown">
      <div class="sort-option selected" data-value="relevance">
        Relevance (Default)
        <span class="radio-dot"></span>
      </div>
      <div class="sort-option" data-value="delivery_time">
        Delivery Time
        <span class="radio-dot"></span>
      </div>
      <div class="sort-option" data-value="rating">
        Rating
        <span class="radio-dot"></span>
      </div>
      <button class="apply-btn" id="applySort">Apply</button>
    </div>
  </div>

  <button class="clear-filter-btn" id="clearFilterBtn">&times; Clear sort</button>
</div>

<section class="restaurant-container" id="skeletonGrid" style="display:none;">
  <% for(int i=0;i<6;i++){ %>
  <div class="skeleton-card">
    <div class="skeleton-img"></div>
    <div class="skeleton-line w80"></div>
    <div class="skeleton-line w40"></div>
  </div>
  <% } %>
</section>

<section class="restaurant-container" id="restaurantGrid">
<%
List<Restaurant> restaurants = (List<Restaurant>)request.getAttribute("restaurants");

if(restaurants != null && !restaurants.isEmpty()){
    for(Restaurant restaurant : restaurants){
        double rating = restaurant.getRating();
%>
<a class="restaurant-card"
   href="menu?restaurantId=<%=restaurant.getRestaurantId()%>"
   data-name="<%=restaurant.getName().toLowerCase()%>"
   data-desc="<%=restaurant.getDescription() != null ? restaurant.getDescription().toLowerCase() : ""%>"
   data-rating="<%=rating%>"
   data-time="<%=restaurant.getDeliveryTime()%>">

  <div class="card-img-wrap">
    <img
      src="<%=request.getContextPath()%>/<%=restaurant.getImage() != null ? restaurant.getImage() : "images/default.png"%>"
      alt="<%=restaurant.getName()%>"
      loading="lazy"
      onload="this.classList.add('loaded')">
  </div>

  <div class="card-body">
    <h2><%=restaurant.getName()%></h2>
    <div class="card-meta">
      <span class="rating-dot <%=rating < 3.5 ? "low" : ""%>">★ <%=rating%></span>
      <span class="sep">•</span>
      <span><%=restaurant.getDeliveryTime()%> mins</span>
    </div>
    <p class="card-desc"><%=restaurant.getDescription()%></p>
  </div>
</a>
<%
    }
} else {
%>
<div class="empty-state" id="noRestaurantsState">
  <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="#cb202d" stroke-width="1.5">
    <path d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-1.5 7h13L17 13M9 21a1 1 0 1 0 2 0 1 1 0 0 0-2 0zm8 0a1 1 0 1 0 2 0 1 1 0 0 0-2 0z"/>
  </svg>
  <h2>No Restaurants Available</h2>
  <p>Please check back later.</p>
</div>
<%
}
%>
</section>

<section class="restaurant-container" id="noMatchState" style="display:none;">
  <div class="empty-state">
    <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="#828282" stroke-width="1.5">
      <circle cx="11" cy="11" r="7"></circle>
      <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
    </svg>
    <h2>No matches found</h2>
    <p>Try a different search term or clear your filters.</p>
    <button class="reset-link" id="resetSearchBtn">Clear search</button>
  </div>
</section>

<script>
document.addEventListener("DOMContentLoaded", () => {
    // DOM Elements References
    const sortBtn = document.getElementById("sortBtn");
    const sortDropdown = document.getElementById("sortDropdown");
    const sortOptions = document.querySelectorAll(".sort-option");
    const applySortBtn = document.getElementById("applySort");
    const clearFilterBtn = document.getElementById("clearFilterBtn");
    const restaurantGrid = document.getElementById("restaurantGrid");
    const originalCards = Array.from(restaurantGrid.querySelectorAll(".restaurant-card"));
    const resultCount = document.getElementById("resultCount");

    // Initialize Card Total Indicator Count
    if(resultCount) {
        resultCount.textContent = originalCards.length + " places near you";
    }

    // 1. Toggle Filter Dropdown Menu Visibility
    sortBtn.addEventListener("click", (e) => {
        e.stopPropagation();
        const isDisplayed = sortDropdown.style.display === "flex";
        sortDropdown.style.display = isDisplayed ? "none" : "flex";
    });

    // Close dropdown instantly if clicking outside the component
    document.addEventListener("click", () => {
        sortDropdown.style.display = "none";
    });
    sortDropdown.addEventListener("click", (e) => e.stopPropagation());

    // 2. Select Option Active States Toggle
    sortOptions.forEach(option => {
        option.addEventListener("click", () => {
            sortOptions.forEach(opt => opt.classList.remove("selected"));
            option.classList.add("selected");
        });
    });

    // 3. Main Sorting Algorithmic Matrix
    applySortBtn.addEventListener("click", () => {
        const selectedOption = sortDropdown.querySelector(".sort-option.selected");
        const criterion = selectedOption ? selectedOption.getAttribute("data-value") : "relevance";
        
        // Hide Dropdown
        sortDropdown.style.display = "none";

        // Filter out cards currently hidden by the search bar algorithm
        const cardsToSort = Array.from(restaurantGrid.querySelectorAll(".restaurant-card"));

        if (criterion === "relevance") {
            // Restore initial original sequence layout structure
            originalCards.forEach(card => {
                if (card.style.display !== "none") restaurantGrid.appendChild(card);
            });
            clearFilterBtn.style.display = "none";
        } else {
            // Dynamic Sort Processing Loop
            cardsToSort.sort((cardA, cardB) => {
                if (criterion === "delivery_time") {
                    const timeA = parseInt(cardA.getAttribute("data-time")) || 0;
                    const timeB = parseInt(cardB.getAttribute("data-time")) || 0;
                    return timeA - timeB; // Ascending order (Fastest delivery first)
                } 
                if (criterion === "rating") {
                    const valA = parseFloat(cardA.getAttribute("data-rating")) || 0.0;
                    const valB = parseFloat(cardB.getAttribute("data-rating")) || 0.0;
                    return valB - valA; // Descending order (Highest rated first)
                }
                return 0;
            });

            // Re-render sorted collection pipeline elements down to the page DOM grid
            cardsToSort.forEach(card => restaurantGrid.appendChild(card));
            clearFilterBtn.style.display = "inline-flex";
        }
    });

    // 4. Clear Filter Reset Operation
    clearFilterBtn.addEventListener("click", () => {
        sortOptions.forEach(opt => opt.classList.remove("selected"));
        const relevanceOption = sortDropdown.querySelector('[data-value="relevance"]');
        if (relevanceOption) relevanceOption.classList.add("selected");

        // Revert UI structure back to standard defaults
        originalCards.forEach(card => {
            if (card.style.display !== "none") restaurantGrid.appendChild(card);
        });
        clearFilterBtn.style.display = "none";
    });
});




document.addEventListener("DOMContentLoaded", () => {
    // DOM Elements References
    const openProfileModalBtn = document.getElementById("openProfileModalBtn");
    const closeProfileModalBtn = document.getElementById("closeProfileModalBtn");
    const profileModal = document.getElementById("profileModal");
    const profileImageInput = document.getElementById("profileImageInput");
    const avatarPreviewImg = document.getElementById("avatarPreviewImg");
    const avatarLetter = document.getElementById("avatarLetter");
    const modalAvatarPreview = document.querySelector(".modal-avatar-preview");

    // 1. Open Profile Modal on Clicking Avatar/Name Row
    if (openProfileModalBtn && profileModal) {
        openProfileModalBtn.addEventListener("click", (e) => {
            e.preventDefault();
            profileModal.style.display = "flex";
        });
    }

    // 2. Close Profile Modal via Close Button (&times;)
    if (closeProfileModalBtn && profileModal) {
        closeProfileModalBtn.addEventListener("click", () => {
            profileModal.style.display = "none";
        });
    }

    // Close Modal instantly if user clicks outside the modal glass window container
    window.addEventListener("click", (e) => {
        if (e.target === profileModal) {
            profileModal.style.display = "none";
        }
    });

    // 3. Real-Time Dynamic Avatar Image Preview Update
    if (profileImageInput) {
        profileImageInput.addEventListener("change", function() {
            const file = this.files[0];
            if (file) {
                const reader = new FileReader();
                
                reader.onload = function(e) {
                    if (avatarPreviewImg) {
                        // Update existing image source element
                        avatarPreviewImg.src = e.target.result;
                    } else {
                        // If user previously had no image (letter avatar), replace text wrapper with live image element
                        if (avatarLetter) {
                            avatarLetter.remove();
                        }
                        const newImg = document.createElement("img");
                        newImg.id = "avatarPreviewImg";
                        newImg.src = e.target.result;
                        newImg.alt = "Preview";
                        modalAvatarPreview.appendChild(newImg);
                    }
                };
                
                reader.readAsDataURL(file);
            }
        });
    }
});


</script>

</body>
</html>