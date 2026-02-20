package d.dream.servlet;

import d.dream.dao.UtilisateurDao;
import d.dream.dao.UtilisateurDaoImpl;
import d.dream.model.Utilisateur;
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
 * Admin-only actions on user accounts.
 *
 * Routes (all ADMIN only):
 *   GET /utilisateurs?action=delete&id=   → delete user
 *   GET /utilisateurs?action=toggle&id=   → activate / deactivate user
 */
@WebServlet("/utilisateurs")
public class UtilisateurServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(UtilisateurServlet.class.getName());
    private static final long serialVersionUID = 1L;

    private final UtilisateurDao utilisateurDao = new UtilisateurDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) {
            SessionUtil.setError(req, "Accès refusé : action réservée aux administrateurs.");
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        String action = req.getParameter("action");
        int    id     = parseId(req.getParameter("id"));

        Utilisateur me = SessionUtil.getUser(req);
        if (me.getId() == id) {
            SessionUtil.setError(req, "Vous ne pouvez pas modifier votre propre compte ici.");
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        switch (action == null ? "" : action) {

            case "delete" -> {
                try {
                    utilisateurDao.deleteById(id);
                    SessionUtil.setFlash(req, "Utilisateur supprimé avec succès.");
                } catch (SQLException e) {
                    LOG.log(Level.SEVERE, "deleteById user error", e);
                    SessionUtil.setError(req, "Impossible de supprimer cet utilisateur.");
                }
            }

            case "toggle" -> {
                try {
                    utilisateurDao.findById(id).ifPresentOrElse(u -> {
                        // Build updated user with flipped actif flag
                        Utilisateur updated = new Utilisateur(
                            u.getId(), u.getNom(), u.getPrenom(), u.getEmail(),
                            u.getMotDePasse(), u.getRole(), !u.isActif(), u.getCreatedAt()
                        );
                        try {
                            utilisateurDao.update(updated);
                            String state = updated.isActif() ? "activé" : "désactivé";
                            SessionUtil.setFlash(req, "Compte de " + u.getFullName() + " " + state + ".");
                        } catch (SQLException ex) {
                            LOG.log(Level.SEVERE, "toggle user error", ex);
                            SessionUtil.setError(req, "Erreur lors de la mise à jour.");
                        }
                    }, () -> SessionUtil.setError(req, "Utilisateur introuvable."));
                } catch (SQLException e) {
                    LOG.log(Level.SEVERE, "findById user error", e);
                    SessionUtil.setError(req, "Erreur de base de données.");
                }
            }

            default -> SessionUtil.setError(req, "Action inconnue.");
        }

        resp.sendRedirect(req.getContextPath() + "/dashboard");
    }

    private boolean isAdmin(HttpServletRequest req) {
        Utilisateur user = SessionUtil.getUser(req);
        return user != null && user.getRole() == Utilisateur.Role.ADMIN;
    }

    private int parseId(String s) {
        try { return Integer.parseInt(s); } catch (Exception e) { return 0; }
    }
}
