<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Instafoods - Welcome Back</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
  <link rel="icon" type="image/x-icon" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQz8HFcByuK1fp2KQdFls5532X50P87Ucp1kg&s">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    /* Premium dark inputs mapping */
    .input-group input,
    .input-group .password-wrapper input,
    .password-wrapper input,
    #email,
    #password {
      background: #121212 !important;
      border: 1px solid rgba(255, 255, 255, 0.08) !important;
      color: #ffffff !important;
      padding: 14px 16px !important;
      border-radius: 9999px !important; /* Pill shaped input to match button template style */
      outline: none !important;
      font-family: var(--font-body), sans-serif !important;
      font-size: 0.95rem !important;
      transition: border-color 0.25s ease, box-shadow 0.25s ease !important;
      width: 100% !important;
      box-sizing: border-box !important;
    }
    .input-group input:focus {
      border-color: #caff00 !important;
      box-shadow: 0 0 12px rgba(202, 255, 0, 0.15) !important;
    }
    /* Customize eye button container */
    .password-wrapper {
      position: relative !important;
      width: 100% !important;
    }
    .password-wrapper input {
      padding-right: 48px !important;
    }
    .toggle-pw {
      background: transparent !important;
      border: none !important;
      color: #a0a0a0 !important;
      position: absolute !important;
      right: 18px !important;
      top: 50% !important;
      transform: translateY(-50%) !important;
      cursor: pointer !important;
      font-size: 1rem !important;
    }
    .toggle-pw:hover {
      color: #ffffff !important;
    }
    /* Custom Switcher Tabs styling */
    .login-tabs-container {
      display: flex !important;
      background: #121212 !important; /* dark track background */
      border: 1px solid rgba(255, 255, 255, 0.08) !important;
      border-radius: 9999px !important; /* pill track */
      padding: 4px !important;
      margin-bottom: 24px !important;
    }
    .login-tab-btn {
      flex: 1 !important;
      background: transparent !important;
      border: none !important;
      color: #a0a0a0 !important;
      padding: 10px 0 !important;
      font-size: 0.8rem !important;
      font-weight: 900 !important;
      text-transform: uppercase !important;
      letter-spacing: 0.5px !important;
      font-family: var(--font-heading), sans-serif !important;
      cursor: pointer !important;
      border-radius: 9999px !important;
      transition: all 0.25s ease !important;
      text-align: center !important;
    }
    .login-tab-btn:hover {
      color: #ffffff !important;
    }
    .login-tab-btn.active {
      background: #caff00 !important; /* Neon Lime active track */
      color: #080808 !important; /* Dark text */
      box-shadow: 0 4px 12px rgba(202, 255, 0, 0.15) !important;
    }
  </style>
</head>
<body>

  <div class="auth-page">
    <!-- Left panel (Branding) -->
    <div class="auth-branding">
      <div class="branding-logo">
        <a href="${pageContext.request.contextPath}/LandingServlet" class="logo">
          <span class="logo-text">Insta<span>Foods</span></span>
        </a>
      </div>

      <div class="branding-hero">
        <h2>Fuel your<br>body. <span class="highlight">Fast.</span></h2>
        <p style="margin-top: 16px;">Log in to access your customized dashboard, track delivery couriers in real-time, and reorder your preferred gourmet bowls with one click.</p>
      </div>

      <div class="metric-card" style="max-width: 320px; background: rgba(255,255,255,0.03); border-color: #caff00;">
        <div class="icon"><i class="fa-solid fa-medal"></i></div>
        <div class="details">
          <div class="title" style="font-size: 0.95rem; font-family: var(--font-heading); font-weight: 900;">BEST IN CLASS DELIVERIES</div>
          <div class="sub" style="font-size: 0.72rem; color: #a0a0a0;">98.6% orders delivered under 15 mins.</div>
        </div>
      </div>
    </div>

    <!-- Right panel (Login Form) -->
    <div class="auth-form-panel">
      <div class="auth-form-container">

        <div class="auth-header">
          <h1 id="loginTitle">Sign In</h1>
          <p id="loginDesc">Access your Instafoods dashboard and active tracking.</p>
        </div>

        <!-- Admin Login Section Selection Tabs -->
        <div class="login-tabs-container">
          <button type="button" class="login-tab-btn active" id="userLoginTab" onclick="switchLoginMode('User')">
            Customer Sign In
          </button>
          <button type="button" class="login-tab-btn" id="adminLoginTab" onclick="switchLoginMode('Admin')">
            Admin Sign In
          </button>
        </div>

        <!-- Dynamic Success & Error Banners -->
        <%
            String errorMsg = (String) session.getAttribute("errorMsg");
            if (errorMsg != null) {
        %>
            <div style="background-color: rgba(239, 68, 68, 0.15); border: 1px solid #ef4444; color: #f87171; padding: 12px; border-radius: 6px; margin-bottom: 20px; font-family: var(--font-body); font-size: 0.9rem; display: flex; align-items: center; gap: 8px;">
                <i class="fa-solid fa-triangle-exclamation"></i>
                <%= errorMsg %>
            </div>
        <%
                session.removeAttribute("errorMsg");
            }
        %>
        
        <%
            String successMsg = (String) session.getAttribute("successMsg");
            if (successMsg != null) {
        %>
            <div style="background-color: rgba(34, 197, 94, 0.15); border: 1px solid #22c55e; color: #4ade80; padding: 12px; border-radius: 6px; margin-bottom: 20px; font-family: var(--font-body); font-size: 0.9rem; display: flex; align-items: center; gap: 8px;">
                <i class="fa-solid fa-circle-check"></i>
                <%= successMsg %>
            </div>
        <%
                session.removeAttribute("successMsg");
            }
        %>

        <!-- Submit to LoginServlet -->
        <form class="auth-form" action="${pageContext.request.contextPath}/LoginServlet" method="POST">
          <input type="hidden" name="loginType" id="loginType" value="User">
          <!-- Email -->
          <div class="input-group">
            <label for="email">Email Address</label>
            <input type="email" id="email" name="email" placeholder="name@domain.com" required>
          </div>

          <!-- Password -->
          <div class="input-group">
            <div style="display: flex; justify-content: space-between; align-items: center;">
              <label for="password">Password</label>
              <a href="#" class="forgot-link" onclick="handleForgotPassword(event)" style="font-size: 0.75rem; text-transform: uppercase; font-family: var(--font-heading); font-weight: 800; letter-spacing: 0.5px;">Forgot Password?</a>
            </div>
            <div class="password-wrapper">
              <input type="password" id="password" name="password" placeholder="••••••••••••" required>
              <button type="button" class="toggle-pw" id="togglePwBtn" aria-label="Toggle password visibility">
                <i class="fa-solid fa-eye-slash" id="eyeIcon"></i>
              </button>
            </div>
          </div>

          <!-- Options -->
          <div class="form-options">
            <label>
              <input type="checkbox" name="remember">
              <span>Remember this browser</span>
            </label>
          </div>

          <!-- Action Button -->
          <button type="submit" class="btn btn-primary submit-btn">
            <span>Unlock Dashboard</span>
            <i class="fa-solid fa-arrow-right"></i>
          </button>

          <!-- Create Account Footer -->
          <p class="auth-footer">
            New to the movement? <a href="${pageContext.request.contextPath}/views/signup.jsp">Create an Account</a>
          </p>
        </form>

      </div>
    </div>
  </div>

<script>
  const toggleBtn = document.getElementById('togglePwBtn');
  const passwordInput = document.getElementById('password');
  const eyeIcon = document.getElementById('eyeIcon');

  toggleBtn.addEventListener('click', function () {
    const isHidden = passwordInput.type === 'password';
    passwordInput.type = isHidden ? 'text' : 'password';
    eyeIcon.classList.toggle('fa-eye-slash', !isHidden);
    eyeIcon.classList.toggle('fa-eye', isHidden);
  });

  function handleForgotPassword(event) {
    event.preventDefault();
    const emailInput = document.getElementById('email');
    const email = emailInput.value.trim();
    if (!email) {
      alert("Please enter your email address first so we can send you an OTP.");
      emailInput.focus();
      return;
    }
    window.location.href = "${pageContext.request.contextPath}/LoginServlet?action=forgotPassword&email=" + encodeURIComponent(email);
  }

  function switchLoginMode(mode) {
    const userTab = document.getElementById('userLoginTab');
    const adminTab = document.getElementById('adminLoginTab');
    const emailInput = document.getElementById('email');
    const title = document.getElementById('loginTitle');
    const desc = document.getElementById('loginDesc');
    const loginTypeInput = document.getElementById('loginType');

    if (loginTypeInput) {
      loginTypeInput.value = mode;
    }

    if (mode === 'Admin') {
      adminTab.classList.add('active');
      userTab.classList.remove('active');
      emailInput.value = 'rajathos07@gmail.com'; // Autofill Admin for comfort
      title.innerText = 'Admin Sign In';
      desc.innerText = 'Access the Instafoods Administrative Control Panel.';
    } else {
      userTab.classList.add('active');
      adminTab.classList.remove('active');
      emailInput.value = '';
      title.innerText = 'Sign In';
      desc.innerText = 'Access your Instafoods dashboard and active tracking.';
    }
  }
</script>
</body>
</html>
