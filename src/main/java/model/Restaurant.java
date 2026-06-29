package model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Restaurant implements Serializable {

    private int restaurantId;

    private int ownerId;

    private String name;

    private String image;

    private String description;

    private String address;

    private String city;

    private String phone;

    private double rating;

    private int deliveryTime;

    private boolean active;

    private boolean approved;

    private Timestamp createdAt;

    public Restaurant() {

    }

    public Restaurant(int restaurantId,
                      int ownerId,
                      String name,
                      String image,
                      String description,
                      String address,
                      String city,
                      String phone,
                      double rating,
                      int deliveryTime,
                      boolean active,
                      boolean approved,
                      Timestamp createdAt) {

        this.restaurantId = restaurantId;
        this.ownerId = ownerId;
        this.name = name;
        this.image = image;
        this.description = description;
        this.address = address;
        this.city = city;
        this.phone = phone;
        this.rating = rating;
        this.deliveryTime = deliveryTime;
        this.active = active;
        this.approved = approved;
        this.createdAt = createdAt;

    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public int getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(int ownerId) {
        this.ownerId = ownerId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public int getDeliveryTime() {
        return deliveryTime;
    }

    public void setDeliveryTime(int deliveryTime) {
        this.deliveryTime = deliveryTime;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public boolean isApproved() {
        return approved;
    }

    public void setApproved(boolean approved) {
        this.approved = approved;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

}