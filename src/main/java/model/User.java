package model;

import java.io.Serializable;
import java.sql.Timestamp;

public class User implements Serializable {

    private static final long serialVersionUID = 1L;

    private int userId;
    private String fullName;
    private String email;
    private String password;
    private String phone;
    private String profileImage;
    private String role;
    private boolean active;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // ─── NEW: FIELDS FOR OTP LIFECYCLE TRACKING ───
    private String resetToken;
    private Timestamp tokenExpiry;
    
 // Add this field at the top with your other private variables
    private int restaurantId;

    // Add these methods
    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public User() {
    }

    public User(int userId,
                String fullName,
                String email,
                String password,
                String phone,
                String profileImage,
                String role,
                boolean active,
                Timestamp createdAt,
                Timestamp updatedAt,
                String resetToken,
                Timestamp tokenExpiry) {

        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.profileImage = profileImage;
        this.role = role;
        this.active = active;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.resetToken = resetToken;
        this.tokenExpiry = tokenExpiry;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getProfileImage() {
        return profileImage;
    }

    public void setProfileImage(String profileImage) {
        this.profileImage = profileImage;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
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

    // ─── NEW: GETTERS AND SETTERS FOR OTP MANAGEMENT ───
    public String getResetToken() {
        return resetToken;
    }

    public void setResetToken(String resetToken) {
        this.resetToken = resetToken;
    }

    public Timestamp getTokenExpiry() {
        return tokenExpiry;
    }

    public void setTokenExpiry(Timestamp tokenExpiry) {
        this.tokenExpiry = tokenExpiry;
    }

    @Override
    public String toString() {
        return "User [userId=" + userId +
                ", fullName=" + fullName +
                ", email=" + email +
                ", phone=" + phone +
                ", role=" + role + 
                ", resetToken=" + resetToken + 
                ", tokenExpiry=" + tokenExpiry + "]";
    }
}