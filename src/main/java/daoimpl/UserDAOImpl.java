package daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import dao.UserDAO;
import model.User;
import util.DBConnection;

public class UserDAOImpl implements UserDAO {

	private Connection connection;

	public UserDAOImpl() {
		connection = DBConnection.getConnection();
	}

	@Override
	public boolean addUser(User user) {
		String role = (user.getRole() == null || user.getRole().trim().isEmpty()) ? "CUSTOMER"
				: user.getRole().toUpperCase();
		String profileImg = (user.getProfileImage() == null || user.getProfileImage().trim().isEmpty())
				? "images/default.png"
				: user.getProfileImage();

		String query = "INSERT INTO users(name, email, password, phone, profile_image, role, is_active, created_at, updated_at) "
				+ "VALUES(?, ?, ?, ?, ?, ?, 1, NOW(), NOW())";

		try (PreparedStatement ps = connection.prepareStatement(query)) {
			ps.setString(1, user.getFullName());
			ps.setString(2, user.getEmail());
			ps.setString(3, user.getPassword());
			ps.setString(4, user.getPhone());
			ps.setString(5, profileImg);
			ps.setString(6, role);

			int result = ps.executeUpdate();
			return result > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	@Override
	public User getUserByEmail(String email) {
		String query = "SELECT * FROM users WHERE email=?";
		try (PreparedStatement ps = connection.prepareStatement(query)) {
			ps.setString(1, email);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return mapResultSetToUser(rs);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public boolean emailExists(String email) {
		return getUserByEmail(email) != null;
	}

	@Override
	public User getUserById(int userId) {
		String query = "SELECT * FROM users WHERE user_id=?";
		try (PreparedStatement ps = connection.prepareStatement(query)) {
			ps.setInt(1, userId);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return mapResultSetToUser(rs);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public boolean updateUser(User user) {
		String query = "UPDATE users SET name=?, email=?, phone=?, profile_image=?, role=?, is_active=?, updated_at=NOW() WHERE user_id=?";
		try (PreparedStatement ps = connection.prepareStatement(query)) {
			ps.setString(1, user.getFullName());
			ps.setString(2, user.getEmail());
			ps.setString(3, user.getPhone());
			ps.setString(4, user.getProfileImage());
			ps.setString(5, user.getRole().toUpperCase());
			ps.setInt(6, user.isActive() ? 1 : 0);
			ps.setInt(7, user.getUserId());

			int result = ps.executeUpdate();
			return result > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	@Override
	public boolean deleteUser(int userId) {
		String query = "DELETE FROM users WHERE user_id=?";
		try (PreparedStatement ps = connection.prepareStatement(query)) {
			ps.setInt(1, userId);
			int result = ps.executeUpdate();
			return result > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	@Override
	public List<User> getAllUsers() {
		List<User> userList = new ArrayList<>();
		String query = "SELECT * FROM users";
		try (PreparedStatement ps = connection.prepareStatement(query); ResultSet rs = ps.executeQuery()) {
			while (rs.next()) {
				userList.add(mapResultSetToUser(rs));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return userList;
	}

	// ─── NEW: OTP PASSPORT LIFE-CYCLE TRACKING IMPLEMENTATIONS ───

	@Override
	public boolean saveResetToken(String email, String token) {
		// Safe 15-minute token lifecycle restriction on your custom users table
		// topology
		String query = "UPDATE users SET reset_token = ?, token_expiry = DATE_ADD(NOW(), INTERVAL 15 MINUTE) WHERE email = ?";
		try (PreparedStatement ps = connection.prepareStatement(query)) {
			ps.setString(1, token);
			ps.setString(2, email);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	@Override
	public boolean verifyOtpToken(String email, String token) {
		// Enforces explicit verification: matching OTP code AND token has not expired
		// yet
		String query = "SELECT 1 FROM users WHERE email = ? AND reset_token = ? AND token_expiry > NOW()";
		try (PreparedStatement ps = connection.prepareStatement(query)) {
			ps.setString(1, email);
			ps.setString(2, token);
			try (ResultSet rs = ps.executeQuery()) {
				return rs.next(); // Returns true if validation window conditions pass perfectly
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	@Override
	public boolean updatePassword(String email, String newPassword) {
		// Overwrites credentials, updates timestamp, and wipes tracking context
		// variables safely
		String query = "UPDATE users SET password = ?, reset_token = NULL, token_expiry = NULL, updated_at = NOW() WHERE email = ?";
		try (PreparedStatement ps = connection.prepareStatement(query)) {
			ps.setString(1, newPassword);
			ps.setString(2, email);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	// Private helper method to eliminate duplicate row-mapping logic
	private User mapResultSetToUser(ResultSet rs) throws SQLException {
		User user = new User();
		user.setUserId(rs.getInt("user_id"));
		user.setFullName(rs.getString("name"));
		user.setEmail(rs.getString("email"));
		user.setPassword(rs.getString("password"));
		user.setPhone(rs.getString("phone"));
		user.setProfileImage(rs.getString("profile_image"));
		user.setRole(rs.getString("role"));
		user.setActive(rs.getInt("is_active") == 1);
		user.setCreatedAt(rs.getTimestamp("created_at"));
		user.setUpdatedAt(rs.getTimestamp("updated_at"));
		// Inside your UserDAO's login or getUser method
		user.setRestaurantId(rs.getInt("restaurant_id"));
		return user;
	}
}