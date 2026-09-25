package com.instafoo.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.instafoo.Model.Restaurant;
import com.instafoo.Model.Menu;
import com.instafoo.Model.User;
import com.instafoo.daoImp.RestaurantDaoImp;
import com.instafoo.daoImp.MenuDaoImp;
import com.instafoo.connection.DBConnection;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LandingServlet")
public class LandingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        RestaurantDaoImp restaurantDao = new RestaurantDaoImp();
        List<Restaurant> allrestaurant = restaurantDao.getAllRestaurants();
        req.setAttribute("allrestaurant", allrestaurant);

        MenuDaoImp menuDao = new MenuDaoImp();
        List<Menu> allMenu = menuDao.getAllMenuItems();
        req.setAttribute("allMenu", allMenu);

        // Fetch dynamic details for the "Live Activity" tracker
        HttpSession session = req.getSession();
        User loggedInUser = (User) session.getAttribute("user");

        if (loggedInUser != null && loggedInUser.getRole() != null && "Admin".equalsIgnoreCase(loggedInUser.getRole().trim())) {
            resp.sendRedirect("AdminServlet");
            return;
        }

        boolean hasActiveOrder = false;
        String activeRestName = "Meghana Foods";
        String activeItemName = "Gosht Dum Biryani";
        double activeTotal = 1460.0;
        String activeStatus = "On The Way";

        if (loggedInUser != null) {
            try (Connection conn = DBConnection.getConnection()) {
                // Find latest order
                String orderQuery = "SELECT order_id, restaurant_id, total_amount, status FROM `order_table` WHERE user_id = ? ORDER BY order_id DESC LIMIT 1";
                try (PreparedStatement pstmt = conn.prepareStatement(orderQuery)) {
                    pstmt.setInt(1, loggedInUser.getUser_id());
                    try (ResultSet rs = pstmt.executeQuery()) {
                        if (rs.next()) {
                            hasActiveOrder = true;
                            int orderId = rs.getInt("order_id");
                            int restaurantId = rs.getInt("restaurant_id");
                            activeTotal = rs.getDouble("total_amount");
                            activeStatus = rs.getString("status");

                            // Fetch restaurant name
                            String restQuery = "SELECT name FROM `restaurant` WHERE restaurant_id = ?";
                            try (PreparedStatement pstmtRest = conn.prepareStatement(restQuery)) {
                                pstmtRest.setInt(1, restaurantId);
                                try (ResultSet rsRest = pstmtRest.executeQuery()) {
                                    if (rsRest.next()) {
                                        activeRestName = rsRest.getString("name");
                                    }
                                }
                            }

                            // Fetch first item name from order_item
                            String itemQuery = "SELECT m.item_name FROM `order_item` oi JOIN `menu` m ON oi.menu_id = m.menu_id WHERE oi.order_id = ? LIMIT 1";
                            try (PreparedStatement pstmtItem = conn.prepareStatement(itemQuery)) {
                                pstmtItem.setInt(1, orderId);
                                try (ResultSet rsItem = pstmtItem.executeQuery()) {
                                    if (rsItem.next()) {
                                        activeItemName = rsItem.getString("item_name");
                                    }
                                }
                            }
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // If no active order exists (or user logged out), use first restaurant + menu item as dynamic demo fallback
        if (!hasActiveOrder && allrestaurant != null && !allrestaurant.isEmpty() && allMenu != null && !allMenu.isEmpty()) {
            activeRestName = allrestaurant.get(0).getName();
            // Find first menu item belonging to this restaurant
            int targetRestId = allrestaurant.get(0).getResturant_id();
            for (Menu m : allMenu) {
                if (m.getRestaurantId() == targetRestId) {
                    activeItemName = m.getItemName();
                    activeTotal = m.getPrice();
                    break;
                }
            }
        }

        req.setAttribute("hasActiveOrder", hasActiveOrder);
        req.setAttribute("activeRestName", activeRestName);
        req.setAttribute("activeItemName", activeItemName);
        req.setAttribute("activeTotal", activeTotal);
        req.setAttribute("activeStatus", activeStatus);

        RequestDispatcher rd = req.getRequestDispatcher("views/landing.jsp");
        rd.forward(req, resp);
    }
}