package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import java.io.IOException;

@WebFilter("/manage") // This protects your /manage controller
public class AdminFilter implements Filter {
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;
        
        // Only allow if user is logged in AND is an Admin or Owner
        if (user != null && ("ADMIN".equalsIgnoreCase(user.getRole()) || "OWNER".equalsIgnoreCase(user.getRole()))) {
            chain.doFilter(request, response);
        } else {
            res.sendRedirect("login.jsp");
        }
    }
}