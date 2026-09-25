<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.instafoo.Model.Restaurant" %>
<%@ page import="com.instafoo.Model.Menu" %>
<%@ page import="com.instafoo.Model.User" %>
<%
    User sessionUser = (User) session.getAttribute("user");
    if (sessionUser == null || sessionUser.getRole() == null || !"Admin".equalsIgnoreCase(sessionUser.getRole().trim())) {
        session.setAttribute("errorMsg", "Access Denied. Administrator privilege required.");
        response.sendRedirect(request.getContextPath() + "/views/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <link rel="icon" type="image/x-icon" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQz8HFcByuK1fp2KQdFls5532X50P87Ucp1kg&s">
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Instafoods Administrator Dashboard</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Outfit:wght@800;900&display=swap" rel="stylesheet">
  <style>
    /* ==========================================================================
       ADMIN STYLING SYSTEM - Brutalist Neon Lime Theme
       ========================================================================== */
    :root {
      --color-ember-orange: #caff00; /* Neon Lime is the sole accent */
      --color-onyx: #080808;
      --color-graphite: #ffffff;
      --color-stone: #a0a0a0;
      --color-silver-mist: rgba(255, 255, 255, 0.08);
      --color-fog: #121212;
      --color-paper: #080808;
      --color-pure-white: #121212;
    }

    body {
      background-color: var(--color-paper) !important;
      color: var(--color-graphite) !important;
      font-family: var(--font-body), sans-serif !important;
    }

    .admin-page-container {
      padding: 140px 80px 80px;
      max-width: 1360px;
      margin: 0 auto;
      min-height: 80vh;
      font-family: var(--font-body), sans-serif;
    }

    .admin-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 40px;
      animation: none;
    }

    .admin-header h1 {
      font-family: var(--font-heading), sans-serif;
      font-size: 2.5rem;
      font-weight: 900;
      color: #fff;
      margin: 0 0 8px 0;
      text-transform: uppercase;
      letter-spacing: -0.5px;
    }

    .admin-header p {
      color: var(--color-stone);
      margin: 0;
      font-size: 1rem;
    }

    /* Stats Grid */
    .admin-stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
      gap: 24px;
      margin-bottom: 40px;
    }

    .stat-card {
      background: var(--color-pure-white) !important;
      border: 1px solid var(--color-silver-mist) !important;
      border-radius: 0px !important; /* Brutalist sharp */
      padding: 24px;
      display: flex;
      align-items: center;
      gap: 20px;
    }

    .stat-icon {
      width: 50px;
      height: 50px;
      border-radius: 9999px !important; /* Pill style */
      display: inline-flex;
      align-items: center;
      justify-content: center;
      font-size: 1.5rem;
      background: rgba(202, 255, 0, 0.08) !important;
      color: var(--color-ember-orange) !important;
      border: 1px solid rgba(202, 255, 0, 0.15) !important;
    }

    .stat-icon.blue {
      background: rgba(0, 229, 255, 0.08) !important;
      color: #00e5ff !important;
      border: 1px solid rgba(0, 229, 255, 0.15) !important;
    }

    .stat-info h3 {
      font-size: 1.8rem;
      font-weight: 900;
      color: #fff;
      margin: 0;
      font-family: var(--font-heading), sans-serif;
    }

    .stat-info p {
      color: var(--color-stone);
      margin: 3px 0 0 0;
      font-size: 0.85rem;
      text-transform: uppercase;
      font-family: var(--font-heading), sans-serif;
      font-weight: 800;
      letter-spacing: 0.5px;
    }

    /* Controls Bar */
    .admin-controls-bar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      background: var(--color-pure-white) !important;
      border: 1px solid var(--color-silver-mist) !important;
      padding: 16px 24px;
      border-radius: 0px !important;
      margin-bottom: 30px;
    }

    /* Restaurant Accordion / Rows */
    .restaurant-row-card {
      background: var(--color-pure-white) !important;
      border: 1px solid var(--color-silver-mist) !important;
      border-radius: 0px !important; /* Brutalist sharp */
      margin-bottom: 20px;
      overflow: hidden;
      transition: border-color 0.3s;
    }

    .restaurant-row-card:hover {
      border-color: var(--color-ember-orange) !important;
    }

    .restaurant-row-header {
      display: flex;
      align-items: center;
      padding: 20px 24px;
      cursor: pointer;
      justify-content: space-between;
      user-select: none;
    }

    .restaurant-row-meta {
      display: flex;
      align-items: center;
      gap: 20px;
      flex-grow: 1;
    }

    .restaurant-img-thumb {
      width: 60px;
      height: 60px;
      border-radius: 0px !important; /* Brutalist sharp */
      object-fit: cover;
      border: 1px solid var(--color-silver-mist);
    }

    .restaurant-info h2 {
      font-family: var(--font-heading), sans-serif;
      font-size: 1.25rem;
      font-weight: 900;
      color: #fff;
      margin: 0;
      text-transform: uppercase;
    }

    .restaurant-info p {
      margin: 4px 0 0 0;
      font-size: 0.85rem;
      color: var(--color-stone);
    }

    .restaurant-actions {
      display: flex;
      align-items: center;
      gap: 24px;
    }

    /* Switch Styling */
    .switch {
      position: relative;
      display: inline-block;
      width: 48px;
      height: 24px;
    }

    .switch input {
      opacity: 0;
      width: 0;
      height: 0;
    }

    .slider {
      position: absolute;
      cursor: pointer;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background-color: rgba(255,255,255,0.1);
      transition: .3s;
      border-radius: 24px;
    }

    .slider:before {
      position: absolute;
      content: "";
      height: 18px;
      width: 18px;
      left: 3px;
      bottom: 3px;
      background-color: #fff;
      transition: .3s;
      border-radius: 50%;
    }

    input:checked + .slider {
      background-color: var(--color-ember-orange);
    }

    input:checked + .slider:before {
      transform: translateX(24px);
      background-color: var(--color-onyx);
    }

    /* Expandable Items Panel */
    .menu-items-panel {
      border-top: 1px solid var(--color-silver-mist) !important;
      background: #0a0a0a !important; /* Dark contrast background */
      padding: 24px;
      display: none;
    }

    .menu-panel-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
    }

    .menu-panel-header h4 {
      margin: 0;
      font-family: var(--font-heading), sans-serif;
      font-weight: 900;
      color: #fff;
      font-size: 1.05rem;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }

    .items-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
      gap: 20px;
    }

    .item-card {
      background: var(--color-pure-white) !important;
      border: 1px solid var(--color-silver-mist) !important;
      border-radius: 0px !important; /* Brutalist sharp */
      padding: 16px;
      display: flex;
      gap: 16px;
      align-items: center;
      justify-content: space-between;
      box-sizing: border-box;
      width: 100%;
      overflow: hidden;
    }

    .item-card-left {
      display: flex;
      gap: 16px;
      align-items: center;
      flex: 1;
      min-width: 0;
    }

    .item-card-img {
      width: 50px;
      height: 50px;
      border-radius: 0px !important; /* Brutalist sharp */
      object-fit: cover;
      border: 1px solid var(--color-silver-mist);
    }

    .item-card-details {
      flex: 1;
      min-width: 0;
    }

    .item-card-details h5 {
      margin: 0;
      font-size: 0.95rem;
      color: #fff;
      font-weight: 700;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
      text-transform: uppercase;
      font-family: var(--font-heading), sans-serif;
    }

    .item-card-details p {
      margin: 3px 0 0 0;
      font-size: 0.8rem;
      color: var(--color-stone);
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
      width: 100%;
    }

    .item-card-details span {
      display: block;
      margin-top: 4px;
      font-weight: 800;
      color: var(--color-ember-orange);
      font-size: 0.9rem;
      font-family: var(--font-heading), sans-serif;
    }

    .item-card-right {
      display: flex;
      align-items: center;
      gap: 16px;
      flex-shrink: 0;
    }

    /* Buttons */
    .btn-icon-red {
      background: rgba(255, 74, 74, 0.08) !important;
      border: 1px solid rgba(255, 74, 74, 0.15) !important;
      color: #ff4a4a;
      width: 32px;
      height: 32px;
      border-radius: 50% !important; /* Round circular buttons */
      display: inline-flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      transition: all 0.2s;
    }

    .btn-icon-red:hover {
      background: #ff4a4a !important;
      color: #000 !important;
      border-color: #ff4a4a !important;
    }

    /* Modals */
    .modal-overlay {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0, 0, 0, 0.85);
      backdrop-filter: blur(12px);
      z-index: 2000;
      display: flex;
      align-items: center;
      justify-content: center;
      opacity: 0;
      pointer-events: none;
      transition: opacity 0.3s ease;
    }

    .modal-overlay.open {
      opacity: 1;
      pointer-events: auto;
    }

    .admin-modal-card {
      background: var(--color-onyx) !important;
      border: 1px solid var(--color-silver-mist) !important;
      border-radius: 0px !important; /* Brutalist sharp */
      padding: 32px;
      width: 100%;
      max-width: 500px;
      max-height: 90vh;
      overflow-y: auto;
      box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.8);
      transform: translateY(20px);
      transition: transform 0.3s ease;
      scrollbar-width: thin;
      scrollbar-color: rgba(255,255,255,0.1) transparent;
    }

    .admin-modal-card::-webkit-scrollbar {
      width: 6px;
    }
    .admin-modal-card::-webkit-scrollbar-thumb {
      background: rgba(255,255,255,0.1);
      border-radius: 3px;
    }

    .admin-modal-card .input-group input,
    .admin-modal-card .input-group select {
      background: #121212 !important;
      border: 1px solid var(--color-silver-mist) !important;
      color: #ffffff !important;
      padding: 12px 14px !important;
      border-radius: 0px !important; /* Brutalist sharp */
      width: 100%;
      box-sizing: border-box;
      outline: none;
      font-family: var(--font-body) !important;
      font-size: 0.95rem !important;
      transition: border-color 0.2s, box-shadow 0.2s;
    }

    .admin-modal-card .input-group input:focus,
    .admin-modal-card .input-group select:focus {
      border-color: var(--color-ember-orange) !important;
      box-shadow: 0 0 10px rgba(202,255,0,0.15) !important;
    }

    .modal-overlay.open .admin-modal-card {
      transform: translateY(0);
    }

    .modal-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 24px;
    }

    .modal-header h3 {
      margin: 0;
      font-family: var(--font-heading), sans-serif;
      font-weight: 900;
      font-size: 1.4rem;
      color: #fff;
      text-transform: uppercase;
    }

    .modal-close-btn {
      background: none;
      border: none;
      color: var(--color-stone);
      font-size: 1.5rem;
      cursor: pointer;
      transition: color 0.2s;
    }

    .modal-close-btn:hover { color: #fff; }

    /* Alert Banner */
    .alert-banner {
      padding: 14px 20px;
      border-radius: 0px !important; /* Brutalist sharp */
      margin-bottom: 30px;
      font-family: var(--font-body);
      font-size: 0.9rem;
      display: flex;
      align-items: center;
      gap: 12px;
    }

    .alert-banner.success {
      background: rgba(202, 255, 0, 0.08) !important;
      border: 1px solid var(--color-ember-orange) !important;
      color: var(--color-ember-orange) !important;
    }

    .alert-banner.error {
      background: rgba(255, 74, 74, 0.08) !important;
      border: 1px solid #ff4a4a !important;
      color: #ff8888 !important;
    }

    /* ==========================================================================
       SIDEBAR & TABS DASHBOARD SYSTEM
       ========================================================================== */
    body {
      margin: 0 !important;
      padding: 0 !important;
      overflow-x: hidden !important;
    }
    
    .admin-dashboard-wrapper {
      display: flex;
      min-height: 100vh;
      background-color: #080808;
    }

    .admin-sidebar {
      width: 280px;
      background-color: #121212;
      border-right: 1px solid rgba(255, 255, 255, 0.08);
      display: flex;
      flex-direction: column;
      position: fixed;
      top: 0;
      bottom: 0;
      left: 0;
      z-index: 100;
      padding: 30px 24px;
      box-sizing: border-box;
    }

    .sidebar-brand {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 40px;
      padding-bottom: 20px;
      border-bottom: 1px solid rgba(255, 255, 255, 0.08);
    }

    .sidebar-brand .logo-text {
      font-family: var(--font-heading), sans-serif;
      font-size: 1.6rem;
      font-weight: 900;
      color: #ffffff;
      letter-spacing: -0.5px;
    }
    .sidebar-brand .logo-text span {
      color: #caff00;
    }
    .sidebar-brand .badge {
      background: rgba(202, 255, 0, 0.08);
      color: #caff00;
      border: 1px solid rgba(202, 255, 0, 0.15);
      font-size: 0.65rem;
      padding: 3px 8px;
      border-radius: 9999px;
      font-family: var(--font-heading);
      font-weight: 800;
      letter-spacing: 0.5px;
    }

    .sidebar-nav {
      display: flex;
      flex-direction: column;
      gap: 10px;
      flex: 1;
    }

    .nav-item {
      display: flex;
      align-items: center;
      gap: 14px;
      color: #a0a0a0;
      text-decoration: none;
      padding: 14px 18px;
      border-radius: 9999px; /* pill styling */
      font-family: var(--font-heading), sans-serif;
      font-weight: 900;
      font-size: 0.82rem;
      text-transform: uppercase;
      letter-spacing: 0.8px;
      transition: all 0.25s ease;
      cursor: pointer;
      border: 1px solid transparent;
    }

    .nav-item i {
      font-size: 1.15rem;
      width: 20px;
      text-align: center;
    }

    .nav-item:hover {
      color: #ffffff;
      background-color: rgba(255, 255, 255, 0.03);
      border-color: rgba(255, 255, 255, 0.05);
    }

    .nav-item.active {
      color: #080808;
      background-color: #caff00;
      box-shadow: 0 4px 20px rgba(202, 255, 0, 0.2);
      border-color: #caff00;
    }

    .sidebar-footer {
      border-top: 1px solid rgba(255, 255, 255, 0.08);
      padding-top: 20px;
      display: flex;
      flex-direction: column;
      gap: 18px;
    }

    .sidebar-footer .user-info {
      display: flex;
      align-items: center;
      gap: 12px;
    }

    .sidebar-footer .user-info .avatar {
      width: 42px;
      height: 42px;
      border-radius: 50%;
      background: linear-gradient(135deg, #caff00 0%, #00e5ff 100%);
      color: #080808;
      display: flex;
      align-items: center;
      justify-content: center;
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 1.15rem;
      box-shadow: 0 0 15px rgba(202, 255, 0, 0.2);
    }

    .sidebar-footer .user-info .name {
      color: #ffffff;
      font-family: var(--font-heading);
      font-size: 0.95rem;
      font-weight: 900;
      line-height: 1.2;
    }

    .sidebar-footer .user-info .role {
      color: #a0a0a0;
      font-size: 0.72rem;
      font-weight: 500;
    }

    .btn-signout {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      border: 1px solid rgba(255, 74, 74, 0.15) !important;
      background: rgba(255, 74, 74, 0.04) !important;
      color: #ff4a4a !important;
      text-decoration: none;
      padding: 12px;
      border-radius: 9999px !important;
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.8rem;
      text-transform: uppercase;
      transition: all 0.25s ease;
      text-align: center;
      letter-spacing: 0.5px;
    }

    .btn-signout:hover {
      background: #ff4a4a !important;
      color: #ffffff !important;
      box-shadow: 0 4px 15px rgba(255, 74, 74, 0.2) !important;
    }

    .admin-main-content {
      flex: 1;
      margin-left: 280px; /* Sidebar offset */
      padding: 60px 40px; /* Reduced from 80px to give content more room */
      min-height: 100vh;
      box-sizing: border-box;
      overflow-x: hidden;
    }

    /* Panels style definition */
    .admin-panel {
      display: none;
    }

    .admin-panel.active {
      display: block;
      animation: fadeIn 0.4s cubic-bezier(0.16, 1, 0.3, 1);
    }

    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(12px); }
      to { opacity: 1; transform: translateY(0); }
    }

    /* Form and Table Custom Overrides */
    .admin-table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
      text-align: left;
    }
    .admin-table th {
      font-family: var(--font-heading);
      font-weight: 900;
      text-transform: uppercase;
      font-size: 0.8rem;
      letter-spacing: 0.8px;
      color: #a0a0a0;
      padding: 16px 20px;
      border-bottom: 2px solid rgba(255, 255, 255, 0.08);
    }
    .admin-table td {
      padding: 18px 20px;
      border-bottom: 1px solid rgba(255, 255, 255, 0.05);
      font-size: 0.9rem;
      color: #ffffff;
      vertical-align: middle;
    }
    .admin-table tr:hover {
      background: rgba(255, 255, 255, 0.02);
    }

    .status-pill {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 6px 14px;
      border-radius: 9999px;
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.7rem;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
    .status-pill.placed {
      background: rgba(0, 229, 255, 0.08);
      color: #00e5ff;
      border: 1px solid rgba(0, 229, 255, 0.15);
    }
    .status-pill.preparing {
      background: rgba(255, 170, 0, 0.08);
      color: #ffaa00;
      border: 1px solid rgba(255, 170, 0, 0.15);
    }
    .status-pill.out {
      background: rgba(138, 43, 226, 0.08);
      color: #da70d6;
      border: 1px solid rgba(138, 43, 226, 0.15);
    }
    .status-pill.delivered {
      background: rgba(202, 255, 0, 0.08);
      color: #caff00;
      border: 1px solid rgba(202, 255, 0, 0.15);
    }

    .search-input-group {
      position: relative;
      display: flex;
      align-items: center;
      width: 100%;
      max-width: 380px;
    }
    .search-input-group input {
      width: 100%;
      background: #121212 !important;
      border: 1px solid rgba(255, 255, 255, 0.08) !important;
      color: #ffffff !important;
      padding: 12px 16px 12px 42px !important;
      border-radius: 9999px !important;
      outline: none !important;
      font-family: var(--font-body), sans-serif !important;
      font-size: 0.88rem !important;
      transition: all 0.25s ease !important;
    }
    .search-input-group input:focus {
      border-color: #caff00 !important;
      box-shadow: 0 0 12px rgba(202, 255, 0, 0.1) !important;
    }
    .search-input-group i {
      position: absolute;
      left: 16px;
      color: #a0a0a0;
      font-size: 0.95rem;
    }

    /* Sub-tabs layout inside panelOrders */
    .sub-tabs-container {
      display: flex !important;
      gap: 16px !important;
      margin-top: 20px !important;
      border-bottom: 1px solid rgba(255, 255, 255, 0.08) !important;
      padding-bottom: 10px !important;
    }
    .sub-tab-btn {
      background: transparent !important;
      border: none !important;
      color: #a0a0a0 !important;
      font-family: var(--font-heading), sans-serif !important;
      font-weight: 900 !important;
      font-size: 0.78rem !important;
      text-transform: uppercase !important;
      letter-spacing: 0.5px !important;
      cursor: pointer !important;
      padding: 6px 12px !important;
      border-bottom: 2px solid transparent !important;
      transition: all 0.2s ease !important;
      outline: none !important;
    }
    .sub-tab-btn:hover {
      color: #ffffff !important;
    }
    .sub-tab-btn.active {
      color: #caff00 !important;
      border-bottom-color: #caff00 !important;
    }
    .order-sub-panel {
      display: none !important;
    }
    .order-sub-panel.active {
      display: block !important;
    }
  </style>
</head>
<body>
  <%
      User loggedInUser = (User) session.getAttribute("user");
      char firstLetter = 'U';
      if (loggedInUser != null) {
          if (loggedInUser.getUsername() != null && !loggedInUser.getUsername().trim().isEmpty()) {
              firstLetter = loggedInUser.getUsername().trim().toUpperCase().charAt(0);
          }
      }
  %>

  <div class="admin-dashboard-wrapper">
    <!-- Sidebar Navigation -->
    <aside class="admin-sidebar">
      <div class="sidebar-brand">
        <span class="logo-text">Insta<span>Foods</span></span>
        <span class="badge">ADMIN</span>
      </div>
      <nav class="sidebar-nav">
        <a href="javascript:void(0)" class="nav-item active" id="tabLinkRestaurants" onclick="switchTab('Restaurants')">
          <i class="fa-solid fa-store"></i>
          <span>Restaurants</span>
        </a>
        <a href="javascript:void(0)" class="nav-item" id="tabLinkMenuItems" onclick="switchTab('MenuItems')">
          <i class="fa-solid fa-utensils"></i>
          <span>Menu Items</span>
        </a>
        <a href="javascript:void(0)" class="nav-item" id="tabLinkOrders" onclick="switchTab('Orders')">
          <i class="fa-solid fa-receipt"></i>
          <span>Orders & History</span>
        </a>
      </nav>
      <div class="sidebar-footer">
        <div class="user-info">
          <div class="avatar"><%= firstLetter %></div>
          <div>
            <div class="name"><%= loggedInUser != null ? loggedInUser.getUsername() : "Admin" %></div>
            <div class="role">Administrator</div>
          </div>
        </div>
        <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn-signout">
          <i class="fa-solid fa-arrow-right-from-bracket"></i>
          <span>Sign Out</span>
        </a>
      </div>
    </aside>

    <!-- Main Content Area -->
    <main class="admin-main-content">

      <!-- Feedback Banners -->
      <% 
          String successMsg = (String) session.getAttribute("successMsg");
          String errorMsg = (String) session.getAttribute("errorMsg");
          if (successMsg != null) { 
      %>
          <div class="alert-banner success">
            <i class="fa-solid fa-circle-check"></i>
            <%= successMsg %>
          </div>
      <% 
              session.removeAttribute("successMsg");
          } 
          if (errorMsg != null) { 
      %>
          <div class="alert-banner error">
            <i class="fa-solid fa-triangle-exclamation"></i>
            <%= errorMsg %>
          </div>
      <% 
              session.removeAttribute("errorMsg");
          } 
      %>

      <!-- ============ PANEL 1: RESTAURANTS ============ -->
      <div class="admin-panel active" id="panelRestaurants">
        <!-- Header -->
        <div class="admin-header">
          <div>
            <h1>Admin Control Panel</h1>
            <p>Manage partner kitchens and dynamic listings</p>
          </div>
          <button class="btn btn-primary" onclick="openModal('addRestaurantModal')">
            <i class="fa-solid fa-plus" style="margin-right: 6px;"></i> Add Restaurant
          </button>
        </div>

        <!-- Stats summary counters -->
        <%
            List<Restaurant> restaurantList = (List<Restaurant>) request.getAttribute("restaurantList");
            List<Menu> menuList = (List<Menu>) request.getAttribute("menuList");
            int totalRestaurants = (restaurantList != null) ? restaurantList.size() : 0;
            int totalItems = (menuList != null) ? menuList.size() : 0;
            int activeRestaurants = 0;
            if (restaurantList != null) {
                for (Restaurant r : restaurantList) {
                    if (r.getIs_active() != null && r.getIs_active()) {
                        activeRestaurants++;
                    }
                }
            }
        %>
        <div class="admin-stats-grid">
          <div class="stat-card">
            <div class="stat-icon"><i class="fa-solid fa-store"></i></div>
            <div class="stat-info">
              <h3><%= totalRestaurants %></h3>
              <p>Total Kitchens</p>
            </div>
          </div>
          <div class="stat-card">
            <div class="stat-icon"><i class="fa-solid fa-bolt"></i></div>
        <div class="stat-info">
          <h3><%= activeRestaurants %></h3>
          <p>Live Kitchens</p>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon blue"><i class="fa-solid fa-utensils"></i></div>
        <div class="stat-info">
          <h3><%= totalItems %></h3>
          <p>Cataloged Dishes</p>
        </div>
      </div>
    </div>

    <!-- Restaurants control accordion list -->
    <div style="margin-top: 30px;">
      <%
          if (restaurantList != null && !restaurantList.isEmpty()) {
              for (Restaurant r : restaurantList) {
                  int rId = r.getResturant_id();
      %>
                  <div class="restaurant-row-card">
                    <!-- Accordion header row -->
                    <div class="restaurant-row-header" onclick="toggleMenuDrawer(<%= rId %>)">
                      <div class="restaurant-row-meta">
                        <img class="restaurant-img-thumb" src="<%= (r.getImage_path() != null && !r.getImage_path().isEmpty()) ? r.getImage_path() : "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?q=80&w=600&auto=format&fit=crop" %>" alt="cover">
                        <div class="restaurant-info">
                          <h2><%= r.getName() %></h2>
                          <p><%= r.getCuisine_type() %> &nbsp;·&nbsp; <%= r.getDelivery_time() %> mins &nbsp;·&nbsp; <%= r.getAddress() %></p>
                        </div>
                      </div>
                      
                      <div class="restaurant-actions" onclick="event.stopPropagation()">
                        <!-- Live Switch Toggle Form -->
                        <form action="${pageContext.request.contextPath}/AdminServlet" method="POST" id="toggleFormRest_<%= rId %>">
                          <input type="hidden" name="action" value="toggleRestaurant">
                          <input type="hidden" name="restaurantId" value="<%= rId %>">
                          <input type="hidden" name="currentStatus" value="<%= r.getIs_active() %>">
                          <label class="switch">
                            <input type="checkbox" <%= (r.getIs_active() != null && r.getIs_active()) ? "checked" : "" %> onchange="document.getElementById('toggleFormRest_<%= rId %>').submit()">
                            <span class="slider"></span>
                          </label>
                        </form>

                        <!-- Delete Button Form -->
                        <form action="${pageContext.request.contextPath}/AdminServlet" method="POST" onsubmit="return confirm('Are you sure you want to delete this restaurant and all of its items?')" style="display:inline;">
                          <input type="hidden" name="action" value="deleteRestaurant">
                          <input type="hidden" name="restaurantId" value="<%= rId %>">
                          <button type="submit" class="btn-icon-red"><i class="fa-solid fa-trash-can"></i></button>
                        </form>

                        <button class="btn btn-outline" style="padding: 6px 14px; font-size: 0.8rem;" onclick="toggleMenuDrawer(<%= rId %>)">Menu</button>
                      </div>
                    </div>

                    <!-- Inner items lists drawer panel -->
                    <div class="menu-items-panel" id="menuDrawer_<%= rId %>">
                      <div class="menu-panel-header">
                        <h4>Menu Items</h4>
                        <button class="btn btn-outline" style="padding: 6px 14px; font-size: 0.8rem;" onclick="openAddMenuModal(<%= rId %>, '<%= r.getName().replace("'", "\\'") %>')">
                          <i class="fa-solid fa-plus" style="margin-right: 4px;"></i> Add Dish
                        </button>
                      </div>

                      <div class="items-grid">
                        <%
                            boolean hasItems = false;
                            if (menuList != null) {
                                for (Menu m : menuList) {
                                    if (m.getRestaurantId() == rId) {
                                        hasItems = true;
                                        int mId = m.getMenuId();
                        %>
                                        <div class="item-card">
                                          <div class="item-card-left">
                                            <img class="item-card-img" src="<%= (m.getImagePath() != null && !m.getImagePath().isEmpty()) ? m.getImagePath() : "https://images.unsplash.com/photo-1541832676-9b763b0239ab?q=80&w=600&auto=format&fit=crop" %>" alt="dish">
                                            <div class="item-card-details">
                                              <h5><%= m.getItemName() %></h5>
                                              <p><%= m.getDescription() %></p>
                                              <span>₹<%= m.getPrice() %></span>
                                            </div>
                                          </div>
                                          
                                          <div class="item-card-right">
                                            <!-- Availability Toggle Form -->
                                            <form action="${pageContext.request.contextPath}/AdminServlet" method="POST" id="toggleFormMenu_<%= mId %>">
                                              <input type="hidden" name="action" value="toggleMenuItem">
                                              <input type="hidden" name="menuId" value="<%= mId %>">
                                              <input type="hidden" name="currentStatus" value="<%= m.isAvailable() %>">
                                              <label class="switch" title="<%= m.isAvailable() ? "In Stock" : "Out of Stock" %>">
                                                <input type="checkbox" <%= m.isAvailable() ? "checked" : "" %> onchange="document.getElementById('toggleFormMenu_<%= mId %>').submit()">
                                                <span class="slider"></span>
                                              </label>
                                            </form>

                                            <!-- Edit Dish Button -->
                                            <button class="btn btn-outline" style="padding: 6px 10px; font-size: 0.8rem; height: 32px; display: inline-flex; align-items: center; justify-content: center;" 
                                                    onclick="openEditMenuModal(<%= mId %>, '<%= m.getItemName().replace("'", "\\'") %>', '<%= m.getDescription().replace("'", "\\'") %>', <%= m.getPrice() %>, '<%= m.getImagePath().replace("'", "\\'") %>', <%= m.isAvailable() %>)">
                                              <i class="fa-solid fa-pen-to-square"></i>
                                            </button>

                                            <!-- Delete Dish Form -->
                                            <form action="${pageContext.request.contextPath}/AdminServlet" method="POST" onsubmit="return confirm('Delete this menu item?')" style="display:inline;">
                                              <input type="hidden" name="action" value="deleteMenuItem">
                                              <input type="hidden" name="menuId" value="<%= mId %>">
                                              <button type="submit" class="btn-icon-red"><i class="fa-solid fa-trash-can"></i></button>
                                            </form>
                                          </div>
                                        </div>
                        <%
                                    }
                                }
                            }
                            if (!hasItems) {
                        %>
                                <div style="color: var(--text-muted); font-size: 0.9rem; grid-column: 1/-1; text-align: center; padding: 20px 0;">No menu items cataloged for this restaurant.</div>
                        <%
                            }
                        %>
                      </div>
                    </div>
                  </div>
      <%
              }
          } else {
      %>
              <div style="background: rgba(255,255,255,0.02); text-align:center; padding: 60px; border-radius: 12px; border: 1px dashed rgba(255,255,255,0.1); color: var(--text-muted);">
                <i class="fa-solid fa-store-slash" style="font-size: 2.5rem; margin-bottom: 16px;"></i>
                <p>No restaurants found. Register a partner kitchen to get started!</p>
              </div>
      <%
          }
      %>
    </div>
  </div> <!-- Close panelRestaurants -->

  <!-- ============ PANEL 2: MENU ITEMS ============ -->
  <div class="admin-panel" id="panelMenuItems">
    <div class="admin-header">
      <div>
        <h1>Cataloged Menu Items</h1>
        <p>Manage listings, pricing, description, and availability of gourmet items</p>
      </div>
      <button class="btn btn-primary" onclick="openModal('addMenuModalGlobal')">
        <i class="fa-solid fa-plus" style="margin-right: 6px;"></i> Add Menu Item
      </button>
    </div>

    <!-- Menu Items Table -->
    <div style="background: #121212; border: 1px solid rgba(255, 255, 255, 0.08); margin-top: 30px; width: 100%; overflow-x: auto; border-radius: 8px;">
      <table class="admin-table">
        <thead>
          <tr>
            <th>Dish</th>
            <th>Cuisine/Description</th>
            <th>Kitchen/Restaurant</th>
            <th>Price</th>
            <th>Availability</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <%
              if (menuList != null && !menuList.isEmpty()) {
                  for (Menu m : menuList) {
                      String rName = "Unknown";
                      if (restaurantList != null) {
                          for (Restaurant rest : restaurantList) {
                              if (rest.getResturant_id() == m.getRestaurantId()) {
                                  rName = rest.getName();
                                  break;
                              }
                          }
                      }
          %>
          <tr>
            <td style="font-weight: 800; font-family: var(--font-heading);">
              <div style="display: flex; align-items: center; gap: 12px;">
                <div style="width: 44px; height: 44px; border-radius: 8px; overflow: hidden; border: 1px solid rgba(255,255,255,0.08); background: #1a1a1a; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                  <img src="<%= (m.getImagePath() != null && !m.getImagePath().isEmpty()) ? m.getImagePath() : "https://images.unsplash.com/photo-1541832676-9b763b0239ab?q=80&w=600&auto=format&fit=crop" %>" style="width: 100%; height: 100%; object-fit: cover;" alt="dish">
                </div>
                <%= m.getItemName() %>
              </div>
            </td>
            <td style="color: #a0a0a0; font-size: 0.85rem;"><%= m.getDescription() %></td>
            <td style="font-weight: 600;"><%= rName %></td>
            <td style="font-family: var(--font-heading); font-weight: 800; color: #caff00;">₹<%= (int) m.getPrice() %></td>
            <td>
              <form action="${pageContext.request.contextPath}/AdminServlet" method="POST" style="margin:0;">
                <input type="hidden" name="action" value="toggleMenuItem">
                <input type="hidden" name="menuId" value="<%= m.getMenuId() %>">
                <input type="hidden" name="currentStatus" value="<%= m.isAvailable() %>">
                <button type="submit" class="status-pill <%= m.isAvailable() ? "delivered" : "placed" %>" style="border:none; cursor:pointer;">
                  <%= m.isAvailable() ? "Available" : "Unavailable" %>
                </button>
              </form>
            </td>
            <td>
              <div style="display:flex; gap: 8px;">
                <button class="btn btn-outline" style="padding: 6px 12px; font-size: 0.75rem;" onclick="openEditMenuModal('<%= m.getMenuId() %>', '<%= m.getItemName().replace("'", "\\'") %>', '<%= m.getDescription().replace("'", "\\'") %>', '<%= m.getPrice() %>', '<%= m.getImagePath() != null ? m.getImagePath().replace("'", "\\'") : "" %>', <%= m.isAvailable() %>)">Edit</button>
                <form action="${pageContext.request.contextPath}/AdminServlet" method="POST" style="margin:0;" onsubmit="return confirm('Delete this menu item?');">
                  <input type="hidden" name="action" value="deleteMenuItem">
                  <input type="hidden" name="menuId" value="<%= m.getMenuId() %>">
                  <button type="submit" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.75rem; color:#ff4a4a; border-color: rgba(255, 74, 74, 0.2);">Delete</button>
                </form>
              </div>
            </td>
          </tr>
          <%
                  }
              } else {
          %>
          <tr>
            <td colspan="6" style="text-align: center; padding: 40px; color: #a0a0a0;">No menu items cataloged yet.</td>
          </tr>
          <%
              }
          %>
        </tbody>
      </table>
    </div>
  </div>

  <!-- ============ PANEL 3: ORDERS & HISTORY ============ -->
  <div class="admin-panel" id="panelOrders">
    <div class="admin-header" style="margin-bottom: 20px;">
      <div>
        <h1>Orders &amp; Customer History</h1>
        <p>Track real-time orders, manage status stages, and view customer purchase profiles</p>
      </div>
    </div>

    <!-- Sub-tab switcher container -->
    <div class="sub-tabs-container">
      <button class="sub-tab-btn active" id="btnSubAllOrders" onclick="switchOrderSubTab('AllOrders')">All Orders</button>
      <button class="sub-tab-btn" id="btnSubCustomers" onclick="switchOrderSubTab('Customers')">Customer Profiles</button>
    </div>

    <!-- SUB-PANEL 1: ALL ORDERS -->
    <div class="order-sub-panel active" id="subPanelAllOrders">
      <!-- Search / Filter controls -->
      <div class="admin-controls-bar" style="margin-top: 30px;">
        <div class="search-input-group">
          <i class="fa-solid fa-magnifying-glass"></i>
          <input type="text" id="orderSearchInput" placeholder="Search by customer name or email..." onkeyup="filterOrders()">
        </div>
        
        <%
            List<java.util.Map<String, Object>> orderList = (List<java.util.Map<String, Object>>) request.getAttribute("orderList");
            java.util.Map<Integer, java.util.List<java.util.Map<String, Object>>> orderItemsMap = (java.util.Map<Integer, java.util.List<java.util.Map<String, Object>>>) request.getAttribute("orderItemsMap");
            double totalRevenue = 0;
            int ordersCount = (orderList != null) ? orderList.size() : 0;
            if (orderList != null) {
                for (java.util.Map<String, Object> o : orderList) {
                    totalRevenue += (Double) o.get("totalAmount");
                }
            }
        %>
        <div style="display: flex; gap: 20px;">
          <div style="text-align: right;">
            <div style="font-size: 0.72rem; color: #a0a0a0; font-family: var(--font-heading); font-weight: 800; text-transform: uppercase;">Total Active Orders</div>
            <div style="font-size: 1.35rem; font-weight: 900; font-family: var(--font-heading); color: #fff; margin-top:2px;"><%= ordersCount %></div>
          </div>
          <div style="text-align: right; padding-left: 20px; border-left: 1px solid rgba(255, 255, 255, 0.08);">
            <div style="font-size: 0.72rem; color: #a0a0a0; font-family: var(--font-heading); font-weight: 800; text-transform: uppercase;">Estimated Sales Revenue</div>
            <div style="font-size: 1.35rem; font-weight: 900; font-family: var(--font-heading); color: #caff00; margin-top:2px;">₹<%= (int)totalRevenue %></div>
          </div>
        </div>
      </div>

      <!-- Orders Table -->
      <div style="background: #121212; border: 1px solid rgba(255, 255, 255, 0.08); width: 100%; overflow-x: auto; border-radius: 8px;">
        <table class="admin-table" id="ordersTable">
          <thead>
            <tr>
              <th>Order ID</th>
              <th>Customer</th>
              <th>Kitchen/Restaurant</th>
              <th>Items Ordered</th>
              <th>Total Paid</th>
              <th>Order Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <%
                if (orderList != null && !orderList.isEmpty()) {
                    for (java.util.Map<String, Object> o : orderList) {
                        int orderId = (Integer) o.get("orderId");
                        String username = (String) o.get("username");
                        String email = (String) o.get("email");
                        String phone = (String) o.get("phone");
                        String status = (String) o.get("status");
                        double total = (Double) o.get("totalAmount");
                        String restaurantName = (String) o.get("restaurantName");
                        
                        StringBuilder itemsDesc = new StringBuilder();
                        if (orderItemsMap != null && orderItemsMap.containsKey(orderId)) {
                            java.util.List<java.util.Map<String, Object>> items = orderItemsMap.get(orderId);
                            for (int idx = 0; idx < items.size(); idx++) {
                                java.util.Map<String, Object> item = items.get(idx);
                                itemsDesc.append(item.get("itemName")).append(" x").append(item.get("quantity"));
                                if (idx < items.size() - 1) {
                                    itemsDesc.append(", ");
                                }
                            }
                        }
                        if (itemsDesc.length() == 0) {
                            itemsDesc.append("No items recorded");
                        }
            %>
            <tr class="order-row-item" data-username="<%= username.toLowerCase() %>" data-email="<%= email.toLowerCase() %>">
              <td style="font-family: var(--font-heading); font-weight: 900; color: #a0a0a0;">#<%= orderId %></td>
              <td>
                <div style="font-weight: 800; color: #ffffff;"><%= username %></div>
                <div style="font-size: 0.72rem; color: #a0a0a0;"><%= email %></div>
              </td>
              <td style="font-weight: 600;"><%= restaurantName %></td>
              <td style="max-width: 260px; font-size: 0.85rem; color: #d0d0d0; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" title="<%= itemsDesc.toString() %>">
                <%= itemsDesc.toString() %>
              </td>
              <td style="font-family: var(--font-heading); font-weight: 800; color: #caff00;">₹<%= (int)total %></td>
              <td>
                <span class="status-pill <%= status.toLowerCase().replace(" ", "") %>">
                  <i class="fa-solid fa-circle" style="font-size: 0.5rem; margin-right: 4px;"></i>
                  <%= status %>
                </span>
              </td>
              <td>
                <form action="${pageContext.request.contextPath}/AdminServlet" method="POST" style="margin: 0; display: flex; gap: 8px;">
                  <input type="hidden" name="action" value="updateOrderStatus">
                  <input type="hidden" name="orderId" value="<%= orderId %>">
                  <select name="status" onchange="this.form.submit()" style="background:#080808; color:#fff; border: 1px solid rgba(255,255,255,0.1); border-radius: 4px; padding: 6px 10px; font-family: var(--font-heading); font-weight: 800; font-size: 0.75rem; text-transform: uppercase; cursor: pointer; outline: none;">
                    <option value="Placed" <%= "Placed".equalsIgnoreCase(status) ? "selected" : "" %>>Placed</option>
                    <option value="Preparing" <%= "Preparing".equalsIgnoreCase(status) ? "selected" : "" %>>Preparing</option>
                    <option value="Out for Delivery" <%= "Out for Delivery".equalsIgnoreCase(status) ? "selected" : "" %>>Out for Delivery</option>
                    <option value="Delivered" <%= "Delivered".equalsIgnoreCase(status) ? "selected" : "" %>>Delivered</option>
                  </select>
                </form>
              </td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
              <td colspan="7" style="text-align: center; padding: 40px; color: #a0a0a0;">No orders placed yet.</td>
            </tr>
            <%
                }
            %>
          </tbody>
        </table>
      </div>
    </div>

    <!-- SUB-PANEL 2: CUSTOMER PROFILES -->
    <div class="order-sub-panel" id="subPanelCustomers">
      <div style="background: #121212; border: 1px solid rgba(255, 255, 255, 0.08); margin-top: 30px; width: 100%; overflow-x: auto; border-radius: 8px;">
        <table class="admin-table">
          <thead>
            <tr>
              <th>Customer Name</th>
              <th>Email Address</th>
              <th>Total Orders Placed</th>
              <th>Total Value Spent</th>
              <th>History Access</th>
            </tr>
          </thead>
          <tbody>
            <%
                java.util.Map<String, java.util.Map<String, Object>> customerSummaryMap = new java.util.HashMap<>();
                if (orderList != null) {
                    for (java.util.Map<String, Object> o : orderList) {
                        String uName = (String) o.get("username");
                        String email = (String) o.get("email");
                        String phone = (String) o.get("phone");
                        double total = (Double) o.get("totalAmount");
                        
                        if (!customerSummaryMap.containsKey(uName)) {
                            java.util.Map<String, Object> summary = new java.util.HashMap<>();
                            summary.put("username", uName);
                            summary.put("email", email);
                            summary.put("phone", phone);
                            summary.put("ordersCount", 0);
                            summary.put("totalSpent", 0.0);
                            customerSummaryMap.put(uName, summary);
                        }
                        
                        java.util.Map<String, Object> summary = customerSummaryMap.get(uName);
                        summary.put("ordersCount", (Integer) summary.get("ordersCount") + 1);
                        summary.put("totalSpent", (Double) summary.get("totalSpent") + total);
                    }
                }
                
                if (!customerSummaryMap.isEmpty()) {
                    for (java.util.Map.Entry<String, java.util.Map<String, Object>> entry : customerSummaryMap.entrySet()) {
                        java.util.Map<String, Object> summary = entry.getValue();
                        String uName = (String) summary.get("username");
                        String email = (String) summary.get("email");
                        String phone = (String) summary.get("phone");
                        int count = (Integer) summary.get("ordersCount");
                        double spent = (Double) summary.get("totalSpent");
            %>
            <tr>
              <td style="font-weight: 800; font-family: var(--font-heading); color: #ffffff;"><%= uName %></td>
              <td style="color: #a0a0a0;"><%= email %></td>
              <td style="font-family: var(--font-heading); font-weight: 800; color: #00e5ff;"><%= count %> orders</td>
              <td style="font-family: var(--font-heading); font-weight: 800; color: #caff00;">₹<%= (int)spent %></td>
              <td>
                <button class="btn btn-outline" style="padding: 6px 14px; font-size: 0.78rem;" onclick="viewCustomerHistory('<%= uName.toLowerCase() %>')">
                  <i class="fa-solid fa-clock-rotate-left" style="margin-right: 4px;"></i> View Orders
                </button>
              </td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
              <td colspan="6" style="text-align: center; padding: 40px; color: #a0a0a0;">No customer profiles recorded yet.</td>
            </tr>
            <%
                }
            %>
          </tbody>
        </table>
      </div>
    </div>
  </div>

  </main>
  </div>

  <!-- ============ ADD RESTAURANT MODAL ============ -->
  <div class="modal-overlay" id="addRestaurantModal">
    <div class="admin-modal-card">
      <div class="modal-header">
        <h3>Add Partner Kitchen</h3>
        <button class="modal-close-btn" onclick="closeModal('addRestaurantModal')">&times;</button>
      </div>
      <form action="${pageContext.request.contextPath}/AdminServlet" method="POST">
        <input type="hidden" name="action" value="addRestaurant">
        
        <div class="input-group">
          <label>Restaurant Name</label>
          <input type="text" name="name" required placeholder="e.g. Empire Restaurant" style="width: 100%;">
        </div>
        <div class="input-group">
          <label>Cuisine Style</label>
          <input type="text" name="cuisineType" required placeholder="e.g. North Indian, Muglai" style="width: 100%;">
        </div>
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
          <div class="input-group">
            <label>Delivery Time (mins)</label>
            <input type="number" name="deliveryTime" required min="1" placeholder="30" style="width: 100%;">
          </div>
          <div class="input-group">
            <label>Rating (1.0 to 5.0)</label>
            <input type="number" name="rating" required step="0.1" min="1" max="5" placeholder="4.5" style="width: 100%;">
          </div>
        </div>
        <div class="input-group">
          <label>Address</label>
          <input type="text" name="address" required placeholder="e.g. Indiranagar, Bangalore" style="width: 100%;">
        </div>
        <div class="input-group">
          <label>Cover Image URL (Unsplash/Web)</label>
          <input type="url" name="imagePath" required placeholder="https://images.unsplash.com/..." style="width: 100%;">
        </div>
        <div class="input-group" style="margin-bottom: 24px;">
          <label>Live Listing Status</label>
          <select name="isActive" required style="width: 100%;">
            <option value="true" selected>Live (Visible to Customers)</option>
            <option value="false">Offline (Hidden)</option>
          </select>
        </div>
        <button type="submit" class="btn btn-primary" style="width: 100%; padding: 14px 20px;">Save Kitchen</button>
      </form>
    </div>
  </div>

  <!-- ============ ADD MENU ITEM GLOBAL MODAL ============ -->
  <div class="modal-overlay" id="addMenuModalGlobal">
    <div class="admin-modal-card">
      <div class="modal-header">
        <h3>Add New Dish</h3>
        <button class="modal-close-btn" onclick="closeModal('addMenuModalGlobal')">&times;</button>
      </div>
      <form action="${pageContext.request.contextPath}/AdminServlet" method="POST">
        <input type="hidden" name="action" value="addMenuItem">
        
        <div class="input-group">
          <label>Select Restaurant / Kitchen</label>
          <select name="restaurantId" required style="width: 100%; background: #080808; color: #fff; border: 1px solid rgba(255,255,255,0.08); padding: 12px; border-radius: 4px; font-family: var(--font-body); outline: none;">
            <%
                if (restaurantList != null) {
                    for (Restaurant r : restaurantList) {
            %>
            <option value="<%= r.getResturant_id() %>"><%= r.getName() %></option>
            <%
                    }
                }
            %>
          </select>
        </div>
        <div class="input-group">
          <label>Dish/Item Name</label>
          <input type="text" name="itemName" required placeholder="e.g. Paneer Butter Masala" style="width: 100%;">
        </div>
        <div class="input-group">
          <label>Description / Ingredients</label>
          <input type="text" name="description" required placeholder="e.g. Cottage cheese cubes in rich tomato gravy" style="width: 100%;">
        </div>
        <div class="input-group">
          <label>Price (INR)</label>
          <input type="number" name="price" required step="0.01" min="0" placeholder="240.00" style="width: 100%;">
        </div>
        <div class="input-group">
          <label>Dish Cover Image URL</label>
          <input type="url" name="imagePath" required placeholder="https://images.unsplash.com/..." style="width: 100%;">
        </div>
        <div class="input-group" style="margin-bottom: 24px;">
          <label>Availability</label>
          <select name="isAvailable" required style="width: 100%;">
            <option value="true" selected>In Stock (Available)</option>
            <option value="false">Out of Stock (Unavailable)</option>
          </select>
        </div>
        <button type="submit" class="btn btn-primary" style="width: 100%; padding: 14px 20px;">Save Dish</button>
      </form>
    </div>
  </div>

  <!-- ============ ADD MENU ITEM MODAL ============ -->
  <div class="modal-overlay" id="addMenuModal">
    <div class="admin-modal-card">
      <div class="modal-header">
        <h3 id="addMenuModalTitle">Add Menu Item</h3>
        <button class="modal-close-btn" onclick="closeModal('addMenuModal')">&times;</button>
      </div>
      <form action="${pageContext.request.contextPath}/AdminServlet" method="POST">
        <input type="hidden" name="action" value="addMenuItem">
        <input type="hidden" name="restaurantId" id="addMenuRestaurantId">
        
        <div class="input-group">
          <label>Dish/Item Name</label>
          <input type="text" name="itemName" required placeholder="e.g. Paneer Butter Masala" style="width: 100%;">
        </div>
        <div class="input-group">
          <label>Description / Ingredients</label>
          <input type="text" name="description" required placeholder="e.g. Cottage cheese cubes in rich tomato gravy" style="width: 100%;">
        </div>
        <div class="input-group">
          <label>Price (INR)</label>
          <input type="number" name="price" required step="0.01" min="0" placeholder="240.00" style="width: 100%;">
        </div>
        <div class="input-group">
          <label>Dish Cover Image URL</label>
          <input type="url" name="imagePath" required placeholder="https://images.unsplash.com/..." style="width: 100%;">
        </div>
        <div class="input-group" style="margin-bottom: 24px;">
          <label>Availability</label>
          <select name="isAvailable" required style="width: 100%;">
            <option value="true" selected>In Stock (Available)</option>
            <option value="false">Out of Stock (Unavailable)</option>
          </select>
        </div>
        <button type="submit" class="btn btn-primary" style="width: 100%; padding: 14px 20px;">Save Dish</button>
      </form>
    </div>
  </div>

  <!-- ============ EDIT MENU ITEM MODAL ============ -->
  <div class="modal-overlay" id="editMenuModal">
    <div class="admin-modal-card">
      <div class="modal-header">
        <h3>Edit Menu Item</h3>
        <button class="modal-close-btn" onclick="closeModal('editMenuModal')">&times;</button>
      </div>
      <form action="${pageContext.request.contextPath}/AdminServlet" method="POST">
        <input type="hidden" name="action" value="editMenuItem">
        <input type="hidden" name="menuId" id="editMenuId">
        
        <div class="input-group">
          <label>Dish/Item Name</label>
          <input type="text" name="itemName" id="editItemName" required placeholder="e.g. Paneer Butter Masala" style="width: 100%;">
        </div>
        <div class="input-group">
          <label>Description / Ingredients</label>
          <input type="text" name="description" id="editDescription" required placeholder="e.g. Cottage cheese cubes in rich tomato gravy" style="width: 100%;">
        </div>
        <div class="input-group">
          <label>Price (INR)</label>
          <input type="number" name="price" id="editPrice" required step="0.01" min="0" placeholder="240.00" style="width: 100%;">
        </div>
        <div class="input-group">
          <label>Dish Cover Image URL</label>
          <input type="url" name="imagePath" id="editImagePath" required placeholder="https://images.unsplash.com/..." style="width: 100%;">
        </div>
        <div class="input-group" style="margin-bottom: 24px;">
          <label>Availability</label>
          <select name="isAvailable" id="editIsAvailable" required style="width: 100%;">
            <option value="true">In Stock (Available)</option>
            <option value="false">Out of Stock (Unavailable)</option>
          </select>
        </div>
        <button type="submit" class="btn btn-primary" style="width: 100%; padding: 14px 20px;">Save Changes</button>
      </form>
    </div>
  </div>

  <!-- ============ FOOTER ============ -->
  <footer class="footer" style="border-top: 1px solid rgba(255,255,255,0.05); padding: 40px 80px; text-align: center; font-size: 0.88rem; color: var(--text-muted); font-family: var(--font-body);">
    <p>&copy; 2026 Instafoods Administrator Dashboard. All rights reserved.</p>
  </footer>

  <!-- ============ JAVASCRIPT ============ -->
  <script>
    /* ---- Profile Dropdown toggle ---- */
    function toggleUserDropdown(event) {
      event.stopPropagation();
      const menu = document.getElementById('userDropdownMenu');
      if (menu) {
        menu.style.display = (menu.style.display === 'none' || menu.style.display === '') ? 'block' : 'none';
      }
    }

    document.addEventListener('click', () => {
      const menu = document.getElementById('userDropdownMenu');
      if (menu) menu.style.display = 'none';
    });

    /* ---- Hamburger Menu Toggle ---- */
    const hamburger = document.getElementById('hamburger');
    if (hamburger) {
      hamburger.addEventListener('click', () => {
        document.querySelector('.nav-links').classList.toggle('open');
        hamburger.classList.toggle('open');
      });
    }

    /* ---- Toggle Accordion Drawer ---- */
    function toggleMenuDrawer(rId) {
      const panel = document.getElementById('menuDrawer_' + rId);
      if (panel) {
        panel.style.display = (panel.style.display === 'none' || panel.style.display === '') ? 'block' : 'none';
      }
    }

    /* ---- Modal Handlers ---- */
    function openModal(modalId) {
      const modal = document.getElementById(modalId);
      if (modal) modal.classList.add('open');
    }

    document.addEventListener('click', (e) => {
      if (e.target.classList.contains('modal-overlay')) {
        e.target.classList.remove('open');
      }
    });

    function closeModal(modalId) {
      const modal = document.getElementById(modalId);
      if (modal) modal.classList.remove('open');
    }

    function openAddMenuModal(restaurantId, restaurantName) {
      document.getElementById('addMenuRestaurantId').value = restaurantId;
      document.getElementById('addMenuModalTitle').innerText = 'Add Dish to ' + restaurantName;
      openModal('addMenuModal');
    }

    function openEditMenuModal(menuId, itemName, description, price, imagePath, isAvailable) {
      document.getElementById('editMenuId').value = menuId;
      document.getElementById('editItemName').value = itemName;
      document.getElementById('editDescription').value = description;
      document.getElementById('editPrice').value = price;
      document.getElementById('editImagePath').value = imagePath;
      document.getElementById('editIsAvailable').value = isAvailable ? 'true' : 'false';
      openModal('editMenuModal');
    }

    /* ---- Tab Switcher ---- */
    function switchTab(tabId) {
      document.querySelectorAll('.admin-panel').forEach(panel => {
        panel.classList.remove('active');
      });
      document.querySelectorAll('.sidebar-nav .nav-item').forEach(item => {
        item.classList.remove('active');
      });

      const targetPanel = document.getElementById('panel' + tabId);
      if (targetPanel) {
        targetPanel.classList.add('active');
      }
      const targetLink = document.getElementById('tabLink' + tabId);
      if (targetLink) {
        targetLink.classList.add('active');
      }
      sessionStorage.setItem('activeAdminTab', tabId);
    }

    document.addEventListener('DOMContentLoaded', () => {
      const savedTab = sessionStorage.getItem('activeAdminTab');
      if (savedTab) {
        switchTab(savedTab);
      } else {
        switchTab('Restaurants');
      }
    });

    /* ---- Search / Filter Orders ---- */
    function filterOrders() {
      const input = document.getElementById('orderSearchInput');
      if (!input) return;
      const filter = input.value.toLowerCase().trim();
      const rows = document.querySelectorAll('#ordersTable .order-row-item');

      rows.forEach(row => {
        const username = row.getAttribute('data-username') || '';
        const email = row.getAttribute('data-email') || '';
        if (username.includes(filter) || email.includes(filter)) {
          row.style.display = '';
        } else {
          row.style.display = 'none';
        }
      });
    }

    /* ---- Orders Sub-Tab Switcher ---- */
    function switchOrderSubTab(subTabId) {
      document.querySelectorAll('.order-sub-panel').forEach(p => {
        p.classList.remove('active');
      });
      document.querySelectorAll('.sub-tab-btn').forEach(b => {
        b.classList.remove('active');
      });

      const targetPanel = document.getElementById('subPanel' + subTabId);
      if (targetPanel) {
        targetPanel.classList.add('active');
      }
      const targetBtn = document.getElementById('btnSub' + subTabId);
      if (targetBtn) {
        targetBtn.classList.add('active');
      }
    }

    /* ---- View specific customer's order history ---- */
    function viewCustomerHistory(username) {
      document.getElementById('orderSearchInput').value = username;
      filterOrders();
      switchOrderSubTab('AllOrders');
    }
  </script>

</body>
</html>
