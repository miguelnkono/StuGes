CREATE DATABASE IF NOT EXISTS student_management
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE student_management;

-- ─── utilisateur ───
CREATE TABLE IF NOT EXISTS utilisateur (
    id          INT          NOT NULL AUTO_INCREMENT,
    nom         VARCHAR(100) NOT NULL,
    prenom      VARCHAR(100) NOT NULL,
    email       VARCHAR(150) NOT NULL UNIQUE,
    mot_de_passe VARCHAR(255) NOT NULL,        -- BCrypt hash
    role        ENUM('ADMIN','SECRETAIRE') NOT NULL DEFAULT 'SECRETAIRE',
    actif       BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE=InnoDB;

-- ─── etudiant ───
CREATE TABLE IF NOT EXISTS etudiant (
    id          INT          NOT NULL AUTO_INCREMENT,
    matricule   VARCHAR(20)  NOT NULL UNIQUE,
    nom         VARCHAR(100) NOT NULL,
    prenom      VARCHAR(100) NOT NULL,
    email       VARCHAR(150)          UNIQUE,
    date_naissance DATE,
    filiere     VARCHAR(100),
    niveau      VARCHAR(50),
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE=InnoDB;

-- ─── Seed Data ───
-- Password for both users: "Admin1234!" (BCrypt hash below)
INSERT INTO utilisateur (nom, prenom, email, mot_de_passe, role) VALUES
  ('Dupont',  'Alice',  'alice@school.cm',  '$2a$12$K.3IcbzwM4A5TtH9I/WdYeq1c7e0M0Wqp0VC1AKj4EqC3lqkC9Dlu', 'ADMIN'),
  ('Nguema',  'Bruno',  'bruno@school.cm',  '$2a$12$K.3IcbzwM4A5TtH9I/WdYeq1c7e0M0Wqp0VC1AKj4EqC3lqkC9Dlu', 'SECRETAIRE');

INSERT INTO etudiant (matricule, nom, prenom, email, date_naissance, filiere, niveau) VALUES
  ('STU-001', 'Mvondo', 'Jean',   'jean.mvondo@etu.cm',   '2002-03-15', 'Informatique',  'L2'),
  ('STU-002', 'Biyong', 'Claire', 'claire.biyong@etu.cm', '2001-07-22', 'Mathématiques', 'L3');
