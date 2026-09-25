package com.instafoo.daoImp;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.instafoo.Model.User;
import com.instafoo.connection.DBConnection;
import com.instafoo.dao.UserDao;

public class UserDaoImp implements UserDao {

    @Override
    public int addUser(User u) {

        String query = "INSERT INTO `user` "
                + "(username,password,email,role,address,logout,security_question,security_answer,security_question_2,security_answer_2) "
                + "VALUES (?,?,?,?,?,?,?,?,?,?)";

        int res = 0;

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(query)
        ) {

            pstmt.setString(1, u.getUsername());
            pstmt.setString(2, u.getPassword());
            pstmt.setString(3, u.getEmail());
            pstmt.setString(4, u.getRole());
            pstmt.setString(5, u.getAddress());
            pstmt.setTimestamp(6, u.getLogout());
            pstmt.setString(7, u.getSecurity_question());
            pstmt.setString(8, u.getSecurity_answer());
            pstmt.setString(9, u.getSecurity_question_2());
            pstmt.setString(10, u.getSecurity_answer_2());

            res = pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return res;
    }

    @Override
    public int updateUser(User u) {

        String update = "UPDATE `user` SET "
                + "username=?, password=?, email=?, role=?, address=?, logout=?, security_question=?, security_answer=?, security_question_2=?, security_answer_2=? "
                + "WHERE user_id=?";

        int res = 0;

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(update)
        ) {

            pstmt.setString(1, u.getUsername());
            pstmt.setString(2, u.getPassword());
            pstmt.setString(3, u.getEmail());
            pstmt.setString(4, u.getRole());
            pstmt.setString(5, u.getAddress());
            pstmt.setTimestamp(6, u.getLogout());
            pstmt.setString(7, u.getSecurity_question());
            pstmt.setString(8, u.getSecurity_answer());
            pstmt.setString(9, u.getSecurity_question_2());
            pstmt.setString(10, u.getSecurity_answer_2());

            // IMPORTANT FIX
            pstmt.setInt(11, u.getUser_id());

            res = pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return res;
    }

    @Override
    public int deleteUser(int id) {

        String query = "DELETE FROM `user` WHERE user_id=?";

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
    public List<User> getAllUser() {

        List<User> list = new ArrayList<>();

        String query = "SELECT * FROM `user`";

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(query);
                ResultSet res = pstmt.executeQuery()
        ) {

            while (res.next()) {

                User u = new User();

                u.setUser_id(res.getInt("user_id"));
                u.setUsername(res.getString("username"));
                u.setPassword(res.getString("password"));
                u.setEmail(res.getString("email"));
                u.setRole(res.getString("role"));
                u.setAddress(res.getString("address"));
                u.setLogout(res.getTimestamp("logout"));
                u.setCreate(res.getTimestamp("create"));
                u.setSecurity_question(res.getString("security_question"));
                u.setSecurity_answer(res.getString("security_answer"));
                u.setSecurity_question_2(res.getString("security_question_2"));
                u.setSecurity_answer_2(res.getString("security_answer_2"));

                list.add(u);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public User getUserByID(int id) {

        String query = "SELECT * FROM `user` WHERE user_id=?";

        User u = null;

        try (
                Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(query)
        ) {

            pstmt.setInt(1, id);

            ResultSet res = pstmt.executeQuery();

            if (res.next()) {

                u = new User();

                u.setUser_id(res.getInt("user_id"));
                u.setUsername(res.getString("username"));
                u.setPassword(res.getString("password"));
                u.setEmail(res.getString("email"));
                u.setRole(res.getString("role"));
                u.setAddress(res.getString("address"));
                u.setLogout(res.getTimestamp("logout"));
                u.setCreate(res.getTimestamp("create"));
                u.setSecurity_question(res.getString("security_question"));
                u.setSecurity_answer(res.getString("security_answer"));
                u.setSecurity_question_2(res.getString("security_question_2"));
                u.setSecurity_answer_2(res.getString("security_answer_2"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return u;
    }
}