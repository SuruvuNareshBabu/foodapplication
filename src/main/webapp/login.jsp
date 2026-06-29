<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
User loggedUser = (User)session.getAttribute("loggedUser");
Object cartCountAttr = session.getAttribute("cartCount");
int cartCount = cartCountAttr != null ? (Integer)cartCountAttr : 0;

if(loggedUser != null) {
    response.sendRedirect("index.jsp");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FoodExpress | Secure Account Authentication</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
  * {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
  }

  body {
    background: #f8f8f8;
    color: #1c1c1c;
    overflow-x: hidden;
    display: flex;
    flex-direction: column;
    min-height: 100vh;
  }

  /* ── 1. Unified Sticky Navigation System ── */
  header {
    position: fixed;
    top: 0;
    width: 100%;
    z-index: 1000;
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(20px);
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
    border-bottom: 1px solid #f2f2f2;
  }

  .navbar {
    height: 72px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 10%;
    max-width: 1400px;
    margin: 0 auto;
  }

  .logo {
    font-size: 32px;
    font-weight: 800;
    text-decoration: none;
    color: #cb202d; /* Zomato Corporate Red */
    letter-spacing: -1px;
  }

  .menu-links {
    display: flex;
    gap: 30px;
    align-items: center;
  }

  .menu-links a {
    text-decoration: none;
    font-weight: 500;
    font-size: 16px;
    color: #333;
    transition: color 0.25s;
  }

  .menu-links a:hover {
    color: #cb202d;
  }

  .cart-pill {
    padding: 8px 18px;
    background: #cb202d;
    color: white !important;
    border-radius: 20px;
    font-weight: 600;
    font-size: 14px;
    display: flex;
    align-items: center;
    gap: 6px;
    box-shadow: 0 4px 12px rgba(203,32,45,0.25);
  }

  .cart-badge {
    background: #fff;
    color: #cb202d;
    border-radius: 50%;
    width: 18px;
    height: 18px;
    font-size: 11px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-weight: 700;
  }

  .auth-btn {
    padding: 8px 20px;
    border-radius: 20px;
    font-weight: 600;
    font-size: 15px;
    transition: all 0.25s;
  }

  .auth-btn.login {
    border: 1px solid #cb202d;
    color: #cb202d;
  }

  .auth-btn.register {
    background: #cb202d;
    color: #fff !important;
  }

  /* ── 2. Immersive Authentic Modal Canvas Layout ── */
  .auth-main {
    flex: 1;
    margin-top: 72px;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 60px 20px;
    background: linear-gradient(180deg, #ffffff 0%, #f8f8f8 100%);
  }

  .login-card {
    width: 100%;
    max-width: 440px;
    background: #ffffff;
    padding: 40px 36px;
    border-radius: 12px;
    border: 1px solid #e8e8e8;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.04);
  }

  .login-card h2 {
    font-size: 26px;
    font-weight: 600;
    color: #1c1c1c;
    margin-bottom: 8px;
  }

  .login-card .subtitle {
    color: #696969;
    font-size: 15px;
    margin-bottom: 28px;
  }

  /* ── 3. High-Fidelity Form Design ── */
  .input-group {
    margin-bottom: 20px;
  }

  .input-group label {
    display: block;
    font-size: 13px;
    font-weight: 600;
    color: #1c1c1c;
    margin-bottom: 8px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
  }

  .input-wrap {
    position: relative;
    display: flex;
    align-items: center;
  }

  .input-wrap span.input-icon {
    position: absolute;
    left: 14px;
    color: #828282;
    font-size: 15px;
    user-select: none;
  }

  .input-wrap input {
    width: 100%;
    padding: 13px 14px 13px 40px;
    border: 1px solid #a3a4ae;
    border-radius: 6px;
    outline: none;
    font-size: 15px;
    color: #1c1c1c;
    transition: border-color 0.2s, box-shadow 0.2s;
  }

  .input-wrap input:focus {
    border-color: #cb202d;
    box-shadow: 0 0 0 3px rgba(203, 32, 45, 0.1);
  }

  .input-wrap input.valid {
    border-color: #10b981;
  }

  .input-wrap input.invalid {
    border-color: #cb202d;
  }

  .password-wrap input {
    padding-right: 60px;
  }

  .toggle-pass {
    position: absolute;
    right: 14px;
    background: none;
    border: none;
    color: #cb202d;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
    outline: none;
  }

  .field-hint {
    font-size: 12.5px;
    color: #ef4444;
    margin-top: 6px;
    min-height: 16px;
    font-weight: 500;
    display: none;
  }

  .field-hint.visible {
    display: block;
  }

  .options-row {
    display: flex;
    justify-content: flex-end;
    margin-top: -10px;
    margin-bottom: 24px;
  }

  .options-row a {
    font-size: 14px;
    color: #cb202d;
    text-decoration: none;
    font-weight: 500;
  }

  .options-row a:hover {
    text-decoration: underline;
  }

  button.submit-btn {
    width: 100%;
    padding: 14px;
    border: none;
    border-radius: 6px;
    background: #cb202d;
    color: white;
    font-size: 16px;
    font-weight: 600;
    cursor: pointer;
    transition: background 0.2s;
  }

  button.submit-btn:hover {
    background: #b01b26;
  }

  button.submit-btn:disabled {
    background: #f4a4a9;
    cursor: not-allowed;
  }

  .register-link {
    text-align: center;
    margin-top: 24px;
    color: #4f4f4f;
    font-size: 15px;
  }

  .register-link a {
    color: #cb202d;
    font-weight: 600;
    text-decoration: none;
  }

  .register-link a:hover {
    text-decoration: underline;
  }

  /* ── 4. Interceptor Messages ── */
  .message {
    padding: 12px 16px;
    border-radius: 6px;
    margin-bottom: 20px;
    font-size: 14px;
    font-weight: 500;
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .message.success {
    background: #e6f7ed;
    color: #10b981;
    border: 1px solid #a7f3d0;
  }

  .message.error {
    background: #fdf2f2;
    color: #cb202d;
    border: 1px solid #fecdca;
  }

  /* ── 5. Enterprise Zomato Minimalist Footer ── */
  footer {
    background: #f8f8f8;
    padding: 60px 10% 40px;
    border-top: 1px solid #e8e8e8;
  }

  .footer-top {
    max-width: 1100px;
    margin: 0 auto 40px;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .footer-top .f-logo {
    font-size: 30px;
    font-weight: 800;
    color: #000;
    text-decoration: none;
  }

  .footer-links-grid {
    max-width: 1100px;
    margin: 0 auto;
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 30px;
    padding-bottom: 40px;
    border-bottom: 1px solid #dfdfdf;
  }

  .f-col h4 {
    font-size: 14px;
    font-weight: 600;
    letter-spacing: 1px;
    text-transform: uppercase;
    margin-bottom: 15px;
    color: #1c1c1c;
  }

  .f-col ul { list-style: none; }
  .f-col ul li { margin-bottom: 10px; }
  .f-col ul li a { text-decoration: none; color: #696969; font-size: 14px; transition: color 0.2s; }
  .f-col ul li a:hover { color: #1c1c1c; }

  .footer-legal {
    max-width: 1100px;
    margin: 24px auto 0;
    font-size: 13px;
    color: #828282;
    line-height: 20px;
  }

  /* Shake Animation */
  @keyframes shake {
    0%, 100% { transform: translateX(0); }
    25% { transform: translateX(-6px); }
    75% { transform: translateX(6px); }
  }
  .shake { animation: shake 0.3s ease; }

  @media (max-width: 768px) {
    .navbar { padding: 0 20px; }
    .footer-links-grid { grid-template-columns: repeat(2, 1fr); }
  }
</style>
</head>
<body>

<header id="mainHeader">
  <nav class="navbar">
    <a href="index.jsp" class="logo">FoodExpress</a>
    <div class="menu-links">
      <a href="restaurant">Investor Relations</a>
      <a href="restaurant">Add restaurant</a>
      <a href="login.jsp" style="color: #cb202d;">Log in</a>
      <a href="register.jsp">Sign up</a>
    </div>
  </nav>
</header>

<main class="auth-main">
  <div class="login-card" id="loginCard">
    <h2>Login</h2>
    <p class="subtitle">Manage your orders, track delivery and explore setups</p>

    <%
    String success = request.getParameter("success");
    String error = request.getParameter("error");
    %>

    <% if("registered".equals(success)){ %>
      <div class="message success"><span>✓</span> Registration successful! Please login below.</div>
    <% } %>

    <% if("logout".equals(success)){ %>
      <div class="message success"><span>✓</span> You have logged out securely.</div>
    <% } %>

    <% if("invalid".equals(error)){ %>
      <div class="message error"><span>⚠</span> Invalid email address or password profile match.</div>
    <% } %>

    <form action="user" method="post" id="loginForm" novalidate>
      <input type="hidden" name="action" value="login">

      <div class="input-group">
        <label for="email">Email</label>
        <div class="input-wrap">
          <span class="input-icon">✉</span>
          <input type="email" id="email" name="email" placeholder="Enter your registered email" required>
        </div>
        <div class="field-hint" id="emailHint"></div>
      </div>

      <div class="input-group">
        <label for="password">Password</label>
        <div class="input-wrap password-wrap">
          <span class="input-icon">🔒</span>
          <input type="password" id="password" name="password" placeholder="••••••••" required>
          <button type="button" class="toggle-pass" data-target="password">Show</button>
        </div>
        <div class="field-hint" id="passwordHint"></div>
      </div>

      <div class="options-row">
        <a href="forgot-password.jsp">Forgot password?</a>
      </div>

      <button type="submit" class="submit-btn" id="submitBtn">Sign In</button>
    </form>

    <div class="register-link">
      New to FoodExpress? <a href="register.jsp">Create account</a>
    </div>
  </div>
</main>

<footer>
  <div class="footer-top">
    <a href="index.jsp" class="f-logo">FoodExpress</a>
  </div>
  
  <div class="footer-links-grid">
    <div class="f-col">
      <h4>About FoodExpress</h4>
      <ul>
        <li><a href="#">Who We Are</a></li>
        <li><a href="#">Blog</a></li>
        <li><a href="#">Work With Us</a></li>
        <li><a href="#">Report Fraud</a></li>
      </ul>
    </div>
    <div class="f-col">
      <h4>Foodies</h4>
      <ul>
        <li><a href="#">Code of Conduct</a></li>
        <li><a href="#">Community</a></li>
        <li><a href="#">Verified Profiles</a></li>
      </ul>
    </div>
    <div class="f-col">
      <h4>For Restaurants</h4>
      <ul>
        <li><a href="#">Partner With Us</a></li>
        <li><a href="#">Apps For You</a></li>
      </ul>
    </div>
    <div class="f-col">
      <h4>Learn More</h4>
      <ul>
        <li><a href="#">Privacy Policy</a></li>
        <li><a href="#">Security Terms</a></li>
        <li><a href="#">Terms of Service</a></li>
      </ul>
    </div>
  </div>
  
  <div class="footer-legal">
    By continuing past this page, you agree to our Terms of Service, Cookie Policy, Privacy Policy and Content Policies. All trademarks are properties of their respective owners. &copy; 2026 FoodExpress Ltd. All rights reserved.
  </div>
</footer>

<script>
  const form = document.getElementById("loginForm");
  const emailInput = document.getElementById("email");
  const passwordInput = document.getElementById("password");
  const card = document.getElementById("loginCard");

  function setState(input, hintEl, valid, message) {
    input.classList.remove("valid", "invalid");
    hintEl.classList.remove("visible");
    
    if (valid === null) {
      return;
    }
    
    if (!valid) {
      input.classList.add("invalid");
      hintEl.textContent = message;
      hintEl.classList.add("visible");
    } else {
      input.classList.add("valid");
    }
  }

  emailInput.addEventListener("input", function() {
    const val = this.value.trim();
    const ok = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val);
    if (val.length === 0) { setState(this, document.getElementById("emailHint"), null, ""); return; }
    setState(this, document.getElementById("emailHint"), ok, "Please enter a valid email address.");
  });

  passwordInput.addEventListener("input", function() {
    const val = this.value;
    const hintEl = document.getElementById("passwordHint");
    if (val.length === 0) { setState(this, hintEl, null, ""); return; }
    setState(this, hintEl, true, "");
  });

  document.querySelectorAll(".toggle-pass").forEach(function(btn) {
    btn.addEventListener("click", function() {
      const target = document.getElementById(this.dataset.target);
      const isPass = target.type === "password";
      target.type = isPass ? "text" : "password";
      this.textContent = isPass ? "Hide" : "Show";
    });
  });

  function triggerShakeEffect() {
    card.classList.add("shake");
    setTimeout(() => { card.classList.remove("shake"); }, 300);
  }

  form.addEventListener("submit", function(e) {
    const email = emailInput.value.trim();
    const pass = passwordInput.value;
    let isValid = true;

    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      e.preventDefault();
      setState(emailInput, document.getElementById("emailHint"), false, "Please enter a valid email address.");
      isValid = false;
    }

    if (pass.length === 0) {
      e.preventDefault();
      setState(passwordInput, document.getElementById("passwordHint"), false, "Password field cannot be left blank.");
      isValid = false;
    }

    if (!isValid) {
      triggerShakeEffect();
    } else {
      document.getElementById("submitBtn").textContent = "Processing Security Check...";
      document.getElementById("submitBtn").disabled = true;
    }
  });
</script>
</body>
</html>