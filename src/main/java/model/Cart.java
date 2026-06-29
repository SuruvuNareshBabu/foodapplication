package model;

import java.sql.Timestamp;

public class Cart {

    private int cartId;
    private int userId;
    private int restaurantId;
    private int menuId;
    public Cart() {
		super();
		// TODO Auto-generated constructor stub
	}
	public Cart(int cartId, int userId, int restaurantId, int menuId, int quantity, double totalPrice,
			Timestamp createdAt, String menuName, String image, String restaurantName) {
		super();
		this.cartId = cartId;
		this.userId = userId;
		this.restaurantId = restaurantId;
		this.menuId = menuId;
		this.quantity = quantity;
		this.totalPrice = totalPrice;
		this.createdAt = createdAt;
		this.menuName = menuName;
		this.image = image;
		this.restaurantName = restaurantName;
	}
	@Override
	public String toString() {
		return "Cart [cartId=" + cartId + ", userId=" + userId + ", restaurantId=" + restaurantId + ", menuId=" + menuId
				+ ", quantity=" + quantity + ", totalPrice=" + totalPrice + ", createdAt=" + createdAt + ", menuName="
				+ menuName + ", image=" + image + ", restaurantName=" + restaurantName + "]";
	}
	public int getCartId() {
		return cartId;
	}
	public void setCartId(int cartId) {
		this.cartId = cartId;
	}
	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	public int getRestaurantId() {
		return restaurantId;
	}
	public void setRestaurantId(int restaurantId) {
		this.restaurantId = restaurantId;
	}
	public int getMenuId() {
		return menuId;
	}
	public void setMenuId(int menuId) {
		this.menuId = menuId;
	}
	public int getQuantity() {
		return quantity;
	}
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	public double getTotalPrice() {
		return totalPrice;
	}
	public void setTotalPrice(double totalPrice) {
		this.totalPrice = totalPrice;
	}
	public Timestamp getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}
	public String getMenuName() {
		return menuName;
	}
	public void setMenuName(String menuName) {
		this.menuName = menuName;
	}
	public String getImage() {
		return image;
	}
	public void setImage(String image) {
		this.image = image;
	}
	public String getRestaurantName() {
		return restaurantName;
	}
	public void setRestaurantName(String restaurantName) {
		this.restaurantName = restaurantName;
	}
	private int quantity;
    private double totalPrice;
    private Timestamp createdAt;

    private String menuName;
    private String image;
    private String restaurantName;

  
 // Add this to your Cart.java file
    public double getPrice() {
        if (this.quantity > 0) {
            return this.totalPrice / this.quantity;
        }
        return 0.0;
    }
    
    
}