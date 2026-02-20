package d.dream.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import d.dream.db.DatabaseConfig;
import d.dream.model.Utilisateur;
import d.dream.model.Utilisateur.Role;

public final class UtilisateurDaoImpl implements UtilisateurDao {

    private static final String SELECT_ALL =
        "SELECT id, nom, prenom, email, mot_de_passe, role, actif, created_at FROM utilisateur";

    private static final String SELECT_BY_ID =
        SELECT_ALL + " WHERE id = ?";

    private static final String SELECT_BY_EMAIL =
        SELECT_ALL + " WHERE email = ?";

    private static final String INSERT =
        "INSERT INTO utilisateur (nom, prenom, email, mot_de_passe, role) VALUES (?, ?, ?, ?, ?)";

    private static final String UPDATE =
        "UPDATE utilisateur SET nom=?, prenom=?, email=?, mot_de_passe=?, role=?, actif=? WHERE id=?";

    private static final String DELETE =
        "DELETE FROM utilisateur WHERE id=?";

    private static final String COUNT_BY_EMAIL =
        "SELECT COUNT(*) FROM utilisateur WHERE email = ?";

    private Utilisateur map(ResultSet rs) throws SQLException {
        return new Utilisateur(
            rs.getInt("id"),
            rs.getString("nom"),
            rs.getString("prenom"),
            rs.getString("email"),
            rs.getString("mot_de_passe"),
            Role.valueOf(rs.getString("role")),
            rs.getBoolean("actif"),
            rs.getTimestamp("created_at").toLocalDateTime()
        );
    }

    @Override
    public Utilisateur save(Utilisateur u) throws SQLException {
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, u.getNom());
            ps.setString(2, u.getPrenom());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getMotDePasse());
            ps.setString(5, u.getRole().name());
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return findById(keys.getInt(1)).orElseThrow();
                }
            }
            throw new SQLException("Insert failed — no generated key returned.");
        }
    }

    @Override
    public Optional<Utilisateur> findById(Integer id) throws SQLException {
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_ID)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(map(rs)) : Optional.empty();
            }
        }
    }

    @Override
    public List<Utilisateur> findAll() throws SQLException {
        List<Utilisateur> list = new ArrayList<>();
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ALL);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    @Override
    public Utilisateur update(Utilisateur u) throws SQLException {
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE)) {

            ps.setString(1, u.getNom());
            ps.setString(2, u.getPrenom());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getMotDePasse());
            ps.setString(5, u.getRole().name());
            ps.setBoolean(6, u.isActif());
            ps.setInt(7, u.getId());
            ps.executeUpdate();
            return u;
        }
    }

    @Override
    public void deleteById(Integer id) throws SQLException {
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE)) {

            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    @Override
    public Optional<Utilisateur> findByEmail(String email) throws SQLException {
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_EMAIL)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(map(rs)) : Optional.empty();
            }
        }
    }

    @Override
    public boolean emailExists(String email) throws SQLException {
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(COUNT_BY_EMAIL)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }
}
