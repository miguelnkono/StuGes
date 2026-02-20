package d.dream.model;

import java.io.Serializable;
import java.time.LocalDateTime;

public final class Utilisateur implements Serializable {

    private static final long serialVersionUID = 1L;

    public enum Role { ADMIN, SECRETAIRE }

    private final int           id;
    private final String        nom;
    private final String        prenom;
    private final String        email;
    private final String        motDePasse;
    private final Role          role;
    private final boolean       actif;
    private final LocalDateTime createdAt;

    public Utilisateur(int id, String nom, String prenom, String email,
                       String motDePasse, Role role, boolean actif,
                       LocalDateTime createdAt) {
        this.id          = id;
        this.nom         = nom;
        this.prenom      = prenom;
        this.email       = email;
        this.motDePasse  = motDePasse;
        this.role        = role;
        this.actif       = actif;
        this.createdAt   = createdAt;
    }

    public int           getId()          { return id; }
    public String        getNom()         { return nom; }
    public String        getPrenom()      { return prenom; }
    public String        getFullName()    { return prenom + " " + nom; }
    public String        getEmail()       { return email; }
    public String        getMotDePasse()  { return motDePasse; }
    public Role          getRole()        { return role; }
    public boolean       isActif()        { return actif; }
    public LocalDateTime getCreatedAt()   { return createdAt; }

    @Override
    public String toString() {
        return "Utilisateur[id=%d, email=%s, role=%s]".formatted(id, email, role);
    }
}
