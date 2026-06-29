package model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Menu implements Serializable {

    private int menuId;
    private int restaurantId;
    private String name;
    private String description;
    private String category;
    private double price;
    private String image;
    private boolean available;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Menu() {
    }

    public Menu(int menuId,
                int restaurantId,
                String name,
                String description,
                String category,
                double price,
                String image,
                boolean available,
                Timestamp createdAt,
                Timestamp updatedAt) {

        this.menuId = menuId;
        this.restaurantId = restaurantId;
        this.name = name;
        this.description = description;
        this.category = category;
        this.price = price;
        this.image = image;
        this.available = available;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;

    }

    public int getMenuId() {
        return menuId;
    }

    public void setMenuId(int menuId) {
        this.menuId = menuId;
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

}
