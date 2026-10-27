-- Schéma de la base de données d'une usine : clients, commandes, machines, matières, produits.
-- Le schéma relationnel est dans schema_bdd.png.
-- Les colonnes sont volontairement permissives (texte libre, valeurs NULL autorisées) :
-- le TP consiste à nettoyer les données puis à resserrer les types et les contraintes (voir 03_nettoyage.sql).

DROP TABLE IF EXISTS produits, matiere, commande, machine, client CASCADE;

CREATE TABLE client (
  id    BIGINT PRIMARY KEY,
  nom   VARCHAR(255) NOT NULL,
  num   VARCHAR(50),
  email VARCHAR(255)
);

CREATE TABLE machine (
  id     BIGINT PRIMARY KEY,
  nom    VARCHAR(255) NOT NULL,
  statut VARCHAR(50)
);

CREATE TABLE commande (
  id         BIGINT PRIMARY KEY,
  id_machine BIGINT REFERENCES machine(id),
  id_client  BIGINT REFERENCES client(id),
  produit    VARCHAR(255),
  poids      VARCHAR(255),
  matiere    VARCHAR(255),
  qte        VARCHAR(255),
  etat       VARCHAR(50)
);

CREATE TABLE matiere (
  id        BIGINT PRIMARY KEY,
  nom       VARCHAR(255),
  qte       INTEGER,
  id_client BIGINT REFERENCES client(id)
);

CREATE TABLE produits (
  id          BIGINT PRIMARY KEY,
  nom         VARCHAR(255),
  id_commande BIGINT REFERENCES commande(id),
  qte         INTEGER
);
