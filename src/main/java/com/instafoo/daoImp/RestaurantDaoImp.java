package com.instafoo.daoImp;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.instafoo.Model.Restaurant;
import com.instafoo.connection.DBConnection;
import com.instafoo.dao.RestaurantDao;

public class RestaurantDaoImp implements RestaurantDao {

    @Override
    public int addRestaurant(Restaurant r) {
        String query = "insert into restaurant (name,cuisine_type,delivery_time,address,rating,is_active,image_path) "
                + "values (?,?,?,?,?,?,?);";
        int res = 0;
        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query)
        ) {
            pstmt.setString(1, r.getName());
            pstmt.setString(2, r.getCuisine_type());
            pstmt.setInt(3, r.getDelivery_time());
            pstmt.setString(4, r.getAddress());
            pstmt.setDouble(5, r.getRating());
            pstmt.setBoolean(6, r.getIs_active());
            pstmt.setString(7, r.getImage_path());
            res = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return res;
    }

    @Override
    public int updateRestaurant(Restaurant r) {
        String query = "update restaurant set name=?,cuisine_type=?, delivery_time=?,address=?, rating=?, is_active=?, image_path=? "
                + "where restaurant_id=?; ";
        int res = 0;
        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query)
        ) {
            pstmt.setString(1, r.getName());
            pstmt.setString(2, r.getCuisine_type());
            pstmt.setInt(3, r.getDelivery_time());
            pstmt.setString(4, r.getAddress());
            pstmt.setDouble(5, r.getRating());
            pstmt.setBoolean(6, r.getIs_active());
            pstmt.setString(7, r.getImage_path());
            pstmt.setInt(8, r.getResturant_id());
            res = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return res;
    }

    @Override
    public int deleteRestaurant(int id) {
        String query = "delete from restaurant where restaurant_id=?";
        int res = 0;
        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query)
        ) {
            pstmt.setInt(1, id);
            res = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return res;
    }

    @Override
    public Restaurant getRestaurantById(int id) {
        String query = "select * from restaurant where restaurant_id=?";
        Restaurant r = null;
        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query)
        ) {
            pstmt.setInt(1, id);
            try (ResultSet res = pstmt.executeQuery()) {
                while (res.next()) {
                    r = new Restaurant();
                    r.setResturant_id(res.getInt("restaurant_id"));
                    r.setName(res.getString("name"));
                    r.setCuisine_type(res.getString("cuisine_type"));
                    r.setDelivery_time(res.getInt("delivery_time"));
                    r.setAddress(res.getString("address"));
                    r.setRating(res.getDouble("rating"));
                    r.setIs_active(res.getBoolean("is_active"));
                    r.setImage_path(res.getString("image_path"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return r;
    }

    @Override
    public List<Restaurant> getAllRestaurants() {
        List<Restaurant> list = new ArrayList<>();
        String query = "select * from restaurant ";
        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(query);
            ResultSet res = pstmt.executeQuery()
        ) {
            while (res.next()) {
                Restaurant r = new Restaurant();
                r.setResturant_id(res.getInt("restaurant_id"));
                r.setName(res.getString("name"));
                r.setCuisine_type(res.getString("cuisine_type"));
                r.setDelivery_time(res.getInt("delivery_time"));
                r.setAddress(res.getString("address"));
                r.setRating(res.getDouble("rating"));
                r.setIs_active(res.getBoolean("is_active"));
                r.setImage_path(res.getString("image_path"));
                list.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
