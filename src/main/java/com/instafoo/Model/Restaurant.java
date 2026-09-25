package com.instafoo.Model;

public class Restaurant {

	
		private int restaurant_id;
		private String name;
		private String cuisine_type;
		private int delivery_time;
		private String address;
		private double rating;
		private Boolean is_active;
		private String image_path;
		
		public Restaurant(){
			
		}

		public Restaurant(String name, String cuisine_type, int delivery_time, String address, double rating,
				Boolean is_active, String image_path) {
			super();
			this.name = name;
			this.cuisine_type = cuisine_type;
			this.delivery_time = delivery_time;
			this.address = address;
			this.rating = rating;
			this.is_active = is_active;
			this.image_path = image_path;
		}

		public Restaurant(int restaurant_id, String name, String cuisine_type, int delivery_time, String address,
				double rating, Boolean is_active, String image_path) {
			super();
			this.restaurant_id = restaurant_id;
			this.name = name;
			this.cuisine_type = cuisine_type;
			this.delivery_time = delivery_time;
			this.address = address;
			this.rating = rating;
			this.is_active = is_active;
			this.image_path = image_path;
		}

		public int getResturant_id() {
			return restaurant_id;
		}

		public void setResturant_id(int restaurant_id) {
			this.restaurant_id = restaurant_id;
		}

		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}

		public String getCuisine_type() {
			return cuisine_type;
		}

		public void setCuisine_type(String cuisine_type) {
			this.cuisine_type = cuisine_type;
		}

		public int getDelivery_time() {
			return delivery_time;
		}

		public void setDelivery_time(int delivery_time) {
			this.delivery_time = delivery_time;
		}

		public String getAddress() {
			return address;
		}

		public void setAddress(String address) {
			this.address = address;
		}

		public double getRating() {
			return rating;
		}

		public void setRating(double rating) {
			this.rating = rating;
		}

		public Boolean getIs_active() {
			return is_active;
		}

		public void setIs_active(Boolean is_active) {
			this.is_active = is_active;
		}

		public String getImage_path() {
			return image_path;
		}

		public void setImage_path(String image_path) {
			this.image_path = image_path;
		}

		@Override
		public String toString() {
			return "Restaurant [resturant_id=" + restaurant_id + ", name=" + name + ", cuisine_type=" + cuisine_type
					+ ", delivery_time=" + delivery_time + ", address=" + address + ", rating=" + rating
					+ ", is_active=" + is_active + ", image_path=" + image_path + "]";
		}
		
		
		
		
	

}
