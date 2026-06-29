<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
User loggedUser = (User)session.getAttribute("loggedUser");
if(loggedUser != null) {
    response.sendRedirect("index.jsp");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FoodExpress | Create a Secure Account</title>
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

  /* ── 1. Unified Zomato Fixed Header ── */
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

  /* ── 2. Immersive Form Canvas Layout ── */
  .auth-main {
    flex: 1;
    margin-top: 72px;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 40px 20px;
    background: linear-gradient(180deg, #ffffff 0%, #f8f8f8 100%);
  }

  .form-card {
    width: 100%;
    max-width: 480px;
    background: #ffffff;
    padding: 40px 36px;
    border-radius: 12px;
    border: 1px solid #e8e8e8;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.04);
  }

  .form-card h2 {
    font-size: 26px;
    font-weight: 600;
    color: #1c1c1c;
    margin-bottom: 8px;
  }

  .form-card .subtitle {
    color: #696969;
    font-size: 15px;
    margin-bottom: 24px;
  }

  /* ── 3. High-Fidelity Styled Grid Inputs ── */
  .input-group {
    margin-bottom: 18px;
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

  .input-wrap input, .input-wrap select {
    width: 100%;
    padding: 13px 14px 13px 40px;
    border: 1px solid #a3a4ae;
    border-radius: 6px;
    outline: none;
    font-size: 15px;
    color: #1c1c1c;
    background: #ffffff;
    transition: border-color 0.2s, box-shadow 0.2s;
  }

  .input-wrap select {
    appearance: none;
    cursor: pointer;
    background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%234f4f4f' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
    background-repeat: no-repeat;
    background-position: right 14px center;
    background-size: 16px;
    padding-right: 40px;
  }

  .input-wrap input:focus, .input-wrap select:focus {
    border-color: #cb202d;
    box-shadow: 0 0 0 3px rgba(203, 32, 45, 0.1);
  }

  .input-wrap input.valid { border-color: #10b981; }
  .input-wrap input.invalid { border-color: #cb202d; }

  .password-wrap input { padding-right: 60px; }

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

  /* ── 4. Dynamic Password Strength Meter ── */
  .strength-bar {
    height: 4px;
    border-radius: 2px;
    background: #e8e8e8;
    margin-top: 8px;
    overflow: hidden;
  }

  .strength-fill {
    height: 100%;
    width: 0%;
    border-radius: 2px;
    transition: width 0.3s ease, background-color 0.3s ease;
    background: #ef4444;
  }

  .field-hint {
    font-size: 12.5px;
    color: #696969;
    margin-top: 6px;
    min-height: 16px;
    font-weight: 500;
  }

  .field-hint.error {
    color: #cb202d;
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
    margin-top: 10px;
  }

  button.submit-btn:hover { background: #b01b26; }
  button.submit-btn:disabled { background: #f4a4a9; cursor: not-allowed; }

  .login-link {
    text-align: center;
    margin-top: 24px;
    color: #4f4f4f;
    font-size: 15px;
  }

  .login-link a {
    color: #cb202d;
    font-weight: 600;
    text-decoration: none;
  }

  .login-link a:hover { text-decoration: underline; }

  /* ── 5. Platform Response Banners ── */
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

  /* ── 6. Structural Zomato Footer ── */
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
      <a href="login.jsp">Log in</a>
      <a href="register.jsp" style="color: #cb202d;">Sign up</a>
    </div>
  </nav>
</header>

<main class="auth-main">
  <div class="form-card" id="registerCard">
    <h2>Create Account</h2>
    <p class="subtitle">Join FoodExpress ecosystem to manage your daily orders</p>

    <%
    String success = request.getParameter("success");
    String error = request.getParameter("error");
    %>

    <% if("registered".equals(success)){ %>
      <div class="message success"><span>✓</span> Registration Successful! Please Login.</div>
    <% } %>

    <% if("passwordMismatch".equals(error)){ %>
      <div class="message error"><span>⚠</span> Passwords do not match!</div>
    <% } else if("emailExists".equals(error)){ %>
      <div class="message error"><span>⚠</span> This Email is already registered!</div>
    <% } else if(error != null) { %>
      <div class="message error"><span>⚠</span> Registration failed. Something went wrong.</div>
    <% } %>

    <form action="user?action=register" method="post" id="registerForm" novalidate>
      
      <div class="input-group">
        <label for="fullName">Full Name</label>
        <div class="input-wrap">
          <span class="input-icon">👤</span>
          <input type="text" id="fullName" name="fullName" placeholder="e.g. Priya Sharma" required minlength="3">
        </div>
        <div class="field-hint" id="nameHint"></div>
      </div>

      <div class="input-group">
        <label for="email">Email Address</label>
        <div class="input-wrap">
          <span class="input-icon">✉</span>
          <input type="email" id="email" name="email" placeholder="you@example.com" required>
        </div>
        <div class="field-hint" id="emailHint"></div>
      </div>

      <div class="input-group">
        <label for="password">Password</label>
        <div class="input-wrap password-wrap">
          <span class="input-icon">🔒</span>
          <input type="password" id="password" name="password" placeholder="At least 6 characters" required minlength="6">
          <button type="button" class="toggle-pass" data-target="password">Show</button>
        </div>
        <div class="strength-bar"><div class="strength-fill" id="strengthFill"></div></div>
        <div class="field-hint" id="passwordHint">Use 6+ characters with letters and numbers</div>
      </div>

      <div class="input-group">
        <label for="confirmPassword">Confirm Password</label>
        <div class="input-wrap password-wrap">
          <span class="input-icon">🛡️</span>
          <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Re-enter your password" required>
          <button type="button" class="toggle-pass" data-target="confirmPassword">Show</button>
        </div>
        <div class="field-hint" id="confirmHint"></div>
      </div>

      <div class="input-group">
        <label for="phone">Mobile Number</label>
        <div class="input-wrap">
          <span class="input-icon">📱</span>
          <input type="tel" id="phone" name="phone" maxlength="10" placeholder="10-digit mobile number" required>
        </div>
        <div class="field-hint" id="phoneHint"></div>
      </div>

      <div class="input-group">
        <label for="role">Register As</label>
        <div class="input-wrap">
          <span class="input-icon">💼</span>
          <select id="role" name="role" required>
            <option value="CUSTOMER">Customer</option>
            <option value="OWNER">Restaurant Owner</option>
            <option value="ADMIN">Admin</option>
          </select>
        </div>
      </div>

      <button type="submit" class="submit-btn" id="submitBtn">Create Account</button>
    </form>

    <div class="login-link">
      Already have an account? <a href="login.jsp">Login</a>
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
const form = document.getElementById("registerForm");
const nameInput = document.getElementById("fullName");
const emailInput = document.getElementById("email");
const passwordInput = document.getElementById("password");
const confirmInput = document.getElementById("confirmPassword");
const phoneInput = document.getElementById("phone");
const strengthFill = document.getElementById("strengthFill");
const card = document.getElementById("registerCard");

function setState(input, hintEl, valid, message){
  input.classList.remove("valid","invalid");
  hintEl.classList.remove("error");
  
  if(valid === null){
    hintEl.textContent = message || "";
    return;
  }
  
  if(!valid) {
    input.classList.add("invalid");
    hintEl.classList.add("error");
  } else {
    input.classList.add("valid");
  }
  hintEl.textContent = message || "";
}

nameInput.addEventListener("input", function(){
  const val = this.value.trim();
  if(val.length === 0){ setState(this, document.getElementById("nameHint"), null, ""); return; }
  setState(this, document.getElementById("nameHint"), val.length >= 3, val.length >= 3 ? "" : "Name must be at least 3 characters");
});

emailInput.addEventListener("input", function(){
  const val = this.value.trim();
  const ok = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val);
  if(val.length === 0){ setState(this, document.getElementById("emailHint"), null, ""); return; }
  setState(this, document.getElementById("emailHint"), ok, ok ? "" : "Enter a valid email address");
});

passwordInput.addEventListener("input", function(){
  const val = this.value;
  const hintEl = document.getElementById("passwordHint");

  let score = 0;
  if(val.length >= 6) score++;
  if(val.length >= 10) score++;
  if(/[0-9]/.test(val) && /[a-zA-Z]/.test(val)) score++;
  if(/[^a-zA-Z0-9]/.test(val)) score++;

  const colors = ["#ef4444","#ef4444","#f59e0b","#f59e0b","#10b981"];
  const widths = [0,25,50,75,100];
  const labels = ["","Weak","Fair","Good","Strong"];

  strengthFill.style.width = widths[score] + "%";
  strengthFill.style.background = colors[score];

  if(val.length === 0){
    hintEl.textContent = "Use 6+ characters with letters and numbers";
    hintEl.classList.remove("error");
    this.classList.remove("valid","invalid");
  } else {
    setState(this, hintEl, val.length >= 6, val.length >= 6 ? labels[score] + " password" : "Password must be at least 6 characters");
  }

  if(confirmInput.value.length > 0){
    confirmInput.dispatchEvent(new Event("input"));
  }
});

confirmInput.addEventListener("input", function(){
  const val = this.value;
  const hintEl = document.getElementById("confirmHint");
  if(val.length === 0){ setState(this, hintEl, null, ""); return; }
  const match = val === passwordInput.value;
  setState(this, hintEl, match, match ? "" : "Passwords do not match");
});

phoneInput.addEventListener("input", function(){
  this.value = this.value.replace(/\D/g,"").slice(0,10);
  const hintEl = document.getElementById("phoneHint");
  if(this.value.length === 0){ setState(this, hintEl, null, ""); return; }
  const ok = this.value.length === 10;
  setState(this, hintEl, ok, ok ? "" : "Enter a valid 10-digit mobile number");
});

document.querySelectorAll(".toggle-pass").forEach(function(btn){
  btn.addEventListener("click", function(){
    const target = document.getElementById(this.dataset.target);
    const showing = target.type === "text";
    target.type = showing ? "password" : "text";
    this.textContent = showing ? "Show" : "Hide";
  });
});

function triggerShakeEffect() {
  card.classList.add("shake");
  setTimeout(() => { card.classList.remove("shake"); }, 300);
}

form.addEventListener("submit", function(e){
  let name = nameInput.value.trim();
  let email = emailInput.value.trim();
  let pass = passwordInput.value;
  let cpass = confirmInput.value;
  let phone = phoneInput.value.trim();
  let isValid = true;

  if(name.length < 3){
    e.preventDefault();
    setState(nameInput, document.getElementById("nameHint"), false, "Name must be at least 3 characters");
    isValid = false;
  }

  if(!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)){
    e.preventDefault();
    setState(emailInput, document.getElementById("emailHint"), false, "Enter a valid email address");
    isValid = false;
  }

  if(pass.length < 6){
    e.preventDefault();
    setState(passwordInput, document.getElementById("passwordHint"), false, "Password must be at least 6 characters");
    isValid = false;
  }

  if(pass !== cpass){
    e.preventDefault();
    setState(confirmInput, document.getElementById("confirmHint"), false, "Passwords do not match");
    isValid = false;
  }

  if(phone.length !== 10){
    e.preventDefault();
    setState(phoneInput, document.getElementById("phoneHint"), false, "Enter a valid 10-digit mobile number");
    isValid = false;
  }

  if(!isValid) {
    triggerShakeEffect();
  } else {
    document.getElementById("submitBtn").textContent = "Creating Account Matrix...";
    document.getElementById("submitBtn").disabled = true;
  }
});
</script>
</body>
</html>