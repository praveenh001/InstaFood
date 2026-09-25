package com.instafoo.servlets;

import java.io.IOException;
import java.util.List;

import com.instafoo.Model.Restaurant;
import com.instafoo.daoImp.RestaurantDaoImp;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
@WebServlet("/ResturantServlet")
public class ResturantServlet extends HttpServlet {
		@Override
		protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
			jakarta.servlet.http.HttpSession session = req.getSession(false);
			if (session != null) {
				com.instafoo.Model.User user = (com.instafoo.Model.User) session.getAttribute("user");
				if (user != null && "Admin".equalsIgnoreCase(user.getRole())) {
					resp.sendRedirect("AdminServlet");
					return;
				}
			}

			RestaurantDaoImp resturant=new RestaurantDaoImp();
			List<Restaurant>allrestaurant=resturant.getAllRestaurants();
			
			req.setAttribute("allrestaurant", allrestaurant);
			RequestDispatcher rd=req.getRequestDispatcher("views/restaurant.jsp");
			rd.forward(req, resp);
			
			
		}
}
