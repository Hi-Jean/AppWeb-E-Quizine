#================================================#
#                    SQL DML                     #
#================================================#

-- https://moodlesciences.univ-brest.fr/moodle/pluginfile.php/74923/mod_resource/content/22/TutorielSQL-DML_et_SQL-PSM_PourAllerPlusLoin_1.pdf --



#################### ACTIVITE 1 ####################

SELECT rsp_pseudo, act_titre, act_contenu
FROM t_responsable_rsp
LEFT OUTER JOIN t_actualite_act USING(rsp_id)
ORDER BY rsp_id;


SELECT rsp_pseudo
FROM t_responsable_rsp
WHERE rsp_id in (
	SELECT rsp_id
	FROM t_responsable_rsp
	EXCEPT
	SELECT rsp_id
	FROM t_actualite_act);

SELECT rsp_pseudo
FROM t_responsable_rsp
LEFT OUTER JOIN t_actualite_act USING(rsp_id)
WHERE act_id is NULL;



#################### ACTIVITE 2 ####################

SELECT jou_id, jou_pseudo
FROM t_joueur_jou
WHERE mch_code = "LFS9P2QA";

DELIMITER //
CREATE OR REPLACE FUNCTION joueurs_ds_match (CODE_MATCH CHAR(8)) RETURNS VARCHAR(255)
BEGIN
	DECLARE liste VARCHAR(255) DEFAULT NULL;
	SELECT GROUP_CONCAT(jou_pseudo) INTO liste FROM t_joueur_jou WHERE mch_code = CODE_MATCH;
	RETURN liste;
END;
//
DELIMITER ;

SELECT joueurs_ds_match("LFS9P2QA");


DELIMITER //
CREATE OR REPLACE PROCEDURE actu_fin_mch (IN CODE_MATCH CHAR(8))
BEGIN
	DECLARE intitule VARCHAR(100);
	DECLARE deb DATETIME;
	DECLARE fin DATETIME;
	DECLARE liste VARCHAR(255);
	SELECT mch_intitule INTO intitule FROM t_match_mch WHERE mch_code = CODE_MATCH;
    SELECT mch_date_deb INTO deb FROM t_match_mch WHERE mch_code = CODE_MATCH;
    SELECT mch_date_fin INTO fin FROM t_match_mch WHERE mch_code = CODE_MATCH;
    SELECT joueurs_ds_match(mch_code) INTO liste FROM t_match_mch WHERE mch_code = CODE_MATCH;
	IF (fin IS NOT NULL) THEN INSERT INTO `t_actualite_act` (`act_id`, `act_titre`, `act_contenu`, `act_date_publi`, `rsp_id`) VALUES (NULL, 'Fin du Match !', CONCAT("Intitule : ", intitule," Date de début : ", deb, " Date de fin : ", fin, " Liste des joueurs : ", liste), NOW(), 1);
	END IF;
END;
//
DELIMITER ;


DELIMITER //
CREATE OR REPLACE TRIGGER fin_mch
AFTER UPDATE ON t_match_mch
FOR EACH ROW
BEGIN
	IF (NEW.mch_date_fin IS NOT NULL AND OLD.mch_date_fin IS NULL) THEN CALL actu_fin_mch(NEW.mch_code);
	END IF;
END;
//
DELIMITER ;

UPDATE t_match_mch SET mch_date_fin = NOW() WHERE mch_code = "0TJ5XLR1";


#################### ACTIVITE 3 ####################

DELIMITER //
CREATE OR REPLACE PROCEDURE nb_mch(OUT NB_FINI INT, OUT NB_COURS INT, OUT NB_VENIR INT)
BEGIN
	SELECT COUNT(mch_code) INTO NB_FINI FROM t_match_mch WHERE mch_date_fin IS NOT NULL;
	SELECT COUNT(mch_code) INTO NB_COURS FROM t_match_mch WHERE mch_date_fin IS NULL AND mch_date_deb IS NOT NULL;
	SELECT COUNT(mch_code) INTO NB_VENIR FROM t_match_mch WHERE mch_date_deb IS NULL;
END;
//
DELIMITER ;

SET @nb_fin = 0;
SET @nb_cours = 0;
SET @nb_venir = 0;

CALL nb_mch(@nb_fin,@nb_cours,@nb_venir);

SELECT @nb_fin,@nb_cours,@nb_venir;




#################### ACTIVITE 4 ####################

# Vue info complémentaire matchs
CREATE OR REPLACE VIEW info_match
AS
SELECT mch_code, mch_intitule, mch_actif, (mch_date_fin IS NOT NULL) AS est_termine, SUM(jou_score) / COUNT(jou_score) AS moyenne_match, COUNT(jou_id) as nb_joueur
FROM t_match_mch LEFT JOIN t_joueur_jou USING(mch_code)
GROUP BY mch_code;

SELECT * FROM info_match;



# Vue jointure profil-compte
CREATE OR REPLACE VIEW info_profil_compte
AS
SELECT *
FROM t_responsable_rsp JOIN t_profil_pro USING(rsp_id);

SELECT * FROM info_profil_compte;



# Fonction vérifiant la présence d'un pseudo associé à un match dans la table des joueurs
DELIMITER //
CREATE OR REPLACE FUNCTION verif_pseudo_jou_mch(PSEUDO VARCHAR(20) CHARACTER SET 'utf8' COLLATE 'utf8_bin', CODE_MATCH CHAR(8)) RETURNS TINYINT
BEGIN
	DECLARE present INT DEFAULT 0;
	SELECT COUNT(jou_pseudo) INTO present FROM t_joueur_jou WHERE mch_code = CODE_MATCH AND jou_pseudo = PSEUDO;
    RETURN present;
END;
//
DELIMITER ;

SELECT verif_pseudo_jou_mch("Pedro", "LFS9P2QA");		# -> 1
SELECT verif_pseudo_jou_mch("PEDRO", "LFS9P2QA");		# -> 0



# Fonction vérifiant la présence d'un pseudo dans la table des comptes
DELIMITER //
CREATE OR REPLACE FUNCTION verif_pseudo_compte(PSEUDO VARCHAR(20) CHARACTER SET 'utf8' COLLATE 'utf8_bin') RETURNS TINYINT
BEGIN
	DECLARE present INT DEFAULT 0;
	SELECT COUNT(rsp_pseudo) INTO present FROM t_responsable_rsp WHERE rsp_pseudo = PSEUDO;
    RETURN present;
END;
//
DELIMITER ;

SELECT verif_pseudo_compte("Hi.Jean");		# -> 1
SELECT verif_pseudo_compte("Hi.JEan");		# -> 0


# Fonction générant un nouveau code de match, qui n'est pas déjà présent dans la table des matchs
DELIMITER //
CREATE OR REPLACE FUNCTION gener_code_mch() RETURNS CHAR(8)
BEGIN
	DECLARE code CHAR(8) DEFAULT NULL;
	WHILE ((SELECT COUNT(mch_code) FROM t_match_mch WHERE mch_code = code) > 0) OR (code IS NULL) DO
		SELECT UPPER(LEFT(UUID(), 8)) INTO code;
	END WHILE;
	RETURN code;
END;
//
DELIMITER ;

SELECT gener_code_mch();



# Procédure générant un nouveau match à partir intitule, num quiz, et pseudo createur + d'un code fourni (si NULL en génére un aléatoirement)
DELIMITER //
CREATE OR REPLACE PROCEDURE creer_mch(IN INTITULE_MCH VARCHAR(100),
									IN PSEUDO_CPT VARCHAR(20) CHARACTER SET 'utf8' COLLATE 'utf8_bin',
									IN ID_QUIZ INT,
									IN CODE_MATCH CHAR(8))
BEGIN
	DECLARE id_resp INT DEFAULT 1;
	SELECT rsp_id INTO id_resp FROM t_responsable_rsp WHERE rsp_pseudo = PSEUDO_CPT;
	IF (CODE_MATCH IS NULL) THEN SET CODE_MATCH := (SELECT gener_code_mch());
	END IF;
	IF ((SELECT COUNT(mch_code) FROM t_match_mch WHERE mch_code = CODE_MATCH) = 0) && (id_resp != 0) && ((SELECT COUNT(qiz_id) FROM t_quiz_qiz WHERE qiz_id = ID_QUIZ) = 1)
	THEN INSERT INTO `t_match_mch` (`mch_code`, `mch_intitule`, `mch_actif`, `mch_score`, `mch_date_deb`, `mch_date_fin`, `rsp_id`, `qiz_id`) VALUES (CODE_MATCH, INTITULE_MCH, 0, NULL, NOW(), NULL, id_resp, ID_QUIZ);
	END IF;
END;
//
DELIMITER ;

CALL creer_mch("Nouveau match", "Hi.Jean", 1, NULL);



# Procédure de mis à jour de la moyenne d'un match dans la BDD
DELIMITER //
CREATE OR REPLACE PROCEDURE maj_moyenne_mch(IN CODE_MATCH CHAR(8))
BEGIN
	DECLARE moyenne DOUBLE DEFAULT 0;
	SELECT (SUM(jou_score) / COUNT(jou_score)) INTO moyenne FROM t_joueur_jou WHERE mch_code = CODE_MATCH;
	UPDATE t_match_mch SET mch_score = moyenne WHERE mch_code = CODE_MATCH;
END;
//
DELIMITER ;

CALL maj_moyenne_mch("0TJ5XLR1");


/*
# Procédure suppression compte + profil + actu (+ deplacement quizz sur compte responsable)
DELIMITER //
CREATE OR REPLACE PROCEDURE del_compte (IN ID_COMPTE INT)
BEGIN
	DELETE FROM t_responsable_rsp WHERE rsp_id = ID_COMPTE;
END;
//
DELIMITER ;
*/


# Trigger quand suppression compte
DELIMITER //
CREATE OR REPLACE TRIGGER on_compte_deletion
BEFORE DELETE ON t_responsable_rsp
FOR EACH ROW
BEGIN
	DELETE FROM t_profil_pro WHERE rsp_id = OLD.rsp_id;
	UPDATE t_actualite_act SET rsp_id = 1 WHERE rsp_id = OLD.rsp_id;
	UPDATE t_quiz_qiz SET rsp_id = 1 WHERE rsp_id = OLD.rsp_id;
	UPDATE t_match_mch SET rsp_id = 1 WHERE rsp_id = OLD.rsp_id;
END;
//
DELIMITER ;



# Trigger quand suppression quiz
DELIMITER //
CREATE OR REPLACE TRIGGER suppr_qst_de_qiz
BEFORE DELETE ON t_quiz_qiz
FOR EACH ROW
BEGIN
	DELETE FROM t_question_qst WHERE qiz_id = OLD.qiz_id;
END;
//
DELIMITER ;



# Trigger avant suppresion question -> supprime reponses associées
DELIMITER //
CREATE OR REPLACE TRIGGER suppr_rep_de_qst
BEFORE DELETE ON t_question_qst
FOR EACH ROW
BEGIN
	DELETE FROM t_reponse_rep WHERE qst_id = OLD.qst_id;
END;
//
DELIMITER ;




#################### ACTIVITE 5 ####################

# Trigger 1 : quand suppression question
DELIMITER //
CREATE OR REPLACE TRIGGER on_question_deletion
AFTER DELETE ON t_question_qst
FOR EACH ROW
BEGIN
	DECLARE nb_qst INT DEFAULT 0;
	DECLARE contenu VARCHAR(100);
	DECLARE mch_et_rsp VARCHAR(500);
	DELETE FROM t_actualite_act WHERE act_titre LIKE CONCAT("Modification du quiz ", OLD.qiz_id, ".");
	SELECT COUNT(qst_id) INTO nb_qst FROM t_question_qst WHERE qiz_id = OLD.qiz_id;
	CASE nb_qst
		WHEN 0 THEN SET contenu := "QUIZ VIDE !";
		WHEN 1 THEN SET contenu := "ATTENTION, plus qu’une question.";
		ELSE SET contenu := (SELECT CONCAT("Suppression d’une question (", nb_qst, " questions restantes)."));
	END CASE;
	IF (SELECT COUNT(mch_code) FROM t_match_mch WHERE qiz_id = OLD.qiz_id) = 0
		THEN SET mch_et_rsp := (SELECT "Aucun match associé à ce quiz pour l’instant !");
		ELSE SET mch_et_rsp := (SELECT CONCAT("matchs :", GROUP_CONCAT(CONCAT(" ", mch_code, "(formateur : ", rsp_pseudo), ")")) FROM t_match_mch JOIN t_responsable_rsp USING(rsp_id) WHERE qiz_id = OLD.qiz_id);
	END IF;
	INSERT INTO `t_actualite_act` (`act_id`, `act_titre`, `act_contenu`, `act_date_publi`, `rsp_id`) VALUES (NULL, CONCAT("Modification du quiz ", OLD.qiz_id, "."), CONCAT(contenu, " ", mch_et_rsp), NOW(), 1); 
END;
//
DELIMITER ;


# Trigger 2 :
DELIMITER //
CREATE OR REPLACE TRIGGER on_mch_dates_update
AFTER UPDATE ON t_match_mch
FOR EACH ROW
BEGIN
	IF (NEW.mch_date_deb != OLD.mch_date_deb) && (NEW.mch_date_fin IS NULL) THEN DELETE FROM t_joueur_jou WHERE mch_code = NEW.mch_code;
	END IF;
END;
//
DELIMITER ;

INSERT INTO `t_joueur_jou` (`jou_id`, `jou_pseudo`, `jou_score`, `mch_code`) VALUES
	(NULL, 'jou1', '20', 'TESTMACH'),
	(NULL, 'jou2', '12', 'TESTMACH'),
	(NULL, 'jou3', '16', 'TESTMACH'),
	(NULL, 'jou4', '9', 'TESTMACH');

UPDATE t_match_mch
SET mch_date_deb = NOW(),
	mch_date_fin = NULL
WHERE mch_code = "TESTMACH";