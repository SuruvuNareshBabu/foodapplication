package dao;

import java.util.List;
import model.User;

public interface UserDAO {

    // Register User
    boolean addUser(User user);

    // Login
    User getUserByEmail(String email);

    // Profile
    User getUserById(int userId);

    // Update Profile
    boolean updateUser(User user);

    // Delete User
    boolean deleteUser(int userId);

    // Admin
    List<User> getAllUsers();

    // Validation
    boolean emailExists(String email);
    
    // ─── NEW: PASSPORT RESET METHOD CONTRACTS ───
    boolean saveResetToken(String email, String token);
    
    boolean verifyOtpToken(String email, String token);
    
    boolean updatePassword(String email, String newPassword);
}