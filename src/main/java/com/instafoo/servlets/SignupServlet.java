package com.instafoo.servlets;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.instafoo.Model.User;
import com.instafoo.dao.UserDao;
import com.instafoo.daoImp.UserDaoImp;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String firstName = request.getParameter("firstname");
        String lastName = request.getParameter("lastname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String securityQuestion = request.getParameter("securityQuestion");
        String securityAnswer = request.getParameter("securityAnswer");
        String securityQuestion2 = request.getParameter("securityQuestion2");
        String securityAnswer2 = request.getParameter("securityAnswer2");

        String username = firstName + " " + lastName;
        HttpSession session = request.getSession();
        UserDao userDao = new UserDaoImp();

        // 1. Check if email already exists
        List<User> userList = userDao.getAllUser();
        boolean exists = false;
        for (User u : userList) {
            if (u.getEmail().equalsIgnoreCase(email)) {
                exists = true;
                break;
            }
        }

        if (exists) {
            session.setAttribute("errorMsg", "An account with this email address already exists.");
            response.sendRedirect("views/signup.jsp");
            return;
        }

        // 2. Add new user
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setEmail(email);
        newUser.setPassword(password);
        newUser.setRole("Customer");
        newUser.setAddress(""); // Initial default empty address
        newUser.setLogout(new Timestamp(System.currentTimeMillis()));
        newUser.setSecurity_question(securityQuestion);
        newUser.setSecurity_answer(securityAnswer);
        newUser.setSecurity_question_2(securityQuestion2);
        newUser.setSecurity_answer_2(securityAnswer2);

        int status = userDao.addUser(newUser);

        if (status > 0) {
            session.setAttribute("successMsg", "Registration successful! You can now log in.");
            response.sendRedirect("views/login.jsp");
        } else {
            session.setAttribute("errorMsg", "Registration failed due to a database issue. Please try again.");
            response.sendRedirect("views/signup.jsp");
        }
    }
}