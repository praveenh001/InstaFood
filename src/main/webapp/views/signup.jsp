<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <link rel="icon" type="image/x-icon" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQz8HFcByuK1fp2KQdFls5532X50P87Ucp1kg&s">

  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Instafoods - Join the Movement</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    .auth-hero {
      position: relative;
      width: 100%;
      background: #080808;
      padding: 28px 60px 0;
      overflow: hidden;
    }
    .auth-hero::before {
      content: '';
      position: absolute;
      top: -80px; right: -80px;
      width: 420px; height: 420px;
      background: radial-gradient(circle, rgba(202,255,0,0.06) 0%, transparent 70%);
      pointer-events: none;
      z-index: 0;
    }
    .auth-hero::after {
      content: '';
      position: absolute;
      bottom: 0; left: 10%;
      width: 300px; height: 300px;
      background: radial-gradient(circle, rgba(202,255,0,0.04) 0%, transparent 70%);
      pointer-events: none;
      z-index: 0;
    }
    .auth-hero > * { position: relative; z-index: 1; }
    .auth-hero-nav {
      display: flex;
      align-items: center;
      justify-content: space-between;
    }
    .auth-hero-nav .logo-text {
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 1.6rem;
      color: #fff;
      letter-spacing: -1px;
      text-decoration: none;
    }
    .auth-hero-nav .logo-text span { color: var(--primary); }
    .auth-hero-nav-links {
      display: flex;
      gap: 32px;
      list-style: none;
    }
    .auth-hero-nav-links a {
      text-decoration: none;
      color: var(--text-muted);
      font-family: var(--font-heading);
      font-weight: 800;
      text-transform: uppercase;
      font-size: 0.85rem;
      transition: color 0.2s;
    }
    .auth-hero-nav-links a:hover { color: var(--primary); }
    .auth-hero-body {
      display: grid;
      grid-template-columns: 1fr 1fr;
      align-items: center;
      gap: 48px;
      padding: 60px 0 0;
      max-width: 1200px;
      margin: 0 auto;
    }
    .auth-hero-left h1 {
      font-size: clamp(2.4rem, 4vw, 3.8rem);
      line-height: 0.95;
      margin-bottom: 20px;
    }
    .auth-hero-left p {
      color: var(--text-muted);
      font-size: 1.05rem;
      max-width: 460px;
      line-height: 1.7;
      margin-bottom: 32px;
    }
    .offer-cards {
      display: flex;
      flex-direction: column;
      gap: 14px;
      margin-bottom: 32px;
    }
    .offer-card {
      display: flex;
      align-items: center;
      gap: 16px;
      padding: 16px 18px;
      background: #0f0f0f;
      border: 1px solid rgba(202,255,0,0.15);
      border-radius: 10px;
      transition: background 0.2s, transform 0.2s;
    }
    .offer-card:hover {
      background: #141414;
      transform: translateX(4px);
    }
    .offer-icon {
      width: 44px; height: 44px;
      border-radius: 8px;
      background: rgba(202,255,0,0.1);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.3rem;
      flex-shrink: 0;
    }
    .offer-text .offer-title {
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.9rem;
      text-transform: uppercase;
      color: #fff;
      margin-bottom: 2px;
    }
    .offer-text .offer-sub {
      font-size: 0.8rem;
      color: var(--text-muted);
    }
    .hero-cta-row {
      display: flex;
      gap: 14px;
      flex-wrap: wrap;
    }
    .hero-stat-strip {
      display: flex;
      gap: 0;
      margin-top: 36px;
      background: #0f0f0f;
      border: 1px solid var(--border);
      border-radius: 8px;
      overflow: hidden;
    }
    .hero-stat-item {
      flex: 1;
      padding: 16px 20px;
      border-right: 1px solid var(--border);
      text-align: center;
    }
    .hero-stat-item:last-child { border-right: none; }
    .hero-stat-item .s-num {
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 1.4rem;
      color: var(--primary);
      display: block;
    }
    .hero-stat-item .s-lbl {
      font-size: 0.72rem;
      color: var(--text-muted);
      text-transform: uppercase;
      font-family: var(--font-heading);
      font-weight: 800;
      letter-spacing: 0.4px;
    }
    .auth-hero-right {
      display: flex;
      flex-direction: column;
      gap: 16px;
      align-self: flex-end;
    }
    .feature-card-big {
      background: linear-gradient(135deg, #111 0%, #0a0a0a 100%);
      border: 1px solid rgba(202,255,0,0.2);
      border-radius: 14px;
      padding: 28px;
      position: relative;
      overflow: hidden;
    }
    .feature-card-big::after {
      content: '';
      position: absolute;
      top: -40px; right: -40px;
      width: 140px; height: 140px;
      background: radial-gradient(circle, rgba(202,255,0,0.12) 0%, transparent 70%);
    }
    .feature-card-big .fc-tag {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      background: var(--primary);
      color: #000;
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.72rem;
      text-transform: uppercase;
      padding: 4px 10px;
      border-radius: 3px;
      margin-bottom: 14px;
    }
    .feature-card-big .fc-title {
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 1.5rem;
      text-transform: uppercase;
      margin-bottom: 8px;
      line-height: 1.1;
    }
    .feature-card-big .fc-sub {
      color: var(--text-muted);
      font-size: 0.88rem;
      margin-bottom: 20px;
      line-height: 1.5;
    }
    .feature-card-big .fc-price {
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 2rem;
      color: var(--primary);
    }
    .feature-card-big .fc-price span {
      font-size: 1rem;
      color: var(--text-muted);
      text-decoration: line-through;
      margin-left: 8px;
    }
    .feature-card-big .fc-emoji {
      position: absolute;
      bottom: 20px; right: 24px;
      font-size: 3.5rem;
      opacity: 0.8;
    }
    .feature-cards-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 14px;
    }
    .feature-card-sm {
      background: #111;
      border: 1px solid var(--border);
      border-radius: 10px;
      padding: 18px;
      transition: border-color 0.2s, transform 0.2s;
    }
    .feature-card-sm:hover {
      border-color: var(--primary);
      transform: translateY(-2px);
    }
    .feature-card-sm .sm-emoji { font-size: 1.8rem; margin-bottom: 10px; }
    .feature-card-sm .sm-title {
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 0.85rem;
      text-transform: uppercase;
      margin-bottom: 4px;
    }
    .feature-card-sm .sm-sub { font-size: 0.78rem; color: var(--text-muted); }
    .auth-hero-bottom {
      background: #040404;
      border-top: 1px solid var(--border);
      padding: 14px 60px;
      display: flex;
      align-items: center;
      gap: 36px;
      overflow-x: auto;
      margin-top: 48px;
    }
    .bottom-badge {
      display: flex;
      align-items: center;
      gap: 8px;
      white-space: nowrap;
      font-family: var(--font-heading);
      font-weight: 800;
      font-size: 0.78rem;
      text-transform: uppercase;
      color: var(--text-muted);
    }
    .bottom-badge i { color: var(--primary); }
    .auth-form-standalone {
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 64px 24px 80px;
      background: #080808;
    }
    .auth-form-container {
      width: 100%;
      max-width: 440px;
    }
    .form-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 14px;
    }
    @media (max-width: 900px) {
      .auth-hero { padding: 24px 28px 0; }
      .auth-hero-body { grid-template-columns: 1fr; padding: 40px 0 0; }
      .auth-hero-right { display: none; }
      .auth-hero-bottom { padding: 14px 28px; }
      .auth-hero-nav-links { display: none; }
      .hero-stat-strip { display: none; }
    }
  </style>
</head>
<body>

  <div class="auth-hero">
    <nav class="auth-hero-nav">
      <a href="${pageContext.request.contextPath}/LandingServlet" style="text-decoration:none;">
        <span class="logo-text">Insta<span>foods</span></span>
      </a>
      <ul class="auth-hero-nav-links">
        <li><a href="${pageContext.request.contextPath}/ResturantServlet">Restaurants</a></li>
        <li><a href="${pageContext.request.contextPath}/MenuServlet">Full Menu</a></li>
        <li><a href="${pageContext.request.contextPath}/OrderTrackerServlet">Insta-Tracker</a></li>
        <li><a href="${pageContext.request.contextPath}/views/cart.jsp"><i class="fa-solid fa-cart-shopping" style="margin-right:5px;"></i>Cart</a></li>
      </ul>
      <a href="${pageContext.request.contextPath}/views/login.jsp" class="btn btn-outline" style="padding: 10px 20px; font-size: 0.85rem; border-width: 1px;">Sign In</a>
    </nav>

    <div class="auth-hero-body">
      <div class="auth-hero-left">
        <h1>
          Join the <span class="highlight">movement.</span><br>
          Eat premium.<br>
          Live faster.
        </h1>
        <p>
          Sign up today — unlock your first 5 deliveries free, configure delivery presets, and get exclusive access to new restaurant menus before anyone else.
        </p>

        <div class="offer-cards">
          <div class="offer-card">
            <div class="offer-icon">🎁</div>
            <div class="offer-text">
              <div class="offer-title">Welcome Pack — ₹150 Voucher</div>
              <div class="offer-sub">Applied instantly on your first order. No minimum spend.</div>
            </div>
          </div>
          <div class="offer-card">
            <div class="offer-icon">🚀</div>
            <div class="offer-text">
              <div class="offer-title">Free Delivery · First 5 Orders</div>
              <div class="offer-sub">Zero delivery charges for a full week after joining.</div>
            </div>
          </div>
          <div class="offer-card">
            <div class="offer-icon">⚡</div>
            <div class="offer-text">
              <div class="offer-title">Priority Dispatch Queue</div>
              <div class="offer-sub">Your orders jump the queue — guaranteed faster delivery.</div>
            </div>
          </div>
        </div>
      </div>

      <div class="auth-hero-right">
        <div class="feature-card-big">
          <div class="fc-tag"><i class="fa-solid fa-gift"></i> New Member Offer</div>
          <div class="fc-title">First Order<br>On Us.</div>
          <div class="fc-sub">Use code <strong style="color:var(--primary);">INSTA150</strong> at checkout to get ₹150 off your first order from any partner restaurant.</div>
          <div class="fc-price">₹0 <span>₹150.00</span></div>
          <div class="fc-emoji">🎉</div>
        </div>
      </div>
    </div>

    <div class="auth-hero-bottom">
      <div class="bottom-badge"><i class="fa-solid fa-shield-halved"></i> 100% Secure Payments</div>
      <div class="bottom-badge"><i class="fa-solid fa-truck-fast"></i> Live GPS Tracking</div>
      <div class="bottom-badge"><i class="fa-solid fa-fire-flame-curved"></i> Thermally Sealed Packaging</div>
    </div>
  </div>

  <div class="auth-form-standalone">
    <div class="auth-form-container">

      <div class="auth-header">
        <h1>Create Account</h1>
        <p>Register to customize menus and start tracking your orders.</p>
      </div>

      <!-- Dynamic Error Banner -->
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

      <!-- Submit to SignupServlet -->
      <form class="auth-form" action="${pageContext.request.contextPath}/SignupServlet" method="POST">
        <div class="form-row">
          <div class="input-group">
            <label for="firstname">First Name</label>
            <input type="text" id="firstname" name="firstname" placeholder="John" required>
          </div>
          <div class="input-group">
            <label for="lastname">Last Name</label>
            <input type="text" id="lastname" name="lastname" placeholder="Smith" required>
          </div>
        </div>

        <div class="input-group">
          <label for="email">Email Address</label>
          <input type="email" id="email" name="email" placeholder="john.smith@domain.com" required>
        </div>

        <div class="input-group">
          <label for="password">Create Password</label>
          <div class="password-wrapper">
            <input type="password" id="password" name="password" placeholder="Min. 8 characters" required>
            <button type="button" class="toggle-pw" id="togglePwBtn" aria-label="Toggle password visibility">
              <i class="fa-solid fa-eye-slash" id="eyeIcon"></i>
            </button>
          </div>
          <div class="strength-meter">
            <div class="strength-bar" id="s1"></div>
            <div class="strength-bar" id="s2"></div>
            <div class="strength-bar" id="s3"></div>
          </div>
          <span class="strength-label" id="strengthLabel">Password Strength: Empty</span>
        </div>

        <div class="input-group">
          <label for="securityQuestion">Security Question (For Password Recovery)</label>
          <select id="securityQuestion" name="securityQuestion" required style="width: 100%; background: #181818; border: 1.5px solid var(--border); padding: 14px; border-radius: 8px; color: #fff; font-size: 0.95rem; font-family: var(--font-body); box-sizing: border-box; appearance: none; -webkit-appearance: none; -moz-appearance: none; background-image: url('data:image/svg+xml;utf8,<svg fill=\"white\" height=\"24\" viewBox=\"0 0 24 24\" width=\"24\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M7 10l5 5 5-5z\"/></svg>'); background-repeat: no-repeat; background-position: right 12px center;">
            <option value="" disabled selected>Select a recovery question...</option>
            <option value="What is your pet name?">What is your pet's name?</option>
            <option value="What was the name of your first school?">What was the name of your first school?</option>
            <option value="In which city were you born?">In which city were you born?</option>
            <option value="What was your childhood nickname?">What was your childhood nickname?</option>
          </select>
        </div>

        <div class="input-group">
          <label for="securityAnswer">Security Answer</label>
          <input type="text" id="securityAnswer" name="securityAnswer" placeholder="Enter your answer" required autocomplete="off" style="width: 100%;">
        </div>

        <div class="input-group">
          <label for="securityQuestion2">Second Security Question (Backup Recovery)</label>
          <select id="securityQuestion2" name="securityQuestion2" required style="width: 100%; background: #181818; border: 1.5px solid var(--border); padding: 14px; border-radius: 8px; color: #fff; font-size: 0.95rem; font-family: var(--font-body); box-sizing: border-box; appearance: none; -webkit-appearance: none; -moz-appearance: none; background-image: url('data:image/svg+xml;utf8,<svg fill=\"white\" height=\"24\" viewBox=\"0 0 24 24\" width=\"24\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M7 10l5 5 5-5z\"/></svg>'); background-repeat: no-repeat; background-position: right 12px center;">
            <option value="" disabled selected>Select a backup recovery question...</option>
            <option value="What was the name of your first school?">What was the name of your first school?</option>
            <option value="In which city were you born?">In which city were you born?</option>
            <option value="What was your childhood nickname?">What was your childhood nickname?</option>
            <option value="What is your favorite food?">What is your favorite food?</option>
            <option value="What is your pet name?">What is your pet's name?</option>
          </select>
        </div>

        <div class="input-group">
          <label for="securityAnswer2">Second Security Answer</label>
          <input type="text" id="securityAnswer2" name="securityAnswer2" placeholder="Enter your backup answer" required autocomplete="off" style="width: 100%;">
        </div>

        <div class="form-options" style="margin-bottom: 20px;">
          <label style="align-items: flex-start;">
            <input type="checkbox" id="terms" required style="margin-top: 3px;">
            <span>I accept all the <a href="#" style="text-decoration: underline; color: var(--text-primary);">Terms &amp; Agreements</a> and the Instafoods Privacy Policy.</span>
          </label>
        </div>

        <button type="submit" class="btn btn-primary submit-btn">
          <span>Activate Account</span>
          <i class="fa-solid fa-user-plus"></i>
        </button>

        <p class="auth-footer">
          Already have an active plan? <a href="${pageContext.request.contextPath}/views/login.jsp">Sign In here</a>
        </p>
      </form>

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

  passwordInput.addEventListener('input', function () {
    const val = passwordInput.value;
    const bars = [document.getElementById('s1'), document.getElementById('s2'), document.getElementById('s3')];
    const label = document.getElementById('strengthLabel');

    bars.forEach(b => { b.className = 'strength-bar'; });

    if (val.length === 0) {
      label.textContent = 'Password Strength: Empty';
    } else if (val.length < 6) {
      bars[0].classList.add('filled', 'weak');
      label.textContent = 'Password Strength: Weak';
    } else if (val.length < 10) {
      bars[0].classList.add('filled', 'fair');
      bars[1].classList.add('filled', 'fair');
      label.textContent = 'Password Strength: Fair';
    } else {
      bars.forEach(b => b.classList.add('filled', 'strong'));
      label.textContent = 'Password Strength: Strong';
    }
  });
</script>
</body>
</html>