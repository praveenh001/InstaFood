<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.instafoo.Model.Menu" %>
<%@ page import="com.instafoo.Model.Restaurant" %>
<%@ page import="com.instafoo.Model.User" %>
<%@ page import="com.instafoo.daoImp.RestaurantDaoImp" %>

<%
    Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
    List<Menu> allMenu = (List<Menu>) request.getAttribute("allmenu");
    
    RestaurantDaoImp filterRestDao = new RestaurantDaoImp();
    List<Restaurant> filterRestaurants = filterRestDao.getAllRestaurants();
    
    // Resolve restaurant image based on cuisine
    String restaurantImage = "images/rest_modern.png";
    String restaurantName = "Instafoods Partner";
    String cuisineType = "Delicious Cuisines";
    String address = "Bengaluru";
    double rating = 4.5;
    int deliveryTime = 25;
    
    if (restaurant != null) {
        restaurantName = restaurant.getName();
        cuisineType = restaurant.getCuisine_type();
        address = restaurant.getAddress();
        rating = restaurant.getRating();
        deliveryTime = restaurant.getDelivery_time();
        
        String cuisine = cuisineType.toLowerCase();
        if (cuisine.contains("south indian")) {
            restaurantImage = "images/rest_south_indian.png";
        } else if (cuisine.contains("north indian")) {
            restaurantImage = "images/rest_biryani.png";
        } else if (cuisine.contains("asian")) {
            restaurantImage = "images/rest_asian.png";
        } else if (cuisine.contains("italian") || cuisine.contains("pizza")) {
            restaurantImage = "images/rest_italian.png";
        } else if (cuisine.contains("cafe") || cuisine.contains("brunch")) {
            restaurantImage = "images/rest_cafe.png";
        } else if (cuisine.contains("vegetarian")) {
            restaurantImage = "images/rest_indian.png";
        }
    }
    
    User loggedInUser = (User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <link rel="icon" type="image/x-icon" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQz8HFcByuK1fp2KQdFls5532X50P87Ucp1kg&s">

  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><%= restaurantName %> Menu – Instafoods</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    @keyframes fadeSlideUp {
      from { opacity: 0; transform: translateY(28px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    .page-hero {
      padding: 140px 80px 40px;
      max-width: 1360px;
      margin: 0 auto;
    }
    .page-hero-inner {
      display: flex;
      align-items: flex-end;
      justify-content: space-between;
      gap: 32px;
      flex-wrap: wrap;
    }
    .page-hero h1 {
      font-size: clamp(2.4rem, 4.5vw, 4rem);
      line-height: 0.95;
      margin-bottom: 16px;
      animation: fadeSlideUp 0.7s ease both;
    }
    .hero-accent-line {
      height: 3px; width: 80px; border-radius: 2px;
      background: linear-gradient(90deg, var(--primary), #7fff00, var(--primary));
      background-size: 200% auto;
      margin: 12px 0 20px;
    }
    
    .restaurant-header-section {
      padding: 0 80px 40px;
      max-width: 1360px;
      margin: 0 auto;
    }
    .restaurant-group-header {
      background: var(--bg-card);
      border: 1px solid var(--border);
      border-radius: 20px;
      padding: 30px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 30px;
      flex-wrap: wrap;
      margin-bottom: 40px;
    }
    .restaurant-group-title {
      display: flex;
      align-items: center;
      gap: 20px;
    }
    .group-img {
      width: 72px; height: 72px;
      border-radius: 16px;
      object-fit: cover;
      border: 1px solid var(--border);
      flex-shrink: 0;
    }
    .group-name {
      font-family: var(--font-heading);
      font-size: 1.8rem;
      font-weight: 900;
      text-transform: uppercase;
      line-height: 1.0;
    }
    .group-cuisine {
      font-size: 0.85rem;
      color: var(--primary);
      font-family: var(--font-heading);
      font-weight: 800;
      text-transform: uppercase;
      letter-spacing: 0.6px;
      margin-top: 6px;
    }
    .group-address {
      font-size: 0.8rem;
      color: var(--text-muted);
      margin-top: 5px;
      display: flex;
      align-items: center;
      gap: 5px;
    }
    .group-address i { color: var(--primary); }
    .group-meta {
      display: flex;
      gap: 24px;
      align-items: center;
    }
    .group-meta-item {
      display: flex;
      align-items: center;
      gap: 8px;
      font-size: 0.95rem;
      color: var(--text-muted);
    }
    .group-meta-item i { color: var(--primary); }
    
    .menu-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(290px, 1fr));
      gap: 24px;
      padding-top: 12px;
      margin-top: -12px;
    }
    .food-card {
      transition: transform 0.3s cubic-bezier(0.34,1.4,0.64,1),
                  box-shadow 0.3s ease,
                  border-color 0.3s ease;
    }
    .food-card:hover {
      transform: translateY(-8px) scale(1.01);
      box-shadow: 0 20px 50px rgba(0,0,0,0.55), 0 0 20px rgba(202,255,0,0.08);
      border-color: var(--primary);
    }
    .food-emoji {
      position: absolute;
      inset: 0;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 4rem;
      z-index: 0;
    }
    .availability-badge {
      position: absolute;
      top: 12px; right: 12px;
      display: flex;
      align-items: center;
      gap: 5px;
      padding: 4px 10px;
      border-radius: 50px;
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.68rem;
      text-transform: uppercase;
      z-index: 2;
    }
    .availability-badge.available {
      background: var(--primary);
      color: #000;
    }
    .availability-badge.unavailable {
      background: #2a2a2a;
      color: var(--text-muted);
      border: 1px solid var(--border);
    }
    .kcal-tag {
      font-size: 0.78rem;
      color: var(--text-muted);
      margin-bottom: 14px;
      display: flex;
      align-items: center;
      gap: 6px;
    }
    .kcal-tag i { color: var(--primary); }
    .food-card.unavailable {
      opacity: 0.5;
      pointer-events: none;
    }
    .food-card.unavailable .food-img { filter: grayscale(1); }
    
    @media (max-width: 1100px) {
      .page-hero { padding: 120px 36px 30px; }
      .restaurant-header-section { padding: 0 36px 40px; }
    }
    @media (max-width: 700px) {
      .menu-grid { grid-template-columns: 1fr; }
      .group-name { font-size: 1.4rem; }
      .restaurant-group-header { padding: 20px; }
    }
    
    /* ====================================
       FILTER ACCORDION SIDEBAR
       ==================================== */
    .restaurants-page-content {
      display: grid;
      grid-template-columns: 280px minmax(0, 1fr);
      gap: 40px;
      max-width: 1360px;
      margin: 0 auto;
      padding: 0 80px 80px;
    }
    
    .filter-sidebar {
      background: var(--bg-card);
      border: 1px solid var(--border);
      border-radius: 16px;
      padding: 24px;
      height: fit-content;
      position: sticky;
      top: 92px;
    }
    
    .filter-sidebar-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 24px;
      padding-bottom: 12px;
      border-bottom: 1px solid var(--border);
    }
    
    .filter-sidebar-header h3 {
      font-size: 1.15rem;
      font-family: var(--font-heading);
      font-weight: 900;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
    
    .clear-all-filters-btn {
      background: none;
      border: none;
      color: var(--primary);
      font-family: var(--font-heading);
      font-weight: 800;
      font-size: 0.75rem;
      text-transform: uppercase;
      cursor: pointer;
      transition: color 0.2s;
    }
    
    .clear-all-filters-btn:hover {
      color: var(--primary-light);
    }
    
    .accordion-item {
      border-bottom: 1px solid rgba(255,255,255,0.06);
      margin-bottom: 16px;
      padding-bottom: 16px;
    }
    
    .accordion-item:last-child {
      border-bottom: none;
      margin-bottom: 0;
      padding-bottom: 0;
    }
    
    .accordion-header {
      width: 100%;
      background: none;
      border: none;
      color: #fff;
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 8px 0;
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.88rem;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      cursor: pointer;
    }
    
    .accordion-header i {
      font-size: 0.8rem;
      transition: transform 0.3s;
    }
    
    .accordion-item.active .accordion-header i {
      transform: rotate(180deg);
    }
    
    .accordion-content {
      display: none;
      flex-direction: column;
      gap: 10px;
      padding-top: 12px;
    }
    
    .accordion-item.active .accordion-content {
      display: flex;
    }
    
    .filter-checkbox-label, .filter-radio-label {
      display: flex;
      align-items: center;
      gap: 10px;
      font-size: 0.9rem;
      color: var(--text-muted);
      cursor: pointer;
      user-select: none;
      transition: color 0.15s;
    }
    
    .filter-checkbox-label:hover, .filter-radio-label:hover {
      color: #fff;
    }
    
    .filter-checkbox-label input, .filter-radio-label input {
      appearance: none;
      -webkit-appearance: none;
      width: 18px;
      height: 18px;
      border: 1.5px solid var(--border);
      border-radius: 4px;
      background: #111;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: border-color 0.15s, background-color 0.15s;
      position: relative;
    }
    
    .filter-radio-label input {
      border-radius: 50%;
    }
    
    .filter-checkbox-label input:checked, .filter-radio-label input:checked {
      background-color: var(--primary);
      border-color: var(--primary);
    }
    
    .filter-checkbox-label input:checked::after {
      content: "\f00c";
      font-family: "Font Awesome 6 Free";
      font-weight: 900;
      color: #000;
      font-size: 0.7rem;
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
    }
    
    .filter-radio-label input:checked::after {
      content: "";
      width: 8px;
      height: 8px;
      border-radius: 50%;
      background: #000;
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
    }
    
    @media (max-width: 1024px) {
      .restaurants-page-content {
        grid-template-columns: 1fr;
        padding: 0 40px 60px;
      }
      .filter-sidebar {
        position: static;
        width: 100%;
      }
    }
    @media (max-width: 640px) {
      .restaurants-page-content {
        padding: 0 20px 40px;
      }
    }
  </style>

  <script>
    /* ---- Profile Dropdown Toggle ---- */
    function toggleUserDropdown(event) {
      event.stopPropagation();
      const menu = document.getElementById('userDropdownMenu');
      if (menu) {
        const isVisible = menu.style.display === 'block';
        menu.style.display = isVisible ? 'none' : 'block';
      }
    }
    window.addEventListener('click', function() {
      const menu = document.getElementById('userDropdownMenu');
      if (menu) {
        menu.style.display = 'none';
      }
    });

    function checkCartAccess(event) {
      <% if (session.getAttribute("user") == null) { %>
        alert("Please sign in to access your cart!");
        window.location.href = "${pageContext.request.contextPath}/views/login.jsp";
        if (event) event.preventDefault();
        return false;
      <% } %>
      return true;
    }
  </script>
</head>
<body>

  <!-- ============ NAVBAR ============ -->
  <header class="navbar" id="navbar">
    <a href="${pageContext.request.contextPath}/LandingServlet" class="logo">
      <span class="logo-text">Insta<span>foods</span></span>
    </a>
    <ul class="nav-links">
      <li><a href="${pageContext.request.contextPath}/ResturantServlet">Restaurants</a></li>
      <li><a href="${pageContext.request.contextPath}/MenuServlet" class="active">Full Menu</a></li>
      <li><a href="${pageContext.request.contextPath}/OrderTrackerServlet">Insta-Tracker</a></li>
      <li><a href="${pageContext.request.contextPath}/CartServlet" onclick="return checkCartAccess(event)"><i class="fa-solid fa-cart-shopping" style="margin-right:5px;"></i>Cart</a></li>
    </ul>
    <div class="nav-actions">
      <%
          if (loggedInUser != null) {
              char firstLetter = 'U';
              if (loggedInUser.getUsername() != null && !loggedInUser.getUsername().trim().isEmpty()) {
                  firstLetter = loggedInUser.getUsername().trim().toUpperCase().charAt(0);
              }
      %>
          <!-- Profile Dropdown Component -->
          <div class="user-profile-dropdown">
            <button class="user-avatar-badge" onclick="toggleUserDropdown(event)" style="width: 36px; height: 36px; border-radius: 50%; background: linear-gradient(135deg, #caff00 0%, #00e5ff 100%); color: #000000; display: inline-flex; align-items: center; justify-content: center; font-family: var(--font-heading), sans-serif; font-weight: 900; font-size: 1.05rem; text-transform: uppercase; box-shadow: 0 0 15px rgba(202, 255, 0, 0.35); border: 1.5px solid rgba(255, 255, 255, 0.15); flex-shrink: 0; cursor: pointer; user-select: none; padding: 0; outline: none; transition: transform 0.2s ease;" title="<%= loggedInUser.getUsername() %>">
              <%= firstLetter %>
            </button>
            <div class="dropdown-menu" id="userDropdownMenu" style="display: none; position: absolute; right: 0; top: 48px; background-color: #121212; border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 8px; box-shadow: 0 10px 30px rgba(0,0,0,0.65); min-width: 160px; z-index: 1000; overflow: hidden; box-sizing: border-box; text-align: left;">
              <div style="padding: 12px 16px; border-bottom: 1px solid rgba(255, 255, 255, 0.08); font-size: 0.8rem; color: #888; font-family: var(--font-heading), sans-serif; font-weight: 800; text-transform: uppercase; letter-spacing: 0.5px; white-space: nowrap;">
                <%= loggedInUser.getUsername() %>
              </div>
              <% if ("Admin".equalsIgnoreCase(loggedInUser.getRole())) { %>
                <a href="${pageContext.request.contextPath}/AdminServlet" style="display: flex; align-items: center; gap: 8px; padding: 12px 16px; color: var(--primary); text-decoration: none; font-size: 0.82rem; font-family: var(--font-heading), sans-serif; font-weight: 800; text-transform: uppercase; transition: background 0.2s; border-bottom: 1px solid rgba(255, 255, 255, 0.06);" onmouseover="this.style.backgroundColor='rgba(202, 255, 0, 0.08)'" onmouseout="this.style.backgroundColor='transparent'">
                  <i class="fa-solid fa-user-shield" style="font-size: 0.9rem;"></i> Admin Panel
                </a>
              <% } %>
              <a href="${pageContext.request.contextPath}/LogoutServlet" style="display: flex; align-items: center; gap: 8px; padding: 12px 16px; color: #ff4a4a; text-decoration: none; font-size: 0.82rem; font-family: var(--font-heading), sans-serif; font-weight: 800; text-transform: uppercase; transition: background 0.2s;" onmouseover="this.style.backgroundColor='rgba(255, 74, 74, 0.08)'" onmouseout="this.style.backgroundColor='transparent'">
                <i class="fa-solid fa-arrow-right-from-bracket" style="font-size: 0.9rem;"></i> Sign Out
              </a>
            </div>
          </div>
      <% } else { %>
          <a href="${pageContext.request.contextPath}/views/login.jsp" class="btn btn-outline" style="border:none;padding:10px 16px;">Sign In</a>
      <% } %>
    </div>
    <div class="hamburger" id="hamburger">
      <span></span><span></span><span></span>
    </div>
  </header>

  <!-- ============ PAGE HERO ============ -->
  <div class="page-hero">
    <div class="page-hero-inner">
      <div>
        <h1><%= restaurantName %><br><span class="highlight">Menu.</span></h1>
        <div class="hero-accent-line"></div>
      </div>
    </div>
  </div>

  <!-- ============ RESTAURANT PROFILE HEADER & MENU SECTIONS ============ -->
  <main class="restaurant-header-section">
    <div class="restaurant-group-header">
      <div class="restaurant-group-title">
        <img src="<%= restaurantImage %>" class="group-img" alt="<%= restaurantName %>">
        <div>
          <h2 class="group-name"><%= restaurantName %></h2>
          <div class="group-cuisine"><%= cuisineType %></div>
          <div class="group-address"><i class="fa-solid fa-location-dot"></i> <%= address %></div>
        </div>
      </div>
      <div class="group-meta">
        <div class="group-meta-item"><i class="fa-solid fa-star"></i> <%= rating %></div>
        <div class="group-meta-item"><i class="fa-solid fa-clock"></i> <%= deliveryTime %> mins</div>
        <a href="${pageContext.request.contextPath}/ResturantServlet" class="btn btn-secondary" style="padding:8px 16px;font-size:0.78rem;">All Restaurants</a>
      </div>
    </div>

    <div class="restaurants-page-content" style="padding: 0;">
      <!-- FILTER SIDEBAR (Accordion style) -->
      <aside class="filter-sidebar">
        <div class="filter-sidebar-header">
          <h3>Filters</h3>
          <button class="clear-all-filters-btn" onclick="clearAllFilters()">Clear All</button>
        </div>
        
        <div class="filter-accordion">
          <!-- Restaurants Accordion -->
          <div class="accordion-item active">
            <button class="accordion-header" onclick="toggleAccordion(this)">
              <span>Restaurants</span>
              <i class="fa-solid fa-chevron-down"></i>
            </button>
            <div class="accordion-content">
              <%
                  if (filterRestaurants != null) {
                      for (Restaurant r : filterRestaurants) {
              %>
                        <label class="filter-checkbox-label">
                          <input type="checkbox" name="restaurant" value="<%= r.getResturant_id() %>" onchange="applyFilters()">
                          <span><%= r.getName() %></span>
                        </label>
              <%
                      }
                  }
              %>
            </div>
          </div>

          <!-- Price Range Accordion -->
          <div class="accordion-item">
            <button class="accordion-header" onclick="toggleAccordion(this)">
              <span>Price Range</span>
              <i class="fa-solid fa-chevron-down"></i>
            </button>
            <div class="accordion-content">
              <label class="filter-radio-label">
                <input type="radio" name="price" value="all" checked onchange="applyFilters()">
                <span>Show All</span>
              </label>
              <label class="filter-radio-label">
                <input type="radio" name="price" value="under-100" onchange="applyFilters()">
                <span>Under ₹100</span>
              </label>
              <label class="filter-radio-label">
                <input type="radio" name="price" value="100-250" onchange="applyFilters()">
                <span>₹100 - ₹250</span>
              </label>
              <label class="filter-radio-label">
                <input type="radio" name="price" value="over-250" onchange="applyFilters()">
                <span>Over ₹250</span>
              </label>
            </div>
          </div>

          <!-- Availability Accordion -->
          <div class="accordion-item">
            <button class="accordion-header" onclick="toggleAccordion(this)">
              <span>Availability</span>
              <i class="fa-solid fa-chevron-down"></i>
            </button>
            <div class="accordion-content">
              <label class="filter-checkbox-label">
                <input type="checkbox" name="availability" value="available" onchange="applyFilters()">
                <span>Available Now</span>
              </label>
            </div>
          </div>
        </div>
      </aside>

      <!-- MAIN GRID COLUMN -->
      <main class="menu-grid-column" style="padding: 0; min-width: 0; display: flex; flex-direction: column; width: 100%;">
        <!-- The food cards list -->
        <div class="menu-grid" id="menu-grid">
      <%
          if (allMenu != null && !allMenu.isEmpty()) {
              for (Menu m : allMenu) {
                  // Fetch item's restaurant info for dynamic categories
                  String itemCuisine = "";
                  String itemRestaurantName = "";
                  boolean isRestaurantActive = true;
                  try {
                      RestaurantDaoImp rDao = new RestaurantDaoImp();
                      Restaurant rObj = rDao.getRestaurantById(m.getRestaurantId());
                      if (rObj != null) {
                          itemRestaurantName = rObj.getName();
                          itemCuisine = rObj.getCuisine_type();
                          if (rObj.getIs_active() != null) {
                              isRestaurantActive = rObj.getIs_active();
                          }
                      }
                  } catch (Exception e) {}

                  boolean effectiveAvailable = m.isAvailable() && isRestaurantActive;

                  // Fallback food emoji
                  String emoji = "🍲";
                  String nameLower = m.getItemName().toLowerCase();
                  if (nameLower.contains("chicken") || nameLower.contains("murgh")) emoji = "🍗";
                  else if (nameLower.contains("biryani") || nameLower.contains("rice") || nameLower.contains("pulao")) emoji = "🍚";
                  else if (nameLower.contains("pizza")) emoji = "🍕";
                  else if (nameLower.contains("burger")) emoji = "🍔";
                  else if (nameLower.contains("coffee") || nameLower.contains("tea") || nameLower.contains("shake")) emoji = "☕";
                  else if (nameLower.contains("dessert") || nameLower.contains("cake") || nameLower.contains("ice")) emoji = "🍰";
                  else if (nameLower.contains("salad")) emoji = "🥗";
                  else if (nameLower.contains("roti") || nameLower.contains("nan") || nameLower.contains("bread")) emoji = "🫓";
      %>
              <div class="food-card <%= effectiveAvailable ? "" : "unavailable" %>" data-category="<%= (itemCuisine != null ? itemCuisine.toLowerCase().replace(" ", "-") : "") %>" data-available="<%= effectiveAvailable %>" data-restaurant-id="<%= m.getRestaurantId() %>">
                <div class="food-img" style="background-color:#141414; position: relative; overflow: hidden; height: 160px; border-radius: 6px;">
                  <% if (m.getImagePath() != null && !m.getImagePath().trim().isEmpty()) { %>
                    <img src="<%= m.getImagePath() %>" alt="<%= m.getItemName() %>" style="width: 100%; height: 100%; object-fit: cover;">
                  <% } else { %>
                    <div class="food-emoji" style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); font-size: 2.5rem; inset: auto;"><%= emoji %></div>
                  <% } %>
                  <% if (effectiveAvailable) { %>
                    <span class="availability-badge available"><i class="fa-solid fa-circle" style="font-size:0.4rem;margin-right:4px;"></i>Available</span>
                  <% } else { %>
                    <span class="availability-badge unavailable"><i class="fa-solid fa-circle" style="font-size:0.4rem;margin-right:4px;"></i>Unavailable</span>
                  <% } %>
                </div>
                <h3 style="margin-top: 14px; margin-bottom: 4px;"><%= m.getItemName() %></h3>
                <%
                  if (!itemRestaurantName.isEmpty()) {
                %>
                  <div class="item-restaurant-name" style="font-size: 0.75rem; color: var(--primary); font-family: var(--font-heading); font-weight: 800; text-transform: uppercase; margin-bottom: 12px; display: flex; align-items: center; gap: 4px;">
                    <i class="fa-solid fa-store" style="font-size: 0.7rem;"></i><%= itemRestaurantName %>
                  </div>
                <% } %>
                <div class="kcal-tag"><i class="fa-solid fa-fire-flame-curved"></i>450 kcal</div>
                <p><%= m.getDescription() %></p>
                <div class="food-card-footer">
                  <div class="food-price">₹<%= (int)m.getPrice() %></div>
                  <% if (effectiveAvailable) { %>
                  
                  <form action="${pageContext.request.contextPath}/CartServlet" method="post" onsubmit="return checkCartAccess(event)">
                  <input type="hidden" name="menuId" value="<%= m.getMenuId() %>" >
                  <input type="hidden" name="quantity" value="1" >
                  <input type="hidden" name="restaurantid" value="<%= m.getRestaurantId()%>" >
                  <input type="hidden" name="action"  value="add" >
                  
                  <button class="btn btn-primary" style="padding:10px 18px;font-size:0.8rem;">Add to Cart</button>
                  </form>
                    
                  <% } else { %>
                    <button class="btn btn-secondary" style="padding:10px 18px;font-size:0.8rem;opacity:0.5;cursor:not-allowed;" disabled>
                      <%= !isRestaurantActive ? "Kitchen Offline" : "Out of Stock" %>
                    </button>
                  <% } %>
                </div>
              </div>
      <%
              }
          } else {
      %>
              <div style="grid-column:1/-1;text-align:center;padding:60px 20px;color:var(--text-muted);">
                  <i class="fa-solid fa-utensils" style="font-size:3rem;color:var(--primary);margin-bottom:16px;"></i>
                  <p>No menu items available for this restaurant.</p>
              </div>
      <%
          }
      %>
      </div>
    </main>
  </div>
  </main>

  <!-- ============ FOOTER ============ -->
  <footer>
    <a href="${pageContext.request.contextPath}/LandingServlet" class="logo">
      <span class="logo-text">Insta<span>foods</span></span>
    </a>
    <p>&copy; 2026 Instafoods Technologies. Namma Bengaluru's Delivery Movement.</p>
  </footer>

  <script>
    /* ---- Accordion Toggle ---- */
    function toggleAccordion(btn) {
      const item = btn.parentElement;
      item.classList.toggle('active');
    }

    /* ---- Apply Filters ---- */
    function applyFilters() {
      // Get selected restaurants
      const selectedRestaurants = [];
      document.querySelectorAll('input[name="restaurant"]:checked').forEach(cb => {
        selectedRestaurants.push(cb.value);
      });

      // Get selected price range
      const priceVal = document.querySelector('input[name="price"]:checked').value;

      // Get availability filter
      const availableOnly = document.querySelector('input[name="availability"]:checked') !== null;

      const cards = document.querySelectorAll('.food-card');
      let visibleIdx = 0;
      
      cards.forEach(card => {
        const restaurantId = card.getAttribute('data-restaurant-id');
        const isAvailable = card.getAttribute('data-available') === 'true';
        
        // Parse price from footer text
        const priceText = card.querySelector('.food-price').textContent; // e.g. "₹299"
        const price = parseFloat(priceText.replace('₹', ''));

        let matchesRestaurant = selectedRestaurants.length === 0 || selectedRestaurants.includes(restaurantId);
        let matchesAvailability = !availableOnly || isAvailable;
        
        let matchesPrice = false;
        if (priceVal === 'all') {
          matchesPrice = true;
        } else if (priceVal === 'under-100') {
          matchesPrice = price < 100;
        } else if (priceVal === '100-250') {
          matchesPrice = price >= 100 && price <= 250;
        } else if (priceVal === 'over-250') {
          matchesPrice = price > 250;
        }

        if (matchesRestaurant && matchesAvailability && matchesPrice) {
          card.style.display = 'block';
          card.style.animation = 'none';
          void card.offsetHeight;
          card.style.animation = `fadeSlideUp 0.45s ${visibleIdx * 0.07}s ease both`;
          visibleIdx++;
        } else {
          card.style.display = 'none';
        }
      });

      /* Show "no results" message if nothing matches */
      let noResults = document.getElementById('no-results-msg');
      if (visibleIdx === 0) {
        if (!noResults) {
          noResults = document.createElement('div');
          noResults.id = 'no-results-msg';
          noResults.style.cssText = 'grid-column:1/-1;text-align:center;padding:60px 20px;color:var(--text-muted);font-family:var(--font-heading);font-size:1rem;text-transform:uppercase;letter-spacing:1px;';
          noResults.innerHTML = '<i class="fa-solid fa-utensils" style="font-size:2rem;color:var(--primary);display:block;margin-bottom:16px;"></i>No menu items match the selected filters.';
          document.getElementById('menu-grid').appendChild(noResults);
        }
        noResults.style.display = 'block';
      } else if (noResults) {
        noResults.style.display = 'none';
      }

      // Refresh card slider pagination and thumb position
      const gridEl = document.getElementById('menu-grid');
      if (gridEl) {
        gridEl.dispatchEvent(new Event('update-slider'));
      }
    }

    /* ---- Clear All Filters ---- */
    function clearAllFilters() {
      document.querySelectorAll('input[name="restaurant"]').forEach(cb => cb.checked = false);
      document.querySelectorAll('input[name="availability"]').forEach(cb => cb.checked = false);
      document.querySelector('input[name="price"][value="all"]').checked = true;
      applyFilters();
    }

    // Navbar scroll effect
    const navbar = document.getElementById('navbar');
    window.addEventListener('scroll', () => {
      navbar.classList.toggle('scrolled', window.scrollY > 40);
    });

    // Mobile hamburger menu
    const hamburger = document.getElementById('hamburger');
    if (hamburger) {
      hamburger.addEventListener('click', () => {
        document.querySelector('.nav-links').classList.toggle('open');
        hamburger.classList.toggle('open');
      });
    }

    /* ---- Slider initialization Script ---- */
    // We will bind the slider JS logic directly inside styles.css and the script tags below
  </script>
  
  <!-- Slidebar script inclusion -->
  <script src="${pageContext.request.contextPath}/slider.js?v=4" defer></script>
</body>
</html>
