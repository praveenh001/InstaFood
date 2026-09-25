<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <link rel="icon" type="image/x-icon" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQz8HFcByuK1fp2KQdFls5532X50P87Ucp1kg&s">

  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Logged Out - Instafoods</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    body {
      background-color: #0c0c0c;
      color: #ffffff;
      display: flex;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
      margin: 0;
      font-family: var(--font-body), sans-serif;
    }
    .logout-container {
      background: var(--bg-card);
      border: 1px solid var(--border);
      padding: 48px;
      border-radius: 16px;
      text-align: center;
      max-width: 420px;
      width: 100%;
      box-shadow: 0 20px 50px rgba(0,0,0,0.6);
      box-sizing: border-box;
      animation: fadeSlideUp 0.6s ease both;
    }
    @keyframes fadeSlideUp {
      from { opacity: 0; transform: translateY(30px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    .logout-icon {
      width: 80px;
      height: 80px;
      background: rgba(202, 255, 0, 0.1);
      border: 1.5px solid var(--primary);
      color: var(--primary);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 2.2rem;
      margin: 0 auto 24px;
      box-shadow: 0 0 20px rgba(202,255,0,0.15);
    }
    .logout-container h2 {
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 1.8rem;
      margin-bottom: 12px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
    .logout-container p {
      color: var(--text-muted);
      font-size: 0.95rem;
      line-height: 1.5;
      margin-bottom: 24px;
    }
    .countdown-text {
      font-size: 0.82rem;
      color: var(--text-muted);
      margin-bottom: 32px;
      font-family: var(--font-heading);
      text-transform: uppercase;
      letter-spacing: 1px;
    }
    .countdown-seconds {
      color: var(--primary);
      font-weight: 800;
    }
    .btn-group {
      display: flex;
      flex-direction: column;
      gap: 12px;
    }
  </style>
</head>
<body>

  <div class="logout-container">
    <div class="logout-icon">
      <i class="fa-solid fa-arrow-right-from-bracket"></i>
    </div>
    <h2>Logged Out</h2>
    <p>You have been successfully signed out of your account. Thank you for visiting Instafoods!</p>
    
    <div class="countdown-text">
      Redirecting to Home in <span class="countdown-seconds" id="countdown">5</span> seconds...
    </div>
    
    <div class="btn-group">
      <a href="${pageContext.request.contextPath}/views/login.jsp" class="btn btn-primary" style="width: 100%; box-sizing: border-box;">Sign In Again</a>
      <a href="${pageContext.request.contextPath}/LandingServlet" class="btn btn-outline" style="width: 100%; box-sizing: border-box; border-color: rgba(255,255,255,0.15); color: #fff;">Go to Home</a>
    </div>
  </div>

  <script>
    let secondsLeft = 5;
    const countdownEl = document.getElementById('countdown');
    
    const interval = setInterval(() => {
      secondsLeft--;
      countdownEl.textContent = secondsLeft;
      if (secondsLeft <= 0) {
        clearInterval(interval);
        window.location.href = '${pageContext.request.contextPath}/LandingServlet';
      }
    }, 1000);
  </script>

</body>
</html>
