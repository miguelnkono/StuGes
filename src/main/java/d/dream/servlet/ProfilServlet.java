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
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * User profile page — allows any logged-in user to change their password.
 *
 * GET  /profil → show profile page
 * POST /profil → process password change
 */
@WebServlet("/profil")
public class ProfilServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(ProfilServlet.class.getName());
    private static final long serialVersionUID = 1L;

    private final UtilisateurDao utilisateurDao = new UtilisateurDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/jsp/profil.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Utilisateur me         = SessionUtil.getUser(req);
        String currentPassword = req.getParameter("currentPassword");
        String newPassword     = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        if (isBlank(currentPassword) || isBlank(newPassword) || isBlank(confirmPassword)) {
            req.setAttribute("error", "Tous les champs sont obligatoires.");
            req.getRequestDispatcher("/WEB-INF/jsp/profil.jsp").forward(req, resp);
            return;
        }

        if (!PasswordUtil.verify(currentPassword, me.getMotDePasse())) {
            req.setAttribute("error", "Mot de passe actuel incorrect.");
            req.getRequestDispatcher("/WEB-INF/jsp/profil.jsp").forward(req, resp);
            return;
        }

        if (newPassword.length() < 8) {
            req.setAttribute("error", "Le nouveau mot de passe doit contenir au moins 8 caractères.");
            req.getRequestDispatcher("/WEB-INF/jsp/profil.jsp").forward(req, resp);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            req.setAttribute("error", "Les nouveaux mots de passe ne correspondent pas.");
            req.getRequestDispatcher("/WEB-INF/jsp/profil.jsp").forward(req, resp);
            return;
        }

        if (PasswordUtil.verify(newPassword, me.getMotDePasse())) {
            req.setAttribute("error", "Le nouveau mot de passe doit être différent de l'ancien.");
            req.getRequestDispatcher("/WEB-INF/jsp/profil.jsp").forward(req, resp);
            return;
        }

        try {
            Utilisateur updated = new Utilisateur(
                me.getId(), me.getNom(), me.getPrenom(), me.getEmail(),
                PasswordUtil.hash(newPassword),
                me.getRole(), me.isActif(), me.getCreatedAt()
            );
            utilisateurDao.update(updated);

            SessionUtil.login(req, updated);

            SessionUtil.setFlash(req, "Mot de passe modifié avec succès !");
            resp.sendRedirect(req.getContextPath() + "/profil");

        } catch (SQLException e) {
            LOG.log(Level.SEVERE, "Erreur changement mot de passe", e);
            req.setAttribute("error", "Erreur interne. Veuillez réessayer.");
            req.getRequestDispatcher("/WEB-INF/jsp/profil.jsp").forward(req, resp);
        }
    }

    private boolean isBlank(String s) { return s == null || s.isBlank(); }
}
