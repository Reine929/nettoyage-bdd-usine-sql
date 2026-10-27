-- Nettoyage de la base de l'usine.
-- À exécuter après 01_schema.sql et 02_donnees_brutes.sql.
-- Les valeurs de remplacement (marquées "choix") sont des hypothèses faites pour l'exercice.

BEGIN;

-- =====================================================================
-- TABLE client
-- =====================================================================

-- Email vide : un client peut ne pas en donner, donc NULL plutôt qu'une chaîne vide
UPDATE client SET email = NULL WHERE id = 4;

-- Email incomplet complété (choix : exercice)
UPDATE client SET email = 'bernard@gmail.com' WHERE id = 6;

-- Numéro mal renseigné remplacé (choix : exercice)
UPDATE client SET num = '0744637892' WHERE id = 7;

-- Espaces inutiles retirés
UPDATE client SET num = TRIM(num);

-- Mêmes règles d'écriture pour les noms, pour que les doublons soient détectés (Dupont / DUPONT)
UPDATE client SET nom = INITCAP(TRIM(nom));

-- Doublons : on garde le plus petit id de chaque couple (nom, email).
-- Avant de supprimer, on rattache les commandes et les matières au client conservé,
-- sinon les clés étrangères empêcheraient la suppression.
CREATE TEMP TABLE client_a_garder AS
SELECT id,
       MIN(id) OVER (PARTITION BY nom, email) AS id_garde
FROM client;

UPDATE commande c SET id_client = g.id_garde
FROM client_a_garder g
WHERE c.id_client = g.id AND g.id <> g.id_garde;

UPDATE matiere m SET id_client = g.id_garde
FROM client_a_garder g
WHERE m.id_client = g.id AND g.id <> g.id_garde;

DELETE FROM client c
USING client_a_garder g
WHERE c.id = g.id AND g.id <> g.id_garde;

-- =====================================================================
-- TABLE commande
-- =====================================================================

-- Poids et quantité négatifs corrigés (choix : valeurs positives)
UPDATE commande SET poids = '5', qte = '10' WHERE id = 11;

-- Matière et état manquants complétés (choix : exercice)
UPDATE commande SET matiere = 'Bois'     WHERE id = 12 AND matiere IS NULL;
UPDATE commande SET etat    = 'terminee' WHERE id = 12 AND (etat IS NULL OR TRIM(etat) = '');

-- Écriture uniforme : première lettre de chaque mot en majuscule
UPDATE commande SET produit = INITCAP(TRIM(produit)),
                    matiere = INITCAP(TRIM(matiere)),
                    etat    = INITCAP(TRIM(etat));

-- Bons types de colonnes
ALTER TABLE commande ALTER COLUMN poids TYPE NUMERIC(10,2) USING poids::NUMERIC;
ALTER TABLE commande ALTER COLUMN qte   TYPE SMALLINT      USING qte::SMALLINT;

-- État limité à une liste de valeurs (type énuméré)
CREATE TYPE enum_statut AS ENUM ('En_Cours', 'Terminee');
ALTER TABLE commande ALTER COLUMN etat TYPE enum_statut USING etat::enum_statut;

-- La matière devient obligatoire
ALTER TABLE commande ALTER COLUMN matiere SET NOT NULL;

-- =====================================================================
-- TABLE machine
-- =====================================================================

-- Nom et statut manquants complétés (choix : exercice)
UPDATE machine SET nom = 'Machine B' WHERE id = 5 AND TRIM(nom) = '';
UPDATE machine SET statut = 'panne'  WHERE id = 4 AND statut IS NULL;

-- Écriture uniforme
UPDATE machine SET nom = INITCAP(TRIM(nom)), statut = INITCAP(TRIM(statut));

-- Statut limité à une liste de valeurs
CREATE TYPE enum_statut_machine AS ENUM ('Disponible', 'Panne', 'Maintenance');
ALTER TABLE machine ALTER COLUMN statut TYPE enum_statut_machine USING statut::enum_statut_machine;

-- =====================================================================
-- TABLE produits
-- =====================================================================

-- Nom manquant complété (choix : exercice), puis écriture uniforme
UPDATE produits SET nom = 'produit z' WHERE id = 19 AND TRIM(COALESCE(nom, '')) = '';
UPDATE produits SET nom = INITCAP(TRIM(nom));

-- =====================================================================
-- TABLE matiere
-- =====================================================================

-- Quantité négative corrigée, quantité manquante mise à 0 (choix : exercice)
UPDATE matiere SET qte = 50 WHERE qte < 0;
UPDATE matiere SET qte = 0  WHERE qte IS NULL;

-- Nom manquant complété (choix : exercice), puis écriture uniforme
UPDATE matiere SET nom = 'plastique' WHERE TRIM(nom) = '';
UPDATE matiere SET nom = INITCAP(TRIM(nom));

-- Doublons : on garde le plus petit id de chaque couple (nom, client)
DELETE FROM matiere m
USING (
  SELECT id,
         ROW_NUMBER() OVER (PARTITION BY nom, id_client ORDER BY id) AS rn
  FROM matiere
) d
WHERE m.id = d.id AND d.rn > 1;

COMMIT;
