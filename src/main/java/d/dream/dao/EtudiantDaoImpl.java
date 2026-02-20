package d.dream.dao;

import d.dream.db.DatabaseConfig;
import d.dream.model.Etudiant;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public final class EtudiantDaoImpl implements EtudiantDao {

    private static final String SELECT_ALL =
        "SELECT id, matricule, nom, prenom, email, date_naissance, filiere, niveau, created_at " +
        "FROM etudiant ORDER BY nom, prenom";

    private static final String SELECT_BY_ID =
        "SELECT id, matricule, nom, prenom, email, date_naissance, filiere, niveau, created_at " +
        "FROM etudiant WHERE id = ?";

    private static final String SELECT_BY_MATRICULE =
        "SELECT id, matricule, nom, prenom, email, date_naissance, filiere, niveau, created_at " +
        "FROM etudiant WHERE matricule = ?";

    private static final String INSERT =
        "INSERT INTO etudiant (matricule, nom, prenom, email, date_naissance, filiere, niveau) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?)";

    private static final String UPDATE =
        "UPDATE etudiant SET matricule=?, nom=?, prenom=?, email=?, " +
        "date_naissance=?, filiere=?, niveau=? WHERE id=?";

    private static final String DELETE =
        "DELETE FROM etudiant WHERE id=?";

    private static final String COUNT_BY_MATRICULE =
        "SELECT COUNT(*) FROM etudiant WHERE matricule = ?";

    private static final String DISTINCT_FILIERES =
        "SELECT DISTINCT filiere FROM etudiant WHERE filiere IS NOT NULL AND filiere != '' ORDER BY filiere";

    private static final String DISTINCT_NIVEAUX =
        "SELECT DISTINCT niveau FROM etudiant WHERE niveau IS NOT NULL AND niveau != '' ORDER BY niveau";

    private Etudiant map(ResultSet rs) throws SQLException {
        Date dn = rs.getDate("date_naissance");
        return new Etudiant(
            rs.getInt("id"),
            rs.getString("matricule"),
            rs.getString("nom"),
            rs.getString("prenom"),
            rs.getString("email"),
            dn != null ? dn.toLocalDate() : null,
            rs.getString("filiere"),
            rs.getString("niveau"),
            rs.getTimestamp("created_at").toLocalDateTime()
        );
    }

    @Override
    public Etudiant save(Etudiant e) throws SQLException {
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, e.getMatricule());
            ps.setString(2, e.getNom());
            ps.setString(3, e.getPrenom());
            ps.setString(4, e.getEmail());
            ps.setDate(5, e.getDateNaissance() != null ? Date.valueOf(e.getDateNaissance()) : null);
            ps.setString(6, e.getFiliere());
            ps.setString(7, e.getNiveau());
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return findById(keys.getInt(1)).orElseThrow();
            }
            throw new SQLException("Insert failed — no generated key.");
        }
    }

    @Override
    public Optional<Etudiant> findById(Integer id) throws SQLException {
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_ID)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(map(rs)) : Optional.empty();
            }
        }
    }

    @Override
    public List<Etudiant> findAll() throws SQLException {
        List<Etudiant> list = new ArrayList<>();
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ALL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    @Override
    public Etudiant update(Etudiant e) throws SQLException {
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE)) {

            ps.setString(1, e.getMatricule());
            ps.setString(2, e.getNom());
            ps.setString(3, e.getPrenom());
            ps.setString(4, e.getEmail());
            ps.setDate(5, e.getDateNaissance() != null ? Date.valueOf(e.getDateNaissance()) : null);
            ps.setString(6, e.getFiliere());
            ps.setString(7, e.getNiveau());
            ps.setInt(8, e.getId());
            ps.executeUpdate();
            return e;
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
    public Optional<Etudiant> findByMatricule(String matricule) throws SQLException {
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_MATRICULE)) {
            ps.setString(1, matricule);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(map(rs)) : Optional.empty();
            }
        }
    }

    @Override
    public boolean matriculeExists(String matricule) throws SQLException {
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(COUNT_BY_MATRICULE)) {
            ps.setString(1, matricule);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    @Override
    public List<Etudiant> search(String nom, String filiere, String niveau) throws SQLException {

        StringBuilder sql = new StringBuilder(
            "SELECT id, matricule, nom, prenom, email, date_naissance, filiere, niveau, created_at " +
            "FROM etudiant WHERE 1=1"
        );

        List<Object> params = new ArrayList<>();

        if (nom != null && !nom.isBlank()) {
            sql.append(" AND (LOWER(nom) LIKE ? OR LOWER(prenom) LIKE ? OR LOWER(matricule) LIKE ?)");
            String like = "%" + nom.toLowerCase() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
        }
        if (filiere != null && !filiere.isBlank()) {
            sql.append(" AND filiere = ?");
            params.add(filiere);
        }
        if (niveau != null && !niveau.isBlank()) {
            sql.append(" AND niveau = ?");
            params.add(niveau);
        }

        sql.append(" ORDER BY nom, prenom");

        List<Etudiant> list = new ArrayList<>();
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    @Override
    public List<String> findDistinctFilieres() throws SQLException {
        List<String> list = new ArrayList<>();
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(DISTINCT_FILIERES);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(rs.getString(1));
        }
        return list;
    }

    @Override
    public List<String> findDistinctNiveaux() throws SQLException {
        List<String> list = new ArrayList<>();
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(DISTINCT_NIVEAUX);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(rs.getString(1));
        }
        return list;
    }
}
