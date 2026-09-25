package com.instafoo.servlets;

import java.io.IOException;

import com.instafoo.Model.Cart;
import com.instafoo.Model.CartItem;
import com.instafoo.Model.Menu;
import com.instafoo.daoImp.MenuDaoImp;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet{
	private static final long serialVersionUID = 1L;

	@Override
	protected void service(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		
		HttpSession session = req.getSession();
		com.instafoo.Model.User user = (com.instafoo.Model.User) session.getAttribute("user");
		if (user != null && user.getRole() != null && "Admin".equalsIgnoreCase(user.getRole().trim())) {
			res.sendRedirect("AdminServlet");
			return;
		}
		
		Cart cart = (Cart) session.getAttribute("cart");
		
		// Safe retrieval of restaurantId from session
		Integer restaurantIdObj = (Integer) session.getAttribute("restaurantId");
		int restaurantId = restaurantIdObj != null ? restaurantIdObj : -1;
		
		// Normalize incoming parameter for restaurantId (handles both camelCase and lowercase)
		String newRestaurantIdStr = req.getParameter("restaurantId");
		if (newRestaurantIdStr == null || newRestaurantIdStr.isEmpty()) {
			newRestaurantIdStr = req.getParameter("restaurantid");
		}
		int newRestaurantId = (newRestaurantIdStr != null && !newRestaurantIdStr.isEmpty()) 
				? Integer.parseInt(newRestaurantIdStr) : restaurantId;
		
		// Initialize cart if it doesn't exist yet
		if(cart == null) {
			cart = new Cart();
			session.setAttribute("cart", cart);
		}
		// Track the last added restaurant ID in session for back-to-menu navigation
		if (newRestaurantId != -1) {
			session.setAttribute("restaurantId", newRestaurantId);
		}
		
		String action = req.getParameter("action");
		if (action != null) {
			if (action.equals("add")) {
				addItemCart(req, cart);
			} else if (action.equals("update")) {
				updateItemCart(req, cart);
			} else if (action.equals("delete")) {
				removeItemCart(req, cart);
			}
		}
		res.sendRedirect("views/cart.jsp");
	}

	private void removeItemCart(HttpServletRequest req, Cart cart) {
		String menuIdStr = req.getParameter("menuId");
		if (menuIdStr != null && !menuIdStr.isEmpty()) {
			int menuId = Integer.parseInt(menuIdStr);
			cart.removeItem(menuId);
		}
	}

	private void updateItemCart(HttpServletRequest req, Cart cart) {
		String menuIdStr = req.getParameter("menuId");
		String quantityStr = req.getParameter("quantity");
		if (menuIdStr != null && !menuIdStr.isEmpty() && quantityStr != null && !quantityStr.isEmpty()) {
			int menuId = Integer.parseInt(menuIdStr);
			int quantity = Integer.parseInt(quantityStr);
			cart.updateItem(menuId, quantity);
		}
	}

	private void addItemCart(HttpServletRequest req, Cart cart) {
		String menuIdStr = req.getParameter("menuId");
		String qtyStr = req.getParameter("quantity");
		
		if (menuIdStr != null && !menuIdStr.isEmpty()) {
			int menuId = Integer.parseInt(menuIdStr);
			int quantity = (qtyStr != null && !qtyStr.isEmpty()) ? Integer.parseInt(qtyStr) : 1;
			
			MenuDaoImp menuDao = new MenuDaoImp();
			Menu menu = menuDao.getMenuItemById(menuId);
			
			if (menu != null) {
				boolean isRestaurantActive = true;
				try {
					com.instafoo.daoImp.RestaurantDaoImp rDao = new com.instafoo.daoImp.RestaurantDaoImp();
					com.instafoo.Model.Restaurant rObj = rDao.getRestaurantById(menu.getRestaurantId());
					if (rObj != null && rObj.getIs_active() != null) {
						isRestaurantActive = rObj.getIs_active();
					}
				} catch (Exception e) {
					e.printStackTrace();
				}

				if (menu.isAvailable() && isRestaurantActive) {
					CartItem cartitem = new CartItem(
						menuId,
						menu.getRestaurantId(),
						menu.getItemName(),
						menu.getPrice(),
						quantity,
						menu.getImagePath()
					);
					cart.addItem(cartitem);
				}
			}
		}
	}
}
