package controller;

import java.io.File;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import model.User;
import service.UserService;

@WebServlet("/user")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2 MB
    maxFileSize = 1024 * 1024 * 10,       // 10 MB
    maxRequestSize = 1024 * 1024 * 50     // 50 MB
)
public class UserController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        switch (action) {
            case "logout":
                logout(request, response);
                break;
            default:
                response.sendRedirect("index.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Fall back to checking the URL query string parameters if multipart intercepts request processing
        String action = request.getParameter("action");
        
        if (action == null && request.getContentType() != null && request.getContentType().startsWith("multipart/form-data")) {
            action = "updateProfile"; 
        }

        if (action == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        switch (action) {
            case "register":
                register(request, response);
                break;
                
            case "login":
                login(request, response);
                break;
                
            case "updateProfile": 
                updateProfile(request, response);
                break;

            case "sendResetLink":
                sendResetLink(request, response);
                break;

            case "validateOtp":
                validateOtp(request, response);
                break;

            case "confirmNewPassword":
                confirmNewPassword(request, response);
                break;
                
            default:
                response.sendRedirect("login.jsp");
        }
    }

    private void register(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (confirmPassword != null && !password.equals(confirmPassword)) {
            response.sendRedirect("register.jsp?error=passwordMismatch");
            return;
        }

        User user = new User();
        user.setFullName(request.getParameter("fullName"));
        user.setEmail(request.getParameter("email"));
        user.setPassword(password);
        user.setPhone(request.getParameter("phone"));
        user.setRole(request.getParameter("role")); 

        boolean status = userService.registerUser(user);
        if (status) {
            response.sendRedirect("login.jsp?success=registered");
        } else {
            response.sendRedirect("register.jsp?error=emailExists");
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userService.loginUser(email, password);
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("loggedUser", user);
            
            // Dynamic Role-Based Redirection
            String role = user.getRole() != null ? user.getRole().toUpperCase() : "CUSTOMER";
            
            switch (role) {
                case "ADMIN":
                    response.sendRedirect("admin-dashboard.jsp"); // Global platform management
                    break;
                case "OWNER":
                    response.sendRedirect("admin?action=viewOrders"); // Restaurant specific management
                    break;
                case "CUSTOMER":
                default:
                    response.sendRedirect("restaurant"); // Ordering flow
                    break;
            }
        } else {
            response.sendRedirect("index.jsp?error=invalid");
        }
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
       

        User loggedUser = (User) session.getAttribute("loggedUser");
        if (loggedUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        Part filePart = request.getPart("profileImage");
        String savedImagePath = loggedUser.getProfileImage(); 

        if (filePart != null && filePart.getSize() > 0) {
            String originalName = filePart.getSubmittedFileName();
            String fileExtension = originalName.substring(originalName.lastIndexOf("."));
            
            String dynamicFileName = "avatar_" + loggedUser.getUserId() + "_" + System.currentTimeMillis() + fileExtension;
            
            String applicationStorageRoot = getServletContext().getRealPath("");
            String uploadDirectoryPath = applicationStorageRoot + File.separator + "uploads";
            
            File targetFolder = new File(uploadDirectoryPath);
            if (!targetFolder.exists()) {
                targetFolder.mkdirs();
            }

            filePart.write(uploadDirectoryPath + File.separator + dynamicFileName);
            savedImagePath = "uploads/" + dynamicFileName;
        }

        loggedUser.setFullName(fullName);
        loggedUser.setEmail(email);
        loggedUser.setPhone(phone);
        loggedUser.setProfileImage(savedImagePath);

        boolean isUpdated = userService.updateProfile(loggedUser);

        if (isUpdated) {
            session.setAttribute("loggedUser", loggedUser);
            response.sendRedirect("restaurant?success=profileUpdated");
        } else {
            response.sendRedirect("restaurant?error=profileUpdateFailed");
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect("index.jsp?success=logout");
    }
    
    private void sendResetLink(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        
        // 1. Verify User exists in database vs unknown visitor
        User user = userService.getUserByEmail(email); 
        if (user == null) {
            request.setAttribute("error", "This email address is not registered with us.");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            return;
        }
        
        // 2. Generate a secure, random 6-digit OTP string
        int randomOtp = 100000 + (int)(Math.random() * 900000);
        String otpStr = String.valueOf(randomOtp);
        
        // 3. Persist the generated OTP token to your database user record
        boolean tokenSaved = userService.saveResetToken(email, otpStr);
        
        if (tokenSaved) {
            // 4. Dispatch verification email message payload
            String subject = "FoodExpress Security OTP Verification Code";
            String body = "Hello, your 6-digit security token to reset your password is: " + otpStr + "\nValid for 15 minutes.";
            
            util.EmailUtility.sendEmail(email, subject, body);
            
            request.setAttribute("email", email);
            request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Something went wrong. Please try again.");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
        }
    }

    private void validateOtp(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String enteredOtp = request.getParameter("otp");
        
        // Validate current token match and lifespan boundaries
        boolean isValid = userService.verifyOtpToken(email, enteredOtp);
        
        if (isValid) {
            request.setAttribute("email", email);
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
        } else {
            request.setAttribute("email", email);
            request.setAttribute("error", "Invalid or expired OTP code. Please try again.");
            request.getRequestDispatcher("verify-otp.jsp").forward(request, response);
        }
    }

    private void confirmNewPassword(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");
        
        // Update credentials to new password state and wipe out active memory tokens
        boolean passwordUpdated = userService.updatePassword(email, newPassword);
        
        if (passwordUpdated) {
            // Force routing back to entry login gateway with an explicit flag notification
            response.sendRedirect("login.jsp?status=reset_success");
        } else {
            request.setAttribute("email", email);
            request.setAttribute("error", "Failed to update password. Please try again.");
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
        }
    }
}