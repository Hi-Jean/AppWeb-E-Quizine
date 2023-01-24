-- phpMyAdmin SQL Dump
-- version 5.1.3
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost
-- Généré le : jeu. 08 déc. 2022 à 17:43
-- Version du serveur : 10.5.12-MariaDB-0+deb11u1
-- Version de PHP : 7.4.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `zal3-zjeanhi00_1`
--

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`zjeanhi00`@`%` PROCEDURE `actu_fin_mch` (IN `CODE_MATCH` CHAR(8))   BEGIN
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
END$$

CREATE DEFINER=`zjeanhi00`@`%` PROCEDURE `creer_mch` (IN `INTITULE_MCH` VARCHAR(100), IN `PSEUDO_CPT` VARCHAR(20) CHARACTER SET 'utf8' COLLATE 'utf8_bin', IN `ID_QUIZ` INT, IN `CODE_MATCH` CHAR(8))   BEGIN
	DECLARE id_resp INT DEFAULT 1;
	SELECT rsp_id INTO id_resp FROM t_responsable_rsp WHERE rsp_pseudo = PSEUDO_CPT;
	IF (CODE_MATCH IS NULL) THEN SET CODE_MATCH := (SELECT gener_code_mch());
	END IF;
	IF ((SELECT COUNT(mch_code) FROM t_match_mch WHERE mch_code = CODE_MATCH) = 0) && (id_resp != 0) && ((SELECT COUNT(qiz_id) FROM t_quiz_qiz WHERE qiz_id = ID_QUIZ) = 1)
	THEN INSERT INTO `t_match_mch` (`mch_code`, `mch_intitule`, `mch_actif`, `mch_date_deb`, `mch_date_fin`, `rsp_id`, `qiz_id`) VALUES (CODE_MATCH, INTITULE_MCH, 0, NOW(), NULL, id_resp, ID_QUIZ);
	END IF;
END$$

CREATE DEFINER=`zjeanhi00`@`%` PROCEDURE `del_compte` (IN `ID_COMPTE` INT)   BEGIN
	DELETE FROM t_responsable_rsp WHERE rsp_id = ID_COMPTE;
END$$

CREATE DEFINER=`zjeanhi00`@`%` PROCEDURE `duplicate_quiz` (IN `ID_QUIZ` INT(11), IN `ID_NV_RSP` INT(11))   BEGIN
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

END$$

CREATE DEFINER=`zjeanhi00`@`%` PROCEDURE `maj_moyenne_mch` (IN `CODE_MATCH` CHAR(8))   BEGIN
	DECLARE moyenne DOUBLE DEFAULT 0;
	SELECT (SUM(jou_score) / COUNT(jou_score)) INTO moyenne FROM t_joueur_jou WHERE mch_code = CODE_MATCH;
	UPDATE t_match_mch SET mch_score = moyenne WHERE mch_code = CODE_MATCH;
END$$

CREATE DEFINER=`zjeanhi00`@`%` PROCEDURE `nb_mch` (OUT `NB_FINI` INT, OUT `NB_COURS` INT, OUT `NB_VENIR` INT)   BEGIN
	SELECT COUNT(mch_code) INTO NB_FINI FROM t_match_mch WHERE mch_date_fin IS NOT NULL;
	SELECT COUNT(mch_code) INTO NB_COURS FROM t_match_mch WHERE mch_date_fin IS NULL AND mch_date_deb IS NOT NULL;
	SELECT COUNT(mch_code) INTO NB_VENIR FROM t_match_mch WHERE mch_date_deb IS NULL;
END$$

CREATE DEFINER=`zjeanhi00`@`%` PROCEDURE `remise_a_zero` (IN `CODE_MATCH` CHAR(8))   BEGIN
	UPDATE t_match_mch SET mch_date_deb = NOW(), mch_date_fin = NULL, mch_actif = 1 WHERE mch_code = CODE_MATCH;
END$$

--
-- Fonctions
--
CREATE DEFINER=`zjeanhi00`@`%` FUNCTION `duplicate_question` (`ID_NEW_QUIZ` INT(11), `ID_QUEST` INT(11)) RETURNS INT(11)  BEGIN
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
END$$

CREATE DEFINER=`zjeanhi00`@`%` FUNCTION `gener_code_mch` () RETURNS CHAR(8) CHARSET utf8mb4  BEGIN
	DECLARE code CHAR(8) DEFAULT NULL;
	WHILE ((SELECT COUNT(mch_code) FROM t_match_mch WHERE mch_code = code) > 0) OR (code IS NULL) DO
		SELECT UPPER(LEFT(UUID(), 8)) INTO code;
	END WHILE;
	RETURN code;
END$$

CREATE DEFINER=`zjeanhi00`@`%` FUNCTION `joueurs_ds_match` (`CODE_MATCH` CHAR(8)) RETURNS VARCHAR(255) CHARSET utf8mb4  BEGIN
	DECLARE liste VARCHAR(255) DEFAULT NULL;
	SELECT GROUP_CONCAT(jou_pseudo) INTO liste FROM t_joueur_jou WHERE mch_code = CODE_MATCH;
	RETURN liste;
END$$

CREATE DEFINER=`zjeanhi00`@`%` FUNCTION `verif_pseudo_compte` (`PSEUDO` VARCHAR(20) CHARACTER SET 'utf8' COLLATE 'utf8_bin') RETURNS TINYINT(4)  BEGIN
	DECLARE present INT DEFAULT 0;
	SELECT COUNT(rsp_pseudo) INTO present FROM t_responsable_rsp WHERE rsp_pseudo = PSEUDO;
    RETURN present;
END$$

CREATE DEFINER=`zjeanhi00`@`%` FUNCTION `verif_pseudo_jou_mch` (`PSEUDO` VARCHAR(20) CHARACTER SET 'utf8' COLLATE 'utf8_bin', `CODE_MATCH` CHAR(8)) RETURNS TINYINT(4)  BEGIN
	DECLARE present INT DEFAULT 0;
	SELECT COUNT(jou_pseudo) INTO present FROM t_joueur_jou WHERE mch_code = CODE_MATCH AND jou_pseudo = PSEUDO;
    RETURN present;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `info_globale_quiz_match`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `info_globale_quiz_match` (
`qiz_id` int(11)
,`qiz_image` varchar(200)
,`qiz_titre` varchar(100)
,`qiz_theme` varchar(45)
,`qiz_actif` tinyint(4)
,`qiz_auteur` varchar(20)
,`mch_intitule` varchar(100)
,`mch_auteur` varchar(20)
,`mch_code` char(8)
,`mch_actif` tinyint(4)
,`mch_date_deb` datetime
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `info_match`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `info_match` (
`mch_code` char(8)
,`mch_intitule` varchar(100)
,`mch_actif` tinyint(4)
,`mch_date_fin` datetime
,`nb_joueur` bigint(21)
,`moyenne_match` double
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `info_profil_compte`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `info_profil_compte` (
`rsp_id` int(11)
,`rsp_pseudo` varchar(20)
,`rsp_mdp` char(64)
,`pro_nom` varchar(60)
,`pro_prenom` varchar(60)
,`pro_mail` varchar(80)
,`pro_role` char(1)
,`pro_date_crea` datetime
,`pro_actif` tinyint(4)
);

-- --------------------------------------------------------

--
-- Structure de la table `t_actualite_act`
--

CREATE TABLE `t_actualite_act` (
  `act_id` int(11) NOT NULL,
  `act_titre` varchar(100) NOT NULL,
  `act_contenu` varchar(300) DEFAULT NULL,
  `act_date_publi` datetime NOT NULL,
  `rsp_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `t_actualite_act`
--

INSERT INTO `t_actualite_act` (`act_id`, `act_titre`, `act_contenu`, `act_date_publi`, `rsp_id`) VALUES
(1, 'Grande ouverture d\'E-Quizine !', 'Bienvenue sur E-Quizine ! La toute dernière application de quiz en ligne !', '2022-08-23 10:00:00', 1),
(2, 'Merci pour vos retour, nous les prenons en compte pour l\'amélioration d\'E-Quizine !', NULL, '2022-08-25 12:08:56', 3),
(3, 'Comme neuf !', 'Les problèmes rencontrés par certain de nos utilisateur durant leurs match devrait être réglé. Nous vous remercions pour votre patience !', '2022-09-01 17:43:13', 7),
(25, 'Modification du quiz 6.', 'QUIZ VIDE ! Aucun match associé à ce quiz pour l’instant !', '2022-11-08 15:16:10', 1),
(40, 'Modification du quiz 12.', 'QUIZ VIDE ! Aucun match associé à ce quiz pour l’instant !', '2022-11-11 09:56:19', 1),
(42, 'Modification du quiz 1.', 'Suppression d’une question (5 questions restantes). matchs : 0TJ5XLR1(formateur : E.Durand), APV78Z2Q(formateur : cecile.T), BZ9ATX52(formateur : BiDule)', '2022-11-11 18:17:44', 1),
(44, 'Modification du quiz 2.', 'Suppression d’une question (5 questions restantes). matchs : NYEM7T60(formateur : E.Durand)', '2022-11-15 15:07:29', 1),
(47, 'Fin du Match !', 'Intitule : Nouveau match Date de début : 2022-11-29 17:57:23 Date de fin : 2022-11-29 18:04:17 Liste des joueurs : test,test2,test3,test4,bob', '2022-11-29 18:04:17', 1),
(53, 'Modification du quiz 18.', 'QUIZ VIDE ! Aucun match associé à ce quiz pour l’instant !', '2022-12-01 20:27:59', 1),
(54, 'Fin du Match !', 'Intitule : Test nouveau match Date de début : 2022-12-01 12:11:36 Date de fin : 2022-12-01 20:58:13 Liste des joueurs : NouveauJoueur,Hubert,Ressss', '2022-12-01 20:58:13', 1),
(55, 'Fin du Match !', 'Intitule : test Date de début : 2022-12-08 14:25:00 Date de fin : 2022-12-07 11:33:49 Liste des joueurs : jou,bob', '2022-12-07 11:33:49', 1),
(56, 'Fin du Match !', NULL, '2022-12-07 11:34:30', 1),
(57, 'Fin du Match !', 'Intitule : test vm Date de début : 2022-12-07 10:30:00 Date de fin : 2022-12-07 11:53:06 Liste des joueurs : fifi18,fifi20', '2022-12-07 11:53:06', 1);

-- --------------------------------------------------------

--
-- Structure de la table `t_joueur_jou`
--

CREATE TABLE `t_joueur_jou` (
  `jou_id` int(11) NOT NULL,
  `jou_pseudo` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `jou_score` double DEFAULT NULL,
  `mch_code` char(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `t_joueur_jou`
--

INSERT INTO `t_joueur_jou` (`jou_id`, `jou_pseudo`, `jou_score`, `mch_code`) VALUES
(3, 'NewPlayer', 100, 'NYEM7T60'),
(4, 'Arthur.Flo', 80, 'NYEM7T60'),
(5, 'J_CRUD', 100, 'NYEM7T60'),
(6, 'Hi.E', 20, '0TJ5XLR1'),
(7, 'Gerard', 40, '0TJ5XLR1'),
(19, 'test', 20, 'NYEM7T60'),
(27, 'beep', 40, 'NYEM7T60'),
(28, 'boris', 60, 'NYEM7T60'),
(29, 'sympatonsite', 40, '0TJ5XLR1'),
(31, 'vrem', 20, 'NYEM7T60'),
(32, 'test', 100, '0TJ5XLR1'),
(33, 'ok', 80, '0TJ5XLR1'),
(34, 'fafa86', 100, 'APV78Z2Q'),
(38, 'res', 20, '0TJ5XLR1'),
(47, 'Bebouuuu', 20, 'APV78Z2Q'),
(54, 'Crown', 100, 'EBCF3FFE'),
(55, 'Grim', 40, 'EBCF3FFE'),
(56, 'Prune', 80, 'EBCF3FFE'),
(57, 'Wyrm', 60, 'EBCF3FFE'),
(58, 'Anna', 80, 'EBCF3FFE'),
(59, 'F3RN35', 40, 'EBCF3FFE'),
(60, 'Boris', 40, 'BZ9ATX52'),
(61, 'Glam', 80, 'BZ9ATX52'),
(62, 'Noah', 60, 'BZ9ATX52'),
(63, 'Kris', 0, 'BZ9ATX52'),
(64, 'Bime', 40, 'BZ9ATX52'),
(65, 'Troum', 100, 'BZ9ATX52'),
(66, 'NvJoueur', 20, 'C6C18B09'),
(67, 'Frimeur', 60, 'C6C18B09'),
(68, 'Pedro', 40, 'C6C18B09'),
(69, 'Jojo', 100, 'C6C18B09'),
(70, 'Vioum', 20, 'C6C18B09'),
(71, 'Crown', 60, 'C6C18B09'),
(72, 'Gomor', 80, 'AF0CFF11'),
(73, 'Judas', 40, 'AF0CFF11'),
(74, 'Justine', 60, 'AF0CFF11'),
(75, 'Alfred', 20, 'AF0CFF11'),
(76, 'Brise', 100, 'AF0CFF11'),
(77, 'FreDos', 60, 'AF0CFF11'),
(80, 'fifi18', 100, 'AC42FA22'),
(81, 'fifi20', 20, 'AC42FA22');

-- --------------------------------------------------------

--
-- Structure de la table `t_match_mch`
--

CREATE TABLE `t_match_mch` (
  `mch_code` char(8) NOT NULL,
  `mch_intitule` varchar(100) DEFAULT NULL,
  `mch_actif` tinyint(4) NOT NULL,
  `mch_date_deb` datetime NOT NULL,
  `mch_date_fin` datetime DEFAULT NULL,
  `rsp_id` int(11) NOT NULL,
  `qiz_id` int(11) NOT NULL,
  `mch_cor_vis` tinyint(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `t_match_mch`
--

INSERT INTO `t_match_mch` (`mch_code`, `mch_intitule`, `mch_actif`, `mch_date_deb`, `mch_date_fin`, `rsp_id`, `qiz_id`, `mch_cor_vis`) VALUES
('05798BD6', 'Nouveau match', 0, '2022-10-21 11:01:59', '2022-11-29 15:35:08', 4, 5, 0),
('0TJ5XLR1', 'Entrainement Groupe TD1', 1, '2022-09-28 16:33:49', NULL, 8, 1, 1),
('5C80F845', 'Nouveau match', 1, '2022-12-07 11:46:33', NULL, 5, 4, 1),
('AC42FA22', 'test vm', 0, '2022-12-07 10:30:00', '2022-12-07 11:53:06', 5, 4, 1),
('AF0CFF11', 'Match de test', 1, '2022-12-07 11:20:00', NULL, 5, 2, 0),
('APV78Z2Q', 'Entrainement Groupe TD2', 1, '2022-09-28 16:32:20', NULL, 7, 1, 1),
('BZ9ATX52', 'Entrainement Groupe TD3', 1, '2022-12-07 16:24:03', '2022-11-29 14:44:56', 5, 1, 0),
('C6C18B09', 'Match du mercredi 7 Dec. 2022', 1, '2022-12-07 10:20:00', NULL, 5, 3, 0),
('EBCF3FFE', 'Test nouveau match', 1, '2022-12-02 09:33:32', NULL, 5, 5, 1),
('NYEM7T60', 'Geologie Amphi A', 0, '2022-09-25 10:39:05', '2022-09-25 10:53:41', 8, 2, 0);

--
-- Déclencheurs `t_match_mch`
--
DELIMITER $$
CREATE TRIGGER `fin_mch` AFTER UPDATE ON `t_match_mch` FOR EACH ROW BEGIN
	IF (NEW.mch_date_fin IS NOT NULL && OLD.mch_date_fin IS NULL) THEN CALL actu_fin_mch(NEW.mch_code);
	END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `on_mch_dates_update` AFTER UPDATE ON `t_match_mch` FOR EACH ROW BEGIN
	IF (NEW.mch_date_deb != OLD.mch_date_deb) && (NEW.mch_date_fin IS NULL) THEN DELETE FROM t_joueur_jou WHERE mch_code = NEW.mch_code;
	END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `t_profil_pro`
--

CREATE TABLE `t_profil_pro` (
  `pro_nom` varchar(60) NOT NULL,
  `pro_prenom` varchar(60) NOT NULL,
  `pro_mail` varchar(80) DEFAULT NULL,
  `pro_role` char(1) NOT NULL DEFAULT 'F',
  `pro_date_crea` datetime NOT NULL,
  `pro_actif` tinyint(4) NOT NULL DEFAULT 0,
  `rsp_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `t_profil_pro`
--

INSERT INTO `t_profil_pro` (`pro_nom`, `pro_prenom`, `pro_mail`, `pro_role`, `pro_date_crea`, `pro_actif`, `rsp_id`) VALUES
('Frish', 'Elana', 'responsable@e-quizine.com', 'A', '2018-01-01 00:00:00', 1, 1),
('Jean', 'Hippolyte', 'hippolyte.jean@etudiant.univ-brest.fr', 'A', '2022-10-07 16:48:16', 1, 2),
('Dupont', 'Joann', 'J.Dupont@gmail.com', 'A', '2022-10-07 16:48:16', 1, 3),
('Marc', 'Valerie', 'valerie.marc@univ-brest.fr', 'F', '2022-10-07 16:48:16', 1, 4),
('Jones', 'Jessica', 'Jess.Jones@gmail.com', 'F', '2022-10-07 16:48:16', 1, 5),
('Fongemie', 'Renee', 'Fongemie.R@gmail.com', 'F', '2022-10-07 16:48:16', 0, 6),
('Trahou', 'Cecile', 'Cec_Trahou@laposte.net', 'F', '2022-10-07 16:48:16', 1, 7),
('Durand', 'Eric', NULL, 'F', '2022-10-07 16:48:16', 1, 8),
('Tu', 'Xie', 'tuxtux@mail.fr', 'F', '2022-10-18 14:36:14', 1, 9);

-- --------------------------------------------------------

--
-- Structure de la table `t_question_qst`
--

CREATE TABLE `t_question_qst` (
  `qst_id` int(11) NOT NULL,
  `qst_intitule` varchar(200) NOT NULL,
  `qst_active` tinyint(4) NOT NULL DEFAULT 1,
  `qst_points` double NOT NULL DEFAULT 1,
  `qst_ordre` int(11) NOT NULL,
  `qiz_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `t_question_qst`
--

INSERT INTO `t_question_qst` (`qst_id`, `qst_intitule`, `qst_active`, `qst_points`, `qst_ordre`, `qiz_id`) VALUES
(1, 'De quelle famille de lipide est majoritairement composée la membrane d\'une cellule ?', 1, 1, 1, 1),
(2, 'Comment appele-t-on les organismes unicellulaire ne possedant pas de noyau ?', 1, 1, 2, 1),
(3, 'Comment s\'appelle la théorie évolutive selon laquelle les organites des eucaryotes sont le résultat de l\'incorporation de bactéries par une cellule eucaryote primitive ?', 1, 1, 3, 1),
(4, 'Quelle est le nom donné à la fonction assurée par les mitochondries ?', 1, 1, 4, 1),
(5, 'Les cellules végétales possèdent une structure extra cellulaire, absente chez les cellules animales, assurant une protection et un renfort supplémentaire. Laquelle ?', 1, 1, 5, 1),
(6, 'Comment s\'appelle la couche la plus externe de la lithosphère terrestre ?', 1, 1, 1, 2),
(7, 'Laquelle de ces couches possède une densité moyenne plus élevée ?', 1, 1, 2, 2),
(8, 'Parmis les réponses proposées, laquelle n\'est PAS un type de volcanisme ?', 1, 1, 3, 2),
(9, 'Lorsqu\'un magma refroidis très lentement, pendant des milliers d\'année, cela forme des roches dîtes :', 1, 1, 4, 2),
(10, 'Le nord magnétique est le même que le nord geographique.', 1, 1, 5, 2),
(11, 'A quelle période remonte les plus anciennes traces de vie sur Terre ?', 1, 1, 1, 3),
(12, 'Parmis les plus anciennes trace de vie sur Terre, certaines sont des structures calcaires créées par des cyanobactéries. Quel est leur nom ?', 1, 1, 2, 3),
(13, 'La colonisation du milieux terrestre par les animaux a eu lieu il y a :', 1, 1, 3, 3),
(14, 'Qu\'est-ce-que l\'explosion cambrienne ?', 1, 1, 4, 3),
(15, 'Comment s\'appelle le dernier supercontinent s\'étant formé ?', 1, 1, 5, 3),
(16, 'Comment s\'appelle la macro-molécule présente de le noyau des cellules eucariotes, et servant de support aux informations génétiques ?', 1, 1, 1, 4),
(17, 'Parmis les réponses proposées, laquelle est une base azotée constituante de l\'ADN ?', 1, 1, 2, 4),
(18, 'Parmis les types de taxons suivant, lequels sont les seuls permettant de classer le vivant logiquement ?', 1, 1, 3, 4),
(19, 'La division cellulaire menant à la création de gamettes s\'appelle :', 1, 1, 4, 4),
(20, 'Parmis les associations entre bases azotées suivante, laquelle est la correcte ?', 1, 1, 5, 4),
(21, 'Quelle famille d\'organismes fut la première à développer la photosynthèse ?', 1, 1, 1, 5),
(22, 'A quelle époque remonte la colonisation du milieu terrestre par les plantes ?', 1, 1, 2, 5),
(23, 'Les angiospèrme sont :', 1, 1, 3, 5),
(24, 'Les gymnospermes sont :', 1, 1, 5, 5),
(25, 'Parmis les réponses suivantes, laquelle n\'est PAS une fonction de la paroi pectocellulosique des cellules végétales ?', 1, 1, 6, 5),
(70, 'test', 1, 1, 1, 19),
(71, 'test', 1, 1, 1, 20),
(72, 'A quelle période remonte les plus anciennes traces de vie sur Terre ?', 1, 1, 1, 21),
(73, 'Parmis les plus anciennes trace de vie sur Terre, certaines sont des structures calcaires créées par des cyanobactéries. Quel est leur nom ?', 1, 1, 2, 21),
(74, 'La colonisation du milieux terrestre par les animaux a eu lieu il y a :', 1, 1, 3, 21),
(75, 'Qu\'est-ce-que l\'explosion cambrienne ?', 1, 1, 4, 21),
(76, 'Comment s\'appelle le dernier supercontinent s\'étant formé ?', 1, 1, 5, 21);

--
-- Déclencheurs `t_question_qst`
--
DELIMITER $$
CREATE TRIGGER `on_question_deletion` AFTER DELETE ON `t_question_qst` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `suppr_rep_de_qst` BEFORE DELETE ON `t_question_qst` FOR EACH ROW BEGIN
	DELETE FROM t_reponse_rep WHERE qst_id = OLD.qst_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `t_quiz_qiz`
--

CREATE TABLE `t_quiz_qiz` (
  `qiz_id` int(11) NOT NULL,
  `qiz_titre` varchar(100) NOT NULL,
  `qiz_theme` varchar(45) NOT NULL,
  `qiz_image` varchar(200) DEFAULT NULL,
  `qiz_actif` tinyint(4) DEFAULT NULL,
  `qiz_img_date_heure` datetime DEFAULT NULL,
  `rsp_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `t_quiz_qiz`
--

INSERT INTO `t_quiz_qiz` (`qiz_id`, `qiz_titre`, `qiz_theme`, `qiz_image`, `qiz_actif`, `qiz_img_date_heure`, `rsp_id`) VALUES
(1, 'Bio Cell 101', 'Biologie cellulaire', 'cellule.png', 1, '2022-10-07 16:48:16', 3),
(2, 'Test géologie - Débutant', 'Géologie', 'terre.svg', 1, '2022-10-07 16:48:16', 7),
(3, 'Test Paléobiologie - Débutant', 'Paléobiologie', 'dino.png', 1, '2022-10-07 16:48:16', 7),
(4, 'Controle de connaissance : génétique', 'Génétique', 'adn.png', 1, '2022-10-18 14:05:39', 8),
(5, 'Les organismes végétaux', 'Biologie végétale', 'plante.svg', 1, '2022-10-07 16:48:16', 8),
(18, 'TEST QUIZ VIDE', '??????', 'dino.png', 1, '2022-10-07 16:48:16', 5),
(19, 'TEST QUIZ AVEC 1 QUESTION SANS REPONSES', '??????', 'dino.png', 1, '2022-10-07 16:48:16', 5),
(20, 'TEST QUIZ AVEC 1 QUESTION AYANT 2 REPONSES', '??????', 'dino.png', 1, '2022-10-07 16:48:16', 5),
(21, 'Quiz Désactivé', '??????', 'adn.png', 0, '2022-10-07 16:48:16', 4);

--
-- Déclencheurs `t_quiz_qiz`
--
DELIMITER $$
CREATE TRIGGER `suppr_qst_de_qiz` BEFORE DELETE ON `t_quiz_qiz` FOR EACH ROW BEGIN
	DELETE FROM t_question_qst WHERE qiz_id = OLD.qiz_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `t_reponse_rep`
--

CREATE TABLE `t_reponse_rep` (
  `rep_id` int(11) NOT NULL,
  `rep_libelle` varchar(100) NOT NULL,
  `rep_valide` tinyint(4) NOT NULL,
  `qst_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `t_reponse_rep`
--

INSERT INTO `t_reponse_rep` (`rep_id`, `rep_libelle`, `rep_valide`, `qst_id`) VALUES
(1, 'De phospholipides.', 1, 1),
(2, 'D\'acide gras.', 0, 1),
(3, 'De stérols.', 0, 1),
(4, 'Les procaryotes.', 1, 2),
(5, 'Les Autocaryotes.', 0, 2),
(6, 'Les eucaryotes.', 0, 2),
(7, 'Les mesocaryotes.', 0, 2),
(8, 'La théorie endosymbiotique.', 1, 3),
(9, 'La théorie protosymbiotique.', 0, 3),
(10, 'La théorie cytosymbiotique.', 0, 3),
(11, 'La théorie pharosymbiotique.', 0, 3),
(12, 'La respiration.', 1, 4),
(13, 'La photosynthèse.', 0, 4),
(14, 'La tranformation.', 0, 4),
(15, 'La paroi pectocellulosique.', 1, 5),
(16, 'Le chloroplaste.', 0, 5),
(17, 'Le cytosquelette.', 0, 5),
(18, 'La croute.', 1, 6),
(19, 'Le manteau.', 0, 6),
(20, 'Le noyau.', 0, 6),
(21, 'Le granite.', 0, 6),
(22, 'La croute océanique.', 1, 7),
(23, 'La croute continentale.', 0, 7),
(24, 'Le volcanisme effusif.', 0, 8),
(25, 'Le volcanisme explosif.', 0, 8),
(26, 'Le volcanisme crétacéen.', 1, 8),
(27, 'Volcanique.', 0, 9),
(28, 'Plutonique.', 1, 9),
(29, 'Mantellique.', 0, 9),
(30, 'Pyrolique.', 0, 9),
(31, 'Faux.', 1, 10),
(32, 'Vrai.', 0, 10),
(33, 'Il y a plus de 3.8 milliards d\'années.', 1, 11),
(34, 'Entre 3.0 et 2.5 milliards d\'années.', 0, 11),
(35, 'Entre 1.0 milliard et 500 millions d\'années.', 0, 11),
(36, 'Il y a moins de 225 millions d\'années.', 0, 11),
(37, 'Les stromatolithes.', 1, 12),
(38, 'Les cyanolithes.', 0, 12),
(39, 'Les phytolithes.', 0, 12),
(40, 'Les dendrolithes.', 0, 12),
(41, '430 millions d\'années.', 1, 13),
(42, '1.1 milliard d\'années.', 0, 13),
(43, '225 millions d\'années.', 0, 13),
(44, '780 millions d\'années.', 0, 13),
(45, 'Une période marquant la diversification du reigne animal.', 1, 14),
(46, 'Une eruption ayant eu lieu au Cambrien, marquant la première extinction de masse du vivant.', 0, 14),
(47, 'La fin de la lignée animale cambrienne.', 0, 14),
(48, 'La Pangée.', 1, 15),
(49, 'Nena.', 0, 15),
(50, 'La Panotia.', 0, 15),
(51, 'Ur.', 0, 15),
(52, 'L\'Acide DésoxyriboNucléique.', 1, 16),
(53, 'L\'Acide RiboNucléique.', 0, 16),
(54, 'L\'acide Aminée.', 0, 16),
(55, 'La guanine.', 1, 17),
(56, 'L\'adrénaline.', 0, 17),
(57, 'La phénylalanine.', 0, 17),
(58, 'L\'uracile.', 0, 17),
(59, 'Les groupes monophylétiques.', 1, 18),
(60, 'Les groupes polyphylétiques.', 0, 18),
(61, 'Les groupes paraphylétiques.', 0, 18),
(62, 'La méiose.', 1, 19),
(63, 'La mitose.', 0, 19),
(64, 'A-T  C-G.', 1, 20),
(65, 'A-U  T-G.', 0, 20),
(66, 'U-C  B-G.', 0, 20),
(67, 'B-A  C-T.', 0, 20),
(68, 'Les cyanobactéries.', 1, 21),
(69, 'Les dinophycées.', 0, 21),
(70, 'Les gymnospermes.', 0, 21),
(71, 'A l\'Ordovicien.', 1, 22),
(72, 'A l\'archéen.', 0, 22),
(73, 'Au cénozoïque.', 0, 22),
(74, 'Au paléolithique.', 0, 22),
(75, 'Des plantes à fleurs.', 1, 23),
(76, 'Des plantes à graines.', 0, 23),
(77, 'Des plantes à graines.', 1, 24),
(78, 'Des plantes à fleurs.', 0, 24),
(79, 'Transmettre des hormones aux cellules voisines.', 1, 25),
(80, 'Le soutiens de la plantes.', 0, 25),
(81, 'La protection face aux attaques extérieures.', 0, 25),
(82, 'Limiter les effets d\'une variation de pressions osmotique.', 0, 25),
(134, 'TEST', 1, 71),
(135, 'TEST', 0, 71),
(136, 'Il y a plus de 3.8 milliards d\'années.', 1, 72),
(137, 'Entre 3.0 et 2.5 milliards d\'années.', 0, 72),
(138, 'Entre 1.0 milliard et 500 millions d\'années.', 0, 72),
(139, 'Il y a moins de 225 millions d\'années.', 0, 72),
(143, 'Les stromatolithes.', 1, 73),
(144, 'Les cyanolithes.', 0, 73),
(145, 'Les phytolithes.', 0, 73),
(146, 'Les dendrolithes.', 0, 73),
(150, '430 millions d\'années.', 1, 74),
(151, '1.1 milliard d\'années.', 0, 74),
(152, '225 millions d\'années.', 0, 74),
(153, '780 millions d\'années.', 0, 74),
(157, 'Une période marquant la diversification du reigne animal.', 1, 75),
(158, 'Une eruption ayant eu lieu au Cambrien, marquant la première extinction de masse du vivant.', 0, 75),
(159, 'La fin de la lignée animale cambrienne.', 0, 75),
(160, 'La Pangée.', 1, 76),
(161, 'Nena.', 0, 76),
(162, 'La Panotia.', 0, 76),
(163, 'Ur.', 0, 76);

-- --------------------------------------------------------

--
-- Structure de la table `t_responsable_rsp`
--

CREATE TABLE `t_responsable_rsp` (
  `rsp_id` int(11) NOT NULL,
  `rsp_pseudo` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `rsp_mdp` char(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `t_responsable_rsp`
--

INSERT INTO `t_responsable_rsp` (`rsp_id`, `rsp_pseudo`, `rsp_mdp`) VALUES
(1, 'responsable', '3e4d66ce6ef64301b2f86313292d921c08eff97e730c8e953e12745229acd3c4'),
(2, 'Hi.Jean', 'a37a0cae656642f0e27e179ad3232a553ced2b4638775365c6c4d25ca9b278db'),
(3, 'BiDule', 'bd8c43cad6560ac8cc5cb6a2a59f4a14476242f26a66c12a6f1bb78ec645d08e'),
(4, 'vmarc', '37052eb12b4492a5b2d516cb3a08ac19e3ca94bcd3123fa09b2fa905368e0fd7'),
(5, 'JJones', '4c5fd7499a8caff964215b34f0250ff9198ad50718fe07951dc700cc7a020b36'),
(6, 'Renee05', 'e262da79c12a836f50470bde363c2b5557276e01727e451fe2f0d08e38912e0f'),
(7, 'cecile.T', '3cf1b1f67babcad118d4b79356d8f13c988c4bdddf34dbcaed04a95f9d437e78'),
(8, 'E.Durand', '61a4ce6361facb67a3ec295990cf13208a33f1aae16c3456c689fdbc5af93192'),
(9, 'tuxie', 'c52071294f899907b3e2ccea671dcef0a2c0f88cb7eca55825df66dab9a26a80');

-- --------------------------------------------------------

--
-- Structure de la vue `info_globale_quiz_match`
--
DROP TABLE IF EXISTS `info_globale_quiz_match`;

CREATE ALGORITHM=UNDEFINED DEFINER=`zjeanhi00`@`%` SQL SECURITY DEFINER VIEW `info_globale_quiz_match`  AS SELECT `t_quiz_qiz`.`qiz_id` AS `qiz_id`, `t_quiz_qiz`.`qiz_image` AS `qiz_image`, `t_quiz_qiz`.`qiz_titre` AS `qiz_titre`, `t_quiz_qiz`.`qiz_theme` AS `qiz_theme`, `t_quiz_qiz`.`qiz_actif` AS `qiz_actif`, `T1`.`rsp_pseudo` AS `qiz_auteur`, `t_match_mch`.`mch_intitule` AS `mch_intitule`, `T2`.`rsp_pseudo` AS `mch_auteur`, `t_match_mch`.`mch_code` AS `mch_code`, `t_match_mch`.`mch_actif` AS `mch_actif`, `t_match_mch`.`mch_date_deb` AS `mch_date_deb` FROM (((`t_quiz_qiz` left join `t_match_mch` on(`t_quiz_qiz`.`qiz_id` = `t_match_mch`.`qiz_id`)) join `t_responsable_rsp` `T1`) join `t_responsable_rsp` `T2`) WHERE `T1`.`rsp_id` = `t_quiz_qiz`.`rsp_id` AND `T2`.`rsp_id` = `t_match_mch`.`rsp_id` OR `t_match_mch`.`rsp_id` is null GROUP BY `t_quiz_qiz`.`qiz_titre`, `t_match_mch`.`mch_code`  ;

-- --------------------------------------------------------

--
-- Structure de la vue `info_match`
--
DROP TABLE IF EXISTS `info_match`;

CREATE ALGORITHM=UNDEFINED DEFINER=`zjeanhi00`@`%` SQL SECURITY DEFINER VIEW `info_match`  AS SELECT `t_match_mch`.`mch_code` AS `mch_code`, `t_match_mch`.`mch_intitule` AS `mch_intitule`, `t_match_mch`.`mch_actif` AS `mch_actif`, `t_match_mch`.`mch_date_fin` AS `mch_date_fin`, count(`t_joueur_jou`.`jou_id`) AS `nb_joueur`, sum(`t_joueur_jou`.`jou_score`) / count(`t_joueur_jou`.`jou_id`) AS `moyenne_match` FROM (`t_match_mch` join `t_joueur_jou` on(`t_match_mch`.`mch_code` = `t_joueur_jou`.`mch_code`)) GROUP BY `t_match_mch`.`mch_code`  ;

-- --------------------------------------------------------

--
-- Structure de la vue `info_profil_compte`
--
DROP TABLE IF EXISTS `info_profil_compte`;

CREATE ALGORITHM=UNDEFINED DEFINER=`zjeanhi00`@`%` SQL SECURITY DEFINER VIEW `info_profil_compte`  AS SELECT `t_responsable_rsp`.`rsp_id` AS `rsp_id`, `t_responsable_rsp`.`rsp_pseudo` AS `rsp_pseudo`, `t_responsable_rsp`.`rsp_mdp` AS `rsp_mdp`, `t_profil_pro`.`pro_nom` AS `pro_nom`, `t_profil_pro`.`pro_prenom` AS `pro_prenom`, `t_profil_pro`.`pro_mail` AS `pro_mail`, `t_profil_pro`.`pro_role` AS `pro_role`, `t_profil_pro`.`pro_date_crea` AS `pro_date_crea`, `t_profil_pro`.`pro_actif` AS `pro_actif` FROM (`t_responsable_rsp` join `t_profil_pro` on(`t_responsable_rsp`.`rsp_id` = `t_profil_pro`.`rsp_id`))  ;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `t_actualite_act`
--
ALTER TABLE `t_actualite_act`
  ADD PRIMARY KEY (`act_id`),
  ADD KEY `fk_t_actualite_act_t_responsable_rsp_idx` (`rsp_id`);

--
-- Index pour la table `t_joueur_jou`
--
ALTER TABLE `t_joueur_jou`
  ADD PRIMARY KEY (`jou_id`),
  ADD KEY `fk_t_joueur_jou_t_match_mch1_idx` (`mch_code`);

--
-- Index pour la table `t_match_mch`
--
ALTER TABLE `t_match_mch`
  ADD PRIMARY KEY (`mch_code`),
  ADD KEY `fk_t_match_mch_t_responsable_rsp1_idx` (`rsp_id`),
  ADD KEY `fk_t_match_mch_t_quiz_qiz1_idx` (`qiz_id`);

--
-- Index pour la table `t_profil_pro`
--
ALTER TABLE `t_profil_pro`
  ADD PRIMARY KEY (`rsp_id`),
  ADD KEY `fk_t_profil_pro_t_responsable_rsp1_idx` (`rsp_id`);

--
-- Index pour la table `t_question_qst`
--
ALTER TABLE `t_question_qst`
  ADD PRIMARY KEY (`qst_id`),
  ADD KEY `fk_t_question_qst_t_quiz_qiz1_idx` (`qiz_id`);

--
-- Index pour la table `t_quiz_qiz`
--
ALTER TABLE `t_quiz_qiz`
  ADD PRIMARY KEY (`qiz_id`),
  ADD KEY `fk_t_quiz_qiz_t_responsable_rsp1_idx` (`rsp_id`);

--
-- Index pour la table `t_reponse_rep`
--
ALTER TABLE `t_reponse_rep`
  ADD PRIMARY KEY (`rep_id`),
  ADD KEY `fk_t_reponse_rep_t_question_qst1_idx` (`qst_id`);

--
-- Index pour la table `t_responsable_rsp`
--
ALTER TABLE `t_responsable_rsp`
  ADD PRIMARY KEY (`rsp_id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `t_actualite_act`
--
ALTER TABLE `t_actualite_act`
  MODIFY `act_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;

--
-- AUTO_INCREMENT pour la table `t_joueur_jou`
--
ALTER TABLE `t_joueur_jou`
  MODIFY `jou_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=82;

--
-- AUTO_INCREMENT pour la table `t_question_qst`
--
ALTER TABLE `t_question_qst`
  MODIFY `qst_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- AUTO_INCREMENT pour la table `t_quiz_qiz`
--
ALTER TABLE `t_quiz_qiz`
  MODIFY `qiz_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT pour la table `t_reponse_rep`
--
ALTER TABLE `t_reponse_rep`
  MODIFY `rep_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=167;

--
-- AUTO_INCREMENT pour la table `t_responsable_rsp`
--
ALTER TABLE `t_responsable_rsp`
  MODIFY `rsp_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `t_actualite_act`
--
ALTER TABLE `t_actualite_act`
  ADD CONSTRAINT `fk_t_actualite_act_t_responsable_rsp` FOREIGN KEY (`rsp_id`) REFERENCES `t_responsable_rsp` (`rsp_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_joueur_jou`
--
ALTER TABLE `t_joueur_jou`
  ADD CONSTRAINT `fk_t_joueur_jou_t_match_mch1` FOREIGN KEY (`mch_code`) REFERENCES `t_match_mch` (`mch_code`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_match_mch`
--
ALTER TABLE `t_match_mch`
  ADD CONSTRAINT `fk_t_match_mch_t_quiz_qiz1` FOREIGN KEY (`qiz_id`) REFERENCES `t_quiz_qiz` (`qiz_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_t_match_mch_t_responsable_rsp1` FOREIGN KEY (`rsp_id`) REFERENCES `t_responsable_rsp` (`rsp_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_profil_pro`
--
ALTER TABLE `t_profil_pro`
  ADD CONSTRAINT `fk_t_profil_pro_t_responsable_rsp1` FOREIGN KEY (`rsp_id`) REFERENCES `t_responsable_rsp` (`rsp_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_question_qst`
--
ALTER TABLE `t_question_qst`
  ADD CONSTRAINT `fk_t_question_qst_t_quiz_qiz1` FOREIGN KEY (`qiz_id`) REFERENCES `t_quiz_qiz` (`qiz_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_quiz_qiz`
--
ALTER TABLE `t_quiz_qiz`
  ADD CONSTRAINT `fk_t_quiz_qiz_t_responsable_rsp1` FOREIGN KEY (`rsp_id`) REFERENCES `t_responsable_rsp` (`rsp_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Contraintes pour la table `t_reponse_rep`
--
ALTER TABLE `t_reponse_rep`
  ADD CONSTRAINT `fk_t_reponse_rep_t_question_qst1` FOREIGN KEY (`qst_id`) REFERENCES `t_question_qst` (`qst_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
