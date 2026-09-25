<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.instafoo.Model.User" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    char firstLetter = 'U';
    if (loggedInUser != null && loggedInUser.getUsername() != null && !loggedInUser.getUsername().trim().isEmpty()) {
        firstLetter = loggedInUser.getUsername().trim().toUpperCase().charAt(0);
    }

    String orderId = (String) session.getAttribute("placedOrderId");
    Double totalPaid = (Double) session.getAttribute("placedOrderTotal");
    
    // Fallback if accessed directly
    if (orderId == null) {
        orderId = "INF-2026-" + (1000 + new java.util.Random().nextInt(9000));
    }
    if (totalPaid == null) {
        totalPaid = 0.0;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <link rel="icon" type="image/x-icon" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQz8HFcByuK1fp2KQdFls5532X50P87Ucp1kg&s">

  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Instafoods — Order Placed Successfully!</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    .success-page {
      min-height: 100vh;
      background: var(--bg-dark);
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 120px 24px 80px;
      position: relative;
      overflow: hidden;
    }
    .success-bg-glow {
      position: absolute;
      width: 500px; height: 500px;
      background: radial-gradient(circle, rgba(202,255,0,0.06) 0%, transparent 70%);
      top: 50%; left: 50%;
      transform: translate(-50%, -50%);
      pointer-events: none;
      z-index: 1;
    }
    .success-card {
      background: var(--bg-card);
      border: 1px solid var(--border);
      border-radius: 20px;
      max-width: 540px;
      width: 100%;
      padding: 48px 40px;
      text-align: center;
      box-shadow: 0 20px 50px rgba(0,0,0,0.5);
      position: relative;
      z-index: 2;
      animation: fadeInUp 0.6s cubic-bezier(0.25, 0.8, 0.25, 1) both;
    }
    @keyframes fadeInUp {
      from { opacity: 0; transform: translateY(24px); }
      to { opacity: 1; transform: translateY(0); }
    }
    .success-icon-wrap {
      display: flex;
      justify-content: center;
      align-items: center;
      margin-bottom: 28px;
    }
    .checkmark {
      width: 88px; height: 88px;
      border-radius: 50%;
      display: block;
      stroke-width: 3;
      stroke: var(--primary);
      stroke-miterlimit: 10;
      box-shadow: inset 0px 0px 0px var(--primary);
      animation: fill .4s ease-in-out .4s forwards, scale .3s ease-in-out .9s both;
    }
    .checkmark__circle {
      stroke-dasharray: 166;
      stroke-dashoffset: 166;
      stroke-width: 3;
      stroke-miterlimit: 10;
      stroke: var(--primary);
      fill: none;
      animation: stroke 0.6s cubic-bezier(0.65, 0, 0.45, 1) forwards;
    }
    .checkmark__check {
      transform-origin: 50% 50%;
      stroke-dasharray: 48;
      stroke-dashoffset: 48;
      stroke: #000;
      stroke-width: 4;
      animation: stroke 0.3s cubic-bezier(0.65, 0, 0.45, 1) 0.8s forwards;
    }
    @keyframes stroke {
      100% { stroke-dashoffset: 0; }
    }
    @keyframes scale {
      0%, 100% { transform: none; }
      50% { transform: scale3d(1.1, 1.1, 1); }
    }
    @keyframes fill {
      100% { box-shadow: inset 0px 0px 0px 50px var(--primary); }
    }
    .success-card h1 {
      font-size: clamp(1.6rem, 4vw, 2.2rem);
      color: #fff;
      line-height: 1.1;
      margin-bottom: 12px;
    }
    .success-card p {
      color: var(--text-muted);
      font-size: 0.95rem;
      line-height: 1.5;
      margin-bottom: 32px;
      max-width: 400px;
      margin-left: auto;
      margin-right: auto;
    }
    .recap-box {
      background: #181818;
      border: 1px solid var(--border);
      border-radius: 12px;
      padding: 24px;
      margin-bottom: 36px;
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 16px;
      text-align: left;
    }
    .recap-item {
      display: flex;
      flex-direction: column;
      gap: 4px;
    }
    .recap-item.full {
      grid-column: span 2;
      border-top: 1px solid rgba(255,255,255,0.05);
      padding-top: 12px;
    }
    .recap-lbl {
      font-family: var(--font-heading);
      font-weight: 800;
      font-size: 0.7rem;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      color: var(--text-muted);
    }
    .recap-val {
      font-size: 0.92rem;
      font-weight: 700;
      color: #fff;
    }
    .recap-val.highlight-green {
      color: var(--primary-light);
      font-family: var(--font-heading);
      font-weight: 900;
    }
    .success-actions {
      display: flex;
      flex-direction: column;
      gap: 12px;
    }
    .btn-track {
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
      transition: all 0.2s;
      text-decoration: none;
    }
    .btn-track:hover {
      background: var(--primary-light);
      transform: translateY(-2px);
      box-shadow: 0 8px 24px rgba(202,255,0,0.3);
    }
    .btn-home {
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
    }
    .btn-home:hover {
      border-color: var(--primary);
      color: var(--primary);
    }
    @media (max-width: 640px) {
      .success-card { padding: 36px 20px; }
      .recap-box { grid-template-columns: 1fr; gap: 14px; padding: 16px; }
      .recap-item.full { grid-column: span 1; }
    }
  </style>
</head>
<body>

  <!-- Navbar -->
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
      <% if (loggedInUser != null) { %>
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

  <!-- Page Body -->
  <div class="success-page">
    <div class="success-bg-glow"></div>
    <div class="success-card">
      <div class="success-icon-wrap">
        <svg class="checkmark" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 52 52">
          <circle class="checkmark__circle" cx="26" cy="26" r="25" fill="none"/>
          <path class="checkmark__check" fill="none" d="M14.1 27.2l7.1 7.2 16.7-16.8"/>
        </svg>
      </div>

      <h1>Order Placed<br>Successfully<span class="highlight">!</span></h1>
      <p>Thank you for your order. Our gourmet kitchen has confirmed it. Your delicious meal is being assembled.</p>

      <div class="recap-box">
        <div class="recap-item">
          <span class="recap-lbl">Order ID</span>
          <span class="recap-val">#<%= orderId %></span>
        </div>
        <div class="recap-item">
          <span class="recap-lbl">Estimated Arrival</span>
          <span class="recap-val highlight-green">20–30 MINS</span>
        </div>
        <div class="recap-item full">
          <span class="recap-lbl">Amount Paid</span>
          <span class="recap-val">₹<%= String.format("%.2f", totalPaid) %></span>
        </div>
      </div>

      <div class="success-actions">
        <a href="${pageContext.request.contextPath}/OrderTrackerServlet" class="btn-track">
          <i class="fa-solid fa-route"></i> Track Order (Insta-Tracker)
        </a>
        <a href="${pageContext.request.contextPath}/LandingServlet" class="btn-home">
          <i class="fa-solid fa-house"></i> Back to Homepage
        </a>
      </div>
    </div>
  </div>

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
    document.addEventListener('scroll', () => {
      document.getElementById('navbar').classList.toggle('scrolled', window.scrollY > 40);
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
<%
    // Clean up order details from session to prevent repeat displays on refresh
    session.removeAttribute("placedOrderId");
    session.removeAttribute("placedOrderTotal");
%>
