package d.dream.servlet;

import d.dream.dao.EtudiantDao;
import d.dream.dao.EtudiantDaoImpl;
import d.dream.dao.UtilisateurDao;
import d.dream.dao.UtilisateurDaoImpl;
import d.dream.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Main dashboard.
 * Supports optional search/filter params: nom, filiere, niveau.
 * All DB queries run concurrently via CompletableFuture.
 */
@WebServlet({"/", "/dashboard"})
public class DashboardServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(DashboardServlet.class.getName());
    private static final long serialVersionUID = 1L;

    private final UtilisateurDao utilisateurDao = new UtilisateurDaoImpl();
    private final EtudiantDao    etudiantDao    = new EtudiantDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session != null) {
            Object flash = session.getAttribute(SessionUtil.MESSAGE_KEY);
            Object error = session.getAttribute(SessionUtil.ERROR_KEY);
            if (flash != null) { req.setAttribute("flash",      flash); session.removeAttribute(SessionUtil.MESSAGE_KEY); }
            if (error != null) { req.setAttribute("flashError", error); session.removeAttribute(SessionUtil.ERROR_KEY);   }
        }

        String nomFilter     = trim(req.getParameter("nom"));
        String filiereFilter = trim(req.getParameter("filiere"));
        String niveauFilter  = trim(req.getParameter("niveau"));

        boolean isFiltered = !nomFilter.isEmpty() || !filiereFilter.isEmpty() || !niveauFilter.isEmpty();

        // Pass filter values back to the view for sticky form fields
        req.setAttribute("filterNom",     nomFilter);
        req.setAttribute("filterFiliere", filiereFilter);
        req.setAttribute("filterNiveau",  niveauFilter);
        req.setAttribute("isFiltered",    isFiltered);

        // ── Parallel DB queries ────────────────────────────────────────────────
        final String nom     = nomFilter;
        final String filiere = filiereFilter;
        final String niveau  = niveauFilter;

        CompletableFuture<Object> usersFuture = CompletableFuture.supplyAsync(() -> {
            try { return utilisateurDao.findAll(); }
            catch (SQLException e) { throw new RuntimeException(e); }
        });

        CompletableFuture<Object> etudiantsFuture = CompletableFuture.supplyAsync(() -> {
            try {
                return isFiltered
                    ? etudiantDao.search(nom, filiere, niveau)
                    : etudiantDao.findAll();
            } catch (SQLException e) { throw new RuntimeException(e); }
        });

        CompletableFuture<Object> filieresFuture = CompletableFuture.supplyAsync(() -> {
            try { return etudiantDao.findDistinctFilieres(); }
            catch (SQLException e) { throw new RuntimeException(e); }
        });

        CompletableFuture<Object> niveauxFuture = CompletableFuture.supplyAsync(() -> {
            try { return etudiantDao.findDistinctNiveaux(); }
            catch (SQLException e) { throw new RuntimeException(e); }
        });

        try {
            req.setAttribute("utilisateurs",     usersFuture.get());
            req.setAttribute("etudiants",        etudiantsFuture.get());
            req.setAttribute("filieres",         filieresFuture.get());
            req.setAttribute("niveaux",          niveauxFuture.get());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            handleError(req, resp, e);
            return;
        } catch (ExecutionException e) {
            handleError(req, resp, e.getCause());
            return;
        }

        req.getRequestDispatcher("/WEB-INF/jsp/index.jsp").forward(req, resp);
    }

    private void handleError(HttpServletRequest req, HttpServletResponse resp, Throwable e)
            throws ServletException, IOException {
        LOG.log(Level.SEVERE, "Erreur de chargement du tableau de bord", e);
        req.setAttribute("dbError", "Impossible de charger les données. Veuillez réessayer.");
        req.getRequestDispatcher("/WEB-INF/jsp/index.jsp").forward(req, resp);
    }

    private String trim(String s) { return s == null ? "" : s.trim(); }
}
