package com.instafoo.servlets;

import java.io.IOException;
import java.util.List;

import com.instafoo.Model.Menu;
import com.instafoo.Model.Restaurant;
import com.instafoo.daoImp.MenuDaoImp;
import com.instafoo.daoImp.RestaurantDaoImp;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/MenuServlet")
public class MenuServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

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

		String restIdStr = req.getParameter("restaurant_id");
		if (restIdStr != null) {
			try {
				int rest_id = Integer.parseInt(restIdStr);
				
				// Fetch restaurant details
				RestaurantDaoImp restaurantDao = new RestaurantDaoImp();
				Restaurant restaurant = restaurantDao.getRestaurantById(rest_id);
				req.setAttribute("restaurant", restaurant);
				
				// Fetch menu items
				MenuDaoImp menu = new MenuDaoImp();
				List<Menu> allMenu = menu.getMenuByRestaurantId(rest_id);
				req.setAttribute("allmenu", allMenu);
				
			} catch (NumberFormatException e) {
				e.printStackTrace();
			}
		} else {
			// Fetch all menu items from all restaurants
			MenuDaoImp menu = new MenuDaoImp();
			List<Menu> allMenu = menu.getAllMenuItems();
			req.setAttribute("allmenu", allMenu);
		}
		
		RequestDispatcher rd = req.getRequestDispatcher("views/menu.jsp");
		rd.forward(req, resp);
	}
}
