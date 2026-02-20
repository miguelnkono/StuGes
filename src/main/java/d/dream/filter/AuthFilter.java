package d.dream.filter;

import d.dream.util.SessionUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String uri  = req.getRequestURI();
        String ctx  = req.getContextPath();

        if (uri.startsWith(ctx + "/assets/")
                || uri.endsWith(".css")
                || uri.endsWith(".js")
                || uri.endsWith(".ico")
                || uri.endsWith(".png")
                || uri.endsWith(".jpg")) {
            chain.doFilter(request, response);
            return;
        }

        String path = uri.substring(ctx.length());
        if (path.equals("/auth")
                || path.startsWith("/auth?")
                || path.equals("/inscription")
                || path.startsWith("/inscription?")) {
            chain.doFilter(request, response);
            return;
        }

        if (SessionUtil.isAuthenticated(req)) {
            chain.doFilter(request, response);
            return;
        }

        resp.sendRedirect(ctx + "/auth");
    }
}
