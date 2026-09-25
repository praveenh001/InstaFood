package com.instafoo.dao;

import java.util.List;

import com.instafoo.Model.Restaurant;

public interface RestaurantDao {

	
	
	int addRestaurant(Restaurant r);
	int updateRestaurant(Restaurant r);
	int deleteRestaurant(int id);
	Restaurant getRestaurantById(int id);
	List<Restaurant> getAllRestaurants();
}
