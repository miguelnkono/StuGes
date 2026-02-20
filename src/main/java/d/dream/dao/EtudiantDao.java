package d.dream.dao;

import d.dream.model.Etudiant;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface EtudiantDao extends GenericDao<Etudiant, Integer> {

    Optional<Etudiant> findByMatricule(String matricule) throws SQLException;

    boolean matriculeExists(String matricule) throws SQLException;

    /**
     * fonction pour rechercher un utilisateur en fonction de son nom, filiere et niveau.
     * */
    List<Etudiant> search(String nom, String filiere, String niveau) throws SQLException;

    List<String> findDistinctFilieres() throws SQLException;

    List<String> findDistinctNiveaux() throws SQLException;
}
