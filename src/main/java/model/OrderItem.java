package model;

public class OrderItem {
    private int orderItemId;
    private int orderId;
    private int menuId;
    private String menuName;
    private int quantity;
    private double itemPrice;
    private double totalPrice;

    // Default Constructor
    public OrderItem() {}

    // Parameterized Constructor
    public OrderItem(int orderId, int menuId, String menuName, int quantity, double itemPrice, double totalPrice) {
        this.orderId = orderId;
        this.menuId = menuId;
        this.menuName = menuName;
        this.quantity = quantity;
        this.itemPrice = itemPrice;
        this.totalPrice = totalPrice;
    }

    // Getters and Setters
    public int getOrderItemId() { return orderItemId; }
    public void setOrderItemId(int orderItemId) { this.orderItemId = orderItemId; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getMenuId() { return menuId; }
    public void setMenuId(int menuId) { this.menuId = menuId; }

    public String getMenuName() { return menuName; }
    public void setMenuName(String menuName) { this.menuName = menuName; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getItemPrice() { return itemPrice; }
    public void setItemPrice(double itemPrice) { this.itemPrice = itemPrice; }

    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }
}