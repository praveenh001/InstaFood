<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <link rel="icon" type="image/x-icon" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQz8HFcByuK1fp2KQdFls5532X50P87Ucp1kg&s">

  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Reset Password - Instafoods</title>
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
    .reset-container {
      background: var(--bg-card);
      border: 1px solid var(--border);
      padding: 48px;
      border-radius: 16px;
      max-width: 440px;
      width: 100%;
      box-shadow: 0 20px 50px rgba(0,0,0,0.6);
      box-sizing: border-box;
      animation: fadeSlideUp 0.6s ease both;
    }
    @keyframes fadeSlideUp {
      from { opacity: 0; transform: translateY(30px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    .reset-header {
      text-align: center;
      margin-bottom: 32px;
    }
    .reset-header h2 {
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 1.8rem;
      margin-bottom: 12px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
    .reset-header p {
      color: var(--text-muted);
      font-size: 0.92rem;
      line-height: 1.5;
    }
    .input-group {
      display: flex;
      flex-direction: column;
      gap: 8px;
      margin-bottom: 20px;
    }
    .input-group label {
      font-family: var(--font-heading);
      font-weight: 800;
      font-size: 0.78rem;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      color: var(--text-muted);
    }
    .input-group input {
      background: #111;
      border: 1.5px solid var(--border);
      padding: 14px 16px;
      border-radius: 8px;
      color: #fff;
      font-size: 0.95rem;
      box-sizing: border-box;
      transition: border-color 0.2s;
    }
    .input-group input:focus {
      border-color: var(--primary);
      outline: none;
    }
  </style>
</head>
<body>

  <%
      String email = request.getParameter("email");
      String errorMsg = (String) session.getAttribute("errorMsg");
      
      // If email is missing, redirect to login
      if (email == null || email.trim().isEmpty()) {
          response.sendRedirect(request.getContextPath() + "/views/login.jsp");
          return;
      }
  %>

  <div class="reset-container">

    <div class="reset-header">
      <h2>Reset Password</h2>
      <p>Identity verified! Please select a new secure password for your account <strong><%= email %></strong>.</p>
    </div>

    <% if (errorMsg != null) { %>
        <div style="background-color: rgba(239, 68, 68, 0.15); border: 1px solid #ef4444; color: #f87171; padding: 12px; border-radius: 6px; margin-bottom: 20px; font-family: var(--font-body); font-size: 0.9rem; display: flex; align-items: center; gap: 8px;">
            <i class="fa-solid fa-triangle-exclamation"></i>
            <%= errorMsg %>
        </div>
    <% 
            session.removeAttribute("errorMsg");
        } 
    %>

    <form action="${pageContext.request.contextPath}/LoginServlet" method="POST">
      <input type="hidden" name="action" value="resetPassword">
      <input type="hidden" name="email" value="<%= email %>">
      
      <div class="input-group">
        <label for="newPassword">New Password</label>
        <div class="password-wrapper">
          <input type="password" id="newPassword" name="password" placeholder="••••••••••••" required>
          <button type="button" class="toggle-pw" id="toggleNewPwBtn" aria-label="Toggle password visibility">
            <i class="fa-solid fa-eye-slash" id="newEyeIcon"></i>
          </button>
        </div>
      </div>

      <div class="input-group">
        <label for="confirmPassword">Confirm Password</label>
        <div class="password-wrapper">
          <input type="password" id="confirmPassword" name="confirmPassword" placeholder="••••••••••••" required>
          <button type="button" class="toggle-pw" id="toggleConfirmPwBtn" aria-label="Toggle password visibility">
            <i class="fa-solid fa-eye-slash" id="confirmEyeIcon"></i>
          </button>
        </div>
      </div>
      
      <button type="submit" class="btn btn-primary" style="width: 100%; box-sizing: border-box; padding: 14px 20px; margin-top: 10px;">Save Password</button>
    </form>

  </div>

  <script>
    function setupPasswordToggle(btnId, inputId, iconId) {
      const btn = document.getElementById(btnId);
      const input = document.getElementById(inputId);
      const icon = document.getElementById(iconId);
      
      btn.addEventListener('click', function () {
        const isHidden = input.type === 'password';
        input.type = isHidden ? 'text' : 'password';
        icon.classList.toggle('fa-eye-slash', !isHidden);
        icon.classList.toggle('fa-eye', isHidden);
      });
    }
    
    setupPasswordToggle('toggleNewPwBtn', 'newPassword', 'newEyeIcon');
    setupPasswordToggle('toggleConfirmPwBtn', 'confirmPassword', 'confirmEyeIcon');
  </script>

</body>
</html>
