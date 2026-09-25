package com.instafoo.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
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

import com.instafoo.Model.Cart;
import com.instafoo.Model.CartItem;
import com.instafoo.Model.User;
import com.instafoo.dao.UserDao;
import com.instafoo.daoImp.UserDaoImp;
import com.instafoo.connection.DBConnection;

@WebServlet("/PlaceOrderServlet")
public class PlaceOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.getItems().isEmpty()) {
            response.sendRedirect("views/cart.jsp");
            return;
        }

        // Get shipping address inputs
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String addressLine1 = request.getParameter("addressLine1");
        String addressLine2 = request.getParameter("addressLine2");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String pincode = request.getParameter("pincode");
        String deliveryNote = request.getParameter("deliveryNote");
        String paymentMode = request.getParameter("paymentMode");

        // Format combined address string
        String combinedAddress = addressLine1;
        if (addressLine2 != null && !addressLine2.trim().isEmpty()) {
            combinedAddress += ", " + addressLine2.trim();
        }
        combinedAddress += ", " + city.trim() + ", " + state.trim() + " - " + pincode.trim();
        if (phone != null && !phone.trim().isEmpty()) {
            combinedAddress += " (Phone: " + phone.trim() + ")";
        }
        if (deliveryNote != null && !deliveryNote.trim().isEmpty()) {
            combinedAddress += " [Instructions: " + deliveryNote.trim() + "]";
        }

        // Update user address in Database
        loggedInUser.setAddress(combinedAddress);
        UserDao userDao = new UserDaoImp();
        userDao.updateUser(loggedInUser);
        session.setAttribute("user", loggedInUser);

        // Group cart items by Restaurant ID
        Map<Integer, List<CartItem>> itemsByRestaurant = new HashMap<>();
        for (CartItem ci : cart.getItems().values()) {
            int restId = ci.getRestaurantId();
            if (!itemsByRestaurant.containsKey(restId)) {
                itemsByRestaurant.put(restId, new ArrayList<>());
            }
            itemsByRestaurant.get(restId).add(ci);
        }

        double overallGrandTotal = 0;
        List<Integer> createdOrderIds = new ArrayList<>();

        // Begin DB Transaction
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            try {
                // Update previous orders of this user to 'Delivered'
                String updateOldOrdersQuery = "UPDATE `order_table` SET status = 'Delivered' WHERE user_id = ? AND status = 'Placed'";
                try (PreparedStatement updatePstmt = conn.prepareStatement(updateOldOrdersQuery)) {
                    updatePstmt.setInt(1, loggedInUser.getUser_id());
                    updatePstmt.executeUpdate();
                }
                String updateOldHistoryQuery = "UPDATE `order_history` SET status = 'Delivered' WHERE user_id = ? AND status = 'Placed'";
                try (PreparedStatement updateHistPstmt = conn.prepareStatement(updateOldHistoryQuery)) {
                    updateHistPstmt.setInt(1, loggedInUser.getUser_id());
                    updateHistPstmt.executeUpdate();
                }

                for (Map.Entry<Integer, List<CartItem>> entry : itemsByRestaurant.entrySet()) {
                    int restaurantId = entry.getKey();
                    List<CartItem> items = entry.getValue();

                    // Calculate subtotal for this restaurant
                    double subtotal = 0;
                    for (CartItem ci : items) {
                        subtotal += ci.getPrice() * ci.getQuantity();
                    }
                    double tax = subtotal * 0.05;
                    double platform = 20.0;
                    double orderTotal = subtotal + tax + platform;
                    overallGrandTotal += orderTotal;

                    // 1. Insert order
                    String insertOrderQuery = "INSERT INTO `order_table` (user_id, restaurant_id, total_amount, status, payment_mode) VALUES (?, ?, ?, ?, ?)";
                    try (PreparedStatement pstmt = conn.prepareStatement(insertOrderQuery, Statement.RETURN_GENERATED_KEYS)) {
                        pstmt.setInt(1, loggedInUser.getUser_id());
                        pstmt.setInt(2, restaurantId);
                        pstmt.setDouble(3, orderTotal);
                        pstmt.setString(4, "Placed");
                        pstmt.setString(5, paymentMode);
                        pstmt.executeUpdate();

                        try (ResultSet rs = pstmt.getGeneratedKeys()) {
                            if (rs.next()) {
                                int orderId = rs.getInt(1);
                                createdOrderIds.add(orderId);

                                // 2. Insert order items
                                String insertItemQuery = "INSERT INTO `order_item` (order_id, menu_id, quantity, subtotal) VALUES (?, ?, ?, ?)";
                                try (PreparedStatement itemPstmt = conn.prepareStatement(insertItemQuery)) {
                                    for (CartItem ci : items) {
                                        itemPstmt.setInt(1, orderId);
                                        itemPstmt.setInt(2, ci.getMenuId());
                                        itemPstmt.setInt(3, ci.getQuantity());
                                        itemPstmt.setDouble(4, ci.getPrice() * ci.getQuantity());
                                        itemPstmt.addBatch();
                                    }
                                    itemPstmt.executeBatch();
                                }

                                // 3. Insert order history record
                                String restName = "Instafoods Order";
                                String getRestNameQuery = "SELECT name FROM `restaurant` WHERE restaurant_id = ?";
                                try (PreparedStatement restPstmt = conn.prepareStatement(getRestNameQuery)) {
                                    restPstmt.setInt(1, restaurantId);
                                    try (ResultSet restRs = restPstmt.executeQuery()) {
                                        if (restRs.next()) {
                                            restName = restRs.getString("name");
                                        }
                                    }
                                }
                                
                                String insertHistoryQuery = "INSERT INTO `order_history` (order_id, user_id, restaurant_id, restaurant_name, status, total_amount, delivery_fee) VALUES (?, ?, ?, ?, ?, ?, ?)";
                                try (PreparedStatement histPstmt = conn.prepareStatement(insertHistoryQuery)) {
                                    histPstmt.setInt(1, orderId);
                                    histPstmt.setInt(2, loggedInUser.getUser_id());
                                    histPstmt.setInt(3, restaurantId);
                                    histPstmt.setString(4, restName);
                                    histPstmt.setString(5, "Placed");
                                    histPstmt.setDouble(6, orderTotal);
                                    histPstmt.setDouble(7, 0.0); // Delivery Fee is Free
                                    histPstmt.executeUpdate();
                                }
                            }
                        }
                    }
                }
                
                // Commit transaction
                conn.commit();

                // Clear cart from session
                session.removeAttribute("cart");
                session.removeAttribute("restaurantId");

                // Store order confirmation info in session
                StringBuilder orderIdsStr = new StringBuilder();
                for (int i = 0; i < createdOrderIds.size(); i++) {
                    if (i > 0) orderIdsStr.append(", ");
                    orderIdsStr.append("#").append(createdOrderIds.get(i));
                }
                session.setAttribute("placedOrderId", orderIdsStr.toString());
                session.setAttribute("placedOrderTotal", overallGrandTotal);

                // Redirect to success confirmation page
                response.sendRedirect("views/order-confirmation.jsp");

            } catch (Exception ex) {
                conn.rollback();
                ex.printStackTrace();
                session.setAttribute("errorMsg", "Failed to place order. Please try again.");
                response.sendRedirect("views/checkout.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Database connection error. Please try again.");
            response.sendRedirect("views/checkout.jsp");
        }
    }
}
