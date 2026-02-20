package d.dream.dao;

import d.dream.model.Utilisateur;

import java.sql.SQLException;
import java.util.Optional;

public interface UtilisateurDao extends GenericDao<Utilisateur, Integer> {

    Optional<Utilisateur> findByEmail(String email) throws SQLException;

    boolean emailExists(String email) throws SQLException;
}
