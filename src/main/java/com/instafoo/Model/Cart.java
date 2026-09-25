package com.instafoo.Model;

import java.util.HashMap;
import java.util.Map;

public class Cart {
	
	private Map<Integer, CartItem> items;

	public Cart() {
		items = new HashMap<Integer, CartItem>();
	}

	public Map<Integer, CartItem> getItems() {
		return items;
	}

	public void setItems(Map<Integer, CartItem> items) {
		this.items = items;
	}

	public void addItem(CartItem cartitem) {
		int menuId = cartitem.getMenuId();
		
		if (items.containsKey(menuId)) {
			CartItem existingItem = items.get(menuId);
			existingItem.setQuantity(existingItem.getQuantity() + cartitem.getQuantity());
		} else {
			items.put(menuId, cartitem);
		}
	}

	public void updateItem(int menuId, int quantity) {
		if (items.containsKey(menuId)) {
			if (quantity <= 0) {
				items.remove(menuId);
			} else {
				items.get(menuId).setQuantity(quantity);
			}
		}
	}

	public void removeItem(int menuId) {
		items.remove(menuId);
	}

	public void clear() {
		items.clear();
	}

}
