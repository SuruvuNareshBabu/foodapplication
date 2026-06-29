<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Choose New Password | FoodExpress</title>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
  body { background: #fafafa; display: flex; align-items: center; justify-content: center; min-height: 100vh; }
  .reset-card { background: white; padding: 40px; border-radius: 12px; border: 1px solid #e8e8e8; max-width: 400px; width: 100%; box-shadow: 0 4px 12px rgba(0,0,0,0.03); }
  h2 { margin-bottom: 16px; color: #1c1c1c; }
  .form-group { margin-bottom: 20px; text-align: left; }
  label { display: block; font-size: 13px; font-weight: 600; margin-bottom: 6px; color: #4f4f4f; }
  input[type="password"] { width: 100%; padding: 12px; border: 1px solid #c8c8c8; border-radius: 8px; font-size: 15px; outline: none; }
  input[type="password"]:focus { border-color: #cb202d; }
  .change-btn { width: 100%; background: #cb202d; color: white; border: none; padding: 14px; border-radius: 8px; font-size: 15px; font-weight: 700; cursor: pointer; }
</style>
</head>
<body>

<div class="reset-card">
  <h2>Reset Password</h2>
  <form action="user?action=confirmNewPassword" method="post">
    <input type="hidden" name="email" value="<%= request.getParameter("email") != null ? request.getParameter("email") : request.getAttribute("email") %>">
    
    <div class="form-group">
      <label for="newPass">New Password</label>
      <input type="password" id="newPass" name="newPassword" placeholder="Minimum 6 characters" required minlength="6">
    </div>
    
    <button type="submit" class="change-btn">Update Password</button>
  </form>
</div>

</body>
</html>