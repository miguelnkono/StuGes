# 🎓 GesEtu — Student Management System

A Java EE web application built with **Servlets + JSP + MySQL**, following clean MVC
architecture and best practices for easy extension.

---

## Architecture

```
src/main/
├── java/d/dream/
│   ├── db/
│   │   └── DatabaseConfig.java       ← Thread-safe JDBC singleton
│   ├── model/
│   │   ├── Utilisateur.java          ← User value-object (immutable)
│   │   └── Etudiant.java             ← Student value-object (immutable)
│   ├── dao/
│   │   ├── GenericDao.java           ← CRUD interface (generic)
│   │   ├── UtilisateurDao.java       ← User-specific queries
│   │   ├── UtilisateurDaoImpl.java   ← JDBC implementation
│   │   ├── EtudiantDao.java          ← Student-specific queries
│   │   └── EtudiantDaoImpl.java      ← JDBC implementation
│   ├── servlet/
│   │   ├── AuthServlet.java          ← /auth  (login / logout)
│   │   ├── InscriptionServlet.java   ← /inscription
│   │   ├── DashboardServlet.java     ← /  (main dashboard)
│   │   └── EtudiantServlet.java      ← /etudiants (CRUD)
│   ├── filter/
│   │   └── AuthFilter.java           ← Session guard on all routes
│   └── util/
│       ├── SessionUtil.java          ← Session key constants + helpers
│       └── PasswordUtil.java         ← BCrypt hash/verify
└── webapp/
    ├── index.jsp                     ← Root redirect
    └── WEB-INF/
        ├── web.xml
        └── jsp/
            ├── authentification.jsp
            ├── inscription.jsp
            ├── index.jsp             ← Dashboard view
            ├── etudiant-form.jsp     ← Add/Edit student
            ├── fragments/
            │   └── navbar.jsp
            └── error/
                ├── 404.jsp
                └── 500.jsp
```

### Design Patterns Used

| Pattern | Where |
|---------|-------|
| **MVC** | Servlets (controller) → DAOs (model) → JSPs (view) |
| **DAO + Interface** | `GenericDao<T,ID>` + concrete impls |
| **Singleton** | `DatabaseConfig` |
| **Filter Chain** | `AuthFilter` protects all routes |
| **Template Method** | `HttpServlet.doGet/doPost` |
| **Async / CompletableFuture** | `DashboardServlet` loads users + students in parallel |

---

## Prerequisites

| Tool | Version |
|------|---------|
| JDK | 17+ |
| Tomcat | 10.1+ (Jakarta EE 10) |
| MySQL | 8.0+ |
| Eclipse / IntelliJ | Any recent version |

---

## Setup

### 1. Database

```sql
-- Run the schema script
mysql -u root -p < schema.sql
```

This creates the `student_management` database, tables, and seeds two users
(password `Admin1234!` for both) and two students.

### 2. Configure DB credentials

Edit `DatabaseConfig.java` **or** set environment variables:

```bash
export DB_URL="jdbc:mysql://localhost:3306/student_management?useSSL=false&serverTimezone=UTC"
export DB_USER="your_user"
export DB_PASS="your_password"
```

### 3. Add the MySQL JDBC driver

Copy `mysql-connector-j-9.5.0.jar` to:
```
src/main/webapp/WEB-INF/lib/mysql-connector-j-9.5.0.jar
```

### 4. Deploy to Tomcat

#### Eclipse
1. Right-click project → **Properties → Project Facets** → enable **Dynamic Web Module 6.0**
2. Right-click project → **Run As → Run on Server** → choose Tomcat 10.1

#### Maven (if you add pom.xml)
```bash
mvn package
cp target/StudentManagement.war $CATALINA_HOME/webapps/
```

---

## URL Routes

| Method | URL | Description |
|--------|-----|-------------|
| GET | `/` | Dashboard (protected) |
| GET | `/auth` | Login page |
| POST | `/auth` | Process login |
| GET | `/auth?action=logout` | Logout |
| GET | `/inscription` | Registration form |
| POST | `/inscription` | Create account |
| GET | `/etudiants?action=add` | Add student form |
| POST | `/etudiants?action=add` | Save new student |
| GET | `/etudiants?action=edit&id=N` | Edit student form |
| POST | `/etudiants?action=edit` | Update student |
| GET | `/etudiants?action=delete&id=N` | Delete student |

---

## Security

- Passwords stored as **BCrypt** hashes (work factor 12)
- `AuthFilter` redirects all unauthenticated requests to `/auth`
- Session timeout: 30 minutes (COOKIE tracking, HttpOnly)
- Input trimmed and validated server-side on every form
- No raw SQL concatenation — all queries use `PreparedStatement`

---

## Extending the Project

### Add a new entity (e.g. `Cours`)

1. Create `model/Cours.java`
2. Create `dao/CoursDao.java` extending `GenericDao<Cours, Integer>`
3. Create `dao/CoursDaoImpl.java`
4. Create `servlet/CoursServlet.java` → `@WebServlet("/cours")`
5. Create `WEB-INF/jsp/cours-form.jsp` and add a row in `index.jsp`

### Switch to a connection pool (recommended for production)

Replace the body of `DatabaseConfig.getConnection()` with HikariCP:

```xml
<!-- pom.xml -->
<dependency>
  <groupId>com.zaxxer</groupId>
  <artifactId>HikariCP</artifactId>
  <version>5.1.0</version>
</dependency>
```

```java
// DatabaseConfig.java — swap getConnection() only
private static final HikariDataSource DS;
static {
    HikariConfig cfg = new HikariConfig();
    cfg.setJdbcUrl(URL); cfg.setUsername(USER); cfg.setPassword(PASSWORD);
    DS = new HikariDataSource(cfg);
}
public Connection getConnection() throws SQLException { return DS.getConnection(); }
```

No other code changes needed — callers use the same `getConnection()` API.

---

## Default Credentials

| Email | Password | Role |
|-------|----------|------|
| alice@school.cm | Admin1234! | ADMIN |
| bruno@school.cm | Admin1234! | SECRETAIRE |

> ⚠️ Change these immediately in production!
