#================================================#
#          REQUETES POUR L'APPLICATION           #
#================================================#

-- https://moodlesciences.univ-brest.fr/moodle/pluginfile.php/73742/mod_resource/content/18/FicheRequetesEquizine.pdf



#################### ACTUALITES -- EN TANT QUE VISITEUR ####################

#1 Requête listant toutes les actualités de la table des actualités et leur auteur (login)
SELECT t_actualite_act.*, rsp_pseudo
FROM t_actualite_act JOIN t_responsable_rsp USING(rsp_id);


#2 Requête donnant les données d'une actualité dont on connaît l'identifiant (n°)
SELECT *
FROM t_actualite_act
WHERE act_id = 5;


#3 Requête listant les 5 dernières actualités dans l'ordre décroissant
SELECT *
FROM t_actualite_act
ORDER BY act_date_publi DESC
LIMIT 5;


#4 Requête recherchant et donnant la (ou les) actualité(s) contenant un mot particulier
SELECT *
FROM t_actualite_act
WHERE act_titre LIKE "%odif%"
OR act_contenu LIKE "%odif%";


#5 Requête listant toutes les actualités postées à une date particulière + le login de l’auteur
SELECT t_actualite_act.*, rsp_pseudo
FROM t_actualite_act JOIN t_responsable_rsp USING(rsp_id)
WHERE DATE(act_date_publi) = "2022-10-25";




#################### MATCHS -- EN TANT QUE JOUEURS ####################

#1 Requête vérifiant l’existence (ou non) du code d’un match
SELECT COUNT(mch_code) AS match_present
FROM t_match_mch
WHERE mch_code = "TESTCODE";


#2 Requête d’ajout du pseudo d’un joueur pour un match particulier dont l’ID est connu
INSERT INTO `t_joueur_jou` (`jou_id`, `jou_pseudo`, `jou_score`, `mch_code`)
	VALUES (NULL, 'nouveau_joueur', NULL, 'TESTCODE'); 


#3 Requête vérifiant l’existence (ou non) d’un pseudo pour un match particulier
SELECT verif_pseudo_jou_mch("Pedro", "LFS9P2QA");


#4 Requête(s) d’affichage de toutes les questions (+ réponses) associées à un match
SELECT mch_code, t_question_qst.*, t_reponse_rep.*
FROM t_match_mch JOIN t_question_qst USING(qiz_id) JOIN t_reponse_rep USING(qst_id)
WHERE mch_code = "LFS9P2QA";


#5 Requête(s) d’affichage, si autorisé, de toutes les questions d’un match et leur bonne réponse
SELECT qst_id, qst_intitule, rep_id, rep_libelle
FROM t_match_mch JOIN t_quiz_qiz USING(qiz_id) JOIN t_question_qst USING(qiz_id) JOIN t_reponse_rep USING(qst_id)
WHERE mch_code = "LFS9P2QA"
AND mch_cor_vis = 1
AND rep_valide = 1;


#6 Requête de vérification d’une réponse donnée par un joueur (bonne ou mauvaise ?)
SELECT rep_valide
FROM t_reponse_rep
WHERE rep_id = 12;


#7 Requête de mise à jour du score d’un joueur particulier (pseudo connu)
UPDATE t_joueur_jou SET jou_score = 20 WHERE jou_id = 2;


#8 Requête de récupération du score d’un joueur particulier (pseudo connu)
SELECT jou_score
FROM t_joueur_jou
WHERE jou_pseudo = 'Hi.E'
AND mch_code = "0TJ5XLR1";




#################### ACTUALITES -- EN TANT QUE FORMATEUR/ADMINISTRATEUR ####################

#1 Requête listant toutes les actualités postées par un auteur particulier (connaissant le login du formateur connecté)
SELECT t_actualite_act.*, rsp_pseudo
FROM t_actualite_act JOIN t_responsable_rsp USING(rsp_id)
WHERE rsp_pseudo = "cecile.T";


#2 Requête d'ajout d'une actualité
INSERT INTO `t_actualite_act` (`act_id`, `act_titre`, `act_contenu`, `act_date_publi`, `rsp_id`)
	VALUES (NULL, 'Titre actu', 'Contenu actu (ou NULL)', NOW(), 1);
/*
INSERT INTO `t_actualite_act` (`act_id`, `act_titre`, `act_contenu`, `act_date_publi`, `rsp_id`)
	SELECT NULL, 'Titre actu', 'Contenu actu (ou NULL)', NOW(), rsp_id
    FROM t_responsable_rsp
    WHERE rsp_pseudo = "cecile.T";
*/


#3 Requête qui compte les actualités à une date précise
SELECT COUNT(act_id)
FROM t_actualite_act
WHERE DATE(act_date_publi) = "2022-11-08";


#4 Requête de modification d'une actualité
UPDATE t_actualite_act SET act_titre = "Nouveau titre !" WHERE act_id = 5;


#5 Requête de suppression d'une actualité à partir de son ID
DELETE FROM t_actualite_act WHERE act_id = 5;


#6 Requête supprimant toutes les actualités postées par un auteur particulier
DELETE FROM t_actualite_act WHERE rsp_id = 1;




#################### PROFIL -- EN TANT QUE FORMATEUR/ADMINISTRATEUR ####################

#1 Requête listant toutes les données de tous les profils
SELECT *
FROM t_profil_pro JOIN t_responsable_rsp USING(rsp_id);


#2 Requête listant les données des profils des formateurs (/des administrateurs)
SELECT *
FROM t_profil_pro
WHERE pro_role = 'A';


#3 Requête de vérification des données de connexion (login et mot de passe)
SELECT COUNT(rsp_pseudo)
FROM t_responsable_rsp
WHERE rsp_pseudo = "Hi.Jean"
AND rsp_mdp = "E-qU1zIN3!";


#4 Requête récupérant les données d'un profil particulier (utilisateur connecté)
SELECT t_profil_pro.*, rsp_pseudo
FROM t_profil_pro JOIN t_responsable_rsp USING(rsp_id)
WHERE rsp_pseudo = "Hi.Jean";


#5 Requête récupérant tous les logins des profils et l'état du profil (activé / désactivé)
SELECT rsp_pseudo, pro_actif
FROM info_profil_compte;


#6 Requête d'ajout des données d'un profil
INSERT INTO `t_profil_pro` (`pro_nom`, `pro_prenom`, `pro_mail`, `pro_role`, `pro_date_crea`, `pro_actif`, `rsp_id`)
	VALUES ('Frish', 'Elana', 'responsable@e-quizine.com', 'A', '2018-01-01 00:00:00', 1, 1);


#7 Requête de modification des données d'un profil
UPDATE t_profil_pro SET pro_mail = "tuxtux@mail.fr" WHERE rsp_id = 9;


#8 Requête de désactivation d'un profil
UPDATE t_profil_pro SET pro_actif = 0 WHERE rsp_id = 6;


#9 Requête de suppression d'un profil administrateur
DELETE FROM t_profil_pro WHERE rsp_id = 10000;


#10 Requête(s) de suppression d’un compte formateur et des données associées à ce compte (sans supprimer les quiz !)
DELETE FROM t_responsable_rsp WHERE rsp_id = 10000; -- Lignes des autres tables supprimées par le trigger on_compte_deletion




#################### QUIZ -- EN TANT QUE FORMATEUR ####################

#1 Requête(s) permettant de récupérer toutes les données (questions, choix possibles) d’un quiz en particulier
SELECT *
FROM t_quiz_qiz JOIN t_question_qst USING(qiz_id) JOIN t_reponse_rep USING(qst_id)
WHERE qiz_id = 2;


#2 Requête qui compte les questions d’un quiz dont on connaît l’ID
SELECT COUNT(qst_id) AS nb_qst
FROM t_question_qst
WHERE qiz_id = 3;


#3 Requête listant tous les quiz
SELECT *
FROM t_quiz_qiz;


#4 Requête listant tous les quiz (intitulé et auteur) et les matchs associés (intitulé et auteur)
SELECT qiz_titre, T1.rsp_pseudo AS qiz_auteur, mch_intitule, T2.rsp_pseudo AS mch_auteur
FROM t_quiz_qiz JOIN t_match_mch USING(qiz_id) JOIN t_responsable_rsp AS T1 JOIN t_responsable_rsp AS T2
WHERE t_quiz_qiz.rsp_id = T1.rsp_id
AND t_match_mch.rsp_id = T2.rsp_id;

CREATE OR REPLACE VIEW info_globale_quiz_match AS
SELECT qiz_id, qiz_image, qiz_titre, qiz_theme, qiz_actif, T1.rsp_pseudo AS qiz_auteur, mch_intitule, T2.rsp_pseudo AS mch_auteur, mch_code, mch_actif, mch_date_deb
FROM t_quiz_qiz LEFT JOIN t_match_mch USING(qiz_id) JOIN t_responsable_rsp AS T1 JOIN t_responsable_rsp AS T2
WHERE T1.rsp_id = t_quiz_qiz.rsp_id
AND T2.rsp_id = t_match_mch.rsp_id OR t_match_mch.rsp_id is NULL
GROUP BY qiz_titre, mch_code;



#5 Requête listant tous les quiz d’un formateur en particulier (dont on connaît l'ID)
SELECT *
FROM t_quiz_qiz
WHERE rsp_id = 3;


#6 Requête donnant tous les quiz qui ne sont plus associés à un formateur
SELECT t_quiz_qiz.*
FROM t_quiz_qiz JOIN t_responsable_rsp USING(rsp_id) JOIN t_profil_pro USING(rsp_id)
WHERE pro_role != 'F';


#7 Requête listant, pour un formateur dont on connaît le login, tous les quiz et leurs matchs, s’il y en a
SELECT *
FROM t_responsable_rsp LEFT JOIN t_quiz_qiz USING(rsp_id) LEFT JOIN t_match_mch USING(qiz_id)
WHERE rsp_pseudo = "BiDule";



#8 Requête d’insertion d’un quiz
INSERT INTO `t_quiz_qiz` (`qiz_id`, `qiz_titre`, `qiz_theme`, `qiz_image`, `qiz_actif`, `qiz_img_date_heure`, `rsp_id`)
	VALUES (NULL, 'Titre du quiz', 'Theme du quiz', 'image.png', 0, NOW(), 'ID RESPONSABLE');


#9 Requête(s) de suppression d’un quiz et de toutes les données qui lui sont associées
--DELETE FROM t_question_qst WHERE qiz_id = 6; -- Automatique avec trigger suppr_rep_de_qst 
DELETE FROM t_match_mch WHERE qiz_id = 6;
DELETE FROM t_quiz_qiz WHERE qiz_id = 6;


#10 Requête d’activation (/de désactivation) d’un quiz
UPDATE t_quiz_qiz SET qiz_actif = 0 WHERE qiz_id = 5;


#11 Requête(s) de copie d’un quiz

DELIMITER //
CREATE OR REPLACE PROCEDURE duplicate_quiz(IN ID_QUIZ INT(11), IN ID_NV_RSP INT(11))
BEGIN
	DECLARE id_qiz_max INT DEfAULT 0;

	INSERT INTO t_quiz_qiz  (`qiz_id`, `qiz_titre`, `qiz_theme`, `qiz_image`, `qiz_actif`, `qiz_img_date_heure`, `rsp_id`)
	SELECT NULL, CONCAT(qiz_titre, " - COPIE"), qiz_theme, qiz_image, qiz_actif, qiz_img_date_heure, ID_NV_RSP
	FROM t_quiz_qiz
	WHERE qiz_id = ID_QUIZ;

	SELECT MAX(qiz_id) INTO id_qiz_max FROM t_quiz_qiz;

	CREATE TABLE old_quest AS SELECT * FROM t_question_qst;

	SELECT duplicate_question(id_qiz_max, qst_id)
	FROM old_quest
	WHERE qiz_id = ID_QUIZ;

	DROP TABLE old_quest;

END;
//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE FUNCTION duplicate_question(ID_NEW_QUIZ INT(11), ID_QUEST INT(11)) RETURNS INT(11)
BEGIN
	DECLARE id_qst_max INT DEfAULT 0;

	INSERT INTO `t_question_qst` (`qst_id`, `qst_intitule`, `qst_active`, `qst_points`, `qst_ordre`, `qiz_id`)
	SELECT NULL, qst_intitule, qst_active, qst_points, qst_ordre, ID_NEW_QUIZ
	FROM t_question_qst
	WHERE qst_id = ID_QUEST;

	SELECT MAX(qst_id) INTO id_qst_max FROM t_question_qst;

	INSERT INTO `t_reponse_rep` (`rep_id`, `rep_libelle`, `rep_valide`, `qst_id`)
	SELECT NULL, rep_libelle, rep_valide, id_qst_max
	FROM t_reponse_rep JOIN t_question_qst USING(qst_id)
	WHERE qst_id = ID_QUEST;

	RETURN 1;
END;
//
DELIMITER ;



#12 Requête(s) de modification d’un quiz dont on connaît l’ID (+ suppression des matchs associés)
UPDATE t_quiz_qiz SET xxx = yyy WHERE qiz_id = 5;
DELETE FROM t_match_mch WHERE qiz_id = 5;


#13 Requête qui autorise la visualisation des bonnes réponses pour un quiz
UPDATE t_match_mch SET mch_cor_vis = 1 WHERE mch_code IN (SELECT mch_code FROM t_match_mch JOIN t_quiz_qiz USING(qiz_id) WHERE qiz_id = 2);
# UPDATE t_match_mch SET mch_cor_vis = 1 WHERE mch_code = "CODETEST";



#################### QUESTIONS/REPONSES -- EN TANT QUE FORMATEUR ####################

#1 Requête qui liste toutes les questions d’un quiz particulier dont on connaît l’ID
SELECT *
FROM t_question_qst
WHERE qiz_id = 4;


#2 Requête qui ajoute une question à un quiz particulier dont on connaît l’ID
INSERT INTO `t_question_qst` (`qst_id`, `qst_intitule`, `qst_active`, `qst_points`, `qst_ordre`, `qiz_id`)
	VALUES (NULL, 'Nouvelle question', '1', '1', '', Y);


#3 Requête qui modifie une question d’un quiz particulier dont on connaît l’ID
UPDATE t_question_qst SET qst_intitule = "Nouveau Titre" WHERE qst_id = 23 AND qiz_id = Y;


#4 Requête qui active (/désactive) une question d’un quiz particulier dont on connaît l’ID
UPDATE t_question_qst SET qst_active = 0 WHERE qst_id = 23 AND qiz_id = Y;


#5 Requête qui supprime une question (+ toutes les données associées) d’un quiz particulier dont on connaît l’ID
DELETE FROM t_question_qst WHERE qst_id = X AND qiz_id = Y; -- Reponses supprimées par trigger suppr_rep_de_qst


#6 Requête qui liste les questions d’un quiz dans l’ordre
SELECT *
FROM t_question_qst
WHERE qiz_id = 4
ORDER BY qst_ordre;


#7 Requête qui modifie le numéro (ordre) d’une question d’un quiz



#8 Requête qui liste tous les choix possibles pour une question d’un quiz particulier dont on connaît l’ID
SELECT *
FROM t_reponse_rep JOIN t_question_qst USING(qst_id)
WHERE qst_id = 25;


#9 Requête qui donne la bonne réponse pour une question d’un quiz particulier dont on connaît l’ID
SELECT *
FROM t_reponse_rep JOIN t_question_qst USING(qst_id)
WHERE qst_id = 25
AND rep_valide = 1;


#10 Requête qui ajoute une proposition de réponse pour une question d’un quiz particulier
INSERT INTO `t_reponse_rep` (`rep_id`, `rep_libelle`, `rep_valide`, `qst_id`)
	VALUES (NULL, 'Libelle question', '0', 25) ;


#11 Requête qui modifie une proposition de réponse pour une question d’un quiz particulier



#12 Requête qui supprime une proposition de réponse pour une question d‘un quiz particulier




#################### MATCHS -- EN TANT QUE FORMATEUR ####################

#1 Requête permettant de récupérer toutes les données (questions, choix possibles) d’un questionnaire associé à un match dont on connaît le code
SELECT *
FROM t_match_mch JOIN t_quiz_qiz USING(qiz_id) LEFT JOIN t_question_qst USING(qiz_id) LEFT JOIN t_reponse_rep USING(qst_id)
WHERE mch_code = "TESTCODE";


#2 Requête donnant le nombre de joueurs d’un match particulier
SELECT mch_code, COUNT(jou_id) AS nb_joueur
FROM t_joueur_jou
WHERE mch_code = "0TJ5XLR1";


#3 Requête permettant de donner le score final d’un match particulier
SELECT moyenne_match
FROM info_match
WHERE mch_code = "0TJ5XLR1";


#4 Requête listant les scores finaux et les pseudos des joueurs d’un match particulier
SELECT jou_pseudo, jou_score
FROM t_joueur_jou
WHERE mch_code = "0TJ5XLR1";


#5 Requête listant tous les matchs d’un formateur en particulier (formateur connecté)
SELECT t_match_mch.*, rsp_pseudo
FROM t_match_mch JOIN t_responsable_rsp USING(rsp_id)
WHERE rsp_pseudo = "E.Durand";


#6 Requête qui récupère tous les matchs associés à un quiz particulier (connaissant son ID)
SELECT *
FROM t_match_mch
WHERE qiz_id = 2;


#7 Requête d’ajout d’un match pour un quiz particulier (connaissant son ID)
CALL creer_mch("Nouveau match", "Hi.Jean", 1, NULL);


#8 Requête de modification d’un match
UPDATE t_match_mch SET mch_actif = 1 WHERE mch_code = "XXXXXXXX";


#9 Requête de suppression d’un match dont on connaît l’ID (/le code)
DELETE FROM t_match_mch WHERE mch_code = "XXXXXXXX";


#10 Requête d’activation (/désactivation) d’un match
UPDATE t_match_mch SET mch_actif = 1 WHERE mch_code = "XXXXXXXX";


#11 Requête(s) de « remise à zéro » (RAZ) d’un match
UPDATE t_match_mch
SET mch_date_deb = NOW(),
	mch_date_fin = NULL
WHERE mch_code = "TESTMACH";














