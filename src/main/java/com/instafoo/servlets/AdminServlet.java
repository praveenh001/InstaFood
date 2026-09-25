package com.instafoo.servlets;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.instafoo.connection.DBConnection;

import com.instafoo.Model.Restaurant;
import com.instafoo.Model.Menu;
import com.instafoo.Model.User;
import com.instafoo.dao.RestaurantDao;
import com.instafoo.daoImp.RestaurantDaoImp;
import com.instafoo.dao.MenuDao;
import com.instafoo.daoImp.MenuDaoImp;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("user");
        
        // Security gate: Admin-only access
        if (loggedInUser == null || !"Admin".equalsIgnoreCase(loggedInUser.getRole())) {
            session.setAttribute("errorMsg", "Access Denied. Administrator privilege required.");
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        RestaurantDao restaurantDao = new RestaurantDaoImp();
        MenuDao menuDao = new MenuDaoImp();

        List<Restaurant> restaurantList = restaurantDao.getAllRestaurants();
        List<Menu> menuList = menuDao.getAllMenuItems();

        // Fetch all orders with User and Restaurant details
        java.util.List<java.util.Map<String, Object>> orderList = new java.util.ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT o.order_id, o.user_id, o.restaurant_id, o.total_amount, o.status, o.payment_mode, o.order_date, " +
                         "u.username, u.email, r.name as restaurant_name " +
                         "FROM `order_table` o " +
                         "JOIN `user` u ON o.user_id = u.user_id " +
                         "JOIN `restaurant` r ON o.restaurant_id = r.restaurant_id " +
                         "ORDER BY o.order_id DESC";
            try (PreparedStatement pstmt = conn.prepareStatement(sql);
                 ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    java.util.Map<String, Object> order = new java.util.HashMap<>();
                    order.put("orderId", rs.getInt("order_id"));
                    order.put("userId", rs.getInt("user_id"));
                    order.put("restaurantId", rs.getInt("restaurant_id"));
                    order.put("totalAmount", rs.getDouble("total_amount"));
                    order.put("status", rs.getString("status"));
                    order.put("paymentMode", rs.getString("payment_mode"));
                    order.put("orderDate", rs.getTimestamp("order_date"));
                    order.put("username", rs.getString("username"));
                    order.put("email", rs.getString("email"));
                    order.put("phone", ""); // u.phone does not exist in user schema
                    order.put("restaurantName", rs.getString("restaurant_name"));
                    orderList.add(order);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Fetch all order items and group them by orderId
        java.util.Map<Integer, java.util.List<java.util.Map<String, Object>>> orderItemsMap = new java.util.HashMap<>();
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT oi.order_id, oi.menu_id, oi.quantity, oi.subtotal, m.item_name " +
                         "FROM `order_item` oi " +
                         "JOIN `menu` m ON oi.menu_id = m.menu_id";
            try (PreparedStatement pstmt = conn.prepareStatement(sql);
                 ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    int orderId = rs.getInt("order_id");
                    java.util.Map<String, Object> item = new java.util.HashMap<>();
                    item.put("menuId", rs.getInt("menu_id"));
                    item.put("quantity", rs.getInt("quantity"));
                    item.put("subtotal", rs.getDouble("subtotal"));
                    item.put("itemName", rs.getString("item_name"));
                    
                    if (!orderItemsMap.containsKey(orderId)) {
                        orderItemsMap.put(orderId, new java.util.ArrayList<>());
                    }
                    orderItemsMap.get(orderId).add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("restaurantList", restaurantList);
        request.setAttribute("menuList", menuList);
        request.setAttribute("orderList", orderList);
        request.setAttribute("orderItemsMap", orderItemsMap);
        request.getRequestDispatcher("views/admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("user");

        // Security gate: Admin-only access
        if (loggedInUser == null || !"Admin".equalsIgnoreCase(loggedInUser.getRole())) {
            session.setAttribute("errorMsg", "Access Denied. Administrator privilege required.");
            response.sendRedirect(request.getContextPath() + "/views/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        RestaurantDao restaurantDao = new RestaurantDaoImp();
        MenuDao menuDao = new MenuDaoImp();

        try {
            if ("addRestaurant".equals(action)) {
                String name = request.getParameter("name");
                String cuisineType = request.getParameter("cuisineType");
                int deliveryTime = Integer.parseInt(request.getParameter("deliveryTime"));
                String address = request.getParameter("address");
                double rating = Double.parseDouble(request.getParameter("rating"));
                boolean isActive = "true".equals(request.getParameter("isActive"));
                String imagePath = request.getParameter("imagePath");

                Restaurant r = new Restaurant(name, cuisineType, deliveryTime, address, rating, isActive, imagePath);
                int status = restaurantDao.addRestaurant(r);
                if (status > 0) {
                    session.setAttribute("successMsg", "Restaurant added successfully!");
                } else {
                    session.setAttribute("errorMsg", "Failed to add restaurant.");
                }

            } else if ("deleteRestaurant".equals(action)) {
                int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
                int status = restaurantDao.deleteRestaurant(restaurantId);
                if (status > 0) {
                    session.setAttribute("successMsg", "Restaurant and its associated menu items deleted successfully!");
                } else {
                    session.setAttribute("errorMsg", "Failed to delete restaurant.");
                }

            } else if ("toggleRestaurant".equals(action)) {
                int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
                boolean currentStatus = "true".equals(request.getParameter("currentStatus"));
                
                Restaurant r = restaurantDao.getRestaurantById(restaurantId);
                if (r != null) {
                    r.setIs_active(!currentStatus);
                    restaurantDao.updateRestaurant(r);
                    session.setAttribute("successMsg", "Restaurant status updated successfully!");
                }

            } else if ("addMenuItem".equals(action)) {
                int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
                String itemName = request.getParameter("itemName");
                String description = request.getParameter("description");
                double price = Double.parseDouble(request.getParameter("price"));
                boolean isAvailable = "true".equals(request.getParameter("isAvailable"));
                String imagePath = request.getParameter("imagePath");

                Menu m = new Menu(restaurantId, itemName, description, price, isAvailable, imagePath);
                int status = menuDao.addMenuItem(m);
                if (status > 0) {
                    session.setAttribute("successMsg", "Menu item added successfully!");
                } else {
                    session.setAttribute("errorMsg", "Failed to add menu item.");
                }

            } else if ("editMenuItem".equals(action)) {
                int menuId = Integer.parseInt(request.getParameter("menuId"));
                String itemName = request.getParameter("itemName");
                String description = request.getParameter("description");
                double price = Double.parseDouble(request.getParameter("price"));
                boolean isAvailable = "true".equals(request.getParameter("isAvailable"));
                String imagePath = request.getParameter("imagePath");

                Menu m = menuDao.getMenuItemById(menuId);
                if (m != null) {
                    m.setItemName(itemName);
                    m.setDescription(description);
                    m.setPrice(price);
                    m.setAvailable(isAvailable);
                    m.setImagePath(imagePath);

                    int status = menuDao.updateMenuItem(m);
                    if (status > 0) {
                        session.setAttribute("successMsg", "Menu item updated successfully!");
                    } else {
                        session.setAttribute("errorMsg", "Failed to update menu item.");
                    }
                }

            } else if ("deleteMenuItem".equals(action)) {
                int menuId = Integer.parseInt(request.getParameter("menuId"));
                int status = menuDao.deleteMenuItem(menuId);
                if (status > 0) {
                    session.setAttribute("successMsg", "Menu item deleted successfully!");
                } else {
                    session.setAttribute("errorMsg", "Failed to delete menu item.");
                }

            } else if ("toggleMenuItem".equals(action)) {
                int menuId = Integer.parseInt(request.getParameter("menuId"));
                boolean currentStatus = "true".equals(request.getParameter("currentStatus"));

                Menu m = menuDao.getMenuItemById(menuId);
                if (m != null) {
                    m.setAvailable(!currentStatus);
                    menuDao.updateMenuItem(m);
                    session.setAttribute("successMsg", "Item availability updated successfully!");
                }
            } else if ("updateOrderStatus".equals(action)) {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String newStatus = request.getParameter("status");
                
                try (Connection conn = DBConnection.getConnection()) {
                    String updateOrder = "UPDATE `order_table` SET status = ? WHERE order_id = ?";
                    try (PreparedStatement pstmt = conn.prepareStatement(updateOrder)) {
                        pstmt.setString(1, newStatus);
                        pstmt.setInt(2, orderId);
                        pstmt.executeUpdate();
                    }
                    String updateHistory = "UPDATE `order_history` SET status = ? WHERE order_id = ?";
                    try (PreparedStatement pstmt = conn.prepareStatement(updateHistory)) {
                        pstmt.setString(1, newStatus);
                        pstmt.setInt(2, orderId);
                        pstmt.executeUpdate();
                    }
                    session.setAttribute("successMsg", "Order #" + orderId + " status updated to " + newStatus + " successfully!");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Error processing request: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/AdminServlet");
    }
}
