<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.instafoo.Model.Cart" %>
<%@ page import="com.instafoo.Model.CartItem" %>
<%@ page import="com.instafoo.Model.User" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.instafoo.daoImp.RestaurantDaoImp" %>
<%@ page import="com.instafoo.Model.Restaurant" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <link rel="icon" type="image/x-icon" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQz8HFcByuK1fp2KQdFls5532X50P87Ucp1kg&s">

  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Instafoods — Your Cart</title>
  <meta name="description" content="Review your Instafoods order, adjust quantities and proceed to checkout for fast gourmet delivery.">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

  <%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null) {
        session.setAttribute("errorMsg", "Please sign in to access your cart.");
        response.sendRedirect(request.getContextPath() + "/views/login.jsp");
        return;
    }
    /* ── Fetch cart from session ── */
    Cart cart = (Cart) session.getAttribute("cart");
    Map<Integer, CartItem> cartItems = (cart != null) ? cart.getItems() : new HashMap<>();
    boolean isEmpty = (cartItems == null || cartItems.isEmpty());

    /* ── Compute totals server-side ── */
    double subtotal = 0;
    int    totalQty = 0;
    if (!isEmpty) {
      for (CartItem ci : cartItems.values()) {
        subtotal += ci.getPrice() * ci.getQuantity();
        totalQty += ci.getQuantity();
      }
    }
    double tax       = subtotal * 0.05;
    double platform  = 20.0;
    double grandTotal = subtotal + tax + platform; // promo applied client-side

    /* ── Resolve Back-to-Menu URL ── */
    Integer currentRestaurantId = (Integer) session.getAttribute("restaurantId");
    String backToMenuUrl = (currentRestaurantId != null && currentRestaurantId != -1) 
        ? request.getContextPath() + "/MenuServlet?restaurant_id=" + currentRestaurantId 
        : request.getContextPath() + "/ResturantServlet";

    /* ── Group items by restaurant ID ── */
    Map<Integer, List<CartItem>> itemsByRestaurant = new HashMap<>();
    if (!isEmpty) {
      for (CartItem ci : cartItems.values()) {
        int restId = ci.getRestaurantId();
        if (!itemsByRestaurant.containsKey(restId)) {
          itemsByRestaurant.put(restId, new ArrayList<>());
        }
        itemsByRestaurant.get(restId).add(ci);
      }
    }
  %>

  <style>
    /* =============================================
       PAGE LAYOUT
       ============================================= */
    .cart-page {
      min-height: 100vh;
      background: var(--bg-dark);
      padding-top: 72px;
    }

    /* =============================================
       PAGE HERO BAR
       ============================================= */
    .cart-hero {
      background: #060606;
      border-bottom: 1px solid var(--border);
      padding: 40px 80px 36px;
    }
    .cart-hero-inner {
      max-width: 1200px;
      margin: 0 auto;
      display: flex;
      align-items: flex-end;
      justify-content: space-between;
      flex-wrap: wrap;
      gap: 20px;
    }
    .cart-hero h1 {
      font-size: clamp(2rem, 3.5vw, 3rem);
      line-height: 0.95;
      margin-bottom: 8px;
    }
    .cart-hero p { color: var(--text-muted); font-size: 0.95rem; }

    .cart-count-badge {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      background: rgba(202,255,0,0.1);
      border: 1px solid rgba(202,255,0,0.25);
      border-radius: 100px;
      padding: 7px 18px;
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.78rem;
      text-transform: uppercase;
      color: var(--primary);
      letter-spacing: 0.5px;
    }
    .cart-count-badge .dot {
      width: 8px; height: 8px;
      background: var(--primary);
      border-radius: 50%;
      animation: pulse 1.8s ease-in-out infinite;
    }
    @keyframes pulse {
      0%,100% { opacity:1; transform:scale(1); }
      50%      { opacity:0.4; transform:scale(0.7); }
    }

    /* =============================================
       MAIN CONTENT GRID
       ============================================= */
    .cart-content {
      max-width: 1200px;
      margin: 0 auto;
      padding: 48px 80px 80px;
      display: grid;
      grid-template-columns: 1fr 380px;
      gap: 32px;
      align-items: start;
    }

    /* =============================================
       LEFT — CART ITEMS
       ============================================= */
    .cart-left { display: flex; flex-direction: column; gap: 28px; }

    .cart-restaurant-group {
      background: var(--bg-card);
      border: 1px solid var(--border);
      border-radius: 14px;
      overflow: hidden;
    }
    .crg-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 20px 24px;
      border-bottom: 1px solid var(--border);
      gap: 16px;
    }
    .crg-header-left { display: flex; align-items: center; gap: 14px; }
    .crg-emoji {
      width: 44px; height: 44px;
      background: #1a1a1a;
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.5rem;
      border: 1px solid rgba(255,255,255,0.06);
      flex-shrink: 0;
    }
    .crg-name {
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 1.05rem;
      text-transform: uppercase;
    }
    .crg-meta {
      font-size: 0.78rem;
      color: var(--text-muted);
      margin-top: 2px;
      display: flex;
      align-items: center;
      gap: 10px;
    }
    .crg-meta i { color: var(--primary); font-size: 0.72rem; }
    .crg-status {
      display: flex;
      align-items: center;
      gap: 6px;
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.68rem;
      text-transform: uppercase;
      color: var(--primary);
      background: rgba(202,255,0,0.1);
      border: 1px solid rgba(202,255,0,0.2);
      padding: 4px 12px;
      border-radius: 100px;
    }
    .crg-status .dot-sm {
      width: 6px; height: 6px;
      background: var(--primary);
      border-radius: 50%;
    }

    /* Cart Item Row */
    .cart-item {
      display: flex;
      align-items: center;
      gap: 18px;
      padding: 20px 24px;
      border-bottom: 1px solid var(--border);
      transition: background 0.2s;
    }
    .cart-item:last-of-type { border-bottom: none; }
    .cart-item:hover { background: rgba(255,255,255,0.02); }

    .ci-emoji {
      width: 60px; height: 60px;
      background: #1a1a1a;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.8rem;
      flex-shrink: 0;
      border: 1px solid rgba(255,255,255,0.06);
    }
    .ci-info { flex: 1; min-width: 0; }
    .ci-name {
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.95rem;
      text-transform: uppercase;
      margin-bottom: 4px;
      color: #fff;
    }
    .ci-price-unit {
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.8rem;
      color: var(--primary);
      margin-top: 4px;
    }

    /* Quantity control */
    .ci-qty {
      display: flex;
      align-items: center;
      background: #1a1a1a;
      border: 1px solid var(--border);
      border-radius: 6px;
      overflow: hidden;
      flex-shrink: 0;
    }
    .ci-qty-btn {
      width: 36px; height: 36px;
      background: transparent;
      border: none;
      color: var(--text-muted);
      font-size: 0.9rem;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: background 0.15s, color 0.15s;
    }
    .ci-qty-btn:hover { background: #222; color: var(--primary); }
    .ci-qty-val {
      width: 36px;
      text-align: center;
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.9rem;
      color: #fff;
      border-left: 1px solid var(--border);
      border-right: 1px solid var(--border);
      height: 36px;
      display: flex;
      align-items: center;
      justify-content: center;
      user-select: none;
    }

    /* Line total */
    .ci-total {
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 1.05rem;
      color: #fff;
      min-width: 72px;
      text-align: right;
      flex-shrink: 0;
    }

    /* Remove button */
    .ci-remove {
      background: none;
      border: none;
      color: var(--text-muted);
      cursor: pointer;
      padding: 6px;
      border-radius: 4px;
      transition: color 0.2s, background 0.2s;
      flex-shrink: 0;
    }
    .ci-remove:hover { color: #ff4757; background: rgba(255,71,87,0.08); }

    .crg-delivery-note {
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 14px 24px;
      background: rgba(202,255,0,0.04);
      border-top: 1px solid rgba(202,255,0,0.1);
      font-size: 0.82rem;
      color: var(--text-muted);
    }
    .crg-delivery-note i { color: var(--primary); }
    .crg-delivery-note strong { color: var(--primary); }

    /* =============================================
       PROMO / COUPON BAR
       ============================================= */
    .promo-bar {
      background: var(--bg-card);
      border: 1px solid var(--border);
      border-radius: 14px;
      padding: 20px 24px;
      display: flex;
      align-items: center;
      gap: 14px;
    }
    .promo-icon {
      width: 42px; height: 42px;
      border-radius: 8px;
      background: rgba(202,255,0,0.08);
      border: 1px solid rgba(202,255,0,0.15);
      display: flex;
      align-items: center;
      justify-content: center;
      color: var(--primary);
      font-size: 1rem;
      flex-shrink: 0;
    }
    .promo-input-wrap { flex: 1; display: flex; flex-direction: column; gap: 6px; }
    .promo-input-wrap label {
      font-family: var(--font-heading);
      font-weight: 800;
      font-size: 0.72rem;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      color: var(--text-muted);
    }
    .promo-row { display: flex; gap: 10px; }
    .promo-row input {
      flex: 1;
      background: #1a1a1a;
      border: 1px solid var(--border);
      color: #fff;
      padding: 10px 14px;
      font-family: var(--font-body);
      font-size: 0.88rem;
      border-radius: 6px;
      outline: none;
      transition: border-color 0.2s;
      text-transform: uppercase;
      letter-spacing: 1px;
    }
    .promo-row input::placeholder { color: var(--text-muted); letter-spacing: 0; text-transform: none; }
    .promo-row input:focus { border-color: var(--primary); box-shadow: 0 0 10px rgba(202,255,0,0.1); }
    .promo-apply-btn {
      padding: 10px 20px;
      background: var(--primary);
      color: #000;
      border: none;
      border-radius: 6px;
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.78rem;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      cursor: pointer;
      transition: background 0.2s;
      white-space: nowrap;
    }
    .promo-apply-btn:hover { background: var(--primary-light); }

    /* =============================================
       RIGHT — ORDER SUMMARY
       ============================================= */
    .cart-right {
      position: sticky;
      top: 88px;
      display: flex;
      flex-direction: column;
      gap: 20px;
    }

    .summary-panel {
      background: var(--bg-card);
      border: 1px solid var(--border);
      border-radius: 14px;
      overflow: hidden;
    }
    .summary-panel-header {
      padding: 20px 24px 16px;
      border-bottom: 1px solid var(--border);
    }
    .summary-panel-header h3 {
      font-size: 0.9rem;
      letter-spacing: 0.5px;
      font-weight: 900;
    }
    .summary-rows { padding: 0 24px; }
    .summary-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 14px 0;
      border-bottom: 1px solid rgba(255,255,255,0.04);
      font-size: 0.88rem;
      color: var(--text-muted);
    }
    .summary-row:last-child { border-bottom: none; }
    .summary-row .label { display: flex; align-items: center; gap: 8px; }
    .summary-row .label i { color: var(--primary); font-size: 0.8rem; width: 14px; text-align: center; }
    .summary-row .value { font-family: var(--font-heading); font-weight: 900; font-size: 0.9rem; color: #fff; }
    .summary-row .value.free { color: var(--primary); }
    .summary-row .value.discount { color: #ff4757; }

    .summary-total-row {
      margin: 0 24px;
      padding: 18px 0;
      border-top: 1px solid rgba(255,255,255,0.1);
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .summary-total-row .total-label {
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.88rem;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
    .summary-total-row .total-value {
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 1.6rem;
      color: #fff;
    }

    .summary-cta { padding: 16px 24px 24px; display: flex; flex-direction: column; gap: 10px; }
    .checkout-btn {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
      padding: 16px;
      background: var(--primary);
      color: #000;
      border: none;
      border-radius: 6px;
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.95rem;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      cursor: pointer;
      transition: background 0.2s, transform 0.15s, box-shadow 0.2s;
      width: 100%;
    }
    .checkout-btn:hover {
      background: var(--primary-light);
      transform: translateY(-2px);
      box-shadow: 0 8px 24px rgba(202,255,0,0.3);
    }
    .continue-btn {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      padding: 12px;
      background: transparent;
      color: var(--text-muted);
      border: 1px solid var(--border);
      border-radius: 6px;
      font-family: var(--font-heading);
      font-weight: 800;
      font-size: 0.82rem;
      text-transform: uppercase;
      cursor: pointer;
      transition: all 0.2s;
      text-decoration: none;
      width: 100%;
    }
    .continue-btn:hover { border-color: var(--primary); color: var(--primary); }

    .summary-trust {
      display: flex;
      gap: 8px;
      flex-wrap: wrap;
      padding: 0 24px 20px;
    }
    .trust-pill {
      display: flex;
      align-items: center;
      gap: 5px;
      font-family: var(--font-heading);
      font-weight: 800;
      font-size: 0.65rem;
      text-transform: uppercase;
      color: var(--text-muted);
    }
    .trust-pill i { color: var(--primary); font-size: 0.65rem; }

    /* Delivery estimate card */
    .delivery-est-card {
      background: var(--bg-card);
      border: 1px solid rgba(202,255,0,0.15);
      border-radius: 14px;
      padding: 18px 20px;
      display: flex;
      align-items: center;
      gap: 14px;
    }
    .dec-icon {
      width: 44px; height: 44px;
      background: rgba(202,255,0,0.1);
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      color: var(--primary);
      font-size: 1.1rem;
      flex-shrink: 0;
    }
    .dec-info .dec-label { font-size: 0.72rem; color: var(--text-muted); text-transform: uppercase; font-family: var(--font-heading); font-weight: 800; letter-spacing: 0.4px; }
    .dec-info .dec-val { font-family: var(--font-heading); font-weight: 900; font-size: 1.15rem; color: #fff; margin-top: 2px; }
    .dec-info .dec-sub { font-size: 0.72rem; color: var(--text-muted); margin-top: 1px; }

    /* =============================================
       EMPTY CART STATE
       ============================================= */
    .empty-cart {
      display: none;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      text-align: center;
      padding: 100px 40px;
      gap: 20px;
    }
    .empty-cart.active { display: flex; }
    .empty-cart-icon {
      width: 100px; height: 100px;
      background: #111;
      border: 1px solid var(--border);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 2.8rem;
      margin-bottom: 8px;
    }
    .empty-cart h2 { font-size: 1.8rem; margin-bottom: 8px; }
    .empty-cart p { color: var(--text-muted); font-size: 0.95rem; max-width: 320px; margin-bottom: 20px; }

    /* Promo message */
    .promo-msg {
      font-size: 0.8rem;
      margin-top: 4px;
      padding: 6px 10px;
      border-radius: 4px;
    }
    .promo-msg.success { background: rgba(202,255,0,0.08); color: var(--primary); border: 1px solid rgba(202,255,0,0.2); }
    .promo-msg.error   { background: rgba(255,71,87,0.08);  color: #ff4757;         border: 1px solid rgba(255,71,87,0.2);  }

    /* =============================================
       RESPONSIVE
       ============================================= */
    @media (max-width: 1024px) {
      .cart-content { grid-template-columns: 1fr; padding: 32px 40px 60px; }
      .cart-right { position: static; }
      .cart-hero { padding: 32px 40px 28px; }
    }
    @media (max-width: 640px) {
      .cart-content { padding: 24px 20px 48px; }
      .cart-hero { padding: 24px 20px; }
      .cart-item { gap: 12px; padding: 16px; }
      .ci-emoji { width: 48px; height: 48px; font-size: 1.4rem; }
    }
  </style>
</head>
<body>

  <!-- ==============================
       NAVBAR
       ============================== -->
  <header class="navbar" id="navbar">
    <a href="${pageContext.request.contextPath}/LandingServlet" class="logo">
      <span class="logo-text">Insta<span>foods</span></span>
    </a>
    <ul class="nav-links">
      <li><a href="${pageContext.request.contextPath}/ResturantServlet">Restaurants</a></li>
      <li><a href="${pageContext.request.contextPath}/MenuServlet">Full Menu</a></li>
      <li><a href="${pageContext.request.contextPath}/OrderTrackerServlet">Insta-Tracker</a></li>
      <li>
        <a href="${pageContext.request.contextPath}/views/cart.jsp" class="active">
          <i class="fa-solid fa-cart-shopping" style="margin-right:5px;"></i>Cart
          <span id="navCartCount"
                style="background:var(--primary);color:#000;font-size:0.65rem;
                       padding:2px 6px;border-radius:100px;font-family:var(--font-heading);
                       font-weight:900;margin-left:2px;">
            <%= totalQty %>
          </span>
        </a>
      </li>
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
              <a href="${pageContext.request.contextPath}/LogoutServlet" style="display: flex; align-items: center; gap: 8px; padding: 12px 16px; color: #ff4a4a; text-decoration: none; font-size: 0.82rem; font-family: var(--font-heading), sans-serif; font-weight: 800; text-transform: uppercase; transition: background 0.2s;" onmouseover="this.style.backgroundColor='rgba(255, 74, 74, 0.08)'" onmouseout="this.style.backgroundColor='transparent'">
                <i class="fa-solid fa-arrow-right-from-bracket" style="font-size: 0.9rem;"></i> Sign Out
              </a>
            </div>
          </div>
      <% } else { %>
          <a href="${pageContext.request.contextPath}/views/login.jsp" class="btn btn-outline" style="border:none;padding:10px 16px;">Sign In</a>
      <% } %>
    </div>
    <div class="hamburger" id="hamburger"><span></span><span></span><span></span></div>
  </header>


  <!-- ==============================
       CART PAGE
       ============================== -->
  <div class="cart-page">

    <!-- Hero bar -->
    <div class="cart-hero">
      <div class="cart-hero-inner">
        <div>
          <h1>Your <span class="highlight">Cart.</span></h1>
          <p>Review your order, apply offers and proceed to checkout.</p>
        </div>
        <div class="cart-count-badge">
          <span class="dot"></span>
          <span id="cartItemLabel">
            <% if (isEmpty) { %>
              Empty
            <% } else { %>
              <%= totalQty %> Item<%= totalQty != 1 ? "s" : "" %>
            <% } %>
          </span>
        </div>
      </div>
    </div>


    <!-- ── Main grid (hidden when cart is empty) ── -->
    <div class="cart-content" id="cartContent"
         style="<%= isEmpty ? "display:none;" : "" %>">

      <!-- ===== LEFT PANEL ===== -->
      <div class="cart-left">

        <%
          if (!isEmpty) {
            RestaurantDaoImp restaurantDao = new RestaurantDaoImp();
            for (Map.Entry<Integer, List<CartItem>> entry : itemsByRestaurant.entrySet()) {
              int restId = entry.getKey();
              List<CartItem> itemsInRest = entry.getValue();
              Restaurant rest = restaurantDao.getRestaurantById(restId);
              
              String restName = (rest != null) ? rest.getName() : "Your Order";
              String restCuisine = (rest != null) ? rest.getCuisine_type() : "";
              String restAddress = (rest != null) ? rest.getAddress() : "Bengaluru";
              
              // Resolve emoji based on cuisine
              String emoji = "🛒";
              if (rest != null && restCuisine != null) {
                String cuisine = restCuisine.toLowerCase();
                if (cuisine.contains("south indian")) emoji = "🫓";
                else if (cuisine.contains("north indian")) emoji = "🍛";
                else if (cuisine.contains("italian") || cuisine.contains("pizza")) emoji = "🍕";
                else if (cuisine.contains("asian")) emoji = "🍜";
                else if (cuisine.contains("cafe") || cuisine.contains("brunch")) emoji = "☕";
                else emoji = "🍔";
              }
        %>

        <div class="cart-restaurant-group" style="margin-bottom: 24px;">
          <div class="crg-header">
            <div class="crg-header-left">
              <div class="crg-emoji"><%= emoji %></div>
              <div>
                <div class="crg-name"><%= restName %></div>
                <div class="crg-meta">
                  <span><%= restCuisine %> &nbsp;·&nbsp; <i class="fa-solid fa-location-dot"></i> <%= restAddress %></span>
                </div>
              </div>
            </div>
            <div class="crg-status"><span class="dot-sm"></span> Active</div>
          </div>

          <%-- Loop through the items for this restaurant --%>
          <%
            for (CartItem ci : itemsInRest) {
              double lineTotal = ci.getPrice() * ci.getQuantity();
          %>
          <div class="cart-item" data-id="<%= ci.getMenuId() %>" data-price="<%= ci.getPrice() %>">
            <div class="ci-emoji" style="overflow: hidden; padding: 0;">
              <% if (ci.getImagePath() != null && !ci.getImagePath().trim().isEmpty()) { %>
                <img src="<%= ci.getImagePath() %>" alt="<%= ci.getName() %>" style="width: 100%; height: 100%; object-fit: cover; display: block;">
              <% } else { %>
                🍽️
              <% } %>
            </div>
            <div class="ci-info">
              <div class="ci-name"><%= ci.getName() %></div>
              <div class="ci-price-unit">₹<%= String.format("%.2f", ci.getPrice()) %> / item</div>
            </div>

            <!-- Quantity stepper (calls CartServlet for real updates) -->
            <div class="ci-qty">
              <button class="ci-qty-btn"
                      onclick="servletQty(<%= ci.getMenuId() %>, <%= ci.getRestaurantId() %>, 'decrease')"
                      aria-label="Decrease quantity">
                <i class="fa-solid fa-minus"></i>
              </button>
              <div class="ci-qty-val" id="qty-<%= ci.getMenuId() %>"><%= ci.getQuantity() %></div>
              <button class="ci-qty-btn"
                      onclick="servletQty(<%= ci.getMenuId() %>, <%= ci.getRestaurantId() %>, 'increase')"
                      aria-label="Increase quantity">
                <i class="fa-solid fa-plus"></i>
              </button>
            </div>

            <div class="ci-total" id="total-<%= ci.getMenuId() %>">
              ₹<%= String.format("%.2f", lineTotal) %>
            </div>

            <!-- Remove: POST to CartServlet action=delete then reload -->
            <form method="post" action="${pageContext.request.contextPath}/CartServlet" style="margin:0;">
              <input type="hidden" name="action"       value="delete">
              <input type="hidden" name="menuId"       value="<%= ci.getMenuId() %>">
              <input type="hidden" name="restaurantId" value="<%= ci.getRestaurantId() %>">
              <button type="submit" class="ci-remove" aria-label="Remove item">
                <i class="fa-solid fa-trash-can"></i>
              </button>
            </form>
          </div>
          <% } %>

          <div class="crg-delivery-note">
            <i class="fa-solid fa-truck-fast"></i>
            Estimated delivery: <strong>20–30 mins</strong> &nbsp;·&nbsp; Free delivery applied
          </div>
        </div>
        <%
            } /* end outer loop */
          } /* end if !isEmpty */
        %>

        <!-- Promo / Coupon -->
        <div class="promo-bar">
          <div class="promo-icon"><i class="fa-solid fa-tag"></i></div>
          <div class="promo-input-wrap">
            <label for="promoCode">Promo Code</label>
            <div class="promo-row">
              <input type="text" id="promoCode" placeholder="e.g. INSTA150" maxlength="12">
              <button class="promo-apply-btn" onclick="applyPromo()">Apply</button>
            </div>
            <div id="promoMsg" class="promo-msg" style="display:none;"></div>
          </div>
        </div>

        <a href="<%= backToMenuUrl %>" class="continue-btn" style="width:auto; align-self:flex-start;">
          <i class="fa-solid fa-arrow-left"></i> Continue Adding Items
        </a>

      </div><!-- /cart-left -->


      <!-- ===== RIGHT PANEL ===== -->
      <div class="cart-right">

        <div class="delivery-est-card">
          <div class="dec-icon"><i class="fa-solid fa-truck-fast"></i></div>
          <div class="dec-info">
            <div class="dec-label">Estimated Arrival</div>
            <div class="dec-val">20–30 mins</div>
            <div class="dec-sub">Based on your order</div>
          </div>
        </div>

        <div class="summary-panel">
          <div class="summary-panel-header">
            <h3>Order Summary</h3>
          </div>

          <div class="summary-rows">
            <div class="summary-row">
              <span class="label"><i class="fa-solid fa-receipt"></i> Subtotal</span>
              <span class="value" id="summarySubtotal">
                ₹<%= String.format("%.2f", subtotal) %>
              </span>
            </div>
            <div class="summary-row">
              <span class="label"><i class="fa-solid fa-truck-fast"></i> Delivery Fee</span>
              <span class="value free">FREE</span>
            </div>
            <div class="summary-row">
              <span class="label"><i class="fa-solid fa-tag"></i> Promo Discount</span>
              <span class="value discount" id="summaryDiscount">— ₹0.00</span>
            </div>
            <div class="summary-row">
              <span class="label"><i class="fa-solid fa-shield-halved"></i> Platform Fee</span>
              <span class="value">₹20.00</span>
            </div>
            <div class="summary-row">
              <span class="label"><i class="fa-solid fa-percent"></i> GST &amp; Taxes (5%)</span>
              <span class="value" id="summaryTax">
                ₹<%= String.format("%.2f", tax) %>
              </span>
            </div>
          </div>

          <div class="summary-total-row">
            <span class="total-label">Total</span>
            <span class="total-value" id="summaryTotal">
              ₹<%= String.format("%.2f", grandTotal) %>
            </span>
          </div>

          <div class="summary-cta">
            <button class="checkout-btn" onclick="window.location.href='${pageContext.request.contextPath}/views/checkout.jsp'">
              <i class="fa-solid fa-lock"></i>
              Proceed to Checkout
              <i class="fa-solid fa-arrow-right"></i>
            </button>
            <a href="<%= backToMenuUrl %>" class="continue-btn">
              <i class="fa-solid fa-utensils"></i>
              Add More Items
            </a>
          </div>

          <div class="summary-trust">
            <span class="trust-pill"><i class="fa-solid fa-shield-halved"></i> Secure Checkout</span>
            <span class="trust-pill" style="margin-left:8px;"><i class="fa-solid fa-rotate-left"></i> Easy Refunds</span>
            <span class="trust-pill" style="margin-left:8px;"><i class="fa-solid fa-fire-flame-curved"></i> Hot Guaranteed</span>
          </div>
        </div>

      </div><!-- /cart-right -->

    </div><!-- /cart-content -->


    <!-- Empty cart state -->
    <div class="empty-cart <%= isEmpty ? "active" : "" %>" id="emptyCart">
      <div class="empty-cart-icon">🛒</div>
      <h2>Your cart is <span class="highlight">empty.</span></h2>
      <p>Looks like you haven't added any items yet. Browse our restaurants and discover something amazing.</p>
      <a href="${pageContext.request.contextPath}/ResturantServlet" class="btn btn-primary">
        <i class="fa-solid fa-store"></i> Browse Restaurants
      </a>
      <a href="${pageContext.request.contextPath}/MenuServlet" class="btn btn-secondary" style="margin-top: -8px;">
        <i class="fa-solid fa-utensils"></i> View Full Menu
      </a>
    </div>

  </div><!-- /cart-page -->


  <footer>
    <a href="${pageContext.request.contextPath}/LandingServlet" class="logo">
      <span class="logo-text">Insta<span>foods</span></span>
    </a>
    <p>&copy; 2026 Instafoods Technologies. Fast Delivery Movement.</p>
    <ul class="footer-nav">
      <li><a href="#">Privacy Policy</a></li>
      <li><a href="#">Terms of Use</a></li>
      <li><a href="#">Support Desk</a></li>
    </ul>
  </footer>


  <script>
    /* ── Navbar scroll ── */
    const navbar = document.getElementById('navbar');
    window.addEventListener('scroll', () => {
      navbar.classList.toggle('scrolled', window.scrollY > 40);
    });

    /* ── Server-side prices (used for client-side recalculation) ──
       We keep a JS mirror of the cart so the summary updates instantly
       without a full page reload on qty change.                         */
    const items = {
      <%
        if (!isEmpty) {
          boolean first = true;
          for (CartItem ci : cartItems.values()) {
            if (!first) out.print(",");
            out.print(ci.getMenuId() + ": { price: " + ci.getPrice()
                      + ", qty: " + ci.getQuantity() + " }");
            first = false;
          }
        }
      %>
    };
    let promoDiscount = 0;

    /* ── Quantity change via CartServlet ── */
    function servletQty(menuId, restaurantId, direction) {
      const current = parseInt(document.getElementById('qty-' + menuId).textContent);
      let newQty = direction === 'increase' ? current + 1 : current - 1;

      if (newQty < 1) {
        // Confirm before removing
        if (!confirm('Remove this item from your cart?')) return;
        deleteItem(menuId, restaurantId);
        return;
      }

      // Optimistic UI update
      items[menuId].qty = newQty;
      document.getElementById('qty-' + menuId).textContent = newQty;
      document.getElementById('total-' + menuId).textContent =
        '₹' + (items[menuId].price * newQty).toFixed(2);
      recalculate();

      // Persist to server
      fetch('${pageContext.request.contextPath}/CartServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'action=update&menuId=' + menuId + '&restaurantId=' + restaurantId + '&quantity=' + newQty
      });
    }

    function deleteItem(menuId, restaurantId) {
      fetch('${pageContext.request.contextPath}/CartServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'action=delete&menuId=' + menuId + '&restaurantId=' + restaurantId
      }).then(() => window.location.reload());
    }

    /* ── Recalculate summary totals ── */
    function recalculate() {
      let sub = 0, totalQty = 0;
      Object.values(items).forEach(i => {
        sub      += i.price * i.qty;
        totalQty += i.qty;
      });
      const tax   = sub * 0.05;
      const total = sub - promoDiscount + 20 + tax;

      document.getElementById('summarySubtotal').textContent = '₹' + sub.toFixed(2);
      document.getElementById('summaryTax').textContent      = '₹' + tax.toFixed(2);
      document.getElementById('summaryTotal').textContent    = '₹' + total.toFixed(2);
      document.getElementById('summaryDiscount').textContent = '— ₹' + promoDiscount.toFixed(2);
      document.getElementById('navCartCount').textContent    = totalQty;
      document.getElementById('cartItemLabel').textContent   =
        totalQty + ' Item' + (totalQty != 1 ? 's' : '');
    }

    /* ── Promo codes ── */
    const PROMO_CODES = { 'INSTA150': 150, 'SAVE100': 100 };

    function applyPromo() {
      const code = document.getElementById('promoCode').value.trim().toUpperCase();
      const msgEl = document.getElementById('promoMsg');

      if (PROMO_CODES[code] != undefined) {
        promoDiscount = PROMO_CODES[code];
        msgEl.className = 'promo-msg success';
        msgEl.textContent = '\u2705 ' + code + ' applied \u2014 \u20B9' + promoDiscount + ' discount!';
        msgEl.style.display = 'block';
        recalculate();
      } else {
        msgEl.className = 'promo-msg error';
        msgEl.textContent = '❌ Invalid code. Try INSTA150 or SAVE100.';
        msgEl.style.display = 'block';
      }
    }

    /* Allow Enter key on promo input */
    document.getElementById('promoCode')
      .addEventListener('keydown', e => { if (e.key === 'Enter') applyPromo(); });

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
  </script>
</body>
</html>
