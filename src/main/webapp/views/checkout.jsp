<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.instafoo.Model.User" %>
<%@ page import="com.instafoo.Model.Cart" %>
<%@ page import="com.instafoo.Model.CartItem" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.instafoo.daoImp.RestaurantDaoImp" %>
<%@ page import="com.instafoo.Model.Restaurant" %>

<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null) {
        response.sendRedirect(request.getContextPath() + "/views/login.jsp");
        return;
    }

    Cart cart = (Cart) session.getAttribute("cart");
    Map<Integer, CartItem> cartItems = (cart != null) ? cart.getItems() : null;
    if (cartItems == null || cartItems.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/views/cart.jsp");
        return;
    }

    double subtotal = 0;
    int totalQty = 0;
    for (CartItem ci : cartItems.values()) {
        subtotal += ci.getPrice() * ci.getQuantity();
        totalQty += ci.getQuantity();
    }
    double tax = subtotal * 0.05;
    double platform = 20.0;
    double grandTotal = subtotal + tax + platform;

    char firstLetter = 'U';
    if (loggedInUser.getUsername() != null && !loggedInUser.getUsername().trim().isEmpty()) {
        firstLetter = loggedInUser.getUsername().trim().toUpperCase().charAt(0);
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <link rel="icon" type="image/x-icon" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQz8HFcByuK1fp2KQdFls5532X50P87Ucp1kg&s">

  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Instafoods — Checkout</title>
  <meta name="description" content="Complete your Instafoods order — enter delivery address and choose payment method.">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    .checkout-page {
      min-height: 100vh;
      background: var(--bg-dark);
      padding-top: 72px;
    }
    .checkout-hero {
      background: #060606;
      border-bottom: 1px solid var(--border);
      padding: 36px 80px 32px;
    }
    .checkout-hero-inner {
      max-width: 1200px;
      margin: 0 auto;
      display: flex;
      align-items: center;
      justify-content: space-between;
      flex-wrap: wrap;
      gap: 16px;
    }
    .checkout-hero h1 { font-size: clamp(1.8rem, 3vw, 2.8rem); line-height: 0.95; }
    .checkout-hero p { color: var(--text-muted); font-size: 0.92rem; margin-top: 6px; }

    /* Progress steps */
    .checkout-steps {
      display: flex;
      align-items: center;
      gap: 0;
    }
    .step {
      display: flex;
      align-items: center;
      gap: 8px;
    }
    .step-num {
      width: 28px; height: 28px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.75rem;
    }
    .step.done .step-num  { background: var(--primary); color: #000; }
    .step.active .step-num{ background: #fff; color: #000; }
    .step.pending .step-num{ background: #1a1a1a; color: var(--text-muted); border: 1px solid var(--border); }
    .step-label {
      font-family: var(--font-heading);
      font-weight: 800;
      font-size: 0.75rem;
      text-transform: uppercase;
      letter-spacing: 0.4px;
    }
    .step.done .step-label  { color: var(--primary); }
    .step.active .step-label{ color: #fff; }
    .step.pending .step-label{ color: var(--text-muted); }
    .step-divider {
      width: 40px;
      height: 1px;
      background: var(--border);
      margin: 0 10px;
    }

    .checkout-content {
      max-width: 1200px;
      margin: 0 auto;
      padding: 48px 80px 80px;
      display: grid;
      grid-template-columns: 1fr 380px;
      gap: 32px;
      align-items: start;
    }
    .checkout-left { display: flex; flex-direction: column; gap: 24px; }

    .section-card {
      background: var(--bg-card);
      border: 1px solid var(--border);
      border-radius: 14px;
      overflow: hidden;
    }
    .section-card-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 20px 24px;
      border-bottom: 1px solid var(--border);
    }
    .section-card-header-left {
      display: flex;
      align-items: center;
      gap: 12px;
    }
    .sch-icon {
      width: 36px; height: 36px;
      background: rgba(202,255,0,0.08);
      border: 1px solid rgba(202,255,0,0.15);
      border-radius: 8px;
      display: flex;
      align-items: center;
      justify-content: center;
      color: var(--primary);
      font-size: 0.85rem;
    }
    .sch-title {
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.95rem;
      text-transform: uppercase;
      letter-spacing: 0.3px;
    }
    .sch-sub { font-size: 0.75rem; color: var(--text-muted); margin-top: 1px; }
    .section-card-body { padding: 24px; }

    .form-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 16px;
    }
    .form-grid.full { grid-template-columns: 1fr; }

    .form-field {
      display: flex;
      flex-direction: column;
      gap: 7px;
    }
    .form-field label {
      font-family: var(--font-heading);
      font-weight: 800;
      font-size: 0.72rem;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      color: var(--text-muted);
    }
    .form-field label .req { color: var(--primary); margin-left: 2px; }
    .form-field input,
    .form-field select,
    .form-field textarea {
      background: #111;
      border: 1px solid var(--border);
      color: #fff;
      padding: 12px 16px;
      font-family: var(--font-body);
      font-size: 0.9rem;
      border-radius: 6px;
      outline: none;
      transition: border-color 0.2s, box-shadow 0.2s;
      width: 100%;
    }
    .form-field input::placeholder { color: #444; }
    .form-field input:focus,
    .form-field select:focus,
    .form-field textarea:focus {
      border-color: var(--primary);
      box-shadow: 0 0 0 3px rgba(202,255,0,0.08);
    }

    .delivery-type-toggle {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 10px;
      margin-bottom: 20px;
    }
    .delivery-type-btn {
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 14px 16px;
      background: #111;
      border: 1.5px solid var(--border);
      border-radius: 8px;
      cursor: pointer;
      transition: all 0.2s;
      color: var(--text-muted);
      font-family: var(--font-heading);
      font-weight: 800;
      font-size: 0.82rem;
      text-transform: uppercase;
      justify-content: center;
    }
    .delivery-type-btn.selected {
      border-color: var(--primary);
      background: rgba(202,255,0,0.06);
      color: #fff;
    }
    .delivery-type-btn i { color: var(--primary); font-size: 1rem; }

    .payment-options {
      display: flex;
      flex-direction: column;
      gap: 12px;
    }
    .payment-option {
      position: relative;
    }
    .payment-option input[type="radio"] {
      position: absolute;
      opacity: 0;
      width: 0; height: 0;
    }
    .payment-label {
      display: flex;
      align-items: center;
      gap: 16px;
      padding: 18px 20px;
      background: #111;
      border: 1.5px solid var(--border);
      border-radius: 10px;
      cursor: pointer;
      transition: border-color 0.2s, background 0.2s, box-shadow 0.2s;
    }
    .payment-option input[type="radio"]:checked + .payment-label {
      border-color: var(--primary);
      background: rgba(202,255,0,0.05);
      box-shadow: 0 0 0 3px rgba(202,255,0,0.08);
    }
    .pay-icon-wrap {
      width: 44px; height: 44px;
      border-radius: 10px;
      background: #1a1a1a;
      border: 1px solid rgba(255,255,255,0.06);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.4rem;
      flex-shrink: 0;
    }
    .pay-body { flex: 1; }
    .pay-name {
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.92rem;
      text-transform: uppercase;
      color: #fff;
      margin-bottom: 3px;
    }
    .pay-sub { font-size: 0.78rem; color: var(--text-muted); line-height: 1.4; }
    .pay-radio-dot {
      width: 20px; height: 20px;
      border-radius: 50%;
      border: 2px solid var(--border);
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
      transition: border-color 0.2s;
    }
    .payment-option input[type="radio"]:checked + .payment-label .pay-radio-dot {
      border-color: var(--primary);
    }
    .pay-radio-dot::after {
      content: '';
      width: 9px; height: 9px;
      border-radius: 50%;
      background: var(--primary);
      opacity: 0;
      transition: opacity 0.2s;
    }
    .payment-option input[type="radio"]:checked + .payment-label .pay-radio-dot::after { opacity: 1; }

    /* UPI input expand */
    .upi-expand {
      display: none;
      margin-top: 12px;
      padding: 16px;
      background: #0d0d0d;
      border: 1px solid rgba(202,255,0,0.12);
      border-radius: 8px;
    }
    .upi-expand.visible { display: block; }
    .upi-apps {
      display: flex;
      gap: 10px;
      margin-bottom: 14px;
      flex-wrap: wrap;
    }
    .upi-app-btn {
      display: flex;
      align-items: center;
      gap: 6px;
      padding: 8px 14px;
      background: #111;
      border: 1px solid var(--border);
      border-radius: 6px;
      font-family: var(--font-heading);
      font-weight: 800;
      font-size: 0.72rem;
      text-transform: uppercase;
      color: var(--text-muted);
      cursor: pointer;
      transition: all 0.2s;
    }
    .upi-app-btn:hover,
    .upi-app-btn.selected { border-color: var(--primary); color: var(--primary); background: rgba(202,255,0,0.06); }

    /* Right Summary Column */
    .co-right {
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
    .sp-header {
      padding: 18px 24px;
      border-bottom: 1px solid var(--border);
      display: flex;
      align-items: center;
      justify-content: space-between;
    }
    .sp-header h3 {
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.88rem;
      text-transform: uppercase;
      letter-spacing: 0.4px;
    }
    .sp-header a {
      font-family: var(--font-heading);
      font-weight: 800;
      font-size: 0.72rem;
      text-transform: uppercase;
      color: var(--primary);
      text-decoration: none;
      transition: opacity 0.2s;
    }
    .sp-header a:hover { opacity: 0.7; }
    .sp-items { padding: 0 24px; }
    
    .checkout-item-row {
      display: flex;
      align-items: center;
      gap: 14px;
      padding: 14px 0;
      border-bottom: 1px solid rgba(255,255,255,0.04);
    }
    .checkout-item-row:last-child { border-bottom: none; }
    .ci-co-emoji {
      width: 40px; height: 40px;
      background: #1a1a1a;
      border-radius: 8px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.3rem;
      flex-shrink: 0;
      border: 1px solid rgba(255,255,255,0.05);
    }
    .ci-co-info { flex: 1; min-width: 0; }
    .ci-co-name {
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.8rem;
      text-transform: uppercase;
      color: #fff;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }
    .ci-co-rest { font-size: 0.72rem; color: var(--text-muted); }
    .ci-co-qty {
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.72rem;
      color: var(--text-muted);
      background: #1a1a1a;
      border: 1px solid var(--border);
      padding: 3px 9px;
      border-radius: 100px;
      flex-shrink: 0;
    }
    .ci-co-price {
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.88rem;
      color: #fff;
      flex-shrink: 0;
      min-width: 56px;
      text-align: right;
    }

    .sp-divider {
      height: 1px;
      background: var(--border);
      margin: 4px 24px;
    }
    .sp-rows { padding: 4px 24px 0; }
    .sp-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 11px 0;
      border-bottom: 1px solid rgba(255,255,255,0.04);
      font-size: 0.85rem;
      color: var(--text-muted);
    }
    .sp-row:last-child { border-bottom: none; }
    .sp-row .lbl { display: flex; align-items: center; gap: 8px; }
    .sp-row .lbl i { color: var(--primary); font-size: 0.78rem; width: 14px; text-align: center; }
    .sp-row .val { font-family: var(--font-heading); font-weight: 900; font-size: 0.88rem; color: #fff; }
    .sp-row .val.free { color: var(--primary); }
    .sp-row .val.red { color: #ff4757; }

    .sp-total {
      margin: 0 24px;
      padding: 16px 0;
      border-top: 1px solid rgba(255,255,255,0.1);
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .sp-total .tl { font-family: var(--font-heading); font-weight: 900; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.4px; }
    .sp-total .tv { font-family: var(--font-heading); font-weight: 900; font-size: 1.6rem; color: #fff; }

    .place-order-btn {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
      width: 100%;
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
      margin: 16px 24px 24px;
      width: calc(100% - 48px);
    }
    .place-order-btn:hover {
      background: var(--primary-light);
      transform: translateY(-2px);
      box-shadow: 0 8px 28px rgba(202,255,0,0.35);
    }
    .place-order-btn:disabled {
      opacity: 0.5;
      cursor: not-allowed;
      transform: none;
      box-shadow: none;
    }

    .sp-trust {
      display: flex;
      gap: 16px;
      padding: 0 24px 20px;
      flex-wrap: wrap;
    }
    .sp-tp {
      display: flex;
      align-items: center;
      gap: 5px;
      font-family: var(--font-heading);
      font-weight: 800;
      font-size: 0.63rem;
      text-transform: uppercase;
      color: var(--text-muted);
    }
    .sp-tp i { color: var(--primary); }

    .eta-card {
      background: var(--bg-card);
      border: 1px solid rgba(202,255,0,0.18);
      border-radius: 14px;
      padding: 18px 20px;
      display: flex;
      align-items: center;
      gap: 14px;
    }
    .eta-icon {
      width: 42px; height: 42px;
      border-radius: 10px;
      background: rgba(202,255,0,0.1);
      display: flex;
      align-items: center;
      justify-content: center;
      color: var(--primary);
      font-size: 1rem;
      flex-shrink: 0;
    }
    .eta-info .eta-lbl { font-size: 0.7rem; color: var(--text-muted); font-family: var(--font-heading); font-weight: 800; text-transform: uppercase; letter-spacing: 0.4px; }
    .eta-info .eta-val { font-family: var(--font-heading); font-weight: 900; font-size: 1.1rem; color: #fff; margin-top: 2px; }
    .eta-info .eta-sub { font-size: 0.72rem; color: var(--text-muted); }

    @media (max-width: 1024px) {
      .checkout-content { grid-template-columns: 1fr; padding: 32px 40px 64px; }
      .co-right { position: static; }
      .checkout-hero { padding: 28px 40px; }
      .checkout-steps { display: none; }
    }
    @media (max-width: 640px) {
      .checkout-content { padding: 20px 20px 56px; }
      .checkout-hero { padding: 20px 20px; }
      .form-grid { grid-template-columns: 1fr; }
      .delivery-type-toggle { grid-template-columns: 1fr; }
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
      <li><a href="${pageContext.request.contextPath}/views/cart.jsp"><i class="fa-solid fa-cart-shopping" style="margin-right:5px;"></i>Cart</a></li>
    </ul>
    
    <div class="nav-actions">
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
    </div>
    
    <div class="hamburger" id="hamburger"><span></span><span></span><span></span></div>
  </header>


  <!-- ==============================
       CHECKOUT PAGE
       ============================== -->
  <div class="checkout-page">

    <div class="checkout-hero">
      <div class="checkout-hero-inner">
        <div>
          <h1>Checkout <span class="highlight">.</span></h1>
          <p>Almost there — confirm your address and pick a payment method.</p>
        </div>
        <!-- Progress Steps -->
        <div class="checkout-steps">
          <div class="step done">
            <div class="step-num"><i class="fa-solid fa-check" style="font-size:0.7rem;"></i></div>
            <div class="step-label">Cart</div>
          </div>
          <div class="step-divider"></div>
          <div class="step active">
            <div class="step-num">2</div>
            <div class="step-label">Checkout</div>
          </div>
          <div class="step-divider"></div>
          <div class="step pending">
            <div class="step-num">3</div>
            <div class="step-label">Confirmation</div>
          </div>
        </div>
      </div>
    </div>

    <!-- POST form to PlaceOrderServlet -->
    <form id="checkoutForm" action="${pageContext.request.contextPath}/PlaceOrderServlet" method="POST" novalidate>

      <div class="checkout-content">

        <!-- ===== LEFT PANEL ===== -->
        <div class="checkout-left">
          <%
              String errorMsg = (String) session.getAttribute("errorMsg");
              if (errorMsg != null) {
          %>
              <div style="background-color: rgba(239, 68, 68, 0.15); border: 1px solid #ef4444; color: #f87171; padding: 14px 20px; border-radius: 8px; font-family: var(--font-body); font-size: 0.92rem; display: flex; align-items: center; gap: 8px; margin-bottom: 10px;">
                  <i class="fa-solid fa-triangle-exclamation"></i>
                  <%= errorMsg %>
              </div>
          <%
                  session.removeAttribute("errorMsg");
              }
          %>

          <!-- SECTION 1: Delivery Address -->
          <div class="section-card">
            <div class="section-card-header">
              <div class="section-card-header-left">
                <div class="sch-icon"><i class="fa-solid fa-location-dot"></i></div>
                <div>
                  <div class="sch-title">Delivery Address</div>
                  <div class="sch-sub">Where should we deliver?</div>
                </div>
              </div>
            </div>
            <div class="section-card-body">

              <!-- Delivery Type Toggle -->
              <div class="delivery-type-toggle">
                <div class="delivery-type-btn selected" id="typeHome" onclick="selectDeliveryType('home')">
                  <i class="fa-solid fa-house"></i> Home
                </div>
                <div class="delivery-type-btn" id="typeWork" onclick="selectDeliveryType('work')">
                  <i class="fa-solid fa-briefcase"></i> Work
                </div>
              </div>

              <!-- Hidden field for address type -->
              <input type="hidden" name="addressType" id="addressType" value="home">

              <!-- Address form fields -->
              <div class="form-grid">
                <div class="form-field">
                  <label for="fullName">Full Name <span class="req">*</span></label>
                  <input type="text" id="fullName" name="fullName" placeholder="John Smith" required>
                </div>
                <div class="form-field">
                  <label for="phone">Phone Number <span class="req">*</span></label>
                  <input type="tel" id="phone" name="phone" placeholder="+91 98765 43210" required>
                </div>
              </div>

              <div class="form-grid full" style="margin-top:14px;">
                <div class="form-field">
                  <label for="addressLine1">Address Line 1 <span class="req">*</span></label>
                  <input type="text" id="addressLine1" name="addressLine1" placeholder="Flat / House No., Building Name, Street" required>
                </div>
              </div>

              <div class="form-grid full" style="margin-top:14px;">
                <div class="form-field">
                  <label for="addressLine2">Address Line 2</label>
                  <input type="text" id="addressLine2" name="addressLine2" placeholder="Landmark, Area (optional)">
                </div>
              </div>

              <div class="form-grid" style="margin-top:14px;">
                <div class="form-field">
                  <label for="city">City <span class="req">*</span></label>
                  <input type="text" id="city" name="city" placeholder="Bengaluru" required>
                </div>
                <div class="form-field">
                  <label for="state">State <span class="req">*</span></label>
                  <select id="state" name="state" required>
                    <option value="" disabled selected>Select State</option>
                    <option>Karnataka</option>
                    <option>Telangana</option>
                    <option>Andhra Pradesh</option>
                    <option>Tamil Nadu</option>
                    <option>Maharashtra</option>
                    <option>Delhi</option>
                    <option>Other</option>
                  </select>
                </div>
              </div>

              <div class="form-grid" style="margin-top:14px;">
                <div class="form-field">
                  <label for="pincode">Pincode <span class="req">*</span></label>
                  <input type="text" id="pincode" name="pincode" placeholder="560001" maxlength="6" required>
                </div>
                <div class="form-field">
                  <label for="deliveryNote">Delivery Instructions</label>
                  <input type="text" id="deliveryNote" name="deliveryNote" placeholder="Leave at door, ring bell etc.">
                </div>
              </div>

            </div>
          </div><!-- /delivery address -->

          <!-- SECTION 2: Payment Mode (UPI and COD Only) -->
          <div class="section-card">
            <div class="section-card-header">
              <div class="section-card-header-left">
                <div class="sch-icon"><i class="fa-solid fa-credit-card"></i></div>
                <div>
                  <div class="sch-title">Payment Method</div>
                  <div class="sch-sub">All transactions are secure and encrypted</div>
                </div>
              </div>
            </div>
            <div class="section-card-body">

              <div class="payment-options">

                <!-- COD Option -->
                <div class="payment-option">
                  <input type="radio" name="paymentMode" id="payCOD" value="COD" onchange="togglePayExpand()" checked required>
                  <label class="payment-label" for="payCOD">
                    <div class="pay-icon-wrap">💵</div>
                    <div class="pay-body">
                      <div class="pay-name">Cash on Delivery</div>
                      <div class="pay-sub">Pay in cash when your rider arrives.</div>
                    </div>
                    <div class="pay-radio-dot"></div>
                  </label>
                </div>

              </div><!-- /payment-options -->
            </div>
          </div><!-- /payment mode -->

        </div><!-- /checkout-left -->


        <!-- ===== RIGHT PANEL ===== -->
        <div class="co-right">

          <!-- ETA Card -->
          <div class="eta-card">
            <div class="eta-icon"><i class="fa-solid fa-truck-fast"></i></div>
            <div class="eta-info">
              <div class="eta-lbl">Estimated Arrival Time</div>
              <div class="eta-val">20–30 mins</div>
              <div class="eta-sub">Hot & fresh delivery</div>
            </div>
          </div>

          <!-- Order Summary Panel -->
          <div class="summary-panel">
            <div class="sp-header">
              <h3>Order Items</h3>
              <a href="${pageContext.request.contextPath}/views/cart.jsp"><i class="fa-solid fa-pen-to-square" style="margin-right:4px;"></i>Edit Cart</a>
            </div>

            <!-- Dynamic Cart Items Preview -->
            <div class="sp-items">
              <%
                  RestaurantDaoImp restDao = new RestaurantDaoImp();
                  for (CartItem ci : cartItems.values()) {
                      String itemEmoji = "🍲";
                      String nameLower = ci.getName().toLowerCase();
                      if (nameLower.contains("chicken") || nameLower.contains("murgh")) itemEmoji = "🍗";
                      else if (nameLower.contains("biryani") || nameLower.contains("rice") || nameLower.contains("pulao")) itemEmoji = "🍚";
                      else if (nameLower.contains("pizza")) itemEmoji = "🍕";
                      else if (nameLower.contains("burger")) itemEmoji = "🍔";
                      else if (nameLower.contains("coffee") || nameLower.contains("tea") || nameLower.contains("shake")) itemEmoji = "☕";
                      else if (nameLower.contains("dessert") || nameLower.contains("cake") || nameLower.contains("ice")) itemEmoji = "🍰";
                      else if (nameLower.contains("salad")) itemEmoji = "🥗";
                      else if (nameLower.contains("roti") || nameLower.contains("nan") || nameLower.contains("bread")) itemEmoji = "🫓";
                      
                      Restaurant r = restDao.getRestaurantById(ci.getRestaurantId());
                      String rName = (r != null) ? r.getName() : "Restaurant";
              %>
                      <div class="checkout-item-row">
                        <div class="ci-co-emoji" style="position: relative; overflow: hidden; padding: 0;">
                          <% if (ci.getImagePath() != null && !ci.getImagePath().trim().isEmpty()) { %>
                            <img src="<%= ci.getImagePath() %>" alt="<%= ci.getName() %>" style="width:100%; height:100%; object-fit:cover; display:block;">
                          <% } else { %>
                            <%= itemEmoji %>
                          <% } %>
                        </div>
                        <div class="ci-co-info">
                          <div class="ci-co-name"><%= ci.getName() %></div>
                          <div class="ci-co-rest"><%= rName %></div>
                        </div>
                        <div class="ci-co-qty">x<%= ci.getQuantity() %></div>
                        <div class="ci-co-price">₹<%= String.format("%.2f", ci.getPrice() * ci.getQuantity()) %></div>
                      </div>
              <%
                  }
              %>
            </div>

            <div class="sp-divider"></div>

            <div class="sp-rows">
              <div class="sp-row">
                <span class="lbl"><i class="fa-solid fa-receipt"></i> Subtotal</span>
                <span class="val">₹<%= String.format("%.2f", subtotal) %></span>
              </div>
              <div class="sp-row">
                <span class="lbl"><i class="fa-solid fa-truck-fast"></i> Delivery Fee</span>
                <span class="val free">FREE</span>
              </div>
              <div class="sp-row">
                <span class="lbl"><i class="fa-solid fa-shield-halved"></i> Platform Fee</span>
                <span class="val">₹<%= String.format("%.2f", platform) %></span>
              </div>
              <div class="sp-row">
                <span class="lbl"><i class="fa-solid fa-percent"></i> GST & Taxes (5%)</span>
                <span class="val">₹<%= String.format("%.2f", tax) %></span>
              </div>
            </div>

            <div class="sp-total">
              <span class="tl">Total Payable</span>
              <span class="tv">₹<%= String.format("%.2f", grandTotal) %></span>
            </div>

            <!-- Place Order Button -->
            <button class="place-order-btn" type="submit" id="placeOrderBtn" disabled>
              <i class="fa-solid fa-lock"></i>
              Place Order
              <i class="fa-solid fa-arrow-right"></i>
            </button>

            <div class="sp-trust">
              <span class="sp-tp"><i class="fa-solid fa-shield-halved"></i> SSL Secured</span>
              <span class="sp-tp"><i class="fa-solid fa-rotate-left"></i> Easy Refunds</span>
              <span class="sp-tp"><i class="fa-solid fa-fire-flame-curved"></i> Hot Delivery</span>
            </div>

          </div><!-- /summary-panel -->

        </div><!-- /co-right -->

      </div><!-- /checkout-content -->
    </form>

  </div><!-- /checkout-page -->

  <!-- Footer -->
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
  /* ---- Navbar scroll ---- */
  document.addEventListener('scroll', () => {
    document.getElementById('navbar').classList.toggle('scrolled', window.scrollY > 40);
  });

  /* ---- Delivery Type Toggle ---- */
  function selectDeliveryType(type) {
    document.getElementById('typeHome').classList.toggle('selected', type === 'home');
    document.getElementById('typeWork').classList.toggle('selected', type === 'work');
    document.getElementById('addressType').value = type;
  }

  /* ---- Payment expand / collapse ---- */
  function togglePayExpand() {
    validateForm();
  }

  /* ---- Form validation: enable Place Order only if required fields filled ---- */
  function validateForm() {
    const required = ['fullName','phone','addressLine1','city','state','pincode'];
    const paymentSelected = !!document.querySelector('input[name="paymentMode"]:checked');
    const allFilled = required.every(id => document.getElementById(id)?.value.trim() !== '');
    document.getElementById('placeOrderBtn').disabled = !(allFilled && paymentSelected);
  }

  document.querySelectorAll('#fullName,#phone,#addressLine1,#city,#state,#pincode').forEach(el => {
    el.addEventListener('input', validateForm);
    el.addEventListener('change', validateForm);
  });

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

  // Mobile hamburger menu
  const hamburger = document.getElementById('hamburger');
  if (hamburger) {
    hamburger.addEventListener('click', () => {
      document.querySelector('.nav-links').classList.toggle('open');
      hamburger.classList.toggle('open');
    });
  }
</script>
</body>
</html>
