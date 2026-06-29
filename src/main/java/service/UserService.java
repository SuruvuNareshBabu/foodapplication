package service;

import dao.UserDAO;
import daoimpl.UserDAOImpl;
import model.User;
import util.PasswordUtil;

public class UserService {

    private UserDAO userDAO;

    public UserService() {
        userDAO = new UserDAOImpl();
    }
    
    public User getUserByEmail(String email) {
        return userDAO.getUserByEmail(email);
    }

    public boolean saveResetToken(String email, String token) {
        return userDAO.saveResetToken(email, token);
    }

    public boolean verifyOtpToken(String email, String token) {
        return userDAO.verifyOtpToken(email, token);
    }

    // CRITICAL SECURITY FIX: Hashes the new password string before updating the data layer
    public boolean updatePassword(String email, String newPassword) {
        if (newPassword == null || newPassword.trim().isEmpty()) {
            return false;
        }
        String encryptedPassword = PasswordUtil.hashPassword(newPassword);
        return userDAO.updatePassword(email, encryptedPassword);
    }
    
    // Register User
    public boolean registerUser(User user) {
        if (userDAO.emailExists(user.getEmail())) {
            return false;
        }

        String encryptedPassword = PasswordUtil.hashPassword(user.getPassword());
        user.setPassword(encryptedPassword);

        String role = user.getRole();
        if (role == null || role.trim().isEmpty()) {
            user.setRole("CUSTOMER");
        } else {
            role = role.trim().toUpperCase();
            switch (role) {
                case "OWNER":
                    user.setRole("OWNER");
                    break;
                case "ADMIN":
                    user.setRole("ADMIN");
                    break;
                default:
                    user.setRole("CUSTOMER");
                    break;
            }
        }

        user.setActive(true);

        if (user.getProfileImage() == null || user.getProfileImage().trim().isEmpty()) {
            user.setProfileImage("images/default.png");
        }

        return userDAO.addUser(user);
    }

    // Login User
    public User loginUser(String email, String password) {
        User user = userDAO.getUserByEmail(email);
        if (user == null) {
            return null;
        }

        boolean status = PasswordUtil.verifyPassword(password, user.getPassword());
        if (status) {
            return user;
        }
        return null;
    }

    // Update Profile
    public boolean updateProfile(User user) {
        // Enforce basic validation fallback constraints
        if (user == null || user.getUserId() <= 0) {
            return false;
        }
        // Delegates execution straight to your UserDAOImpl mapping framework
        return userDAO.updateUser(user);
    }
}