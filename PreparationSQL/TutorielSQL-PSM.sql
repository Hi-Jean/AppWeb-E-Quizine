#================================================#
#                 SQL PROCEDURAL                 #
#================================================#

-- https://moodlesciences.univ-brest.fr/moodle/pluginfile.php/74198/mod_resource/content/23/TutorielSQL-Procedural.pdf --


#################### ACTIVITE 1 ####################

SELECT MAX(pfl_id) INTO @id
FROM t_profil_pfl;

SELECT @id;

SET @id := @id + 1;

SELECT @id;

INSERT INTO t_profil_pfl(pfl_id, pfl_nom, pfl_prenom, pfl_email, pfl_statut, pfl_validite, pfl_date, pfl_date_naissance)
VALUES (@id, "nouveau", "profil", "test_mail", 'R', 'A', NOW(), "2000-01-31");
INSERT INTO t_compte_cpt(pfl_id, cpt_pseudo, cpt_mot_de_passe)
VALUES (@id, "pseudo", )


SELECT YEAR(MIN(pfl_date)) INTO @annee FROM t_profil_pfl;

# SELECT @annee := YEAR(MIN(pfl_date)) FROM t_profil_pfl;

SELECT @annee;


#################### ACTIVITE 2 ####################

CREATE VIEW liste_nom_prenom
AS
SELECT pfl_prenom, pfl_nom
FROM t_profil_pfl;

SELECT * FROM liste_nom_prenom;



#################### ACTIVITE 3 ####################

DELIMITER //
CREATE OR REPLACE FUNCTION calcul_age (date_naiss DATE) RETURNS INT 
BEGIN
	DECLARE AGE INT DEFAULT 0;
	SET AGE := YEAR(CURDATE()) - YEAR(date_naiss);
	IF (MONTH(CURDATE()) > MONTH(date_naiss)) OR ( (MONTH(CURDATE()) = MONTH(date_naiss)) AND (DAY(CURDATE()) >= DAY(date_naiss))) THEN
		RETURN AGE;
	ELSE 
		RETURN AGE - 1;
	END IF;
END;
//
DELIMITER ;

SELECT pfl_prenom, pfl_nom, pfl_date_naissance, calcul_age(pfl_date_naissance) AS AGE
FROM t_profil_pfl;



#################### ACTIVITE 4 ####################

DELIMITER //
CREATE OR REPLACE PROCEDURE calcul_age_proc(IN id_profil INT, OUT age INT)
BEGIN
	SELECT TIMESTAMPDIFF(YEAR, pfl_date_naissance, CURDATE()) INTO age FROM t_profil_pfl WHERE pfl_id = id_profil;
END;
//
DELIMITER ;

CALL calcul_age_proc(1, @age);
SELECT @age;


DELIMITER //
CREATE OR REPLACE PROCEDURE min_maj(IN id INT, OUT res TEXT)
BEGIN
	DECLARE AGE INT DEFAULT 0;
	SELECT calcul_age(pfl_date_naissance) INTO AGE FROM t_profil_pfl WHERE pfl_id = id;
	IF AGE >= 18 THEN SET res := "Majeur";
		ELSE SET res := "Mineur";
	END IF;
END;
//
DELIMITER ;

SET @id = 8;
CALL min_maj(@id, @res);
SELECT *, @res FROM t_profil_pfl WHERE pfl_id = @id;


CREATE VIEW liste_nom_prenom_age
AS
SELECT pfl_nom, pfl_prenom, calcul_age(pfl_date_naissance) AS AGE
FROM t_profil_pfl;

SELECT * FROM liste_nom_prenom_age;

DELIMITER //
CREATE OR REPLACE PROCEDURE age_moy(OUT moyenne DOUBLE)
BEGIN
	DECLARE NB_PFL INT DEFAULT 0;
	DECLARE SOMME INT DEFAULT 0;
	SELECT SUM(AGE) INTO SOMME FROM liste_nom_prenom_age;
    SELECT COUNT(AGE) INTO NB_PFL FROM liste_nom_prenom_age;
	SET moyenne := SOMME / NB_PFL;
END;
//
DELIMITER ;

/*
DELIMITER //
CREATE OR REPLACE PROCEDURE age_moy(OUT moyenne DOUBLE)
BEGIN
	SELECT AVG(AGE) INTO moyenne FROM liste_nom_prenom_age;
END;
//
DELIMITER ;
*/

CALL age_moy(@moyenne);
SELECT @moyenne;



#################### ACTIVITE 5 ####################

DELIMITER //
CREATE TRIGGER date_crea
BEFORE INSERT ON t_profil_pfl
FOR EACH ROW
BEGIN
SET NEW.pfl_date = CURDATE();
END;
//
DELIMITER ;


DELIMITER //
CREATE TRIGGER maj_pfl
AFTER UPDATE ON t_compte_cpt
FOR EACH ROW
BEGIN
UPDATE t_profil_pfl SET pfl_date = CURDATE() WHERE t_profil_pfl.pfl_id = NEW.pfl_id;	# pourrait mettre OLD, si id non modifié
END;
//
DELIMITER ;