package com.instafoo.daoImp;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.instafoo.Model.Menu;
import com.instafoo.connection.DBConnection;
import com.instafoo.dao.MenuDao;

public class MenuDaoImp implements MenuDao{

	@Override
	public int addMenuItem(Menu m) {
		String query = "INSERT INTO menu "
				+ "(restaurant_id,item_name,description,price,is_available,image_path) "
				+ "VALUES(?,?,?,?,?,?)";

		int res = 0;

		try (
				Connection conn = DBConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(query)
		) {

			pstmt.setInt(1, m.getRestaurantId());
			pstmt.setString(2, m.getItemName());
			pstmt.setString(3, m.getDescription());
			pstmt.setDouble(4, m.getPrice());
			pstmt.setBoolean(5, m.isAvailable());
			pstmt.setString(6, m.getImagePath());

			res = pstmt.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return res;
		
	}

	@Override
	public int updateMenuItem(Menu m) {
		String query = "UPDATE menu SET "
				+ "restaurant_id=?, item_name=?, description=?, "
				+ "price=?, is_available=?, image_path=? "
				+ "WHERE menu_id=?";

		int res = 0;

		try (
				Connection conn = DBConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(query)
		) {

			pstmt.setInt(1, m.getRestaurantId());
			pstmt.setString(2, m.getItemName());
			pstmt.setString(3, m.getDescription());
			pstmt.setDouble(4, m.getPrice());
			pstmt.setBoolean(5, m.isAvailable());
			pstmt.setString(6, m.getImagePath());

			// Important
			pstmt.setInt(7, m.getMenuId());

			res = pstmt.executeUpdate();

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return res;
	}

	@Override
	public int deleteMenuItem(int id) {
		String query = "DELETE FROM menu WHERE menu_id=?";

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
	public Menu getMenuItemById(int id) {
		Menu m = null;

		String query = "SELECT * FROM menu WHERE menu_id=?";

		try (
				Connection conn = DBConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(query)
		) {

			pstmt.setInt(1, id);

			ResultSet rs = pstmt.executeQuery();

			if (rs.next()) {

				m = new Menu();

				m.setMenuId(rs.getInt("menu_id"));
				m.setRestaurantId(rs.getInt("restaurant_id"));
				m.setItemName(rs.getString("item_name"));
				m.setDescription(rs.getString("description"));
				m.setPrice(rs.getDouble("price"));
				m.setAvailable(rs.getBoolean("is_available"));
				m.setImagePath(rs.getString("image_path"));
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return m;
	}

	@Override
	public List<Menu> getAllMenuItems() {
		List<Menu> list = new ArrayList<>();

		String query = "SELECT * FROM menu";

		try (
				Connection conn = DBConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(query);
				ResultSet rs = pstmt.executeQuery()
		) {

			while (rs.next()) {

				Menu m = new Menu();

				m.setMenuId(rs.getInt("menu_id"));
				m.setRestaurantId(rs.getInt("restaurant_id"));
				m.setItemName(rs.getString("item_name"));
				m.setDescription(rs.getString("description"));
				m.setPrice(rs.getDouble("price"));
				m.setAvailable(rs.getBoolean("is_available"));
				m.setImagePath(rs.getString("image_path"));

				list.add(m);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return list;
	}

	@Override
	public List<Menu> getMenuByRestaurantId(int restaurantId) {
		List<Menu> list = new ArrayList<>();

		String query = "SELECT * FROM menu WHERE restaurant_id=?";

		try (
				Connection conn = DBConnection.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(query)
		) {

			pstmt.setInt(1, restaurantId);

			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {

				Menu m = new Menu();

				m.setMenuId(rs.getInt("menu_id"));
				m.setRestaurantId(rs.getInt("restaurant_id"));
				m.setItemName(rs.getString("item_name"));
				m.setDescription(rs.getString("description"));
				m.setPrice(rs.getDouble("price"));
				m.setAvailable(rs.getBoolean("is_available"));
				m.setImagePath(rs.getString("image_path"));

				list.add(m);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return list;
	}
	

}
