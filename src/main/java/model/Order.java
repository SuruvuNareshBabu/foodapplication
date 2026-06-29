package model;

import java.sql.Timestamp;
import java.util.List;
public class Order {
    private int orderId;
    private int userId;
    private int restaurantId;
    private int addressId; // Matches your address_id column
    private double totalAmount;
    private double deliveryCharge;
    private double tax;
    private double discount;
    private double grandTotal;
    private String orderStatus;
    private String paymentStatus;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private List<OrderItem> orderItems;
    
    private String deliveryAddress;
    public void setDeliveryAddress(String deliveryAddress) {
        this.deliveryAddress = deliveryAddress;
    }
    
    public String getDeliveryAddress() {
        return deliveryAddress;
    }

    public Order() {}

    public Order(int userId, int restaurantId, int addressId, double totalAmount, double deliveryCharge, 
                 double tax, double discount, double grandTotal, String orderStatus, String paymentStatus) {
        this.userId = userId;
        this.restaurantId = restaurantId;
        this.addressId = addressId;
        this.totalAmount = totalAmount;
        this.deliveryCharge = deliveryCharge;
        this.tax = tax;
        this.discount = discount;
        this.grandTotal = grandTotal;
        this.orderStatus = orderStatus;
        this.paymentStatus = paymentStatus;
    }
    
    public List<OrderItem> getOrderItems() {
        return orderItems;
    }
    public void setOrderItems(List<OrderItem> orderItems) {
        this.orderItems = orderItems;
    }

    // Getters and Setters
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getRestaurantId() { return restaurantId; }
    public void setRestaurantId(int restaurantId) { this.restaurantId = restaurantId; }
    public int getAddressId() { return addressId; }
    public void setAddressId(int addressId) { this.addressId = addressId; }
    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
    public double getDeliveryCharge() { return deliveryCharge; }
    public void setDeliveryCharge(double deliveryCharge) { this.deliveryCharge = deliveryCharge; }
    public double getTax() { return tax; }
    public void setTax(double tax) { this.tax = tax; }
    public double getDiscount() { return discount; }
    public void setDiscount(double discount) { this.discount = discount; }
    public double getGrandTotal() { return grandTotal; }
    public void setGrandTotal(double grandTotal) { this.grandTotal = grandTotal; }
    public String getOrderStatus() { return orderStatus; }
    public void setOrderStatus(String orderStatus) { this.orderStatus = orderStatus; }
    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}