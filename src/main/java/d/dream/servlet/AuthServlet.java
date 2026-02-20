package d.dream.servlet;

import d.dream.dao.UtilisateurDao;
import d.dream.dao.UtilisateurDaoImpl;
import d.dream.model.Utilisateur;
import d.dream.util.PasswordUtil;
import d.dream.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Handles:
 *   GET  /auth  → show login form
 *   POST /auth  → process login credentials
 *   GET  /auth?action=logout → invalidate session
 */
@WebServlet("/auth")
public class AuthServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(AuthServlet.class.getName());
    private static final long serialVersionUID = 1L;

    private final UtilisateurDao utilisateurDao = new UtilisateurDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Logout action
        if ("logout".equals(req.getParameter("action"))) {
            SessionUtil.logout(req);
            resp.sendRedirect(req.getContextPath() + "/auth");
            return;
        }

        // Already logged in → go to dashboard
        if (SessionUtil.isAuthenticated(req)) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        req.getRequestDispatcher("/WEB-INF/jsp/authentification.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email       = trim(req.getParameter("email"));
        String motDePasse  = req.getParameter("motDePasse");

        // Basic validation
        if (email.isEmpty() || motDePasse == null || motDePasse.isEmpty()) {
            req.setAttribute("error", "Veuillez remplir tous les champs.");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/WEB-INF/jsp/authentification.jsp").forward(req, resp);
            return;
        }

        try {
            Optional<Utilisateur> opt = utilisateurDao.findByEmail(email);

            if (opt.isEmpty() || !PasswordUtil.verify(motDePasse, opt.get().getMotDePasse())) {
                req.setAttribute("error", "Email ou mot de passe incorrect.");
                req.setAttribute("email", email);
                req.getRequestDispatcher("/WEB-INF/jsp/authentification.jsp").forward(req, resp);
                return;
            }

            Utilisateur user = opt.get();
            if (!user.isActif()) {
                req.setAttribute("error", "Votre compte est désactivé. Contactez l'administrateur.");
                req.getRequestDispatcher("/WEB-INF/jsp/authentification.jsp").forward(req, resp);
                return;
            }

            SessionUtil.login(req, user);
            resp.sendRedirect(req.getContextPath() + "/dashboard");

        } catch (SQLException e) {
            LOG.log(Level.SEVERE, "Erreur de base de données lors de l'authentification", e);
            req.setAttribute("error", "Erreur interne. Veuillez réessayer.");
            req.getRequestDispatcher("/WEB-INF/jsp/authentification.jsp").forward(req, resp);
        }
    }

    private String trim(String s) {
        return s == null ? "" : s.trim();
    }
}
