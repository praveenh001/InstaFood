<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.instafoo.Model.Restaurant" %> 
<%@ page import="com.instafoo.Model.User" %> 
    
<!DOCTYPE html>
<html lang="en">
<head>
  <link rel="icon" type="image/x-icon" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQz8HFcByuK1fp2KQdFls5532X50P87Ucp1kg&s">

  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Instafoods – Bangalore's Top Restaurants</title>
  <meta name="description" content="Explore Bangalore's finest partner restaurants on Instafoods. Discover authentic cuisines from Koramangala to Indiranagar and get gourmet food delivered in minutes.">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    /* ====================================
       ANIMATIONS & KEYFRAMES
       ==================================== */
    @keyframes fadeSlideUp {
      from { opacity: 0; transform: translateY(36px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    @keyframes shimmer {
      0%   { background-position: -800px 0; }
      100% { background-position: 800px 0; }
    }
    @keyframes pulse-dot {
      0%, 100% { opacity: 1; transform: scale(1); }
      50%       { opacity: 0.5; transform: scale(1.4); }
    }
    @keyframes float-badge {
      0%, 100% { transform: translateY(0px); }
      50%       { transform: translateY(-4px); }
    }
    @keyframes glow-line {
      0%   { background-position: -200% center; }
      100% { background-position: 200% center; }
    }

    /* ====================================
       PAGE HERO
       ==================================== */
    .page-hero {
      padding: 140px 80px 60px;
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
    .page-hero-left h1 {
      font-size: clamp(2.6rem, 5vw, 4.2rem);
      line-height: 0.93;
      margin-bottom: 18px;
      animation: fadeSlideUp 0.7s ease both;
    }
    .page-hero-left p {
      color: var(--text-muted);
      font-size: 1.05rem;
      max-width: 520px;
      line-height: 1.75;
      animation: fadeSlideUp 0.85s 0.1s ease both;
    }
    .page-hero-stats {
      display: flex;
      gap: 14px;
      flex-wrap: wrap;
      animation: fadeSlideUp 0.9s 0.2s ease both;
    }

    /* glowing underline accent on the hero */
    .hero-accent-line {
      height: 3px;
      width: 90px;
      border-radius: 2px;
      background: linear-gradient(90deg, var(--primary), #7fff00, var(--primary));
      background-size: 200% auto;
      animation: glow-line 3s linear infinite;
      margin: 14px 0 22px;
    }

    /* ====================================
       FILTER BAR
       ==================================== */
    .filter-bar {
      padding: 0 80px 52px;
      max-width: 1360px;
      margin: 0 auto;
      animation: fadeSlideUp 0.9s 0.3s ease both;
    }
    .filter-inner {
      display: flex;
      align-items: center;
      gap: 10px;
      flex-wrap: wrap;
    }
    .filter-label {
      font-family: var(--font-heading);
      font-weight: 800;
      font-size: 0.78rem;
      text-transform: uppercase;
      color: var(--text-muted);
      letter-spacing: 1px;
      margin-right: 6px;
    }
    .filter-chip {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 9px 20px;
      border-radius: 50px;
      background: var(--bg-card);
      border: 1px solid var(--border);
      color: var(--text-muted);
      font-family: var(--font-heading);
      font-weight: 800;
      font-size: 0.78rem;
      text-transform: uppercase;
      cursor: pointer;
      transition: all 0.25s ease;
      letter-spacing: 0.5px;
    }
    .filter-chip:hover {
      border-color: var(--primary);
      color: var(--primary);
      background: rgba(202,255,0,0.06);
      transform: translateY(-2px);
    }
    .filter-chip.active {
      background: var(--primary);
      border-color: var(--primary);
      color: #000;
      box-shadow: 0 4px 16px rgba(202,255,0,0.3);
    }

    /* ====================================
       RESTAURANTS GRID
       ==================================== */
    .restaurants-section {
      min-width: 0;
      width: 100%;
      overflow: hidden;
      padding: 0;
    }
    .restaurant-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(310px, 1fr));
      gap: 28px;
      padding-top: 12px;
      margin-top: -12px;
    }

    /* ====================================
       RESTAURANT CARD
       ==================================== */
    .restaurant-card {
      background: var(--bg-card);
      border: 1px solid var(--border);
      border-radius: 16px;
      overflow: hidden;
      text-decoration: none;
      color: inherit;
      display: block;
      position: relative;
      transition: transform 0.35s cubic-bezier(0.34,1.56,0.64,1),
                  box-shadow 0.35s ease,
                  border-color 0.3s ease;
      animation: fadeSlideUp 0.7s ease both;
    }
    /* Staggered animation delays for cards */
    .restaurant-card:nth-child(1)  { animation-delay: 0.05s; }
    .restaurant-card:nth-child(2)  { animation-delay: 0.12s; }
    .restaurant-card:nth-child(3)  { animation-delay: 0.19s; }
    .restaurant-card:nth-child(4)  { animation-delay: 0.26s; }
    .restaurant-card:nth-child(5)  { animation-delay: 0.33s; }
    .restaurant-card:nth-child(6)  { animation-delay: 0.40s; }
    .restaurant-card:nth-child(7)  { animation-delay: 0.47s; }
    .restaurant-card:nth-child(8)  { animation-delay: 0.54s; }
    .restaurant-card:nth-child(9)  { animation-delay: 0.61s; }

    .restaurant-card:hover {
      border-color: var(--primary);
      transform: translateY(-10px) scale(1.01);
      box-shadow: 0 24px 60px rgba(0,0,0,0.6), 0 0 30px rgba(202,255,0,0.10);
    }

    /* Shimmer overlay on hover */
    .restaurant-card::before {
      content: '';
      position: absolute;
      top: 0; left: -100%; width: 60%; height: 100%;
      background: linear-gradient(105deg, transparent 20%, rgba(202,255,0,0.04) 50%, transparent 80%);
      transition: left 0.5s ease;
      z-index: 2;
      pointer-events: none;
    }
    .restaurant-card:hover::before {
      left: 150%;
    }

    /* ---- Image panel ---- */
    .restaurant-img {
      width: 100%;
      height: 220px;
      position: relative;
      overflow: hidden;
    }
    .restaurant-img img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      transition: transform 0.5s ease;
      display: block;
    }
    .restaurant-card:hover .restaurant-img img {
      transform: scale(1.08);
    }
    /* gradient overlay on image */
    .restaurant-img::after {
      content: '';
      position: absolute;
      inset: 0;
      background: linear-gradient(
        to top,
        rgba(8,8,8,0.75) 0%,
        rgba(8,8,8,0.2) 50%,
        transparent 100%
      );
      pointer-events: none;
    }

    /* Restaurant name overlaid on image */
    .img-name-overlay {
      position: absolute;
      bottom: 16px;
      left: 18px;
      right: 60px;
      z-index: 3;
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 1.25rem;
      text-transform: uppercase;
      color: #fff;
      line-height: 1.1;
      text-shadow: 0 2px 8px rgba(0,0,0,0.6);
    }

    /* ---- Status badge ---- */
    .restaurant-status {
      position: absolute;
      top: 14px; right: 14px;
      z-index: 4;
      display: flex;
      align-items: center;
      gap: 6px;
      padding: 6px 14px;
      border-radius: 50px;
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.7rem;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      animation: float-badge 3s ease-in-out infinite;
    }
    .restaurant-status.open {
      background: var(--primary);
      color: #000;
      box-shadow: 0 4px 12px rgba(202,255,0,0.4);
    }
    .restaurant-status.closed {
      background: rgba(40,40,40,0.9);
      border: 1px solid #333;
      color: var(--text-muted);
    }
    .status-dot {
      width: 6px; height: 6px;
      border-radius: 50%;
      background: currentColor;
    }
    .restaurant-status.open .status-dot {
      animation: pulse-dot 1.4s ease-in-out infinite;
    }

    /* ---- Info section ---- */
    .restaurant-info {
      padding: 18px 20px 20px;
    }
    .restaurant-cuisine-tag {
      display: inline-block;
      padding: 3px 10px;
      border-radius: 4px;
      background: rgba(202,255,0,0.1);
      border: 1px solid rgba(202,255,0,0.2);
      font-family: var(--font-heading);
      font-weight: 800;
      font-size: 0.68rem;
      text-transform: uppercase;
      color: var(--primary);
      letter-spacing: 0.8px;
      margin-bottom: 10px;
    }
    .restaurant-name {
      font-family: var(--font-heading);
      font-size: 1.18rem;
      font-weight: 900;
      text-transform: uppercase;
      margin-bottom: 8px;
      line-height: 1.15;
      color: var(--text-primary);
    }
    .restaurant-address {
      font-size: 0.82rem;
      color: var(--text-muted);
      margin-bottom: 16px;
      display: flex;
      align-items: flex-start;
      gap: 7px;
      line-height: 1.5;
    }
    .restaurant-address i {
      color: var(--primary);
      font-size: 0.75rem;
      margin-top: 2px;
      flex-shrink: 0;
    }

    /* ---- Meta row ---- */
    .restaurant-meta {
      display: flex;
      align-items: center;
      justify-content: space-between;
      border-top: 1px solid var(--border);
      padding-top: 14px;
      gap: 10px;
      flex-wrap: wrap;
    }
    .meta-group {
      display: flex;
      align-items: center;
      gap: 16px;
    }
    .meta-item {
      display: flex;
      align-items: center;
      gap: 6px;
      font-size: 0.82rem;
      color: var(--text-muted);
    }
    .meta-item i {
      font-size: 0.78rem;
      color: var(--primary);
    }
    .meta-item strong {
      color: var(--text-primary);
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.9rem;
    }

    /* rating stars */
    .rating-stars {
      display: flex;
      align-items: center;
      gap: 3px;
    }
    .rating-stars i {
      color: #fbbf24;
      font-size: 0.7rem;
    }

    /* View Menu button */
    .view-menu-btn {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 8px 16px;
      border-radius: 50px;
      background: transparent;
      border: 1px solid var(--border);
      color: var(--text-muted);
      font-family: var(--font-heading);
      font-weight: 800;
      font-size: 0.72rem;
      text-transform: uppercase;
      text-decoration: none;
      cursor: pointer;
      transition: all 0.25s ease;
      flex-shrink: 0;
    }
    .view-menu-btn:hover {
      background: var(--primary);
      border-color: var(--primary);
      color: #000;
      transform: translateX(2px);
    }

    /* ====================================
       RESPONSIVE
       ==================================== */
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
</head>
<body>

  <!-- ============ NAVBAR ============ -->
  <header class="navbar" id="navbar">
    <a href="${pageContext.request.contextPath}/LandingServlet" class="logo">
      <span class="logo-text">Insta<span>foods</span></span>
    </a>

    <ul class="nav-links">
      <li><a href="${pageContext.request.contextPath}/ResturantServlet" class="active">Restaurants</a></li>
      <li><a href="${pageContext.request.contextPath}/MenuServlet">Full Menu</a></li>
      <li><a href="${pageContext.request.contextPath}/OrderTrackerServlet">Insta-Tracker</a></li>
      <li>
        <a href="${pageContext.request.contextPath}/CartServlet" onclick="return checkCartAccess(event)">
          <i class="fa-solid fa-cart-shopping" style="margin-right:5px;"></i>Cart
        </a>
      </li>
    </ul>

    <div class="nav-actions">
      <%
          User loggedInUser = (User) session.getAttribute("user");
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
      <div class="page-hero-left">
        <h1>Bengaluru's Finest<br><span class="highlight">Restaurants.</span></h1>
        <div class="hero-accent-line"></div>
        <p>
          Handpicked culinary destinations across Koramangala, Indiranagar, Whitefield &amp; more —
          delivering Namma Bengaluru's best food straight to your door.
        </p>
      </div>
      <div class="page-hero-stats">
        <div class="metric-card">
          <div class="icon"><i class="fa-solid fa-store"></i></div>
          <div class="details">
            <div class="title">50+</div>
            <div class="sub">Partner Restaurants</div>
          </div>
        </div>
        <div class="metric-card">
          <div class="icon"><i class="fa-solid fa-star"></i></div>
          <div class="details">
            <div class="title">4.8 AVG</div>
            <div class="sub">Partner Rating</div>
          </div>
        </div>
        <div class="metric-card">
          <div class="icon"><i class="fa-solid fa-motorcycle"></i></div>
          <div class="details">
            <div class="title">18 MIN</div>
            <div class="sub">Avg Delivery</div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- ============ MAIN CONTENT AREA ============ -->
  <div class="restaurants-page-content">
    
    <!-- FILTER SIDEBAR (Accordion style) -->
    <aside class="filter-sidebar">
      <div class="filter-sidebar-header">
        <h3>Filters</h3>
        <button class="clear-all-filters-btn" onclick="clearAllFilters()">Clear All</button>
      </div>
      
      <div class="filter-accordion">
        <!-- Cuisines Accordion -->
        <div class="accordion-item active">
          <button class="accordion-header" onclick="toggleAccordion(this)">
            <span>Cuisines</span>
            <i class="fa-solid fa-chevron-down"></i>
          </button>
          <div class="accordion-content">
            <label class="filter-checkbox-label">
              <input type="checkbox" name="cuisine" value="South Indian" onchange="applyFilters()">
              <span>South Indian</span>
            </label>
            <label class="filter-checkbox-label">
              <input type="checkbox" name="cuisine" value="North Indian" onchange="applyFilters()">
              <span>North Indian</span>
            </label>
            <label class="filter-checkbox-label">
              <input type="checkbox" name="cuisine" value="Italian" onchange="applyFilters()">
              <span>Italian</span>
            </label>
            <label class="filter-checkbox-label">
              <input type="checkbox" name="cuisine" value="Asian" onchange="applyFilters()">
              <span>Asian</span>
            </label>
            <label class="filter-checkbox-label">
              <input type="checkbox" name="cuisine" value="Cafe & Brunch" onchange="applyFilters()">
              <span>Cafe &amp; Brunch</span>
            </label>
            <label class="filter-checkbox-label">
              <input type="checkbox" name="cuisine" value="Fast Food" onchange="applyFilters()">
              <span>Fast Food</span>
            </label>
            <label class="filter-checkbox-label">
              <input type="checkbox" name="cuisine" value="Pizza" onchange="applyFilters()">
              <span>Pizza</span>
            </label>
            <label class="filter-checkbox-label">
              <input type="checkbox" name="cuisine" value="Vegetarian" onchange="applyFilters()">
              <span>Vegetarian</span>
            </label>
          </div>
        </div>
        
        <!-- Status Accordion -->
        <div class="accordion-item active">
          <button class="accordion-header" onclick="toggleAccordion(this)">
            <span>Status</span>
            <i class="fa-solid fa-chevron-down"></i>
          </button>
          <div class="accordion-content">
            <label class="filter-checkbox-label">
              <input type="checkbox" name="status" value="open" onchange="applyFilters()">
              <span>Open Now</span>
            </label>
          </div>
        </div>

        <!-- Rating Accordion -->
        <div class="accordion-item">
          <button class="accordion-header" onclick="toggleAccordion(this)">
            <span>Rating</span>
            <i class="fa-solid fa-chevron-down"></i>
          </button>
          <div class="accordion-content">
            <label class="filter-radio-label">
              <input type="radio" name="rating" value="all" checked onchange="applyFilters()">
              <span>Show All</span>
            </label>
            <label class="filter-radio-label">
              <input type="radio" name="rating" value="4.5" onchange="applyFilters()">
              <span>4.5 ★ &amp; above</span>
            </label>
            <label class="filter-radio-label">
              <input type="radio" name="rating" value="4.0" onchange="applyFilters()">
              <span>4.0 ★ &amp; above</span>
            </label>
          </div>
        </div>

        <!-- Delivery Time Accordion -->
        <div class="accordion-item">
          <button class="accordion-header" onclick="toggleAccordion(this)">
            <span>Delivery Time</span>
            <i class="fa-solid fa-chevron-down"></i>
          </button>
          <div class="accordion-content">
            <label class="filter-radio-label">
              <input type="radio" name="delivery" value="all" checked onchange="applyFilters()">
              <span>Show All</span>
            </label>
            <label class="filter-radio-label">
              <input type="radio" name="delivery" value="25" onchange="applyFilters()">
              <span>Under 25 mins</span>
            </label>
            <label class="filter-radio-label">
              <input type="radio" name="delivery" value="35" onchange="applyFilters()">
              <span>Under 35 mins</span>
            </label>
            <label class="filter-radio-label">
              <input type="radio" name="delivery" value="45" onchange="applyFilters()">
              <span>Under 45 mins</span>
            </label>
          </div>
        </div>
      </div>
    </aside>

    <main class="restaurants-section" style="padding: 0;">
      <div class="restaurant-grid" id="restaurant-grid">
     <%
  List<Restaurant> restaurantList = (List<Restaurant>)request.getAttribute("allrestaurant");
  if(restaurantList != null){
      for(Restaurant r : restaurantList){
  %>

  <a href="MenuServlet?restaurant_id=<%=r.getResturant_id()%>"
     class="restaurant-card"
     data-name="<%=r.getName()%>"
     data-cuisine="<%=r.getCuisine_type()%>"
     data-delivery-time="<%=r.getDelivery_time()%>"
     data-address="<%=r.getAddress()%>"
     data-rating="<%=r.getRating()%>"
     data-image="<%=r.getImage_path() != null && !r.getImage_path().trim().isEmpty() ? r.getImage_path() : "images/rest_south_indian.png" %>"
     data-active="<%=r.getIs_active()%>">

      <div class="restaurant-img">
          <img src="<%=r.getImage_path() != null && !r.getImage_path().trim().isEmpty() ? r.getImage_path() : "images/rest_south_indian.png" %>"
               alt="<%=r.getName()%>"
               loading="lazy">

          <% if(r.getIs_active()){ %>
              <span class="restaurant-status open">
                  <span class="status-dot"></span>
                  Open
              </span>
          <% } else { %>
              <span class="restaurant-status closed">
                  <span class="status-dot"></span>
                  Closed
              </span>
          <% } %>

          <div class="img-name-overlay">
              <%=r.getName()%>
          </div>
      </div>

      <div class="restaurant-info">
          <span class="restaurant-cuisine-tag">
              <%=r.getCuisine_type()%>
          </span>

          <div class="restaurant-header-row">
              <h3 class="restaurant-name">
                  <%=r.getName()%>
              </h3>
              <div class="restaurant-rating">
                  <i class="fa-solid fa-star"></i>
                  <span><%=r.getRating()%></span>
              </div>
          </div>

          <p class="restaurant-address">
              <i class="fa-solid fa-location-dot"></i>
              <%=r.getAddress()%>
          </p>

          <div class="restaurant-footer-row">
              <span class="delivery-time-badge">
                  <i class="fa-solid fa-clock"></i>
                  <%=r.getDelivery_time()%> Mins
              </span>
              <span class="view-menu-btn">
                  View Menu
                  <i class="fa-solid fa-arrow-right"></i>
              </span>
          </div>
      </div>
  </a>

  <%
      }
  }
  %>
     

    </div><!-- /restaurant-grid -->
  </main>
</div>

  <!-- ============ CTA SECTION ============ -->
  <section class="cta-section">
    <div class="cta-banner">
      <div>
        <h2>Can't Find Your Spot? <span class="highlight">We're Expanding.</span></h2>
        <p>New restaurant partners added every week. Sign up to get notified and unlock exclusive early-access menus.</p>
      </div>
      <a href="${pageContext.request.contextPath}/views/signup.jsp" class="btn btn-primary" style="flex-shrink:0;">Join Instafoods</a>
    </div>
  </section>

  <!-- ============ FOOTER ============ -->
  <footer>
    <a href="${pageContext.request.contextPath}/LandingServlet" class="logo">
      <span class="logo-text">Insta<span>foods</span></span>
    </a>
    <p>&copy; 2026 Instafoods Technologies. Namma Bengaluru's Delivery Movement.</p>
    <ul class="footer-nav">
      <li><a href="#">Privacy policy</a></li>
      <li><a href="#">Terms of use</a></li>
      <li><a href="#">Support desk</a></li>
    </ul>
  </footer>

<script>
  /* ---- Navbar scroll effect ---- */
  const navbar = document.getElementById('navbar');
  window.addEventListener('scroll', () => {
    navbar.classList.toggle('scrolled', window.scrollY > 40);
  });

  /* ---- Accordion Toggle ---- */
  function toggleAccordion(btn) {
    const item = btn.parentElement;
    item.classList.toggle('active');
  }

  /* ---- Apply Filters ---- */
  function applyFilters() {
    // Get selected cuisines
    const selectedCuisines = [];
    document.querySelectorAll('input[name="cuisine"]:checked').forEach(cb => {
      selectedCuisines.push(cb.value);
    });

    // Get status filter
    const openOnly = document.querySelector('input[name="status"]:checked') !== null;

    // Get rating filter
    const ratingVal = document.querySelector('input[name="rating"]:checked').value;
    const minRating = ratingVal === 'all' ? 0 : parseFloat(ratingVal);

    // Get delivery time filter
    const deliveryVal = document.querySelector('input[name="delivery"]:checked').value;
    const maxDelivery = deliveryVal === 'all' ? 999 : parseInt(deliveryVal);

    const cards = document.querySelectorAll('.restaurant-card');
    let visibleIdx = 0;
    
    cards.forEach(card => {
      const cuisine  = card.getAttribute('data-cuisine');
      const rating   = parseFloat(card.getAttribute('data-rating'));
      const delivery = parseInt(card.getAttribute('data-delivery-time'));
      const isActive = card.getAttribute('data-active') === 'true';

      let matchesCuisine = selectedCuisines.length === 0 || selectedCuisines.includes(cuisine);
      let matchesStatus = !openOnly || isActive;
      let matchesRating = rating >= minRating;
      let matchesDelivery = delivery <= maxDelivery;

      if (matchesCuisine && matchesStatus && matchesRating && matchesDelivery) {
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
        noResults.innerHTML = '<i class="fa-solid fa-utensils" style="font-size:2rem;color:var(--primary);display:block;margin-bottom:16px;"></i>No restaurants match the selected filters.';
        document.getElementById('restaurant-grid').appendChild(noResults);
      }
      noResults.style.display = 'block';
    } else if (noResults) {
      noResults.style.display = 'none';
    }
    
    // Refresh card slider pagination and thumb position
    const gridEl = document.getElementById('restaurant-grid');
    if (gridEl) {
      gridEl.dispatchEvent(new Event('update-slider'));
    }
  }

  /* ---- Clear All Filters ---- */
  function clearAllFilters() {
    document.querySelectorAll('input[name="cuisine"]').forEach(cb => cb.checked = false);
    document.querySelectorAll('input[name="status"]').forEach(cb => cb.checked = false);
    document.querySelector('input[name="rating"][value="all"]').checked = true;
    document.querySelector('input[name="delivery"][value="all"]').checked = true;
    applyFilters();
  }

  /* ---- Hamburger menu ---- */
  const hamburger = document.getElementById('hamburger');
  if (hamburger) {
    hamburger.addEventListener('click', () => {
      document.querySelector('.nav-links').classList.toggle('open');
      hamburger.classList.toggle('open');
    });
  }

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
<script src="${pageContext.request.contextPath}/slider.js?v=4" defer></script>
</body>
</html>
