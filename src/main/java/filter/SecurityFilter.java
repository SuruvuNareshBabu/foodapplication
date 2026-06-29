package filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

@WebFilter("/*")
public class SecurityFilter implements Filter {
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String path = req.getRequestURI();

        // 1. Define Protected Paths
        if (path.contains("/admin/")) {
            User user = (User) req.getSession().getAttribute("loggedUser");
            if (user == null || !"ADMIN".equals(user.getRole())) {
                res.sendRedirect(req.getContextPath() + "/login.jsp?error=unauthorized");
                return;
            }
        }
        
        if (path.contains("/owner/")) {
            User user = (User) req.getSession().getAttribute("loggedUser");
            if (user == null || (!"OWNER".equals(user.getRole()) && !"ADMIN".equals(user.getRole()))) {
                res.sendRedirect(req.getContextPath() + "/login.jsp?error=unauthorized");
                return;
            }
        }

        chain.doFilter(request, response);
    }
}
