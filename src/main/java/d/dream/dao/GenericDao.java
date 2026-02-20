package d.dream.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

/**
 * Generic CRUD contract.  Every concrete DAO implements this interface,
 * making it trivial to swap implementations 
 * without touching service or servlet code.
 *
 * @param <T>  entity type
 * @param <ID> primary-key type
 */
public interface GenericDao<T, ID> {

    T           save(T entity)           throws SQLException;
    Optional<T> findById(ID id)          throws SQLException;
    List<T>     findAll()                throws SQLException;
    T           update(T entity)         throws SQLException;
    void        deleteById(ID id)        throws SQLException;
}
