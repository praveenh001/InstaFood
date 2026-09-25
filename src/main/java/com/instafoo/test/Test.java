package com.instafoo.test;

import java.sql.Timestamp;
import java.sql.Connection;
import java.util.List;
import java.util.Scanner;

import com.instafoo.Model.Menu;
import com.instafoo.Model.Restaurant;
import com.instafoo.Model.User;
import com.instafoo.connection.DBConnection;
import com.instafoo.dao.MenuDao;
import com.instafoo.dao.RestaurantDao;
import com.instafoo.daoImp.MenuDaoImp;
import com.instafoo.daoImp.RestaurantDaoImp;
import com.instafoo.daoImp.UserDaoImp;

public class Test {
		
	
	public static void main(String[] args) {
		Connection conn=DBConnection.getConnection();
//		if(conn!=null) {
//			System.out.println("database Connected");
//		}else {
//			System.out.println("database Connected");
//		}
		
		///		
		Scanner sc=new Scanner(System.in);
//		
//		User u=new User();
//		System.out.println("enter the username");
//		
//		u.setUsername(sc.next());
//		
//		System.out.println("enter the password");
//		
//		u.setPassword(sc.next());
//		System.out.println("enter the email");
//		u.setEmail(sc.next());
//		System.out.println("enter the role");
//		u.setRole(sc.next());
//		System.out.println("enter the Address");
//		u.setAddress(sc.next());
//		
//		
//		u.setLogout(new Timestamp(System.currentTimeMillis()));
//		
//		UserDaoImp udao=new UserDaoImp();
//		int res=udao.addUser(u);
//		
//		if(res>0) {
//			System.out.println("User added successfully");
//		}else {
//			System.out.println("not added");
//		}
//	
////		
//		
		
//		UserDaoImp udao = new UserDaoImp();
//
//		List<User> userList = udao.getAllUser();
//
//		
//		for(User u : userList) {
//
//			System.out.println("ID : " + u.getUser_id());
//			System.out.println("Username : " + u.getUsername());
//			System.out.println("Password : " + u.getPassword());
//			System.out.println("Email : " + u.getEmail());
//			System.out.println("Role : " + u.getRole());
//			System.out.println("Address : " + u.getAddress());
//			System.out.println("Logout : " + u.getLogout());
//
//			System.out.println("----------------------");
//		}
//		
//		
//		
		
//		Updating
//		Restaurant r=new Restaurant();
//		System.out.println("Enter the user_id");
//		r.setResturant_id(sc.nextInt());
//		System.out.println("Enter the userName");
//		r.setName(sc.next());
//		System.out.println("Enter the cuisine_type");
//		r.setCuisine_type(sc.next());
//		System.out.println("Enter the delivery_time");
//		r.setDelivery_time(sc.nextInt());
//		sc.nextLine();
//		System.out.println("Enter the address");
//		r.setAddress(sc.nextLine());
//		System.out.println("Enter the rating");
//		r.setRating(sc.nextDouble());
//		System.out.println("Enter the is_active");
//		r.setIs_active(sc.nextBoolean());
//		System.out.println("Enter the image path");
//		r.setImage_path(sc.next());
//		
//		RestaurantDao res=new RestaurantDaoImp();
//		int res1=res.updateRestaurant(r);
//		if(res1>0) {
//			System.out.println("Restaurant Updated successfully");
//		}else {
//			System.out.println("Restaurant not added");
//		}
		
//		Adding
//		Restaurant r=new Restaurant();
//		r.setResturant_id(1);
//		System.out.println("Enter the userName");
//		r.setName(sc.next());
//		System.out.println("Enter the cuisine_type");
//		r.setCuisine_type(sc.next());
//		System.out.println("Enter the delivery_time");
//		r.setDelivery_time(sc.nextInt());
//		sc.nextLine();
//		System.out.println("Enter the address");
//		r.setAddress(sc.nextLine());
//		System.out.println("Enter the rating");
//		r.setRating(sc.nextDouble());
//		System.out.println("Enter the is_active");
//		r.setIs_active(sc.nextBoolean());
//		System.out.println("Enter the image path");
//		r.setImage_path(sc.next());
//		
//		RestaurantDao res=new RestaurantDaoImp();
//		int res1=res.addRestaurant(r);
//		if(res1>0) {
//			System.out.println("Restaurant Updated successfully");
//		}else {
//			System.out.println("Restaurant not added");
//		}
////		
		
		
		
//		delete
//		System.out.println("enter the id");
//		
//		 int id=sc.nextInt();
//		
//		RestaurantDao res=new RestaurantDaoImp();
//		int res1=res.deleteRestaurant(id);
//		if(res1>0) {
//			System.out.println("Restaurant Updated successfully");
//		}else {
//			System.out.println("Restaurant not added");
//	}
//		
		
		
//		getRestaurantById
//		RestaurantDao dao = new RestaurantDaoImp();
//
//		Restaurant restaurant = dao.getRestaurantById(sc.nextInt());
//
//		if (restaurant != null) {
//			System.out.println(restaurant);
//		}
//		else {
//			System.out.println("Restaurant Not Found");
//		}
		
		
		
//		getAllRestaurants
		
		
//		RestaurantDao dao = new RestaurantDaoImp();
//
//		List<Restaurant> restaurants = dao.getAllRestaurants();
//
//		if (!restaurants.isEmpty()) {
//
//			for (Restaurant restaurant : restaurants) {
//				System.out.println(restaurant);
//			}
//
//		}
//		else {
//			System.out.println("No Restaurants Found");
//		}
		
		
//		System.out.println("Enter Restaurant ID:");
//		int restaurantId = sc.nextInt();
//		sc.nextLine();
//
//		System.out.println("Enter Item Name:");
//		String itemName = sc.nextLine();
//
//		System.out.println("Enter Description:");
//		String description = sc.nextLine();
//
//		System.out.println("Enter Price:");
//		double price = sc.nextDouble();
//
//		System.out.println("Is Available (true/false):");
//		boolean isAvailable = sc.nextBoolean();
//		sc.nextLine();
//
//		System.out.println("Enter Image Path:");
//		String imagePath = sc.nextLine();
//
//		Menu m = new Menu(
//				restaurantId,
//				itemName,
//				description,
//				price,
//				isAvailable,
//				imagePath);
//
//		MenuDao dao = new MenuDaoImp();
//
//		int result = dao.addMenuItem(m);
//
//		if(result > 0) {
//			System.out.println("Menu Added Successfully");
//		}
//		else {
//			System.out.println("Insertion Failed");
//		}
//			
		
//		System.out.println("Enter Menu ID:");
//		int menuId = sc.nextInt();
//
//		System.out.println("Enter Restaurant ID:");
//		int restaurantId = sc.nextInt();
//		sc.nextLine();
//
//		System.out.println("Enter Item Name:");
//		String itemName = sc.nextLine();
//
//		System.out.println("Enter Description:");
//		String description = sc.nextLine();
//
//		System.out.println("Enter Price:");
//		double price = sc.nextDouble();
//
//		System.out.println("Is Available (true/false):");
//		boolean isAvailable = sc.nextBoolean();
//		sc.nextLine();
//
//		System.out.println("Enter Image Path:");
//		String imagePath = sc.nextLine();
//
//		Menu m = new Menu();
//
//		m.setMenuId(menuId);
//		m.setRestaurantId(restaurantId);
//		m.setItemName(itemName);
//		m.setDescription(description);
//		m.setPrice(price);
//		m.setAvailable(isAvailable);
//		m.setImagePath(imagePath);
//
//		MenuDao dao = new MenuDaoImp();
//
//		int result = dao.updateMenuItem(m);
//
//		if(result > 0) {
//			System.out.println("Menu Updated Successfully");
//		}
//		else {
//			System.out.println("Update Failed");
//		}
		
		
		System.out.println("Enter Menu ID to Delete:");
		int menuId = sc.nextInt();

		MenuDao dao = new MenuDaoImp();

		int result = dao.deleteMenuItem(menuId);

		if(result > 0) {
			System.out.println("Menu Deleted Successfully");
		}
		else {
			System.out.println("Delete Failed");
		}

		
	}
}
