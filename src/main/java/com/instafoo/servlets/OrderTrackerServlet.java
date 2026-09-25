package com.instafoo.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.instafoo.Model.User;
import com.instafoo.connection.DBConnection;

@WebServlet("/OrderTrackerServlet")
public class OrderTrackerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("user");
        if (loggedInUser == null) {
            response.sendRedirect("views/login.jsp");
            return;
        }

        if (loggedInUser.getRole() != null && "Admin".equalsIgnoreCase(loggedInUser.getRole().trim())) {
            response.sendRedirect("AdminServlet");
            return;
        }

        updateOrderStatusesDynamically(loggedInUser.getUser_id());

        String orderIdStr = request.getParameter("orderId");
        Map<String, Object> order = null;
        List<Map<String, Object>> orderItems = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            // 1. Fetch Order details
            if (orderIdStr != null && !orderIdStr.trim().isEmpty()) {
                int orderId = Integer.parseInt(orderIdStr.replace("#", "").trim());
                String query = "SELECT * FROM `order_table` WHERE order_id = ? AND user_id = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(query)) {
                    pstmt.setInt(1, orderId);
                    pstmt.setInt(2, loggedInUser.getUser_id());
                    try (ResultSet rs = pstmt.executeQuery()) {
                        if (rs.next()) {
                            order = mapOrder(rs);
                        }
                    }
                }
            } else {
                // Fetch the most recent order for this user
                String query = "SELECT * FROM `order_table` WHERE user_id = ? ORDER BY order_id DESC LIMIT 1";
                try (PreparedStatement pstmt = conn.prepareStatement(query)) {
                    pstmt.setInt(1, loggedInUser.getUser_id());
                    try (ResultSet rs = pstmt.executeQuery()) {
                        if (rs.next()) {
                            order = mapOrder(rs);
                        }
                    }
                }
            }

            // 2. Fetch Order Items if order exists
            if (order != null) {
                int orderId = (Integer) order.get("order_id");
                String itemsQuery = "SELECT oi.order_item_id, oi.quantity, oi.subtotal, m.item_name, m.image_path, r.name AS restaurant_name "
                                  + "FROM `order_item` oi "
                                  + "JOIN `menu` m ON oi.menu_id = m.menu_id "
                                  + "JOIN `restaurant` r ON m.restaurant_id = r.restaurant_id "
                                  + "WHERE oi.order_id = ?";
                
                try (PreparedStatement pstmt = conn.prepareStatement(itemsQuery)) {
                    pstmt.setInt(1, orderId);
                    try (ResultSet rs = pstmt.executeQuery()) {
                        while (rs.next()) {
                            Map<String, Object> item = new HashMap<>();
                            item.put("order_item_id", rs.getInt("order_item_id"));
                            item.put("quantity", rs.getInt("quantity"));
                            item.put("subtotal", rs.getDouble("subtotal"));
                            item.put("item_name", rs.getString("item_name"));
                            item.put("image_path", rs.getString("image_path"));
                            item.put("restaurant_name", rs.getString("restaurant_name"));
                            orderItems.add(item);
                        }
                    }
                }
            }

            // 3. Fetch all orders placed by this user for the tracking list from order_history
            List<Map<String, Object>> userOrders = new ArrayList<>();
            String allOrdersQuery = "SELECT * FROM `order_history` WHERE user_id = ? ORDER BY order_id DESC";
            try (PreparedStatement pstmt = conn.prepareStatement(allOrdersQuery)) {
                pstmt.setInt(1, loggedInUser.getUser_id());
                try (ResultSet rs = pstmt.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> oMap = new HashMap<>();
                        oMap.put("order_id", rs.getInt("order_id"));
                        oMap.put("restaurant_name", rs.getString("restaurant_name"));
                        oMap.put("total_amount", rs.getDouble("total_amount"));
                        oMap.put("status", rs.getString("status"));
                        
                        try {
                            oMap.put("order_date", rs.getTimestamp("date_placed"));
                        } catch (Exception e) {
                            oMap.put("order_date", new Timestamp(System.currentTimeMillis()));
                        }
                        userOrders.add(oMap);
                    }
                }
            }
            request.setAttribute("userOrders", userOrders);

        } catch (Exception e) {
            e.printStackTrace();
        }

        if (order == null) {
            session.setAttribute("errorMsg", "No orders found to track. Place an order to track it live!");
            response.sendRedirect("ResturantServlet");
            return;
        }

        request.setAttribute("order", order);
        request.setAttribute("orderItems", orderItems);
        request.getRequestDispatcher("views/ordered-items.jsp").forward(request, response);
    }

    private Map<String, Object> mapOrder(ResultSet rs) throws Exception {
        Map<String, Object> map = new HashMap<>();
        map.put("order_id", rs.getInt("order_id"));
        map.put("user_id", rs.getInt("user_id"));
        map.put("restaurant_id", rs.getInt("restaurant_id"));
        map.put("total_amount", rs.getDouble("total_amount"));
        map.put("status", rs.getString("status"));
        map.put("payment_mode", rs.getString("payment_mode"));
        // Try to get order_date if the column exists
        try {
            map.put("order_date", rs.getTimestamp("order_date"));
        } catch (Exception e) {
            map.put("order_date", new Timestamp(System.currentTimeMillis()));
        }
        return map;
    }

    private void updateOrderStatusesDynamically(int userId) {
        try (Connection conn = DBConnection.getConnection()) {
            // Fetch all orders for this user that are not already 'Delivered'
            String selectQuery = "SELECT order_id, order_date FROM `order_table` WHERE user_id = ? AND status <> 'Delivered'";
            List<Integer> orderIdsToUpdate = new ArrayList<>();
            List<String> newStatuses = new ArrayList<>();
            
            long now = System.currentTimeMillis();
            try (PreparedStatement pstmt = conn.prepareStatement(selectQuery)) {
                pstmt.setInt(1, userId);
                try (ResultSet rs = pstmt.executeQuery()) {
                    while (rs.next()) {
                        int orderId = rs.getInt("order_id");
                        Timestamp placedTime = rs.getTimestamp("order_date");
                        if (placedTime != null) {
                            long diffSec = (now - placedTime.getTime()) / 1000;
                            String computedStatus = "Placed";
                            if (diffSec >= 60) {
                                computedStatus = "Delivered";
                            } else if (diffSec >= 40) {
                                computedStatus = "Out for Delivery";
                            } else if (diffSec >= 20) {
                                computedStatus = "Preparing";
                            }
                            
                            orderIdsToUpdate.add(orderId);
                            newStatuses.add(computedStatus);
                        }
                    }
                }
            }
            
            // Apply updates
            for (int i = 0; i < orderIdsToUpdate.size(); i++) {
                int orderId = orderIdsToUpdate.get(i);
                String status = newStatuses.get(i);
                
                String updateOrderTable = "UPDATE `order_table` SET status = ? WHERE order_id = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(updateOrderTable)) {
                    pstmt.setString(1, status);
                    pstmt.setInt(2, orderId);
                    pstmt.executeUpdate();
                }
                
                String updateHistoryTable = "UPDATE `order_history` SET status = ? WHERE order_id = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(updateHistoryTable)) {
                    pstmt.setString(1, status);
                    pstmt.setInt(2, orderId);
                    pstmt.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
