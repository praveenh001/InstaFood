<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.instafoo.Model.Restaurant" %>
<%@ page import="com.instafoo.Model.User" %>
<%@ page import="com.instafoo.Model.Menu" %>

<%
    List<Restaurant> restaurantList = (List<Restaurant>) request.getAttribute("allrestaurant");
    List<Menu> allMenu = (List<Menu>) request.getAttribute("allMenu");
    User loggedInUser = (User) session.getAttribute("user");

    // Dynamic database fallbacks in case JSP is accessed directly without servlet forwarding
    if (restaurantList == null) {
        try {
            com.instafoo.daoImp.RestaurantDaoImp restaurantDao = new com.instafoo.daoImp.RestaurantDaoImp();
            restaurantList = restaurantDao.getAllRestaurants();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    if (allMenu == null) {
        try {
            com.instafoo.daoImp.MenuDaoImp menuDao = new com.instafoo.daoImp.MenuDaoImp();
            allMenu = menuDao.getAllMenuItems();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    Boolean hasActiveOrder = (Boolean) request.getAttribute("hasActiveOrder");
    String activeRestName = (String) request.getAttribute("activeRestName");
    String activeItemName = (String) request.getAttribute("activeItemName");
    Double activeTotal = (Double) request.getAttribute("activeTotal");
    String activeStatus = (String) request.getAttribute("activeStatus");

    // Null checks for active order parameters to prevent JSP errors
    if (hasActiveOrder == null) hasActiveOrder = false;
    if (activeRestName == null) activeRestName = "Meghana Foods";
    if (activeItemName == null) activeItemName = "Gosht Dum Biryani";
    if (activeTotal == null) activeTotal = 1460.0;
    if (activeStatus == null) activeStatus = "On The Way";
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <link rel="icon" type="image/x-icon" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQz8HFcByuK1fp2KQdFls5532X50P87Ucp1kg&s">

  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Instafoods – Bengaluru's Top Food Delivery</title>
  <meta name="description" content="Instafoods delivers Bengaluru's finest gourmet food to your doorstep in minutes. From Nagarjuna to Shiro — real-time tracking, top-tier chefs, absolute speed.">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@400;500;600&family=IBM+Plex+Mono:wght@500;600&display=swap" rel="stylesheet">
  <style>
    /* Color and Typography System - Brutalist Typography with Previous Fonts & Neon Lime Palette */
    :root {
      --color-ember-orange: #caff00; /* Neon Lime is the sole accent */
      --color-onyx: #080808; /* Deep Rich Black from previous brand */
      --color-graphite: #ffffff; /* Primary text white */
      --color-stone: #a0a0a0; /* Secondary text muted */
      --color-ash: #888888;
      --color-silver-mist: rgba(255, 255, 255, 0.08); /* Dark hairline divider */
      --color-fog: #121212; /* Dark card surface */
      --color-paper: #080808; /* Base page canvas dark */
      --color-pure-white: #121212; /* Card surfaces */
    }

    body {
      background-color: var(--color-paper) !important;
      color: var(--color-graphite) !important;
      font-family: var(--font-body), sans-serif !important;
    }

    /* Navbar Brutalist Styling */
    .navbar {
      background: rgba(8, 8, 8, 0.85) !important;
      border-bottom: 1px solid var(--color-silver-mist) !important;
      padding: 24px 80px !important;
      backdrop-filter: blur(12px) !important;
    }
    .navbar.scrolled {
      padding: 16px 80px !important;
      background: var(--color-onyx) !important;
    }
    .logo-text {
      font-family: var(--font-heading), sans-serif !important;
      font-size: 1.8rem !important;
      font-weight: 900 !important;
      letter-spacing: -0.5px !important;
      text-transform: none !important;
      color: #ffffff !important;
    }
    .logo-text span {
      color: var(--color-ember-orange) !important;
    }
    .nav-links a {
      font-family: var(--font-heading), sans-serif !important;
      font-size: 13px !important;
      font-weight: 800 !important;
      text-transform: uppercase !important;
      letter-spacing: 0.5px !important;
      color: var(--color-stone) !important;
    }
    .nav-links a:hover, .nav-links a.active {
      color: var(--color-ember-orange) !important;
    }
    .nav-actions .btn {
      font-family: var(--font-heading), sans-serif !important;
      font-size: 12px !important;
      font-weight: 800 !important;
      text-transform: uppercase !important;
      padding: 8px 16px !important;
      border-radius: 9999px !important; /* Pill Nav */
      border: 1px solid rgba(255, 255, 255, 0.25) !important;
      color: #ffffff !important;
      background: transparent !important;
      box-shadow: none !important;
    }
    .nav-actions .btn:hover {
      border-color: var(--color-ember-orange) !important;
      color: var(--color-ember-orange) !important;
    }
    .nav-actions .btn-primary {
      background: var(--color-ember-orange) !important;
      color: var(--color-onyx) !important;
      border-color: var(--color-ember-orange) !important;
    }
    .nav-actions .btn-primary:hover {
      background: #ffffff !important;
      color: var(--color-onyx) !important;
      border-color: #ffffff !important;
    }
    .nav-actions .user-avatar-badge {
      border-radius: 9999px !important;
      background: var(--color-ember-orange) !important;
      color: var(--color-onyx) !important;
      font-family: var(--font-heading), sans-serif !important;
      font-weight: 900 !important;
      box-shadow: 0 0 10px rgba(202, 255, 0, 0.2) !important;
      border: none !important;
    }

    /* Dark Hero Section */
    .hero {
      background-color: var(--color-onyx) !important;
      padding: 160px 80px 100px !important;
      min-height: 90vh !important;
      border-bottom: 1px solid var(--color-silver-mist) !important;
      grid-template-columns: 1.2fr 1fr !important;
      display: grid !important;
      align-items: center !important;
      gap: 40px !important;
    }
    .hero h1 {
      font-family: var(--font-heading), sans-serif !important;
      font-size: clamp(3.5rem, 8vw, 7rem) !important;
      line-height: 0.86 !important;
      letter-spacing: -1px !important;
      text-transform: uppercase !important;
      background: linear-gradient(180deg, #ffffff 0%, #b9b7bb 50%, #3c3a3e 100%) !important;
      -webkit-background-clip: text !important;
      -webkit-text-fill-color: transparent !important;
      margin-bottom: 24px !important;
    }
    .hero p {
      font-family: var(--font-body), sans-serif !important;
      font-size: 20px !important;
      font-weight: 500 !important;
      color: var(--color-stone) !important;
      line-height: 1.3 !important;
      letter-spacing: -0.02px !important;
      margin-bottom: 40px !important;
      max-width: 580px !important;
    }
    .hero-actions .btn {
      font-family: var(--font-heading), sans-serif !important;
      font-size: 13px !important;
      font-weight: 800 !important;
      text-transform: uppercase !important;
      padding: 14px 28px !important;
      border-radius: 9999px !important;
      letter-spacing: 0.5px !important;
      box-shadow: none !important;
    }
    .hero-actions .btn-primary {
      background: var(--color-ember-orange) !important;
      color: var(--color-onyx) !important;
      border: 1px solid var(--color-ember-orange) !important;
    }
    .hero-actions .btn-primary:hover {
      background: #ffffff !important;
      color: var(--color-onyx) !important;
      border-color: #ffffff !important;
    }
    .hero-actions .btn-outline {
      border: 1px solid var(--color-stone) !important;
      color: #ffffff !important;
      background: transparent !important;
    }
    .hero-actions .btn-outline:hover {
      border-color: #ffffff !important;
      background: #ffffff !important;
      color: var(--color-onyx) !important;
    }

    /* Metric cards inside hero */
    .metric-row {
      margin-top: 48px !important;
      gap: 24px !important;
      display: flex !important;
    }
    .metric-card {
      background: rgba(255, 255, 255, 0.03) !important;
      border: 1px solid rgba(255, 255, 255, 0.06) !important;
      border-radius: 0px !important; /* Brutalist sharp */
      padding: 16px 20px !important;
      display: flex !important;
      align-items: center !important;
      gap: 14px !important;
    }
    .metric-card .icon {
      color: var(--color-ember-orange) !important;
      font-size: 1.5rem !important;
    }
    .metric-card .details .title {
      color: #ffffff !important;
      font-family: var(--font-heading), sans-serif !important;
      font-size: 1.15rem !important;
      font-weight: 800 !important;
      letter-spacing: 0.5px !important;
    }
    .metric-card .details .sub {
      color: var(--color-stone) !important;
      font-family: var(--font-body), sans-serif !important;
      font-weight: 500 !important;
      font-size: 0.78rem !important;
    }

    /* Monitor Mockup Display (Brutalist device design) */
    .hero-visual {
      position: relative !important;
      display: flex !important;
      justify-content: center !important;
      align-items: center !important;
      height: 100% !important;
    }
    .phone-mockup {
      width: 310px !important;
      height: 520px !important;
      background: #080808 !important; /* Screen background */
      border: 12px solid #1a1a1a !important; /* Phone Bezel */
      border-radius: 40px !important; /* Rounded phone chassis */
      padding: 12px 14px !important;
      box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.7), 
                  0 0 0 1px rgba(255, 255, 255, 0.08) !important; /* 3D depth and outline */
      display: flex !important;
      flex-direction: column !important;
      position: relative !important;
      overflow: hidden !important;
      flex-shrink: 0 !important;
    }
    .phone-mockup.offset {
      transform: translateY(15px) rotate(1deg) !important;
      margin-left: -15px !important;
    }
    .phone-notch {
      width: 90px !important;
      height: 18px !important;
      background: #1a1a1a !important;
      border-radius: 9999px !important;
      margin: -6px auto 10px !important;
      position: relative !important;
      display: flex !important;
      align-items: center !important;
      justify-content: center !important;
      flex-shrink: 0 !important;
    }
    .phone-notch::before {
      content: '' !important;
      width: 5px !important;
      height: 5px !important;
      background: #0d1b2a !important;
      border-radius: 50% !important;
      position: absolute !important;
      right: 15px !important;
    }
    .phone-screen {
      font-family: var(--font-heading), sans-serif !important;
      color: var(--color-silver-mist) !important;
      height: 100% !important;
      display: flex !important;
      flex-direction: column !important;
      gap: 10px !important;
      overflow: hidden !important;
    }
    .screen-header {
      font-size: 11px !important;
      text-transform: uppercase !important;
      letter-spacing: 1px !important;
      border-bottom: 1px solid rgba(255, 255, 255, 0.08) !important;
      padding-bottom: 8px !important;
      color: var(--color-stone) !important;
      display: flex !important;
      justify-content: space-between !important;
      align-items: center;
      flex-shrink: 0 !important;
    }
    .screen-card {
      background: rgba(255, 255, 255, 0.02) !important;
      border: 1px solid rgba(255, 255, 255, 0.05) !important;
      border-radius: 0px !important;
      padding: 10px 12px !important; /* Compact padding to prevent overflow */
    }
    .screen-card .label-green {
      background: var(--color-ember-orange) !important;
      color: var(--color-onyx) !important;
      border-radius: 0px !important;
      font-family: var(--font-heading), sans-serif !important;
      font-size: 9px !important;
      font-weight: 800 !important;
      padding: 2px 6px !important;
      display: inline-block !important;
      margin-bottom: 6px !important;
    }
    .screen-card .food-title {
      font-family: var(--font-body), sans-serif !important;
      font-weight: 600 !important;
      font-size: 0.9rem !important;
      color: #ffffff !important;
      margin-bottom: 3px !important;
    }
    .screen-card .delivery-time {
      font-size: 0.72rem !important;
      color: var(--color-stone) !important;
    }
    .delivery-tracker {
      margin-top: 8px !important;
    }
    .tracker-bar {
      height: 4px !important;
      background: #222 !important;
      border-radius: 2px !important;
      overflow: hidden !important;
    }
    .tracker-progress {
      height: 100% !important;
      width: 75% !important;
      background: var(--color-ember-orange) !important;
    }

     /* Responsive Media Queries */
    @media (max-width: 1200px) {
      .hero {
        padding: 140px 40px 80px !important;
        gap: 30px !important;
      }
      .phone-mockup {
        width: 270px !important;
        height: 470px !important;
        border-width: 8px !important;
        padding: 10px 12px !important;
      }
      .phone-mockup.offset {
        transform: translateY(10px) rotate(1deg) !important;
        margin-left: -10px !important;
      }
      .phone-notch {
        width: 70px !important;
        height: 14px !important;
        margin-bottom: 8px !important;
      }
      .screen-card {
        padding: 8px 10px !important;
      }
      .screen-card .food-title {
        font-size: 0.82rem !important;
      }
    }

    @media (max-width: 991px) {
      .navbar {
        padding: 16px 32px !important;
        position: relative !important;
      }
      .hamburger {
        display: flex !important;
        flex-direction: column !important;
        gap: 6px !important;
        cursor: pointer !important;
        z-index: 1001 !important;
      }
      .hamburger span {
        width: 24px !important;
        height: 2px !important;
        background: #ffffff !important;
        transition: all 0.3s ease !important;
      }
      .hamburger.open span:nth-child(1) {
        transform: rotate(45deg) translate(5px, 5px) !important;
      }
      .hamburger.open span:nth-child(2) {
        opacity: 0 !important;
      }
      .hamburger.open span:nth-child(3) {
        transform: rotate(-45deg) translate(6px, -6px) !important;
      }
      .nav-links {
        display: none !important;
        position: absolute !important;
        top: 100% !important;
        left: 0 !important;
        right: 0 !important;
        background: #080808 !important;
        border-bottom: 1px solid var(--color-silver-mist) !important;
        flex-direction: column !important;
        padding: 20px 0 !important;
        gap: 16px !important;
        align-items: center !important;
        z-index: 1000 !important;
      }
      .nav-links.open {
        display: flex !important;
      }
      .nav-actions {
        display: none !important;
      }
      .hero {
        grid-template-columns: 1fr !important;
        padding: 120px 24px 60px !important;
        text-align: center !important;
        min-height: auto !important;
        gap: 48px !important;
      }
      .hero-content {
        max-width: 650px !important;
        margin: 0 auto !important;
      }
      .hero p {
        margin-left: auto !important;
        margin-right: auto !important;
        margin-bottom: 32px !important;
      }
      .hero-actions {
        justify-content: center !important;
      }
      .metric-row {
        justify-content: center !important;
        flex-wrap: wrap !important;
      }
      .hero-visual {
        flex-direction: row !important;
        justify-content: center !important;
        gap: 20px !important;
        margin-top: 20px !important;
      }
      .phone-mockup.offset {
        transform: none !important;
        margin-left: 0 !important;
      }
      .section {
        padding: 60px 24px !important;
      }
      .section-header h2 {
        font-size: 40px !important;
      }
      .cta-section {
        padding: 40px 24px !important;
      }
      .cta-banner {
        flex-direction: column !important;
        padding: 40px 24px !important;
        text-align: center !important;
        gap: 24px !important;
      }
      footer {
        padding: 40px 24px !important;
        flex-direction: column !important;
        text-align: center !important;
        gap: 24px !important;
      }
      .footer-nav {
        flex-direction: column !important;
        gap: 12px !important;
      }
    }

    @media (max-width: 600px) {
      .hero-visual {
        flex-direction: column !important;
        align-items: center !important;
        gap: 30px !important;
      }
    }

    /* Light Content Sections - Namma Bengaluru's Top Restaurants */
    .section {
      background-color: var(--color-paper) !important;
      padding: 100px 80px !important;
      border-bottom: 1px solid var(--color-silver-mist) !important;
    }
    .section-header h2 {
      font-family: var(--font-heading), sans-serif !important;
      font-size: 60px !important;
      font-weight: 900 !important;
      line-height: 1.05 !important;
      letter-spacing: -0.03em !important;
      color: #ffffff !important;
      text-transform: uppercase !important;
    }
    .section-header .highlight {
      color: var(--color-ember-orange) !important;
    }
    .section-header p {
      font-family: var(--font-body), sans-serif !important;
      font-size: 18px !important;
      font-weight: 500 !important;
      color: var(--color-stone) !important;
      line-height: 1.4 !important;
      margin-top: 16px !important;
    }

    /* Grid Cards (Brutalist design) */
    .feat-card {
      background: var(--color-pure-white) !important;
      border: 1px solid var(--color-silver-mist) !important;
      border-radius: 0px !important; /* Sharp cards */
      box-shadow: none !important;
      animation: none !important;
      text-decoration: none !important;
      color: inherit !important;
      display: block !important;
      transition: transform 0.3s cubic-bezier(0.32, 0.72, 0, 1), border-color 0.3s ease !important;
    }
    .feat-card:hover {
      border-color: var(--color-ember-orange) !important;
      transform: translateY(-4px) !important;
      box-shadow: 0 12px 30px rgba(0,0,0,0.4) !important;
    }
    .feat-card::before {
      display: none !important; /* No neon shimmer */
    }
    .feat-img {
      height: 220px !important;
      position: relative !important;
      overflow: hidden !important;
      width: 100% !important;
    }
    .feat-img img {
      width: 100% !important;
      height: 100% !important;
      object-fit: cover !important;
      display: block !important;
      transition: transform 0.5s ease !important;
    }
    .feat-card:hover .feat-img img {
      transform: scale(1.04) !important;
    }
    .feat-img::after {
      background: linear-gradient(to top, rgba(8,8,8,0.85) 0%, transparent 70%) !important;
      content: '' !important;
      position: absolute !important;
      inset: 0 !important;
      pointer-events: none !important;
    }
    .feat-img-name {
      font-family: var(--font-heading), sans-serif !important;
      font-weight: 900 !important;
      font-size: 1.7rem !important;
      letter-spacing: 0.5px !important;
      text-shadow: none !important;
      position: absolute !important;
      bottom: 14px !important;
      left: 16px !important;
      right: 56px !important;
      z-index: 3 !important;
      color: #fff !important;
      line-height: 1.1 !important;
    }
    .feat-badge-open {
      position: absolute !important;
      top: 12px !important;
      right: 12px !important;
      z-index: 4 !important;
      background: var(--color-ember-orange) !important;
      color: var(--color-onyx) !important;
      border-radius: 9999px !important; /* Pills for tags */
      font-family: var(--font-heading), sans-serif !important;
      font-weight: 800 !important;
      font-size: 10px !important;
      box-shadow: none !important;
      padding: 4px 10px !important;
      display: flex !important;
      align-items: center !important;
      gap: 5px !important;
    }
    .feat-badge-open .dot {
      width: 6px !important;
      height: 6px !important;
      border-radius: 50% !important;
      background: var(--color-onyx) !important;
      animation: pulse-dot 1.5s infinite !important;
    }
    .feat-badge-closed {
      position: absolute !important;
      top: 12px !important;
      right: 12px !important;
      z-index: 4 !important;
      border-radius: 9999px !important;
      font-family: var(--font-heading), sans-serif !important;
      font-size: 10px !important;
      padding: 4px 10px !important;
      display: flex !important;
      align-items: center !important;
      gap: 5px !important;
      background: #2a2a2a !important;
      color: var(--color-stone) !important;
      border: 1px solid rgba(255, 255, 255, 0.1) !important;
    }
    .feat-badge-closed .dot {
      width: 6px !important;
      height: 6px !important;
      border-radius: 50% !important;
      background: var(--color-stone) !important;
    }
    .feat-info {
      padding: 20px !important;
    }
    .feat-cuisine {
      background: #1a1a1a !important;
      border: 1px solid var(--color-silver-mist) !important;
      color: var(--color-ember-orange) !important;
      border-radius: 0px !important; /* Rectangular pill tag */
      font-family: var(--font-heading), sans-serif !important;
      font-weight: 800 !important;
      font-size: 11px !important;
      padding: 2px 8px !important;
      display: inline-block !important;
      letter-spacing: 0.5px !important;
    }
    .feat-name {
      font-family: var(--font-heading), sans-serif !important;
      font-weight: 900 !important;
      font-size: 1.25rem !important;
      color: #ffffff !important;
      text-transform: uppercase !important;
      margin-top: 12px !important;
      letter-spacing: -0.01em !important;
    }
    .feat-address {
      font-family: var(--font-body), sans-serif !important;
      font-weight: 500 !important;
      color: var(--color-stone) !important;
      font-size: 0.8rem !important;
      margin-bottom: 14px !important;
      display: flex !important;
      align-items: flex-start !important;
      gap: 6px !important;
    }
    .feat-address i {
      color: var(--color-ember-orange) !important;
      font-size: 0.72rem !important;
      margin-top: 2px !important;
    }
    .feat-meta {
      border-top: 1px solid var(--color-silver-mist) !important;
      padding-top: 16px !important;
      display: flex !important;
      align-items: center !important;
      justify-content: space-between !important;
      gap: 8px !important;
    }
    .feat-meta-group {
      display: flex !important;
      align-items: center !important;
      gap: 14px !important;
    }
    .feat-meta-item {
      display: flex !important;
      align-items: center !important;
      gap: 5px !important;
      font-size: 0.8rem !important;
      color: var(--color-stone) !important;
    }
    .feat-meta-item i {
      color: var(--color-ember-orange) !important;
    }
    .feat-meta-item strong {
      font-family: var(--font-heading), sans-serif !important;
      color: #ffffff !important;
      font-size: 13px !important;
    }
    .feat-view-btn {
      font-family: var(--font-heading), sans-serif !important;
      font-weight: 800 !important;
      font-size: 11px !important;
      border: 1px solid var(--color-silver-mist) !important;
      border-radius: 9999px !important;
      color: var(--color-stone) !important;
      display: inline-flex !important;
      align-items: center !important;
      gap: 5px !important;
      padding: 7px 14px !important;
      text-decoration: none !important;
      transition: all 0.25s ease !important;
    }
    .feat-view-btn:hover {
      background: var(--color-ember-orange) !important;
      border-color: var(--color-ember-orange) !important;
      color: var(--color-onyx) !important;
    }

    /* CTA / Banner Section */
    .cta-section {
      background-color: var(--color-paper) !important;
      padding: 80px 80px 100px !important;
    }
    .cta-banner {
      background: var(--color-fog) !important;
      border: 1px solid var(--color-silver-mist) !important;
      border-radius: 0px !important; /* Sharp */
      padding: 60px !important;
      box-shadow: none !important;
      display: flex !important;
      justify-content: space-between !important;
      align-items: center !important;
      gap: 32px !important;
    }
    .cta-banner h2 {
      font-family: var(--font-heading), sans-serif !important;
      font-size: 40px !important;
      font-weight: 900 !important;
      color: #ffffff !important;
      text-transform: uppercase !important;
      letter-spacing: -0.02em !important;
    }
    .cta-banner .highlight {
      color: var(--color-ember-orange) !important;
    }
    .cta-banner p {
      color: var(--color-stone) !important;
      margin-top: 12px !important;
      font-size: 1.05rem !important;
    }
    .cta-banner .btn {
      font-family: var(--font-heading), sans-serif !important;
      font-size: 13px !important;
      font-weight: 800 !important;
      text-transform: uppercase !important;
      border-radius: 9999px !important;
      background: var(--color-ember-orange) !important;
      color: var(--color-onyx) !important;
      padding: 14px 28px !important;
      border: none !important;
      cursor: pointer !important;
      text-decoration: none !important;
    }
    .cta-banner .btn:hover {
      background: #ffffff !important;
      color: var(--color-onyx) !important;
    }

    /* Footer Section */
    footer {
      background: var(--color-onyx) !important;
      border-top: 1px solid var(--color-silver-mist) !important;
      padding: 60px 80px !important;
      display: flex !important;
      justify-content: space-between !important;
      align-items: center !important;
      flex-wrap: wrap !important;
      gap: 24px !important;
    }
    footer p {
      color: var(--color-stone) !important;
      font-family: var(--font-body), sans-serif !important;
      font-size: 0.9rem !important;
    }
    .footer-nav {
      display: flex !important;
      gap: 32px !important;
      list-style: none !important;
    }
    .footer-nav a {
      font-family: var(--font-heading), sans-serif !important;
      font-size: 12px !important;
      color: var(--color-stone) !important;
      text-decoration: none !important;
      text-transform: uppercase !important;
    }
    .footer-nav a:hover {
      color: var(--color-ember-orange) !important;
    }
  </style>

  <!-- Content elements with nowrap style fix -->
  <style>
    .screen-card button.btn {
      white-space: nowrap !important;
    }
  </style>
</head>
<body>

  <!-- Header / Navigation -->
  <header class="navbar" id="navbar">
    <a href="${pageContext.request.contextPath}/LandingServlet" class="logo">
      <span class="logo-text">Insta<span>Foods</span></span>
    </a>
    
    <ul class="nav-links">
      <li><a href="${pageContext.request.contextPath}/ResturantServlet">Restaurants</a></li>
      <li><a href="${pageContext.request.contextPath}/MenuServlet">Menu</a></li>
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
          <a href="${pageContext.request.contextPath}/views/login.jsp" class="btn btn-outline" style="border: none; padding: 10px 16px;">Sign In</a>
          <a href="${pageContext.request.contextPath}/views/signup.jsp" class="btn btn-primary">Join Instafoods</a>
      <% } %>
    </div>

    <div class="hamburger" id="hamburger">
      <span></span>
      <span></span>
      <span></span>
    </div>
  </header>

  <!-- Hero Section -->
  <section class="hero">
    <div class="hero-content">
      <h1>
        Outrun your<br>
        <span class="highlight">cravings.</span>
      </h1>
      <p>
        Instafoods tracks every order, chef, and delivery route. Instant gourmet dishes delivered to your doorstep in under 15 minutes.
      </p>
      
      <div class="hero-actions">
        <a href="#menu" class="btn btn-primary">
          <span>Order Now</span>
          <i class="fa-solid fa-arrow-right"></i>
        </a>
        <a href="${pageContext.request.contextPath}/views/signup.jsp" class="btn btn-outline">
          <span>Get Free Delivery</span>
        </a>
      </div>

      <!-- Quick Metrics inside Hero -->
      <div class="metric-row">
        <div class="metric-card">
          <div class="icon"><i class="fa-solid fa-truck-fast"></i></div>
          <div class="details">
            <div class="title">12 MINS</div>
            <div class="sub">Average Delivery Time</div>
          </div>
        </div>
        <div class="metric-card">
          <div class="icon"><i class="fa-solid fa-fire-flame-curry"></i></div>
          <div class="details">
            <div class="title">HOT &amp; FRESH</div>
            <div class="sub">Gourmet Temperature Shield</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Right Side Mockup Showcases -->
    <div class="hero-visual">
      <!-- Live Tracker Mockup Phone -->
      <div class="phone-mockup">
        <div class="phone-notch"></div>
        <div class="phone-screen">
          <div class="screen-header">
            <span>Live Activity</span>
            <span class="highlight"><i class="fa-solid fa-signal"></i></span>
          </div>
          
          <div style="text-align: center; margin: 12px 0 8px;">
            <div style="font-size: 0.72rem; color: var(--text-muted); text-transform: uppercase; font-family: var(--font-heading); font-weight: 800;">Estimated Arrival</div>
            <div style="font-size: 2.6rem; font-family: var(--font-heading); font-weight: 900; color: var(--primary); margin: 2px 0; line-height: 1.1;">
              <%= activeStatus.equals("Delivered") ? "00:00" : (activeStatus.equals("Out for Delivery") ? "05:15" : (activeStatus.equals("Preparing") ? "12:30" : "15:00")) %>
            </div>
            <div style="font-size: 0.78rem; font-weight: 600;">
              <%= activeStatus.equals("Delivered") ? "Dishes delivered to your door" : (activeStatus.equals("Out for Delivery") ? "Rider is 0.4 miles away" : (activeStatus.equals("Preparing") ? "Chef is prepping your meal" : "Order received by kitchen")) %>
            </div>
          </div>

          <div class="screen-card">
            <span class="label-green"><%= activeStatus %></span>
            <div class="food-title"><%= activeItemName %></div>
            <div class="delivery-time">Ordered from <%= activeRestName %></div>
            <div class="delivery-tracker">
              <div class="tracker-bar">
                <div class="tracker-progress" style="width: <%= activeStatus.equals("Delivered") ? "100%" : (activeStatus.equals("Out for Delivery") ? "75%" : (activeStatus.equals("Preparing") ? "45%" : "15%")) %>;"></div>
              </div>
            </div>
          </div>

          <div class="screen-card" style="margin-top: auto; display: flex; align-items: center; justify-content: space-between;">
            <div>
              <div style="font-size: 0.75rem; color: var(--text-muted);">Active Order Total</div>
              <div style="font-size: 1.1rem; font-weight: 800; font-family: var(--font-heading);">₹<%= activeTotal.intValue() %></div>
            </div>
            <button class="btn btn-primary" style="padding: 8px 14px; font-size: 0.75rem; border-radius: 4px;">Track Route</button>
          </div>
        </div>
      </div>

      <!-- Food Menu Mockup Phone -->
      <div class="phone-mockup offset">
        <div class="phone-notch"></div>
        <div class="phone-screen">
          <div class="screen-header">
            <span>Today's Specials</span>
            <span><i class="fa-solid fa-heart" style="color: var(--primary);"></i></span>
          </div>

          <%
          Menu item1 = (allMenu != null && allMenu.size() > 0) ? allMenu.get(0) : null;
          Menu item2 = (allMenu != null && allMenu.size() > 1) ? allMenu.get(1) : null;
          Menu item3 = (allMenu != null && allMenu.size() > 2) ? allMenu.get(2) : null;
          %>

          <div class="screen-card" style="margin-top: 10px;">
            <div style="display: flex; justify-content: space-between; align-items: center;">
              <div>
                <span class="label-green" style="background:#ffffff;color:#000000;">Bestseller</span>
                <div class="food-title" style="font-size: 0.95rem;"><%= item1 != null ? item1.getItemName() : "Meghana Chicken Biryani" %></div>
                <div style="font-size: 0.75rem; color: var(--text-muted);">₹<%= item1 != null ? (int)item1.getPrice() : 320 %> • Bestselling Dish</div>
              </div>
              <div style="width:50px;height:50px;background:#1a0d05;border-radius:8px;border:1px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:1.4rem;">🍗</div>
            </div>
          </div>

          <div class="screen-card">
            <div style="display: flex; justify-content: space-between; align-items: center;">
              <div>
                <span class="label-green">Trending</span>
                <div class="food-title" style="font-size: 0.95rem;"><%= item2 != null ? item2.getItemName() : "Black Garlic Tonkotsu Ramen" %></div>
                <div style="font-size: 0.75rem; color: var(--text-muted);">₹<%= item2 != null ? (int)item2.getPrice() : 920 %> • Trending Now</div>
              </div>
              <div style="width:50px;height:50px;background:#0a0c0e;border-radius:8px;border:1px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:1.4rem;">🍜</div>
            </div>
          </div>

          <div class="screen-card">
            <div style="display: flex; justify-content: space-between; align-items: center;">
              <div>
                <span class="label-green" style="background:#ff4757;color:#fff;">Chef Special</span>
                <div class="food-title" style="font-size: 0.95rem;"><%= item3 != null ? item3.getItemName() : "Galouti Kebab + Warqi Paratha" %></div>
                <div style="font-size: 0.75rem; color: var(--text-muted);">₹<%= item3 != null ? (int)item3.getPrice() : 780 %> • Special Treat</div>
              </div>
              <div style="width:50px;height:50px;background:#160a04;border-radius:8px;border:1px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:1.4rem;">🍢</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- Featured Restaurants Section -->
  <section class="section" id="restaurants" style="padding-top: 0;">
    <div class="section-header">
      <h2>Namma Bengaluru's <span class="highlight">Top Restaurants.</span></h2>
      <p>Handpicked culinary destinations from Koramangala to MG Road. Real-time open status. Delivered to your door in minutes.</p>
    </div>

    <div class="restaurant-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(310px, 1fr)); gap: 28px;">

      <%
      if (restaurantList != null && !restaurantList.isEmpty()) {
          // Show up to 6 restaurants on the landing page
          int count = 0;
          for (Restaurant r : restaurantList) {
              if (count >= 6) break;

              // Resolve image based on cuisine type
              String cuisine = r.getCuisine_type().toLowerCase();
              String imgSrc = "images/rest_modern.png";
              if (cuisine.contains("south indian"))                   imgSrc = "images/rest_south_indian.png";
              else if (cuisine.contains("north indian"))              imgSrc = "images/rest_biryani.png";
              else if (cuisine.contains("asian"))                     imgSrc = "images/rest_asian.png";
              else if (cuisine.contains("italian") || cuisine.contains("pizza")) imgSrc = "images/rest_italian.png";
              else if (cuisine.contains("cafe") || cuisine.contains("brunch"))   imgSrc = "images/rest_cafe.png";
              else if (cuisine.contains("vegetarian"))                imgSrc = "images/rest_indian.png";
              
              if (r.getImage_path() != null && !r.getImage_path().trim().isEmpty()) {
                  imgSrc = r.getImage_path();
              }
      %>

      <a href="MenuServlet?restaurant_id=<%= r.getResturant_id() %>" class="feat-card">
        <div class="feat-img">
          <img src="<%= imgSrc %>" alt="<%= r.getName() %>" loading="lazy">
          <% if (r.getIs_active()) { %>
            <span class="feat-badge-open"><span class="dot"></span>Open</span>
          <% } else { %>
            <span class="feat-badge-closed"><span class="dot" style="background:var(--text-muted);animation:none;"></span>Closed</span>
          <% } %>
          <div class="feat-img-name"><%= r.getName() %></div>
        </div>
        <div class="feat-info">
          <span class="feat-cuisine"><%= r.getCuisine_type() %></span>
          <div class="feat-name"><%= r.getName() %></div>
          <div class="feat-address"><i class="fa-solid fa-location-dot"></i><%= r.getAddress() %></div>
          <div class="feat-meta">
            <div class="feat-meta-group">
              <div class="feat-meta-item"><i class="fa-solid fa-star"></i><strong><%= r.getRating() %></strong></div>
              <div class="feat-meta-item"><i class="fa-solid fa-clock"></i><strong><%= r.getDelivery_time() %> mins</strong></div>
            </div>
            <span class="feat-view-btn">View Menu <i class="fa-solid fa-arrow-right"></i></span>
          </div>
        </div>
      </a>

      <%
              count++;
          }
      } else {
      %>
        <div style="grid-column:1/-1;text-align:center;padding:60px 20px;color:var(--text-muted);">
          <i class="fa-solid fa-utensils" style="font-size:3rem;color:var(--primary);margin-bottom:16px;display:block;"></i>
          <p>No restaurants available right now. Check back soon!</p>
        </div>
      <% } %>

    </div>

    <!-- View All Restaurants Button -->
    <div style="text-align: center; margin-top: 48px;">
      <a href="${pageContext.request.contextPath}/ResturantServlet" class="btn btn-outline">
        <span>View All Restaurants</span>
        <i class="fa-solid fa-arrow-right"></i>
      </a>
    </div>
  </section>

  <!-- CTA Section -->
  <section class="cta-section">
    <div class="cta-banner">
      <div>
        <h2>Craving Something Else? <span class="highlight">Join The Club.</span></h2>
        <p>Unlock free deliveries across Bengaluru, exclusive experimental chef menus, and priority dispatch on every order.</p>
      </div>
      <a href="${pageContext.request.contextPath}/views/signup.jsp" class="btn btn-primary" style="flex-shrink: 0;">Unlock Membership</a>
    </div>
  </section>

  <!-- Footer -->
  <footer>
    <a href="${pageContext.request.contextPath}/LandingServlet" class="logo">
      <span class="logo-text">Insta<span>Foods</span></span>
    </a>
    
    <p>&copy; 2026 Instafoods Technologies. Namma Bengaluru's Delivery Movement.</p>

    <ul class="footer-nav">
      <li><a href="#">Privacy policy</a></li>
      <li><a href="#">Terms of use</a></li>
      <li><a href="#">Support desk</a></li>
    </ul>
  </footer>

  <script>
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
