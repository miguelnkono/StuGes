package d.dream.servlet;

import d.dream.dao.EtudiantDao;
import d.dream.dao.EtudiantDaoImpl;
import d.dream.model.Etudiant;
import d.dream.model.Utilisateur;
import d.dream.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Handles CRUD operations for students.
 *
 * Permissions:
 *   ADMIN      → add, edit, delete
 *   SECRETAIRE → add, edit only (no delete)
 *
 * Routes:
 *   GET  /etudiants?action=add        → show add form
 *   GET  /etudiants?action=edit&id=   → show edit form
 *   GET  /etudiants?action=delete&id= → delete (ADMIN only)
 *   POST /etudiants?action=add        → save new student
 *   POST /etudiants?action=edit       → update student
 */
@WebServlet("/etudiants")
public class EtudiantServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(EtudiantServlet.class.getName());
    private static final long serialVersionUID = 1L;

    private final EtudiantDao etudiantDao = new EtudiantDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        switch (action == null ? "" : action) {

            case "add" ->
                req.getRequestDispatcher("/WEB-INF/jsp/etudiant-form.jsp").forward(req, resp);

            case "edit" -> {
                int id = parseId(req.getParameter("id"));
                try {
                    etudiantDao.findById(id).ifPresentOrElse(
                        e -> req.setAttribute("etudiant", e),
                        () -> SessionUtil.setError(req, "Étudiant introuvable.")
                    );
                } catch (SQLException e) {
                    LOG.log(Level.SEVERE, "findById error", e);
                    SessionUtil.setError(req, "Erreur de base de données.");
                }
                req.getRequestDispatcher("/WEB-INF/jsp/etudiant-form.jsp").forward(req, resp);
            }

            case "delete" -> {
                if (!isAdmin(req)) {
                    SessionUtil.setError(req, "Accès refusé : seul un administrateur peut supprimer un étudiant.");
                    resp.sendRedirect(req.getContextPath() + "/dashboard");
                    return;
                }
                int id = parseId(req.getParameter("id"));
                try {
                    etudiantDao.deleteById(id);
                    SessionUtil.setFlash(req, "Étudiant supprimé avec succès.");
                } catch (SQLException e) {
                    LOG.log(Level.SEVERE, "deleteById error", e);
                    SessionUtil.setError(req, "Impossible de supprimer cet étudiant.");
                }
                resp.sendRedirect(req.getContextPath() + "/dashboard");
            }

            default -> resp.sendRedirect(req.getContextPath() + "/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("add".equals(action)) {
            handleSave(req, resp, false);
        } else if ("edit".equals(action)) {
            handleSave(req, resp, true);
        } else {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
        }
    }

    private void handleSave(HttpServletRequest req, HttpServletResponse resp, boolean isEdit)
            throws ServletException, IOException {

        String matricule = trim(req.getParameter("matricule"));
        String nom       = trim(req.getParameter("nom"));
        String prenom    = trim(req.getParameter("prenom"));
        String email     = trim(req.getParameter("email"));
        String filiere   = trim(req.getParameter("filiere"));
        String niveau    = trim(req.getParameter("niveau"));
        String dateStr   = trim(req.getParameter("dateNaissance"));
        int    id        = parseId(req.getParameter("id"));

        if (nom.isEmpty() || prenom.isEmpty() || matricule.isEmpty()) {
            req.setAttribute("error", "Nom, prénom et matricule sont obligatoires.");
            req.setAttribute("matricule", matricule);
            req.setAttribute("nom",     nom);
            req.setAttribute("prenom",  prenom);
            req.setAttribute("email",   email);
            req.setAttribute("filiere", filiere);
            req.setAttribute("niveau",  niveau);
            req.getRequestDispatcher("/WEB-INF/jsp/etudiant-form.jsp").forward(req, resp);
            return;
        }

        LocalDate dateNaissance = null;
        if (!dateStr.isEmpty()) {
            try { dateNaissance = LocalDate.parse(dateStr); } catch (Exception ignored) {}
        }

        Etudiant etudiant = new Etudiant(
            id, matricule, nom, prenom,
            email.isEmpty() ? null : email,
            dateNaissance, filiere, niveau,
            LocalDateTime.now()
        );

        try {
            if (isEdit) {
                etudiantDao.update(etudiant);
                SessionUtil.setFlash(req, "Étudiant mis à jour avec succès.");
            } else {
                if (etudiantDao.matriculeExists(matricule)) {
                    req.setAttribute("error", "Ce matricule est déjà utilisé.");
                    req.setAttribute("etudiant", etudiant);
                    req.getRequestDispatcher("/WEB-INF/jsp/etudiant-form.jsp").forward(req, resp);
                    return;
                }
                etudiantDao.save(etudiant);
                SessionUtil.setFlash(req, "Étudiant ajouté avec succès.");
            }
            resp.sendRedirect(req.getContextPath() + "/dashboard");

        } catch (SQLException e) {
            LOG.log(Level.SEVERE, "Erreur lors de la sauvegarde étudiant", e);
            req.setAttribute("error", "Erreur de base de données. Veuillez réessayer.");
            req.setAttribute("etudiant", etudiant);
            req.getRequestDispatcher("/WEB-INF/jsp/etudiant-form.jsp").forward(req, resp);
        }
    }

    /** Returns true only if the connected user has the ADMIN role. */
    private boolean isAdmin(HttpServletRequest req) {
        Utilisateur user = SessionUtil.getUser(req);
        return user != null && user.getRole() == Utilisateur.Role.ADMIN;
    }

    private int parseId(String s) {
        try { return Integer.parseInt(s); } catch (Exception e) { return 0; }
    }

    private String trim(String s) { return s == null ? "" : s.trim(); }
}
