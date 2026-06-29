<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Oops! Something Went Wrong</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; text-align: center; padding: 50px; background: #fafafa; color: #1c1c1c; }
        .error-card { max-width: 500px; margin: 0 auto; background: white; padding: 40px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); border: 1px solid #e8e8e8; }
        h1 { color: #cb202d; font-size: 48px; margin-bottom: 10px; }
        p { color: #696969; margin-bottom: 25px; }
        .btn { display: inline-block; background: #cb202d; color: white; text-decoration: none; padding: 12px 24px; border-radius: 8px; font-weight: 600; }
    </style>
</head>
<body>
    <div class="error-card">
        <h1>⚠️</h1>
        <h2>System Glitch</h2>
        <p>We are having trouble processing your culinary request right now. Don't worry, your balance is safe.</p>
        <a href="restaurant" class="btn">Go Back to Restaurants</a>
    </div>
</body>
</html>