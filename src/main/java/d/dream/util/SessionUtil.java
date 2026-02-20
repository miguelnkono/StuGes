package d.dream.util;

import d.dream.model.Utilisateur;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/**
 * Centralises all session-attribute names and helper methods.
 * Change a constant here and all servlets stay consistent.
 */
public final class SessionUtil {

    public static final String USER_KEY    = "connectedUser";
    public static final String MESSAGE_KEY = "flashMessage";
    public static final String ERROR_KEY   = "flashError";

    private SessionUtil() {}

    /** Returns the authenticated user or {@code null} if not logged in. */
    public static Utilisateur getUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return session == null ? null : (Utilisateur) session.getAttribute(USER_KEY);
    }

    /** Returns {@code true} if there is a valid authenticated session. */
    public static boolean isAuthenticated(HttpServletRequest req) {
        return getUser(req) != null;
    }

    /** Stores the user in the session (creates session if needed). */
    public static void login(HttpServletRequest req, Utilisateur user) {
        HttpSession session = req.getSession(true);
        session.setMaxInactiveInterval(30 * 60); 
        session.setAttribute(USER_KEY, user);
    }

    /** Invalidates the session completely. */
    public static void logout(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session != null) session.invalidate();
    }

    /** Stores a one-shot success message consumed on the next request. */
    public static void setFlash(HttpServletRequest req, String message) {
        req.getSession(true).setAttribute(MESSAGE_KEY, message);
    }

    /** Stores a one-shot error message consumed on the next request. */
    public static void setError(HttpServletRequest req, String error) {
        req.getSession(true).setAttribute(ERROR_KEY, error);
    }
}
