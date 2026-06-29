package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*") 
public class AuthenticationFilter implements Filter {
    
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String path = req.getRequestURI();

        // 1. ALLOW the login page and registration page to bypass the filter
        // We check if the request ends with the login/register path
        if (path.endsWith("/login.jsp") || path.endsWith("/register.jsp")) {
            chain.doFilter(request, response);
            return;
        }

        // 2. PROTECT your controllers (Checkout, Orders, Payment)
        if (path.contains("/checkout") || path.contains("/orders") || path.contains("/payment")) {
            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("loggedUser") == null) {
                res.sendRedirect(req.getContextPath() + "/login.jsp?msg=auth_required");
                return;
            }
        }
        
        // 3. Allow everything else (images, index, etc)
        chain.doFilter(request, response);
    }
}