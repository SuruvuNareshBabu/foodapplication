<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Reset Password | FoodExpress</title>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
  body { background: #fafafa; display: flex; align-items: center; justify-content: center; min-height: 100vh; padding: 20px; }
  .forgot-card { background: #fff; border: 1px solid #e8e8e8; padding: 40px; border-radius: 12px; max-width: 420px; width: 100%; box-shadow: 0 4px 12px rgba(0,0,0,0.03); }
  h2 { font-size: 24px; font-weight: 700; margin-bottom: 8px; color: #1c1c1c; }
  p { font-size: 14px; color: #696969; margin-bottom: 24px; line-height: 1.4; }
  .form-group { margin-bottom: 20px; }
  label { display: block; font-size: 13px; font-weight: 600; margin-bottom: 6px; color: #4f4f4f; }
  input[type="email"] { width: 100%; padding: 12px; border: 1px solid #c8c8c8; border-radius: 8px; font-size: 15px; outline: none; }
  input[type="email"]:focus { border-color: #cb202d; }
  .submit-btn { width: 100%; background: #cb202d; color: white; border: none; padding: 14px; border-radius: 8px; font-size: 15px; font-weight: 700; cursor: pointer; margin-bottom: 16px; }
  .back-to-login { display: block; text-align: center; color: #cb202d; text-decoration: none; font-size: 14px; font-weight: 600; }
</style>
</head>
<body>

<div class="forgot-card">
  <h2>Forgot Password?</h2>
  <p>Enter your registered email address below, and we will verify your account to initiate a secure credential reset sequence.</p>
  
  <form action="user?action=sendResetLink" method="post">
    <div class="form-group">
      <label for="emailInput">Email Address</label>
      <input type="email" id="emailInput" name="email" placeholder="Enter your email" required>
    </div>
    <button type="submit" class="submit-btn">Send Recovery Instructions</button>
    <a href="login.jsp" class="back-to-login">Back to Login</a>
  </form>
</div>

</body>
</html>