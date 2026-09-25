package com.instafoo.dao;

import java.util.List;

import com.instafoo.Model.User;

public interface UserDao {

    int addUser(User u);

    int updateUser(User u);

    int deleteUser(int id);

    List<User> getAllUser();

    User getUserByID(int id);
}