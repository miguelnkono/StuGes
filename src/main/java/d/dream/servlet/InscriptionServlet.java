package d.dream.servlet;

import d.dream.dao.UtilisateurDao;
import d.dream.dao.UtilisateurDaoImpl;
import d.dream.model.Utilisateur;
import d.dream.model.Utilisateur.Role;
import d.dream.util.PasswordUtil;
import d.dream.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Handles:
 *   GET  /inscription → show registration form
 *   POST /inscription → create a new Utilisateur account
 */
@WebServlet("/inscription")
public class InscriptionServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(InscriptionServlet.class.getName());
    private static final long serialVersionUID = 1L;

    private final UtilisateurDao utilisateurDao = new UtilisateurDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/jsp/inscription.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String nom        = trim(req.getParameter("nom"));
        String prenom     = trim(req.getParameter("prenom"));
        String email      = trim(req.getParameter("email")).toLowerCase();
        String password   = req.getParameter("motDePasse");
        String confirm    = req.getParameter("confirmerMotDePasse");
        String roleParam  = trim(req.getParameter("role"));

        String validationError = validate(nom, prenom, email, password, confirm);
        if (validationError != null) {
            req.setAttribute("error", validationError);
            repopulate(req, nom, prenom, email, roleParam);
            req.getRequestDispatcher("/WEB-INF/jsp/inscription.jsp").forward(req, resp);
            return;
        }

        Role role;
        try {
            role = Role.valueOf(roleParam.toUpperCase());
        } catch (Exception e) {
            role = Role.SECRETAIRE;
        }

        try {
            if (utilisateurDao.emailExists(email)) {
                req.setAttribute("error", "Cet email est déjà utilisé.");
                repopulate(req, nom, prenom, email, roleParam);
                req.getRequestDispatcher("/WEB-INF/jsp/inscription.jsp").forward(req, resp);
                return;
            }

            Utilisateur newUser = new Utilisateur(
                0, nom, prenom, email,
                PasswordUtil.hash(password),
                role, true, LocalDateTime.now()
            );
            utilisateurDao.save(newUser);

            SessionUtil.setFlash(req, "Compte créé avec succès ! Vous pouvez maintenant vous connecter.");
            resp.sendRedirect(req.getContextPath() + "/auth");

        } catch (SQLException e) {
            LOG.log(Level.SEVERE, "Erreur lors de l'inscription", e);
            req.setAttribute("error", "Erreur interne. Veuillez réessayer.");
            repopulate(req, nom, prenom, email, roleParam);
            req.getRequestDispatcher("/WEB-INF/jsp/inscription.jsp").forward(req, resp);
        }
    }

    private String validate(String nom, String prenom, String email,
                            String password, String confirm) {
        if (nom.isEmpty() || prenom.isEmpty() || email.isEmpty())
            return "Tous les champs sont obligatoires.";
        if (!email.matches("^[\\w.+-]+@[\\w-]+\\.[\\w.]+$"))
            return "L'adresse email n'est pas valide.";
        if (password == null || password.length() < 8)
            return "Le mot de passe doit contenir au moins 8 caractères.";
        if (!password.equals(confirm))
            return "Les mots de passe ne correspondent pas.";
        return null;
    }

    private void repopulate(HttpServletRequest req, String nom, String prenom,
                            String email, String role) {
        req.setAttribute("nom",    nom);
        req.setAttribute("prenom", prenom);
        req.setAttribute("email",  email);
        req.setAttribute("role",   role);
    }

    private String trim(String s) { return s == null ? "" : s.trim(); }
}
