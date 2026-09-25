package com.instafoo.dao;

import java.util.List;

import com.instafoo.Model.Menu;

public interface MenuDao {
	
	int addMenuItem(Menu m);

	int updateMenuItem(Menu m);

	int deleteMenuItem(int id);

	Menu getMenuItemById(int id);

	List<Menu> getAllMenuItems();

	List<Menu> getMenuByRestaurantId(int restaurantId);

}
