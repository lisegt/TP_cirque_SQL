/*
\du : voir tous les roles
\dp : voir toutes les tables et vues + droits associés
\c  -  role : se connecter en tant que role
\conninfo : infos de connexion
*/

/*
1.	psql -U postgres

2.	
    a) CREATE ROLE antony WITH LOGIN PASSWORD 'antpass' CREATEDB CREATEROLE ;

    b) CREATE ROLE fabrice WITH LOGIN PASSWORD 'fabword' NOCREATEDB NOCREATEROLE;

    c) CREATE ROLE marven WITH LOGIN PASSWORD 'marword' CREATEDB NOCREATEROLE;

    \c - antony

3. CREATE DATABASE "Cirque" ENCODING 'UTF8' ;

4. \c Cirque antony

*/

-- 5.
\c postgres antony

DROP DATABASE IF EXISTS "Cirque" ;

\echo [INFO] Creation de la BDD
CREATE DATABASE "Cirque" ENCODING 'UTF8' ;
\c Cirque antony

DROP TABLE IF EXISTS UTILISATION;
DROP TABLE IF EXISTS PERSONNEL;
DROP TABLE IF EXISTS NUMERO;
DROP TABLE IF EXISTS ACCESSOIRE;


CREATE TABLE PERSONNEL (
    NOM VARCHAR(20) PRIMARY KEY,
    ROLE VARCHAR(20)
);

CREATE TABLE NUMERO (
    TITRE VARCHAR(30) PRIMARY KEY,
    NATURE VARCHAR(20),
    RESPONSABLE VARCHAR(20)
);

CREATE TABLE ACCESSOIRE (
    NOM VARCHAR(30) PRIMARY KEY,
    COULEUR VARCHAR(10),
    VOLUME NUMERIC(5,2),
    RATELIER INTEGER,
    CAMION INTEGER
);

CREATE TABLE UTILISATION (
    TITRE VARCHAR(30),
    UTILISATEUR VARCHAR(20),
    ACCESSOIRE VARCHAR(30),

    CONSTRAINT FK1_UTIL FOREIGN KEY (ACCESSOIRE) REFERENCES ACCESSOIRE(NOM),
    CONSTRAINT FK2_UTIL FOREIGN KEY (UTILISATEUR) REFERENCES PERSONNEL(NOM),
    CONSTRAINT FK3_UTIL FOREIGN KEY (TITRE) REFERENCES NUMERO(TITRE)
);

-- 6.

\c Cirque marven
/*
INSERT INTO PERSONNEL(NOM,ROLE) VALUES 
    ('Clovis','Jongleur'),
    ('Reine de May','Ecuyer'),
    ('Louche', 'Clown'),
    ('Attention', 'Equilibriste'), 
    ('Partition', 'Musicien'),
    ('Crinière', 'Dompteur'),
    ('Jerry', 'Clown'),
    ('Bal','Jongleur'),
    ('Final','Musicien'),
    ('Louis','Jongleur'),
    ('Léo','Jongleur'),
    ('Lulu','Ecuyer'),
    ('Coloquinte','Equilibriste'),
    ('Grostas','Jongleur'),
    ('Sangtrèspur','Dompteur');

-- ne fonctionne pas car marven n'est pas le propriétaire de la BDD Cirque
*/
-- 7.
-- marven doit avoir les mêmes roles qu'antony
GRANT marven TO antony;
-- on change le propriétaire (attention il faut être connecté en tant que antony)
ALTER DATABASE "Cirque" OWNER TO marven;



-- 8.
/*
\c Cirque marven

INSERT INTO PERSONNEL(NOM,ROLE) VALUES 
    ('Clovis','Jongleur'),
    ('Reine de May','Ecuyer'),
    ('Louche', 'Clown'),
    ('Attention', 'Equilibriste'), 
    ('Partition', 'Musicien'),
    ('Crinière', 'Dompteur'),
    ('Jerry', 'Clown'),
    ('Bal','Jongleur'),
    ('Final','Musicien'),
    ('Louis','Jongleur'),
    ('Léo','Jongleur'),
    ('Lulu','Ecuyer'),
    ('Coloquinte','Equilibriste'),
    ('Grostas','Jongleur'),
    ('Sangtrèspur','Dompteur');
*/

-- ne fonctionne pas marven n'a pas les droit d'insertion sur les tables de Cirque

-- 9.

\c Cirque antony
GRANT INSERT ON PERSONNEL, NUMERO, ACCESSOIRE, UTILISATION TO marven;

\c - marven
INSERT INTO personnel VALUES('Clovis', 'Jongleur'),
('Reine de May', 'Ecuyer'),
('Louche', 'Clown'),
('Attention', 'Equilibriste'),
('Partition', 'Musicien'),
('Criniere', 'Dompteur'),
('Jerry', 'Clown'),
('Bal', 'Jongleur'),
('Final', 'Musicien'),
('Louis', 'Jongleur'),
('Leo', 'Jongleur'),
('Lulu', 'Ecuyer'),
('Coloquinte', 'Equilibriste'),
('Grostas', 'Jongleur'),
('Sangtrespur', 'Dompteur');

INSERT INTO Numero VALUES
('Les Zoupalas', 'Jonglerie', 'Clovis'),
('Le coche infernal', 'Equitation', 'Reine de May'),
('Les fauves', 'Clownerie', 'Louche'),
('Les Smilers', 'Equilibre', 'Attention'),
('La passoire magique', 'Lion', 'Criniere'),
('Les Zozos', 'Clownerie', 'Jerry'),
('Les Tartarins', 'Jonglerie', 'Bal');

INSERT INTO Accessoire VALUES
('Ballon', 'Rouge', 0.3, 15, 5),
('Barre', 'Blanc', 0.6, 19, 5),
('Fouet', 'Marron', 0.2, 11, 3),
('Bicyclette a elephant', 'Vert', 0.4, 27, 8),
('Trompette', 'Rouge', 0.2, 2, 1),
('Cercle magique', 'Orange', 0.2, 1, 1),
('Boule', 'Cristal', 0.2, 88, 8),
('Cage a lions', 'Noir', 10.0, 0, 2),
('Chaise longue de lion', 'Bleu', 0.9, 11, 5),
('Peigne de chimpanze', 'Jaune', 0.2, 23, 3),
('Etrier', NULL, NULL, NULL, NULL);

INSERT INTO Utilisation VALUES
('Les Zoupalas', 'Louis', 'Ballon'),
('Les Zoupalas', 'Leo', 'Ballon'),
('Les Zoupalas', 'Louis', 'Barre'),
('Le coche infernal', 'Grostas', 'Bicyclette a elephant'),
('Le coche infernal', 'Lulu', 'Fouet'),
('Les fauves', 'Jerry', 'Trompette'),
('Les Smilers', 'Attention', 'Cercle magique'),
('Les Smilers', 'Attention', 'Boule'),
('Les Smilers', 'Coloquinte', 'Bicyclette a elephant'),
('La passoire magique', 'Criniere', 'Cage a lions'),
('La passoire magique', 'Criniere', 'Chaise longue de lion'),
('Les Zozos', 'Jerry', 'Bicyclette a elephant'),
('Les Zozos', 'Jerry', 'Peigne de chimpanze'),
('Les Tartarins', 'Grostas', 'Bicyclette a elephant'),
('Le coche infernal', 'Sangtrespur', 'Etrier');



-- 10.
\c Cirque fabrice
CREATE VIEW Res_Numero ("Le Numero", "Le Responsable") AS
SELECT titre, responsable
FROM Numero;

-- SELECT * FROM Res_Numero; ne fonctionne pas

-- 11.
\c - antony
GRANT ALL PRIVILEGES ON NUMERO TO fabrice ;
-- ou GRANT SELECT, INSERT, UPDATE, DELETE ON NUMERO TO fabrice ;

-- 12.

\c - fabrice 
SELECT * FROM Res_Numero ;
-- doit fonctionner


-- 13.
\c - fabrice
UPDATE Res_Numero
SET "Le Responsable"='Léo'
WHERE "Le Numero"='Les Zoupalas';

INSERT INTO Res_Numero VALUES ('Anniversaire','Léo'); 

-- 14. Écrire une règle, permettant de modifier à travers cette vue le nom du responsable d’un numéro désigné par son titre. 
-- Testez la règle pour modifier le nom du responsable du numero Zoupla en « leo».

CREATE OR REPLACE RULE "RegleModifResp"
AS ON UPDATE TO Res_Numero
DO INSTEAD UPDATE Numero
SET responsable = new."Le Responsable" WHERE titre = new."Le Numero";

UPDATE Res_Numero
SET "Le Responsable"='leo'
WHERE "Le Numero"='Anniversaire';

-- 15. Créez la vue ListeAccessoiresUtilisees (Nom_Accessoire,Numero,Camion, Ratelier), Vérifiez son contenu. Quel est l’intérêt de définir cette vue ?
\c - antony
GRANT ALL PRIVILEGES ON ACCESSOIRE TO fabrice ;

CREATE VIEW ListeAccessoiresUtilisees (Nom_Accessoire,Numero,Camion, Ratelier) AS
SELECT Accessoire.nom, Numero.titre, Accessoire.camion, Accessoire.Ratelier
FROM Accessoire INNER JOIN Utilisation ON Accessoire.nom=Utilisation.accessoire
                INNER JOIN Numero USING (titre);

-- permet de répertorier les accessoires associés à leur numéro

-- 16. Écrire une règle, permettant d’insérer à travers cette vue un nouvel accessoire.
CREATE OR REPLACE RULE "RegleAjoutAccessoire" 
AS ON INSERT TO ListeAccessoiresUtilisees
DO INSTEAD 
(INSERT INTO Accessoire VALUES (new.nom_accessoire, NULL, NULL, new.Ratelier, new.camion);
INSERT INTO Numero VALUES (new.numero, NULL, NULL);
INSERT INTO Utilisation VALUES (new.numero, NULL, new.nom_accessoire));

INSERT INTO ListeAccessoiresUtilisees VALUES ('Violon', 'Concert de Lise',2,2); 

-- 17. Attribuer le droit de sélection et de mise à jour et d’insertion de la vue ListeAccessoiresUtilisees à Marven. Testez la commande \dp (ou \z) de psql.
GRANT SELECT, UPDATE, INSERT ON ListeAccessoiresUtilisees TO marven;
\dp

-- 18. Attribuer le droit de sélection et de mise à jour de la vue Res_Numero à Antony.
\c - fabrice
GRANT SELECT, UPDATE ON Res_Numero TO antony;
\dp

-- 19. Connectez-vous avec le login d’Antony et cherchez à travers la vue res_Numero les numeros dont le nom contient ‘zo’
\c - antony
SELECT "Le Numero"
FROM Res_Numero
WHERE UPPER("Le Numero") LIKE '%ZO%';
