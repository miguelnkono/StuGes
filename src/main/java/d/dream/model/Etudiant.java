package d.dream.model;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

public final class Etudiant implements Serializable {

    private static final long serialVersionUID = 1L;

    private final int           id;
    private final String        matricule;
    private final String        nom;
    private final String        prenom;
    private final String        email;
    private final LocalDate     dateNaissance;
    private final String        filiere;
    private final String        niveau;
    private final LocalDateTime createdAt;

    public Etudiant(int id, String matricule, String nom, String prenom,
                    String email, LocalDate dateNaissance,
                    String filiere, String niveau, LocalDateTime createdAt) {
        this.id            = id;
        this.matricule     = matricule;
        this.nom           = nom;
        this.prenom        = prenom;
        this.email         = email;
        this.dateNaissance = dateNaissance;
        this.filiere       = filiere;
        this.niveau        = niveau;
        this.createdAt     = createdAt;
    }

    public int           getId()            { return id; }
    public String        getMatricule()     { return matricule; }
    public String        getNom()           { return nom; }
    public String        getPrenom()        { return prenom; }
    public String        getFullName()      { return prenom + " " + nom; }
    public String        getEmail()         { return email; }
    public LocalDate     getDateNaissance() { return dateNaissance; }
    public String        getFiliere()       { return filiere; }
    public String        getNiveau()        { return niveau; }
    public LocalDateTime getCreatedAt()     { return createdAt; }

    @Override
    public String toString() {
        return "Etudiant[id=%d, matricule=%s]".formatted(id, matricule);
    }
}
