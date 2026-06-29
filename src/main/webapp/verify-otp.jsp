<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Verify OTP | FoodExpress</title>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
  body { background: #fafafa; display: flex; align-items: center; justify-content: center; min-height: 100vh; }
  .otp-card { background: white; padding: 40px; border-radius: 12px; border: 1px solid #e8e8e8; max-width: 400px; width: 100%; text-align: center; box-shadow: 0 4px 12px rgba(0,0,0,0.03); }
  h2 { margin-bottom: 8px; color: #1c1c1c; }
  p { font-size: 14px; color: #696969; margin-bottom: 24px; line-height: 1.4; }
  input[type="text"] { width: 100%; padding: 12px; font-size: 18px; letter-spacing: 8px; text-align: center; border: 1px solid #c8c8c8; border-radius: 8px; margin-bottom: 20px; outline: none; }
  input[type="text"]:focus { border-color: #cb202d; }
  .verify-btn { width: 100%; background: #cb202d; color: white; border: none; padding: 14px; border-radius: 8px; font-size: 15px; font-weight: 700; cursor: pointer; }
  .error-msg { color: #cb202d; font-size: 14px; margin-bottom: 15px; font-weight: 600; }
</style>
</head>
<body>

<div class="otp-card">
  <h2>Enter OTP</h2>
  <p>We have sent a 6-digit verification code to your email inbox. Please type it below to proceed.</p>
  
  <% if (request.getAttribute("error") != null) { %>
    <div class="error-msg"><%= request.getAttribute("error") %></div>
  <% } %>

  <form action="user?action=validateOtp" method="post">
    <input type="hidden" name="email" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : request.getParameter("email") %>">
    <input type="text" name="otp" maxlength="6" placeholder="000000" required autocomplete="off">
    <button type="submit" class="verify-btn">Verify and Continue</button>
  </form>
</div>

</body>
</html>