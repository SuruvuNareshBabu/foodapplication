<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>FoodExpress Secure Payment Gateway</title>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', system-ui, -apple-system, sans-serif; }
  body { background: #f4f6f9; display: flex; align-items: center; justify-content: center; min-height: 100vh; color: #1c1c1c; padding: 20px; }
  
  .gateway-card { background: #fff; width: 100%; max-width: 420px; padding: 30px; border-radius: 16px; box-shadow: 0 10px 25px rgba(0,0,0,0.05); border: 1px solid #e8e8e8; text-align: center; position: relative; overflow: hidden; }
  .gateway-card::before { content: ''; position: absolute; top: 0; left: 0; width: 100%; height: 5px; background: #cb202d; }
  
  .logo-header { font-size: 24px; font-weight: 800; color: #cb202d; margin-bottom: 4px; letter-spacing: -0.5px; }
  .secure-text { font-size: 11px; color: #267e3e; font-weight: 700; margin-bottom: 24px; text-transform: uppercase; letter-spacing: 0.5px; display: flex; align-items: center; justify-content: center; gap: 4px; }
  
  .amount-box { background: #fdf2f2; padding: 16px; border-radius: 12px; margin-bottom: 24px; border: 1px dashed #cb202d; text-align: center; }
  .amount-box span { font-size: 13px; color: #696969; display: block; margin-bottom: 4px; font-weight: 500; }
  .amount-box strong { font-size: 28px; color: #1c1c1c; font-weight: 800; }
  
  .section-title { font-size: 14px; font-weight: 700; margin-bottom: 14px; text-align: left; color: #1c1c1c; text-transform: uppercase; letter-spacing: 0.3px; }
  
  .payment-apps-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 20px; }
  
  .app-btn { background: #fff; border: 1px solid #dcdcdc; border-radius: 10px; padding: 14px 12px; font-weight: 600; font-size: 14px; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 8px; transition: all 0.2s ease; width: 100%; }
  .app-btn:hover { border-color: #cb202d; background: #fffcfc; transform: translateY(-1px); box-shadow: 0 4px 10px rgba(203, 32, 45, 0.05); }
  
  /* Brand accents */
  .gpay:hover { border-color: #4285F4; color: #4285F4; } 
  .phonepe:hover { border-color: #5E2572; color: #5E2572; } 
  .paytm:hover { border-color: #002E6E; color: #002E6E; }
  .card-btn:hover { border-color: #1c1c1c; color: #1c1c1c; }
  
  .status-container { margin-top: 10px; min-height: 60px; display: flex; flex-direction: column; align-items: center; justify-content: center; }
  .timer-text { font-size: 13px; color: #888; font-weight: 500; line-height: 1.4; max-width: 90%; }
  
  .loader { display: none; margin-bottom: 14px; border: 4px solid #f3f3f3; border-top: 4px solid #cb202d; border-radius: 50%; width: 36px; height: 36px; animation: spin 0.8s linear infinite; }
  @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
</style>
</head>
<body>

<div class="gateway-card">
  <div class="logo-header">FoodExpress Pay</div>
  <div class="secure-text">🔒 256-Bit SSL Secured Transaction</div>

  <div class="amount-box">
    <span>Amount to be Paid</span>
    <strong>₹<%= request.getAttribute("grandTotal") != null ? String.format("%.2f", (Double)request.getAttribute("grandTotal")) : "0.00" %></strong>
  </div>

  <div id="paymentOptionsBlock">
    <div class="section-title">Select App to Complete Payment</div>
    <div class="payment-apps-grid">
      <button type="button" class="app-btn gpay" onclick="simulatePayment('Google Pay')">📱 Google Pay</button>
      <button type="button" class="app-btn phonepe" onclick="simulatePayment('PhonePe')">🔮 PhonePe</button>
      <button type="button" class="app-btn paytm" onclick="simulatePayment('Paytm')">💸 Paytm</button>
      <button type="button" class="app-btn card-btn" onclick="simulatePayment('Credit/Debit Card')">💳 Card Gateway</button>
    </div>
  </div>

  <div class="status-container">
    <div class="loader" id="paymentLoader"></div>
    <p class="timer-text" id="statusMessage">
      Awaiting payment choice for Order Reference #FEX-00<%= request.getAttribute("orderId") != null ? request.getAttribute("orderId") : "0" %>
    </p>
  </div>

  <form id="mockPaymentForm" action="orders" method="post" style="display:none;">
     <input type="hidden" name="action" value="processMockPayment">
     <input type="hidden" name="orderId" value="<%= request.getAttribute("orderId") != null ? request.getAttribute("orderId") : "0" %>">
  </form>
</div>

<script>
function simulatePayment(appName) {
    // 1. Hide the interactive grid section completely
    document.getElementById('paymentOptionsBlock').style.display = 'none';
    
    // 2. Bring up the visual loading spinner icon
    document.getElementById('paymentLoader').style.display = 'block';
    
    // 3. Set a message simulating application load state
    var statusTxt = document.getElementById('statusMessage');
    statusTxt.innerHTML = "Opening " + appName + "... <br><span style='font-size:11px; color:#b7791f;'>Please do not refresh or press back. Requesting payment payload authorization pin.</span>";
    statusTxt.style.color = "#1c1c1c";

    // 4. Mimic user interaction processing wait window (UPI PIN entry delay)
    setTimeout(function() {
        statusTxt.innerHTML = "✨ Secure Pin Verified! <br><span style='font-size:11px; color:#267e3e;'>Processing bank settlement networks, writing merchant records...</span>";
        statusTxt.style.color = "#267e3e";
        document.getElementById('paymentLoader').style.borderTopColor = "#267e3e";
        
        // 5. Final delayed trigger to cleanly pass parameters to the servlet
        setTimeout(function() {
            document.getElementById('mockPaymentForm').submit();
        }, 1500);
        
    }, 3000); 
}
</script>

</body>
</html>