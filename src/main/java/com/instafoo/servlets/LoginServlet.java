package com.instafoo.servlets;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.instafoo.Model.User;
import com.instafoo.dao.UserDao;
import com.instafoo.daoImp.UserDaoImp;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Track lockout failed attempts per email across sessions
    private static final Map<String, Integer> failedAttemptsMap = new ConcurrentHashMap<>();


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String email = request.getParameter("email");
        HttpSession session = request.getSession();
        
        if ("forgotPassword".equals(action) && email != null && !email.trim().isEmpty()) {
            UserDao userDao = new UserDaoImp();
            List<User> userList = userDao.getAllUser();
            User matchedUser = null;
            email = email.toLowerCase().trim();
            for (User u : userList) {
                if (u.getEmail().equalsIgnoreCase(email)) {
                    matchedUser = u;
                    break;
                }
            }
            
            if (matchedUser != null) {
                response.sendRedirect("views/verify-question.jsp?email=" + java.net.URLEncoder.encode(email, "UTF-8"));
            } else {
                session.setAttribute("errorMsg", "Email address not found. Please create a new account.");
                response.sendRedirect("views/signup.jsp");
            }
        } else {
            response.sendRedirect("views/login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        UserDao userDao = new UserDaoImp();
        
        // Action: Verify Security Question Answer
        if ("verifySecurityQuestion".equals(action)) {
            String email = request.getParameter("email");
            String answer = request.getParameter("answer");
            
            if (email != null && answer != null) {
                email = email.toLowerCase().trim();
                answer = answer.trim();
                
                List<User> userList = userDao.getAllUser();
                User matchedUser = null;
                for (User u : userList) {
                    if (u.getEmail().equalsIgnoreCase(email)) {
                        matchedUser = u;
                        break;
                    }
                }
                
                if (matchedUser != null) {
                    Integer questionNum = (Integer) session.getAttribute("questionNum");
                    Integer questionAttempts = (Integer) session.getAttribute("questionAttempts");
                    if (questionNum == null) questionNum = 1;
                    if (questionAttempts == null) questionAttempts = 0;
                    
                    if (questionNum == 1) {
                        // Check primary security answer
                        if (matchedUser.getSecurity_answer() != null && matchedUser.getSecurity_answer().equalsIgnoreCase(answer)) {
                            // Correct! Clear attempts and reset password
                            session.removeAttribute("questionNum");
                            session.removeAttribute("questionAttempts");
                            failedAttemptsMap.remove(email);
                            response.sendRedirect("views/reset-password.jsp?email=" + java.net.URLEncoder.encode(email, "UTF-8"));
                            return;
                        } else {
                            // Wrong primary answer
                            questionAttempts++;
                            if (questionAttempts >= 3) {
                                // Transition to question 2 (backup question)
                                session.setAttribute("questionNum", 2);
                                session.setAttribute("questionAttempts", 0);
                                session.setAttribute("errorMsg", "Incorrect answer. You have failed 3 attempts. Please answer your backup question.");
                            } else {
                                session.setAttribute("questionAttempts", questionAttempts);
                                session.setAttribute("errorMsg", "Incorrect answer. " + (3 - questionAttempts) + " attempt(s) remaining.");
                            }
                            response.sendRedirect("views/verify-question.jsp?email=" + java.net.URLEncoder.encode(email, "UTF-8"));
                            return;
                        }
                    } else if (questionNum == 2) {
                        // Check backup security answer
                        if (matchedUser.getSecurity_answer_2() != null && matchedUser.getSecurity_answer_2().equalsIgnoreCase(answer)) {
                            // Correct! Clear attempts and reset password
                            session.removeAttribute("questionNum");
                            session.removeAttribute("questionAttempts");
                            failedAttemptsMap.remove(email);
                            response.sendRedirect("views/reset-password.jsp?email=" + java.net.URLEncoder.encode(email, "UTF-8"));
                            return;
                        } else {
                            // Wrong backup answer
                            questionAttempts++;
                            if (questionAttempts >= 2) {
                                // Exceeded all limits: force signup
                                session.removeAttribute("questionNum");
                                session.removeAttribute("questionAttempts");
                                failedAttemptsMap.remove(email);
                                session.setAttribute("errorMsg", "Incorrect backup answer. You have failed all recovery attempts. Please register a new account.");
                                response.sendRedirect("views/signup.jsp");
                                return;
                            } else {
                                session.setAttribute("questionAttempts", questionAttempts);
                                session.setAttribute("errorMsg", "Incorrect backup answer. " + (2 - questionAttempts) + " attempt(s) remaining.");
                                response.sendRedirect("views/verify-question.jsp?email=" + java.net.URLEncoder.encode(email, "UTF-8"));
                                return;
                            }
                        }
                    }
                }
            }
            
            // FAILED VERIFICATION: Default fallback to signup
            failedAttemptsMap.remove(email);
            session.removeAttribute("questionNum");
            session.removeAttribute("questionAttempts");
            session.setAttribute("errorMsg", "Verification failed. Please create a new account.");
            response.sendRedirect("views/signup.jsp");
            return;
        }

        // Action: Reset Password
        if ("resetPassword".equals(action)) {
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            
            if (email != null && password != null && confirmPassword != null) {
                email = email.toLowerCase().trim();
                
                if (!password.equals(confirmPassword)) {
                    session.setAttribute("errorMsg", "Passwords do not match. Please try again.");
                    response.sendRedirect("views/reset-password.jsp?email=" + java.net.URLEncoder.encode(email, "UTF-8"));
                    return;
                }
                
                // Fetch user to update
                List<User> userList = userDao.getAllUser();
                User targetUser = null;
                for (User u : userList) {
                    if (u.getEmail().equalsIgnoreCase(email)) {
                        targetUser = u;
                        break;
                    }
                }
                
                if (targetUser != null) {
                    // Update password in DB
                    targetUser.setPassword(password);
                    userDao.updateUser(targetUser);
                    
                    // Reset lockout state
                    failedAttemptsMap.remove(email);
                    session.setAttribute("successMsg", "Password reset successful! You can now sign in with your new password.");
                    response.sendRedirect("views/login.jsp");
                    return;
                }
            }
            session.setAttribute("errorMsg", "An error occurred during password reset.");
            response.sendRedirect("views/login.jsp");
            return;
        }

        // Action: Standard Login Submit
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String loginType = request.getParameter("loginType");
        if (loginType == null) {
            loginType = "User";
        }

        if (email == null || email.trim().isEmpty()) {
            session.setAttribute("errorMsg", "Email is required.");
            response.sendRedirect("views/login.jsp");
            return;
        }

        email = email.toLowerCase().trim();

        // Check if already locked out
        int attempts = failedAttemptsMap.getOrDefault(email, 0);
        if (attempts >= 3) {
            session.setAttribute("errorMsg", "Account locked due to 3 failed attempts. Please answer your security question.");
            response.sendRedirect("views/verify-question.jsp?email=" + java.net.URLEncoder.encode(email, "UTF-8"));
            return;
        }

        List<User> userList = userDao.getAllUser();
        User matchedUser = null;

        for (User u : userList) {
            if (u.getEmail().equalsIgnoreCase(email) && u.getPassword().equals(password)) {
                matchedUser = u;
                break;
            }
        }

        if (matchedUser != null) {
            String role = matchedUser.getRole() != null ? matchedUser.getRole().trim() : "Customer";
            
            // Enforce role check against loginType tab choice
            if ("Admin".equalsIgnoreCase(loginType)) {
                if (!"Admin".equalsIgnoreCase(role)) {
                    session.setAttribute("errorMsg", "Access Denied: Customer accounts cannot sign in through the Admin Portal.");
                    response.sendRedirect("views/login.jsp");
                    return;
                }
            } else { // Customer login tab
                if ("Admin".equalsIgnoreCase(role)) {
                    session.setAttribute("errorMsg", "Access Denied: Admin accounts must log in using the Admin Sign In tab.");
                    response.sendRedirect("views/login.jsp");
                    return;
                }
            }

            // Successful login: store user in session and clear failures
            session.setAttribute("user", matchedUser);
            failedAttemptsMap.remove(email);
            if ("Admin".equalsIgnoreCase(role)) {
                response.sendRedirect("AdminServlet");
            } else {
                response.sendRedirect("ResturantServlet");
            }
        } else {
            // Failed login attempt
            attempts = failedAttemptsMap.getOrDefault(email, 0) + 1;
            failedAttemptsMap.put(email, attempts);
            
            if (attempts < 3) {
                session.setAttribute("errorMsg", "Invalid email address or password. " + (3 - attempts) + " attempt(s) remaining.");
                response.sendRedirect("views/login.jsp");
            } else {
                // Max attempts reached: lock account
                session.setAttribute("errorMsg", "Account locked due to 3 failed attempts. Please answer your security question.");
                response.sendRedirect("views/verify-question.jsp?email=" + java.net.URLEncoder.encode(email, "UTF-8"));
            }
        }
    }

}