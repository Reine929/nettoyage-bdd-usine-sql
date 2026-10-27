-- Données brutes (volontairement sales) du TP de nettoyage : doublons, valeurs négatives, valeurs vides, casse incohérente.

INSERT INTO client VALUES
  (1, 'Dupont', '0123456789', 'dupont@gmail.com'),
  (2, 'DUPONT', '123456789', 'dupont@gmail.com'),
  (3, 'Martin', NULL, 'martin@@yahoo.fr'),
  (4, 'Durand', '06 12 34 56 78', ''),
  (5, '   ', '0000000000', 'noemail'),
  (6, 'Bernard', '0612345678', 'bernard@'),
  (7, 'Smith', 'abcdef', 'smith@gmail.com');

INSERT INTO machine VALUES
  (1, 'Machine A', 'disponible'),
  (2, 'machine a', 'Disponible'),
  (3, 'Machine B', 'panne'),
  (4, 'Machine C', NULL),
  (5, ' ', 'maintenance');

INSERT INTO commande VALUES
  (9, 1, 1, 'Produit X', '12.5', 'Acier', '100', 'en_cours'),
  (10, 1, 2, 'produit x', '12', 'acier', '100', 'En_cours'),
  (11, 2, 3, 'Produit Y', '-5', 'Plastique', '-10', 'terminee'),
  (12, 2, 4, 'Produit Z', '20', NULL, '50', '');

INSERT INTO matiere VALUES
  (1, 'Acier', 1000, 1),
  (2, 'acier', 1000, 1),
  (3, 'Plastique', -50, 2),
  (4, 'Bois', NULL, 3),
  (5, '   ', 200, 4),
  (6, 'Acier', 1000, 1),
  (7, 'acier', 1000, 1),
  (8, 'Plastique', -50, 2),
  (9, 'Bois', NULL, 3),
  (10, '   ', 200, 4);

INSERT INTO produits VALUES
  (16, 'Produit X', 9, 100),
  (17, 'produit x', 10, 100),
  (18, 'Produit Y', 11, -20),
  (19, '', 12, 50),
  (20, 'Produit Z', 9, 10);
