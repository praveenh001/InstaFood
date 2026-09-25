<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.instafoo.Model.User" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null) {
        response.sendRedirect(request.getContextPath() + "/views/login.jsp");
        return;
    }

    char firstLetter = 'U';
    if (loggedInUser.getUsername() != null && !loggedInUser.getUsername().trim().isEmpty()) {
        firstLetter = loggedInUser.getUsername().trim().toUpperCase().charAt(0);
    }

    Map<String, Object> order = (Map<String, Object>) request.getAttribute("order");
    List<Map<String, Object>> orderItems = (List<Map<String, Object>>) request.getAttribute("orderItems");
    List<Map<String, Object>> userOrders = (List<Map<String, Object>>) request.getAttribute("userOrders");

    if (order == null) {
        response.sendRedirect(request.getContextPath() + "/OrderTrackerServlet");
        return;
    }

    String status = (String) order.get("status");
    if (status == null) status = "Placed";

    String statusHeader = "Order Placed";
    String badgeText = "Confirmed";
    int activeStep = 1; // 1-based: 1=Confirmed, 2=Preparing, 3=Out for Delivery, 4=Delivered

    if ("Placed".equalsIgnoreCase(status)) {
        statusHeader = "Order Placed.";
        badgeText = "Confirmed";
        activeStep = 1;
    } else if ("Preparing".equalsIgnoreCase(status) || "Kitchen Preparing".equalsIgnoreCase(status)) {
        statusHeader = "Kitchen Preparing.";
        badgeText = "Preparing";
        activeStep = 2;
    } else if ("Out for Delivery".equalsIgnoreCase(status) || "Delivery".equalsIgnoreCase(status)) {
        statusHeader = "Out for Delivery.";
        badgeText = "In Transit";
        activeStep = 3;
    } else if ("Delivered".equalsIgnoreCase(status)) {
        statusHeader = "Order Delivered.";
        badgeText = "Delivered";
        activeStep = 4;
    }

    // Format date
    Timestamp orderDateTs = (Timestamp) order.get("order_date");
    String formattedDate = "Just Now";
    String formattedTime = "";
    if (orderDateTs != null) {
        SimpleDateFormat sdfDate = new SimpleDateFormat("MMMM dd, yyyy");
        SimpleDateFormat sdfTime = new SimpleDateFormat("hh:mm a");
        formattedDate = sdfDate.format(orderDateTs);
        formattedTime = sdfTime.format(orderDateTs);
    }

    // Calculate subtotal
    double calculatedSubtotal = 0;
    if (orderItems != null) {
        for (Map<String, Object> item : orderItems) {
            calculatedSubtotal += (Double) item.get("subtotal");
        }
    }
    double calculatedTax = calculatedSubtotal * 0.05;
    double platformFee = 20.00;
    double totalPaid = (Double) order.get("total_amount");
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <link rel="icon" type="image/x-icon" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQz8HFcByuK1fp2KQdFls5532X50P87Ucp1kg&s">

  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Instafoods — Insta-Tracker</title>
  <meta name="description" content="Track your Instafoods order in real-time with our live order tracker.">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    /* =============================================
       PAGE FOUNDATION
       ============================================= */
    .ordered-page {
      min-height: 100vh;
      background: #050505;
      padding-top: 72px;
    }

    /* =============================================
       HERO — GLASSMORPHIC
       ============================================= */
    .ordered-hero {
      background: linear-gradient(180deg, rgba(202,255,0,0.03) 0%, transparent 100%);
      border-bottom: 1px solid rgba(255,255,255,0.04);
      padding: 48px 80px 40px;
      position: relative;
      overflow: hidden;
    }
    .ordered-hero::before {
      content: '';
      position: absolute;
      top: -80px; right: -80px;
      width: 300px; height: 300px;
      background: radial-gradient(circle, rgba(202,255,0,0.06) 0%, transparent 70%);
      border-radius: 50%;
      pointer-events: none;
    }
    .ordered-hero-inner {
      max-width: 1200px;
      margin: 0 auto;
      display: flex;
      align-items: center;
      justify-content: space-between;
      flex-wrap: wrap;
      gap: 24px;
      position: relative;
      z-index: 1;
    }
    .ordered-hero h1 { font-size: clamp(1.8rem, 3.2vw, 2.8rem); line-height: 0.95; margin-bottom: 8px; }
    .ordered-hero p { color: var(--text-muted); font-size: 0.95rem; }

    .order-status-badge {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      background: rgba(202,255,0,0.08);
      backdrop-filter: blur(16px);
      -webkit-backdrop-filter: blur(16px);
      border: 1px solid rgba(202,255,0,0.2);
      border-radius: 100px;
      padding: 10px 22px;
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.78rem;
      text-transform: uppercase;
      color: var(--primary);
      letter-spacing: 0.5px;
    }
    .order-status-badge .dot {
      width: 8px; height: 8px;
      background: var(--primary);
      border-radius: 50%;
      animation: pulse 1.8s ease-in-out infinite;
    }
    @keyframes pulse {
      0%, 100% { opacity: 1; transform: scale(1); }
      50%       { opacity: 0.4; transform: scale(0.7); }
    }

    /* =============================================
       HORIZONTAL SLIDER TRACKER
       ============================================= */
    .tracker-slider-section {
      max-width: 1200px;
      margin: 0 auto;
      padding: 48px 80px 0;
    }
    .tracker-slider-card {
      background: rgba(12,12,12,0.7);
      backdrop-filter: blur(40px);
      -webkit-backdrop-filter: blur(40px);
      border: 1px solid rgba(255,255,255,0.06);
      border-radius: 20px;
      padding: 40px 48px 48px;
      position: relative;
      overflow: hidden;
    }
    .tracker-slider-card::before {
      content: '';
      position: absolute;
      inset: 0;
      background: linear-gradient(135deg, rgba(202,255,0,0.02) 0%, transparent 50%, rgba(0,229,255,0.015) 100%);
      pointer-events: none;
    }
    .tracker-slider-card::after {
      content: '';
      position: absolute;
      top: -1px; left: 50%; transform: translateX(-50%);
      width: 200px; height: 1px;
      background: linear-gradient(90deg, transparent, rgba(202,255,0,0.3), transparent);
    }
    .tracker-header {
      display: flex;
      align-items: center;
      gap: 14px;
      margin-bottom: 40px;
      position: relative;
      z-index: 1;
    }
    .tracker-header-icon {
      width: 42px; height: 42px;
      background: rgba(202,255,0,0.06);
      backdrop-filter: blur(10px);
      border: 1px solid rgba(202,255,0,0.12);
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      color: var(--primary);
      font-size: 1rem;
    }
    .tracker-header-text h3 {
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 1rem;
      text-transform: uppercase;
      letter-spacing: 0.4px;
      color: #fff;
      margin: 0;
    }
    .tracker-header-text p {
      font-size: 0.75rem;
      color: var(--text-muted);
      margin: 2px 0 0;
    }

    /* Horizontal Track */
    .tracker-progress-wrapper {
      position: relative;
      z-index: 1;
      padding: 0 8px;
    }

    /* The connecting rail */
    .tracker-progress-rail {
      position: absolute;
      top: 28px;
      left: 36px;
      right: 36px;
      height: 3px;
      background: rgba(255,255,255,0.06);
      border-radius: 4px;
      z-index: 0;
    }
    .tracker-progress-fill {
      position: absolute;
      top: 0; left: 0;
      height: 100%;
      background: linear-gradient(90deg, var(--primary), #00e5ff);
      border-radius: 4px;
      transition: width 1.2s cubic-bezier(0.4, 0, 0.2, 1);
      box-shadow: 0 0 20px rgba(202,255,0,0.3);
    }
    .tracker-progress-thumb {
      position: absolute;
      top: 50%;
      left: 0%;
      transform: translate(-50%, -50%);
      width: 38px;
      height: 28px;
      z-index: 10;
      display: flex;
      align-items: center;
      justify-content: center;
      color: var(--primary);
      transition: left 1.2s cubic-bezier(0.4, 0, 0.2, 1);
      filter: drop-shadow(0 0 6px rgba(202, 255, 0, 0.35));
    }

    /* Step nodes row */
    .tracker-progress-steps {
      display: flex;
      justify-content: space-between;
      position: relative;
      z-index: 2;
    }

    .tracker-progress-step {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 16px;
      flex: 1;
      max-width: 180px;
    }

    /* Circle node */
    .tracker-progress-node {
      width: 56px;
      height: 56px;
      border-radius: 50%;
      background: rgba(20,20,20,0.9);
      backdrop-filter: blur(20px);
      -webkit-backdrop-filter: blur(20px);
      border: 2px solid rgba(255,255,255,0.08);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.1rem;
      color: rgba(255,255,255,0.2);
      transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
      position: relative;
      flex-shrink: 0;
    }
    .tracker-progress-step.completed .tracker-progress-node {
      background: linear-gradient(135deg, rgba(202,255,0,0.15), rgba(0,229,255,0.1));
      border-color: var(--primary);
      color: var(--primary);
      box-shadow: 0 0 24px rgba(202,255,0,0.2), inset 0 0 20px rgba(202,255,0,0.05);
    }
    .tracker-progress-step.active .tracker-progress-node {
      background: rgba(20,20,20,0.9);
      border-color: var(--primary);
      color: #fff;
      box-shadow: 0 0 30px rgba(202,255,0,0.25);
      animation: nodeGlow 2s ease-in-out infinite;
    }
    @keyframes nodeGlow {
      0%, 100% { box-shadow: 0 0 20px rgba(202,255,0,0.2); }
      50% { box-shadow: 0 0 40px rgba(202,255,0,0.35), 0 0 60px rgba(202,255,0,0.1); }
    }

    /* Checkmark inside completed node */
    .tracker-progress-step.completed .tracker-progress-node::after {
      content: '\f00c';
      font-family: "Font Awesome 6 Free";
      font-weight: 900;
      font-size: 0.85rem;
      color: var(--primary);
      position: absolute;
    }
    .tracker-progress-step.completed .tracker-progress-node i { display: none; }

    /* Text below node */
    .tracker-progress-info {
      text-align: center;
    }
    .tracker-progress-title {
      font-family: var(--font-heading);
      font-weight: 800;
      font-size: 0.78rem;
      text-transform: uppercase;
      letter-spacing: 0.4px;
      color: rgba(255,255,255,0.25);
      margin-bottom: 4px;
      transition: color 0.4s;
    }
    .tracker-progress-step.completed .tracker-progress-title,
    .tracker-progress-step.active .tracker-progress-title { color: #fff; }

    .tracker-progress-desc {
      font-size: 0.7rem;
      color: rgba(255,255,255,0.15);
      line-height: 1.4;
      max-width: 140px;
      margin: 0 auto;
      transition: color 0.4s;
    }
    .tracker-progress-step.completed .tracker-progress-desc { color: rgba(255,255,255,0.35); }
    .tracker-progress-step.active .tracker-progress-desc { color: var(--text-muted); }

    .tracker-progress-time {
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.68rem;
      color: transparent;
      margin-top: 6px;
      transition: color 0.4s;
    }
    .tracker-progress-step.completed .tracker-progress-time { color: var(--primary); }
    .tracker-progress-step.active .tracker-progress-time { color: rgba(202,255,0,0.7); }

    /* ETA Glass Pill */
    .eta-pill {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      background: rgba(255,255,255,0.03);
      backdrop-filter: blur(20px);
      -webkit-backdrop-filter: blur(20px);
      border: 1px solid rgba(255,255,255,0.06);
      border-radius: 100px;
      padding: 10px 20px;
      margin-top: 32px;
      position: relative;
      z-index: 1;
    }
    .eta-pill i { color: var(--primary); font-size: 0.8rem; }
    .eta-pill span {
      font-family: var(--font-heading);
      font-weight: 800;
      font-size: 0.78rem;
      text-transform: uppercase;
      letter-spacing: 0.3px;
      color: var(--text-muted);
    }
    .eta-pill strong { color: #fff; }

    /* =============================================
       CONTENT GRID
       ============================================= */
    .ordered-content {
      max-width: 1200px;
      margin: 0 auto;
      padding: 36px 80px 80px;
      display: grid;
      grid-template-columns: 1fr 400px;
      gap: 32px;
      align-items: start;
    }
    .ordered-left { display: flex; flex-direction: column; gap: 24px; }
    .ordered-right {
      display: flex;
      flex-direction: column;
      gap: 24px;
      position: sticky;
      top: 88px;
    }

    /* =============================================
       GLASSMORPHIC DETAIL CARDS
       ============================================= */
    .detail-card {
      background: rgba(12,12,12,0.6);
      backdrop-filter: blur(30px);
      -webkit-backdrop-filter: blur(30px);
      border: 1px solid rgba(255,255,255,0.05);
      border-radius: 16px;
      overflow: hidden;
    }
    .detail-card-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 20px 24px;
      border-bottom: 1px solid rgba(255,255,255,0.04);
    }
    .dch-left { display: flex; align-items: center; gap: 12px; }
    .dch-icon {
      width: 38px; height: 38px;
      background: rgba(202,255,0,0.05);
      backdrop-filter: blur(10px);
      border: 1px solid rgba(202,255,0,0.1);
      border-radius: 8px;
      display: flex;
      align-items: center;
      justify-content: center;
      color: var(--primary);
      font-size: 0.95rem;
    }
    .dch-title {
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.95rem;
      text-transform: uppercase;
      letter-spacing: 0.3px;
    }
    .dch-sub { font-size: 0.75rem; color: var(--text-muted); margin-top: 1px; }
    .detail-card-body { padding: 24px; }

    /* =============================================
       INFO GRID — DARKER GLASS
       ============================================= */
    .info-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 16px;
    }
    .info-item { display: flex; flex-direction: column; gap: 6px; }
    .info-item.full { grid-column: span 2; }
    .info-label {
      font-family: var(--font-heading);
      font-weight: 800;
      font-size: 0.72rem;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      color: var(--text-muted);
    }
    .info-value {
      font-size: 0.9rem;
      color: #fff;
      background: rgba(255,255,255,0.02);
      backdrop-filter: blur(10px);
      border: 1px solid rgba(255,255,255,0.05);
      padding: 12px 16px;
      border-radius: 8px;
      line-height: 1.5;
    }

    /* =============================================
       ITEMS LIST
       ============================================= */
    .items-list { display: flex; flex-direction: column; }
    .item-row {
      display: flex;
      align-items: center;
      gap: 16px;
      padding: 16px 24px;
      border-bottom: 1px solid rgba(255,255,255,0.04);
      transition: background 0.2s;
    }
    .item-row:hover { background: rgba(255,255,255,0.015); }
    .item-row:last-child { border-bottom: none; }
    .item-emoji {
      width: 48px; height: 48px;
      background: rgba(255,255,255,0.03);
      border: 1px solid rgba(255,255,255,0.06);
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.4rem;
      flex-shrink: 0;
    }
    .item-info { flex: 1; min-width: 0; }
    .item-name {
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.88rem;
      text-transform: uppercase;
      color: #fff;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
      margin-bottom: 2px;
    }
    .item-rest { font-size: 0.75rem; color: var(--text-muted); }
    .item-qty {
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.75rem;
      color: var(--text-muted);
      background: rgba(255,255,255,0.03);
      border: 1px solid rgba(255,255,255,0.06);
      padding: 4px 12px;
      border-radius: 100px;
      flex-shrink: 0;
    }
    .item-price {
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.95rem;
      color: #fff;
      flex-shrink: 0;
      min-width: 60px;
      text-align: right;
    }

    /* =============================================
       BILL & PAYMENT
       ============================================= */
    .bill-rows {
      display: flex;
      flex-direction: column;
      gap: 12px;
      padding-bottom: 16px;
      border-bottom: 1px solid rgba(255,255,255,0.04);
    }
    .bill-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-size: 0.88rem;
      color: var(--text-muted);
    }
    .bill-row .lbl { display: flex; align-items: center; gap: 8px; }
    .bill-row .lbl i { color: var(--primary); width: 14px; text-align: center; }
    .bill-row .val { font-family: var(--font-heading); font-weight: 900; color: #fff; }
    .bill-row .val.free { color: var(--primary); }

    .bill-total {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding-top: 16px;
    }
    .bill-total .tl { font-family: var(--font-heading); font-weight: 900; font-size: 0.88rem; text-transform: uppercase; letter-spacing: 0.5px; }
    .bill-total .tv { font-family: var(--font-heading); font-weight: 900; font-size: 1.6rem; color: #fff; }

    .pay-status-pill {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.7rem;
      text-transform: uppercase;
      padding: 5px 14px;
      border-radius: 100px;
      margin-top: 4px;
      backdrop-filter: blur(10px);
    }
    .pay-status-pill.success {
      background: rgba(46,213,115,0.08);
      border: 1px solid rgba(46,213,115,0.2);
      color: #2ed573;
    }
    .pay-status-pill.pending {
      background: rgba(255,165,0,0.08);
      border: 1px solid rgba(255,165,0,0.2);
      color: #ffa502;
    }

    /* =============================================
       ACTION BUTTONS
       ============================================= */
    .action-group { display: flex; flex-direction: column; gap: 12px; margin-top: 24px; }
    .action-btn-primary {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
      padding: 16px;
      background: var(--primary);
      color: #000;
      border: none;
      border-radius: 10px;
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.95rem;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      cursor: pointer;
      transition: all 0.2s;
      text-decoration: none;
      text-align: center;
    }
    .action-btn-primary:hover {
      background: var(--primary-light);
      transform: translateY(-2px);
      box-shadow: 0 8px 24px rgba(202,255,0,0.3);
    }
    .action-btn-secondary {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      padding: 13px;
      background: rgba(255,255,255,0.02);
      backdrop-filter: blur(10px);
      color: var(--text-muted);
      border: 1px solid rgba(255,255,255,0.06);
      border-radius: 10px;
      font-family: var(--font-heading);
      font-weight: 800;
      font-size: 0.82rem;
      text-transform: uppercase;
      cursor: pointer;
      transition: all 0.2s;
      text-decoration: none;
      text-align: center;
    }
    .action-btn-secondary:hover { border-color: var(--primary); color: var(--primary); }

    /* =============================================
       RESPONSIVE
       ============================================= */
    @media (max-width: 1024px) {
      .ordered-content { grid-template-columns: 1fr; padding: 32px 40px 60px; }
      .ordered-right { position: static; }
      .ordered-hero { padding: 32px 40px 28px; }
      .tracker-slider-section { padding: 32px 40px 0; }
      .tracker-slider-card { padding: 32px 28px 36px; }
    }
    @media (max-width: 640px) {
      .ordered-content { padding: 24px 20px 48px; }
      .ordered-hero { padding: 24px 20px; }
      .tracker-slider-section { padding: 24px 20px 0; }
      .tracker-slider-card { padding: 24px 16px 28px; }
      .tracker-progress-steps { gap: 4px; }
      .tracker-progress-node { width: 42px; height: 42px; font-size: 0.85rem; }
      .tracker-progress-title { font-size: 0.65rem; }
      .tracker-progress-desc { display: none; }
      .info-grid { grid-template-columns: 1fr; }
      .info-item { grid-column: span 1 !important; }
      .item-row { padding: 14px 16px; gap: 12px; }
      .item-emoji { width: 40px; height: 40px; font-size: 1.25rem; }
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
      <li><a href="${pageContext.request.contextPath}/OrderTrackerServlet" class="active">Insta-Tracker</a></li>
      <li><a href="${pageContext.request.contextPath}/views/cart.jsp" onclick="return checkCartAccess(event)"><i class="fa-solid fa-cart-shopping" style="margin-right:5px;"></i>Cart</a></li>
    </ul>

    <div class="nav-actions">
      <!-- Profile Dropdown Component -->
      <div class="user-profile-dropdown">
        <button class="user-avatar-badge" onclick="toggleUserDropdown(event)" style="width: 36px; height: 36px; border-radius: 50%; background: linear-gradient(135deg, #caff00 0%, #00e5ff 100%); color: #000000; display: inline-flex; align-items: center; justify-content: center; font-family: var(--font-heading), sans-serif; font-weight: 900; font-size: 1.05rem; text-transform: uppercase; box-shadow: 0 0 15px rgba(202, 255, 0, 0.35); border: 1.5px solid rgba(255, 255, 255, 0.15); flex-shrink: 0; cursor: pointer; user-select: none; padding: 0; outline: none; transition: transform 0.2s ease;" title="<%= loggedInUser.getUsername() %>">
          <%= firstLetter %>
        </button>
        <div class="dropdown-menu" id="userDropdownMenu" style="display: none; position: absolute; right: 0; top: 48px; background-color: rgba(12,12,12,0.9); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.08); border-radius: 10px; box-shadow: 0 10px 40px rgba(0,0,0,0.7); min-width: 160px; z-index: 1000; overflow: hidden; box-sizing: border-box; text-align: left;">
          <div style="padding: 12px 16px; border-bottom: 1px solid rgba(255, 255, 255, 0.06); font-size: 0.8rem; color: #888; font-family: var(--font-heading), sans-serif; font-weight: 800; text-transform: uppercase; letter-spacing: 0.5px; white-space: nowrap;">
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

  <!-- Page Body -->
  <div class="ordered-page">

    <!-- Hero -->
    <div class="ordered-hero">
      <div class="ordered-hero-inner">
        <div>
          <h1>Order <span class="highlight"><%= statusHeader %></span></h1>
          <p>Order ID: <span style="color:#fff;">#INF-2026-<%= order.get("order_id") %></span> &nbsp;·&nbsp; Placed: <span><%= formattedDate %><% if (!formattedTime.isEmpty()) { %> at <%= formattedTime %><% } %></span></p>
        </div>
        <div class="order-status-badge">
          <span class="dot"></span>
          <span><%= badgeText %></span>
        </div>
      </div>
    </div>

    <!-- ========== HORIZONTAL SLIDER TRACKER ========== -->
    <div class="tracker-slider-section">
      <div class="tracker-slider-card">
        <div class="tracker-header">
          <div class="tracker-header-icon"><i class="fa-solid fa-route"></i></div>
          <div class="tracker-header-text">
            <h3>Live Tracking</h3>
            <p>Real-time status of your gourmet meal</p>
          </div>
        </div>

        <div class="tracker-progress-wrapper">
          <!-- Horizontal Rail -->
          <div class="tracker-progress-rail">
            <div class="tracker-progress-fill" id="railFill"></div>
            <div class="tracker-progress-thumb" id="railThumb">
              <svg viewBox="0 0 100 80" class="slider-symbol-svg" width="38" height="28" style="width: 38px; height: 28px; display: block;" xmlns="http://www.w3.org/2000/svg">
                <path d="M 0 40 L 40 40" stroke="#ffffff" stroke-width="16" stroke-linecap="square" />
                <path d="M 55 40 L 100 40" stroke="#ffffff" stroke-width="16" stroke-linecap="square" />
                <path d="M 40 30 H 60 L 42 55" fill="none" stroke="#ffffff" stroke-width="18" stroke-linejoin="miter" stroke-linecap="square" />
                
                <path class="symbol-line-left" d="M 0 40 L 40 40" stroke="currentColor" stroke-width="8" stroke-linecap="square" />
                <path class="symbol-line-right" d="M 55 40 L 100 40" stroke="currentColor" stroke-width="8" stroke-linecap="square" />
                <path class="symbol-7" d="M 40 30 H 60 L 42 55" fill="none" stroke="currentColor" stroke-width="10" stroke-linejoin="miter" stroke-linecap="square" />
              </svg>
            </div>
          </div>

          <!-- Step Nodes -->
          <div class="tracker-progress-steps">

            <div class="tracker-progress-step <%= activeStep >= 1 ? (activeStep > 1 ? "completed" : "active") : "" %>">
              <div class="tracker-progress-node"><i class="fa-solid fa-clipboard-check"></i></div>
              <div class="tracker-progress-info">
                <div class="tracker-progress-title">Confirmed</div>
                <div class="tracker-progress-desc">Order received by restaurant</div>
                <div class="tracker-progress-time"><%= formattedTime %></div>
              </div>
            </div>

            <div class="tracker-progress-step <%= activeStep >= 2 ? (activeStep > 2 ? "completed" : "active") : "" %>">
              <div class="tracker-progress-node"><i class="fa-solid fa-fire-burner"></i></div>
              <div class="tracker-progress-info">
                <div class="tracker-progress-title">Preparing</div>
                <div class="tracker-progress-desc">Chef is crafting your meal</div>
                <div class="tracker-progress-time"><%= activeStep >= 2 ? (activeStep > 2 ? "Done" : "In Progress") : "" %></div>
              </div>
            </div>

            <div class="tracker-progress-step <%= activeStep >= 3 ? (activeStep > 3 ? "completed" : "active") : "" %>">
              <div class="tracker-progress-node"><i class="fa-solid fa-motorcycle"></i></div>
              <div class="tracker-progress-info">
                <div class="tracker-progress-title">On the Way</div>
                <div class="tracker-progress-desc">Rider picked up your order</div>
                <div class="tracker-progress-time"><%= activeStep >= 3 ? (activeStep > 3 ? "Done" : "In Transit") : "" %></div>
              </div>
            </div>

            <div class="tracker-progress-step <%= activeStep >= 4 ? "completed" : "" %>">
              <div class="tracker-progress-node"><i class="fa-solid fa-circle-check"></i></div>
              <div class="tracker-progress-info">
                <div class="tracker-progress-title">Delivered</div>
                <div class="tracker-progress-desc">Enjoy your meal!</div>
                <div class="tracker-progress-time"><%= activeStep >= 4 ? "Delivered" : "" %></div>
              </div>
            </div>

          </div>
        </div>

        <div style="text-align:center;">
          <div class="eta-pill">
            <i class="fa-solid fa-clock"></i>
            <span>Estimated delivery: <strong>25–35 min</strong></span>
          </div>
        </div>
      </div>
    </div>

    <!-- Main Content -->
    <div class="ordered-content">

      <!-- Left Column -->
      <div class="ordered-left">

        <!-- Delivery Address Details -->
        <div class="detail-card">
          <div class="detail-card-header">
            <div class="dch-left">
              <div class="dch-icon"><i class="fa-solid fa-location-dot"></i></div>
              <div>
                <div class="dch-title">Delivery Details</div>
                <div class="dch-sub">Insta-Rider destination details</div>
              </div>
            </div>
          </div>
          <div class="detail-card-body">
            <div class="info-grid">
              <div class="info-item">
                <span class="info-label">Customer Name</span>
                <span class="info-value"><%= loggedInUser.getUsername() %></span>
              </div>
              <div class="info-item">
                <span class="info-label">Email Address</span>
                <span class="info-value"><%= loggedInUser.getEmail() %></span>
              </div>
              <div class="info-item full">
                <span class="info-label">Delivery Address</span>
                <span class="info-value"><%= (loggedInUser.getAddress() != null && !loggedInUser.getAddress().isEmpty()) ? loggedInUser.getAddress() : "Address not provided" %></span>
              </div>
            </div>
          </div>
        </div>

        <!-- Ordered Items list -->
        <div class="detail-card">
          <div class="detail-card-header">
            <div class="dch-left">
              <div class="dch-icon"><i class="fa-solid fa-utensils"></i></div>
              <div>
                <div class="dch-title">Items Ordered</div>
                <div class="dch-sub">Menu item quantities & subtotals</div>
              </div>
            </div>
          </div>
          <div class="items-list">
            <%
                if (orderItems != null) {
                    for (Map<String, Object> item : orderItems) {
                        String itemName = (String) item.get("item_name");
                        String imagePath = (String) item.get("image_path");
                        String rName = (String) item.get("restaurant_name");
                        int qty = (Integer) item.get("quantity");
                        double sub = (Double) item.get("subtotal");

                        String itemEmoji = "🍲";
                        String nameLower = itemName.toLowerCase();
                        if (nameLower.contains("chicken") || nameLower.contains("murgh")) itemEmoji = "🍗";
                        else if (nameLower.contains("biryani") || nameLower.contains("rice") || nameLower.contains("pulao")) itemEmoji = "🍚";
                        else if (nameLower.contains("pizza")) itemEmoji = "🍕";
                        else if (nameLower.contains("burger")) itemEmoji = "🍔";
                        else if (nameLower.contains("coffee") || nameLower.contains("tea") || nameLower.contains("shake")) itemEmoji = "☕";
                        else if (nameLower.contains("dessert") || nameLower.contains("cake") || nameLower.contains("ice")) itemEmoji = "🍰";
                        else if (nameLower.contains("salad")) itemEmoji = "🥗";
                        else if (nameLower.contains("roti") || nameLower.contains("nan") || nameLower.contains("bread")) itemEmoji = "🫓";
            %>
                        <div class="item-row">
                          <div class="item-emoji" style="position: relative; overflow: hidden; padding: 0;">
                            <% if (imagePath != null && !imagePath.trim().isEmpty()) { %>
                              <img src="<%= imagePath %>" alt="<%= itemName %>" style="width: 100%; height: 100%; object-fit: cover; display: block; border-radius: 10px;">
                            <% } else { %>
                              <%= itemEmoji %>
                            <% } %>
                          </div>
                          <div class="item-info">
                            <div class="item-name"><%= itemName %></div>
                            <div class="item-rest"><%= rName %></div>
                          </div>
                          <div class="item-qty">×<%= qty %></div>
                          <div class="item-price">₹<%= String.format("%.2f", sub) %></div>
                        </div>
            <%
                    }
                }
            %>
          </div>
        </div>

        <!-- Order History list -->
        <div class="detail-card">
          <div class="detail-card-header">
            <div class="dch-left">
              <div class="dch-icon"><i class="fa-solid fa-clock-rotate-left"></i></div>
              <div>
                <div class="dch-title">Your Order History</div>
                <div class="dch-sub">Track active orders or view past receipts</div>
              </div>
            </div>
          </div>
          <div class="items-list" style="max-height: 380px; overflow-y: auto;">
            <%
                if (userOrders != null && !userOrders.isEmpty()) {
                    for (Map<String, Object> o : userOrders) {
                        int pastOrderId = (Integer) o.get("order_id");
                        String pastRestName = (String) o.get("restaurant_name");
                        double pastTotal = (Double) o.get("total_amount");
                        String pastStatus = (String) o.get("status");
                        Timestamp pastDateTs = (Timestamp) o.get("order_date");
                        
                        String pastFormattedDate = "Recent";
                        if (pastDateTs != null) {
                            SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy");
                            pastFormattedDate = sdf.format(pastDateTs);
                        }
                        
                        boolean isActive = (pastOrderId == (Integer) order.get("order_id"));
            %>
                        <div class="item-row" style="<%= isActive ? "background: rgba(202, 255, 0, 0.02); border-left: 4px solid var(--primary);" : "" %>" onmouseover="this.style.background='rgba(255, 255, 255, 0.025)'" onmouseout="this.style.background='<%= isActive ? "rgba(202, 255, 0, 0.02)" : "transparent" %>'">
                          <div class="item-emoji" style="background: linear-gradient(135deg, rgba(255, 74, 150, 0.15) 0%, rgba(202, 255, 0, 0.1) 100%); border-color: rgba(255,255,255,0.06);">🛍️</div>
                          <div class="item-info">
                            <div class="item-name" style="font-size: 0.85rem; font-family: var(--font-heading); font-weight: 800; letter-spacing: 0.3px;">ORDER #INF-2026-<%= pastOrderId %></div>
                            <div class="item-rest" style="font-size: 0.72rem; color: var(--text-muted); margin-top: 2px;"><%= pastRestName != null ? pastRestName : "Instafoods Order" %> &bull; <%= pastFormattedDate %></div>
                          </div>
                          <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 6px;">
                            <div class="item-price" style="font-size: 0.95rem; font-family: var(--font-heading); font-weight: 900; color: #fff;">₹<%= String.format("%.2f", pastTotal) %></div>
                            <div style="display: flex; align-items: center; gap: 8px;">
                              <span style="font-size: 0.68rem; font-family: var(--font-heading); font-weight: 900; text-transform: uppercase; color: <%= "Delivered".equalsIgnoreCase(pastStatus) ? "#2ed573" : "#caff00" %>"><%= pastStatus %></span>
                              <% if (!isActive) { %>
                                <a href="${pageContext.request.contextPath}/OrderTrackerServlet?orderId=<%= pastOrderId %>" style="background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.12); color: #fff; padding: 4px 12px; font-size: 0.65rem; border-radius: 100px; text-transform: uppercase; font-family: var(--font-heading); font-weight: 900; text-decoration: none; transition: background 0.2s;" onmouseover="this.style.background='rgba(255,255,255,0.15)'" onmouseout="this.style.background='rgba(255,255,255,0.06)'">Track</a>
                              <% } else { %>
                                <span style="background: rgba(255,255,255,0.1); border: 1px solid rgba(255,255,255,0.18); color: #fff; padding: 4px 12px; font-size: 0.65rem; border-radius: 100px; text-transform: uppercase; font-family: var(--font-heading); font-weight: 900; letter-spacing: 0.2px;">Tracking</span>
                              <% } %>
                            </div>
                          </div>
                        </div>
            <%
                    }
                } else {
            %>
                    <div style="padding: 24px; text-align: center; color: var(--text-muted); font-size: 0.88rem;">
                      No order history found.
                    </div>
            <%
                }
            %>
          </div>
        </div>

      </div><!-- /ordered-left -->

      <!-- Right Column -->
      <div class="ordered-right">

        <!-- Payment Mode Card -->
        <div class="detail-card">
          <div class="detail-card-header">
            <div class="dch-left">
              <div class="dch-icon"><i class="fa-solid fa-credit-card"></i></div>
              <div>
                <div class="dch-title">Payment Mode</div>
                <div class="dch-sub">Transaction information</div>
              </div>
            </div>
          </div>
          <div class="detail-card-body" style="display:flex; flex-direction:column; gap:12px;">
            <div style="display:flex; align-items:center; gap:12px;">
              <% if ("UPI".equalsIgnoreCase((String) order.get("payment_mode"))) { %>
                <span style="font-size:1.8rem; background:rgba(255,255,255,0.03); backdrop-filter:blur(10px); padding:10px; border-radius:10px; border:1px solid rgba(255,255,255,0.06);">📲</span>
                <div>
                  <div class="dch-title" style="font-size:0.92rem;">UPI Payment</div>
                  <div style="font-size:0.78rem; color:var(--text-muted); margin-top:2px;">Paid via Instant UPI</div>
                </div>
              <% } else { %>
                <span style="font-size:1.8rem; background:rgba(255,255,255,0.03); backdrop-filter:blur(10px); padding:10px; border-radius:10px; border:1px solid rgba(255,255,255,0.06);">💵</span>
                <div>
                  <div class="dch-title" style="font-size:0.92rem;">Cash on Delivery</div>
                  <div style="font-size:0.78rem; color:var(--text-muted); margin-top:2px;">Pay ₹<%= String.format("%.2f", totalPaid) %> on arrival</div>
                </div>
              <% } %>
            </div>
            <div>
              <% if ("UPI".equalsIgnoreCase((String) order.get("payment_mode"))) { %>
                <span class="pay-status-pill success"><i class="fa-solid fa-circle-check" style="font-size:0.6rem;"></i> Paid successfully</span>
              <% } else { %>
                <span class="pay-status-pill pending"><i class="fa-solid fa-clock" style="font-size:0.6rem;"></i> Payment pending</span>
              <% } %>
            </div>
          </div>
        </div>

        <!-- Bill Details Card -->
        <div class="detail-card">
          <div class="detail-card-header">
            <div class="dch-left">
              <div class="dch-icon"><i class="fa-solid fa-receipt"></i></div>
              <div>
                <div class="dch-title">Bill Details</div>
                <div class="dch-sub">Receipt breakdown</div>
              </div>
            </div>
          </div>
          <div class="detail-card-body">
            <div class="bill-rows">
              <div class="bill-row">
                <span class="lbl"><i class="fa-solid fa-receipt"></i> Subtotal</span>
                <span class="val">₹<%= String.format("%.2f", calculatedSubtotal) %></span>
              </div>
              <div class="bill-row">
                <span class="lbl"><i class="fa-solid fa-truck-fast"></i> Delivery Fee</span>
                <span class="val free">FREE</span>
              </div>
              <div class="bill-row">
                <span class="lbl"><i class="fa-solid fa-shield-halved"></i> Platform Fee</span>
                <span class="val">₹<%= String.format("%.2f", platformFee) %></span>
              </div>
              <div class="bill-row">
                <span class="lbl"><i class="fa-solid fa-percent"></i> GST & Taxes</span>
                <span class="val">₹<%= String.format("%.2f", calculatedTax) %></span>
              </div>
            </div>

            <div class="bill-total">
              <span class="tl">Total Paid</span>
              <span class="tv">₹<%= String.format("%.2f", totalPaid) %></span>
            </div>

            <div class="action-group">
              <a href="${pageContext.request.contextPath}/LandingServlet" class="action-btn-primary">
                <i class="fa-solid fa-house"></i> Return to Home
              </a>
              <a href="${pageContext.request.contextPath}/ResturantServlet" class="action-btn-secondary">
                <i class="fa-solid fa-utensils"></i> Order Something Else
              </a>
            </div>
          </div>
        </div>

      </div><!-- /ordered-right -->

    </div><!-- /ordered-content -->

  </div><!-- /ordered-page -->

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
      if (menu) menu.style.display = 'none';
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

    /* ---- Hamburger ---- */
    const hamburger = document.getElementById('hamburger');
    if (hamburger) {
      hamburger.addEventListener('click', () => {
        document.querySelector('.nav-links').classList.toggle('open');
        hamburger.classList.toggle('open');
      });
    }

    /* ---- Animate Slider Rail Fill on Load ---- */
    document.addEventListener('DOMContentLoaded', () => {
      const activeStep = <%= activeStep %>;
      const railFill = document.getElementById('railFill');
      const railThumb = document.getElementById('railThumb');
      if (railFill) {
        // Calculate fill width: step 1 = 0%, step 2 = 33%, step 3 = 66%, step 4 = 100%
        const fillPercent = ((activeStep - 1) / 3) * 100;
        // Animate after a short delay for visual effect
        setTimeout(() => {
          railFill.style.width = fillPercent + '%';
          if (railThumb) {
            railThumb.style.left = fillPercent + '%';
          }
        }, 300);
      }

      // Auto-refresh the page if the order is not yet delivered
      if (activeStep < 4) {
        setTimeout(() => {
          window.location.reload();
        }, 5000);
      }
    });
  </script>
</body>
</html>
