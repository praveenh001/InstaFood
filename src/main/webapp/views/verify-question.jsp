<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <link rel="icon" type="image/x-icon" href="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQz8HFcByuK1fp2KQdFls5532X50P87Ucp1kg&s">

  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Security Verification - Instafoods</title>
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
    .quiz-container {
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
    .quiz-header {
      text-align: center;
      margin-bottom: 32px;
    }
    .quiz-header h2 {
      font-family: var(--font-heading);
      font-weight: 900;
      font-size: 1.8rem;
      margin-bottom: 12px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
    .quiz-header p {
      color: var(--text-muted);
      font-size: 0.92rem;
      line-height: 1.5;
    }
    .quiz-card {
      background: #111;
      border: 1px solid rgba(255,255,255,0.06);
      padding: 24px;
      border-radius: 8px;
      text-align: center;
      margin-bottom: 24px;
    }
    .quiz-question {
      font-size: 2.2rem;
      font-family: var(--font-heading), monospace;
      font-weight: 900;
      color: var(--primary);
      letter-spacing: 2px;
      text-shadow: 0 0 10px rgba(202,255,0,0.2);
    }
    .quiz-input-field {
      width: 100%;
      background: #181818;
      border: 1.5px solid var(--border);
      padding: 16px;
      border-radius: 8px;
      color: #fff;
      font-size: 1.3rem;
      text-align: center;
      margin-bottom: 24px;
      box-sizing: border-box;
      transition: border-color 0.2s;
    }
    .quiz-input-field:focus {
      border-color: var(--primary);
      outline: none;
    }
    .quiz-footer {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-top: 24px;
      font-size: 0.85rem;
    }
    .quiz-footer a {
      color: var(--primary);
      text-decoration: none;
      font-weight: 800;
      font-family: var(--font-heading);
      text-transform: uppercase;
    }
    .quiz-footer a:hover {
      color: var(--primary-light);
    }
    @keyframes pulse-icon {
      0%, 100% { transform: scale(1); opacity: 0.9; }
      50% { transform: scale(1.08) translateY(-3px); opacity: 1; }
    }
  </style>
</head>
<body>

  <%
      String email = request.getParameter("email");
      String errorMsg = (String) session.getAttribute("errorMsg");
      String successMsg = (String) session.getAttribute("successMsg");
      
      // If email is missing, redirect to login
      if (email == null || email.trim().isEmpty()) {
          response.sendRedirect(request.getContextPath() + "/views/login.jsp");
          return;
      }
      
      // Initialize questionNum and questionAttempts if not present
      Integer questionNum = (Integer) session.getAttribute("questionNum");
      Integer questionAttempts = (Integer) session.getAttribute("questionAttempts");
      if (questionNum == null) {
          questionNum = 1;
          session.setAttribute("questionNum", 1);
      }
      if (questionAttempts == null) {
          questionAttempts = 0;
          session.setAttribute("questionAttempts", 0);
      }
      
      // Fetch user's security questions from database
      String securityQuestion = null;
      String securityQuestion2 = null;
      String username = "User";
      
      com.instafoo.dao.UserDao userDao = new com.instafoo.daoImp.UserDaoImp();
      java.util.List<com.instafoo.Model.User> userList = userDao.getAllUser();
      for (com.instafoo.Model.User u : userList) {
          if (u.getEmail().equalsIgnoreCase(email)) {
              username = u.getUsername();
              securityQuestion = u.getSecurity_question();
              securityQuestion2 = u.getSecurity_question_2();
              break;
          }
      }
      
      // Fallbacks
      if (securityQuestion == null) {
          securityQuestion = "What is your pet name?";
      }
      if (securityQuestion2 == null) {
          securityQuestion2 = "In which city were you born?";
      }
      
      // Determine active question and maximum limits
      String activeQuestion = (questionNum == 1) ? securityQuestion : securityQuestion2;
      int maxAttempts = (questionNum == 1) ? 3 : 2;
      int attemptsLeft = maxAttempts - questionAttempts;
  %>

  <div class="quiz-container">

    <div class="quiz-header">
      <h2>Security Verification</h2>
      <p>Hi <strong><%= username %></strong>, please answer your security question to unlock your account and reset your password.</p>
    </div>

    <% if (errorMsg != null) { %>
        <div style="background-color: rgba(239, 68, 68, 0.15); border: 1px solid #ef4444; color: #f87171; padding: 12px; border-radius: 6px; margin-bottom: 20px; font-family: var(--font-body); font-size: 0.9rem; text-align: left; display: flex; align-items: center; gap: 8px;">
            <i class="fa-solid fa-triangle-exclamation"></i>
            <%= errorMsg %>
        </div>
    <% 
            session.removeAttribute("errorMsg");
        } 
    %>

    <div class="quiz-card" style="text-align: left; background: #141414; padding: 20px; border-radius: 8px; margin-bottom: 24px; border: 1px solid rgba(255,255,255,0.04);">
      <div style="font-size: 0.72rem; text-transform: uppercase; font-family: var(--font-heading); font-weight: 900; color: var(--text-muted); margin-bottom: 6px; letter-spacing: 0.5px;">
        <%= (questionNum == 1) ? "Primary Recovery Question" : "Backup Recovery Question" %>
      </div>
      <div style="font-size: 1.15rem; font-weight: 800; color: #fff; line-height: 1.4;"><%= activeQuestion %></div>
      <div style="font-size: 0.78rem; font-family: var(--font-heading); font-weight: 800; color: <%= (questionNum == 1) ? "var(--primary)" : "#00e5ff" %>; margin-top: 10px; text-transform: uppercase; letter-spacing: 0.5px;">
        Attempts Remaining: <%= attemptsLeft %>
      </div>
    </div>

    <form action="${pageContext.request.contextPath}/LoginServlet" method="POST">
      <input type="hidden" name="action" value="verifySecurityQuestion">
      <input type="hidden" name="email" value="<%= email %>">
      
      <div class="input-group" style="margin-bottom: 20px;">
        <label for="answer" style="display: block; margin-bottom: 8px; font-size: 0.85rem; color: var(--text-muted); text-transform: uppercase; font-weight: 800; font-family: var(--font-heading);">Your Answer</label>
        <input type="text" id="answer" name="answer" placeholder="Type your answer here..." required autocomplete="off" style="width: 100%; box-sizing: border-box; background: #181818; border: 1.5px solid var(--border); padding: 14px; border-radius: 8px; color: #fff; font-size: 1rem; transition: border-color 0.2s;">
      </div>
      
      <button type="submit" class="btn btn-primary" style="width: 100%; box-sizing: border-box; padding: 14px 20px;">Verify Identity</button>
    </form>

    <div style="border-top: 1px solid rgba(255,255,255,0.08); padding-top: 20px; margin-top: 24px; text-align: center;">
      <a href="${pageContext.request.contextPath}/views/login.jsp" style="color: var(--text-muted); text-decoration: none; font-size: 0.88rem; font-weight: 700;">Cancel and Return to Sign In</a>
    </div>

  </div>

</body>
</html>
