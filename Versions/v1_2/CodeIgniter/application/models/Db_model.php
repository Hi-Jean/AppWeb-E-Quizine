<!-- 
#==========================================================#
#          MODELE PRINCIPAL DE L'ARCHITECTURE MVC          #
#==========================================================#
#	Nom du fichier : Db_model.php                          #
#	Auteur(s) : Hippolyte Jean                             #
#	Version : 1.0                                          #
#	Date de création : 2022/11/09                          #
#----------------------------------------------------------#
#	Description :                                          #
#		- Seul et unique modèle de l'architecture MVC du   #
#		  projet E-Quizine.                                #
#		- Contient toutes les fonctions membres envoyant   #
#		  les requêtes utiles au bon fonctionnement de     #
#		  l'application à la BD.                           #
#                                                          #
#==========================================================#
-->

<?php


	/**
	 * Classe Db_model répertoriant toutes les méthodes nécessaire à la communication avec la base de donnée.
	 */
	class Db_model extends CI_Model	{

		// Constructeur de la classe
		// Charge la BD une fois pour toute
		public function __construct() {
			parent::__construct();
			$this->load->database();
		}




		/*###########################################################################################################################
		#                                       FONCTIONS MEMBRES DE GESTION CRUD DES COMPTES                                       #
		###########################################################################################################################*/



		/**
		 * Fonction retournant la liste des pseudo associés aux comptes présent dans la base de données.
		 * 
		 * @return Array	Pseudos des comptes	
		 */
		public function get_all_compte() {

			$query = $this->db->query("SELECT rsp_pseudo FROM t_responsable_rsp;");
			return $query->result_array();

		}


		/**
		 * Fonction retournant les information concernant le compte d'un utilisateur dans la base de données.
		 * 
		 * @param $pseudo Pseudo associé au compte
		 * 
		 * @return Array	Infos du compte	
		 */
		public function get_compte_info($pseudo) {

			$query = $this->db->query("SELECT * FROM t_responsable_rsp JOIN t_profil_pro USING(rsp_id) WHERE rsp_pseudo = '".$pseudo."';");
			return $query->row_array();

		}


		/**
		 * Fonction retournant les information concernant tous les comptes utilisateur de la base de données.
		 * 
		 * @return Array	Infos des comptes	
		 */
		public function get_all_compte_info() {

			$query = $this->db->query("SELECT * FROM t_responsable_rsp JOIN t_profil_pro USING(rsp_id);");
			return $query->result_array();

		}


		/**
		 * Fonction retournant un tableau contenant le nombre de comptes existants.
		 * 
		 * @return Array	
		 */
		public function get_count_compte() {

			$query = $this->db->query("SELECT COUNT(rsp_pseudo) as total FROM t_responsable_rsp;");
			return $query->row_array();

		}


		/**
		 * Fonction inserant un nouveau compte dans la BD, à partir d'un formulaire.
		 * 
		 */
		public function set_compte() {
			$this->load->helper('url');

			$id=$this->input->post('id');
			$mdp=$this->input->post('mdp');

			$salt = "OnRajouteDuSelPourAllongerleMDP123!!45678__Test";

			$req="INSERT INTO t_responsable_rsp(rsp_id, rsp_pseudo, rsp_mdp) VALUES (NULL,'".$id."','".hash('sha256', $salt.$mdp)."');";
			$query = $this->db->query($req);

			$this->db->query("INSERT INTO t_profil_pro(pro_nom, pro_prenom, pro_mail, pro_role, pro_date_crea, pro_actif, rsp_id)
								SELECT 'NOM', 'PRENOM', NULL, 'F', NOW(), 0, rsp_id
								FROM t_responsable_rsp WHERE rsp_pseudo = '". $id ."';");

			return ($query);
		}


		/**
		 * Fonction verifiant qu'il existe bien un compte ayant le pseudo et le mdp donné.
		 * 
		 * @param $usename le pseudo associé au compte
		 * @param $password le mdp associé au compte
		 * 
		 * @return Boolean true si couple $usenarme - $password existe, false sinon
		 */
		public function connect_compte($username, $password) {

			$salt = "OnRajouteDuSelPourAllongerleMDP123!!45678__Test";

			$query =$this->db->query("SELECT rsp_pseudo, rsp_mdp
										FROM t_responsable_rsp JOIN t_profil_pro USING(rsp_id)
										WHERE rsp_pseudo = '". $username ."'
										AND rsp_mdp = '". hash('sha256', $salt.$password) ."'
										AND pro_actif = 1;");

			if($query->num_rows() > 0) {
				return true;
			} else {
				return false;
			}

		}


		/**
		 * Fonction changeant le mot de passe d'un compte donné.
		 * 
		 * @param $username le pseudo du compte dont le mot de passe doit être changé
		 * @param $password le nouveau mdp à associer au compte
		 * 
		 * @return Boolean true si couple $usenarme - $password existe, false sinon
		 */
		public function compte_change_password($username,$password) {

			$salt = "OnRajouteDuSelPourAllongerleMDP123!!45678__Test";

			$query =$this->db->query("UPDATE t_responsable_rsp SET rsp_mdp = '". hash('sha256', $salt.$password) ."'
										WHERE rsp_pseudo = '". $username ."';");

			return $query;
		}



		/*###########################################################################################################################
		#                                      FONCTIONS MEMBRES DE GESTION CRUD DES ACTUALITES                                     #
		###########################################################################################################################*/

		/*-+-+-+-+-+-+-+-+-+-+-+-+-+-+
		# -- EN TANT QUE VISITEUR -- #
		+-+-+-+-+-+-+-+-+-+-+-+-+-+-*/

		/**
		 * Fonction retournant un tableau de toutes les actualités de la table des actualités et leur auteur (login)
		 *
		 * @return Array	Données de toutes les actualités
		 */
		public function get_all_actualite() {
			$query = $this->db->query("SELECT t_actualite_act.*, rsp_pseudo, DATE_FORMAT(act_date_publi, 'Le %d/%m/%Y </br>À %H:%i') as 'date' FROM t_actualite_act JOIN t_responsable_rsp USING(rsp_id);");
			if ($query == false) //Erreur lors de l’exécution de la requête
            { // La requête a echoué
                echo "Error: La requête a echoué \n";
                echo "Errno: " . $mysqli->errno . "\n";
                echo "Error: " . $mysqli->error . "\n";
                exit();
            }
			return $query->result_array();
		}
		

		/**
		 * Fonction retournant un tableau contenant les données d'une actualité.
		 * Prend un entier $ID en argument.
		 * Retourne l'actualité ayant pour act_id la valeur de ID.
		 *
		 * @param integer	$ID	Numero d'actualité
		 * 
		 * @return Array	Données de l'actualité
		 */
		public function get_single_actualite($ID) {
			$query = $this->db->query("SELECT t_actualite_act.*, rsp_pseudo, DATE_FORMAT(act_date_publi, 'Le %d/%m/%Y </br>À %H:%i') as 'date' FROM t_actualite_act JOIN t_responsable_rsp USING(rsp_id) WHERE act_id = ". $ID .";");
			if ($query == false) //Erreur lors de l’exécution de la requête
            { // La requête a echoué
                echo "Error: La requête a echoué \n";
                echo "Errno: " . $mysqli->errno . "\n";
                echo "Error: " . $mysqli->error . "\n";
                exit();
            }
			return $query->row_array();
		}
		

		/**
		 * Fonction retournant un tableau des 5 dernières actualités dans l'ordre décroissant
		 *
		 * @return Array	Données des 5 actualités
		 */
		public function get_last_5_actualite() {
			$query = $this->db->query("SELECT *, DATE_FORMAT(act_date_publi, 'Le %d/%m/%Y </br>À %H:%i') as 'date' FROM t_actualite_act JOIN t_responsable_rsp USING(rsp_id) ORDER BY act_date_publi DESC LIMIT 5;");
			if ($query == false) //Erreur lors de l’exécution de la requête
            { // La requête a echoué
                echo "Error: La requête a echoué \n";
                echo "Errno: " . $mysqli->errno . "\n";
                echo "Error: " . $mysqli->error . "\n";
                exit();
            }
			return $query->result_array();
		}
		

		/**
		 * Fonction retournant un tableau de toutes les actualites contenant un mot particulier.
		 * Prend une chaine $str en argument.
		 * Retourne les actualités dont la colonne act_titre ou act_contenu contient au moins $str.
		 *
		 * @param String	$str	Le mot clé à rechercher dans les actualités
		 * 
		 * @return Array	Données des actualités
		 */
		public function get_all_actualite_like($str) {
			$query = $this->db->query("SELECT * FROM t_actualite_act WHERE act_titre LIKE '". $str ."' OR act_contenu LIKE '". $str ."';");
			if ($query == false) //Erreur lors de l’exécution de la requête
            { // La requête a echoué
                echo "Error: La requête a echoué \n";
                echo "Errno: " . $mysqli->errno . "\n";
                echo "Error: " . $mysqli->error . "\n";
                exit();
            }
			return $query->result_array();
		}
		

		/**
		 * Fonction retournant la liste des actualités postées à une date donnée.
		 * Prend une date $date sous la forme "YYYY-MM-DD" en argument.
		 * Retourne les actualités dont la partie date de act_date_publi (contenant une date et une heure) est égale à $date
		 *
		 * @param String	$date	La date à laquelle les actualites doivent avoir été postées 
		 * 
		 * @return Array	Données des actualités
		 */
		public function get_all_actualite_date($date) {
			$query = $this->db->query("SELECT t_actualite_act.*, rsp_pseudo FROM t_actualite_act JOIN t_responsable_rsp USING(rsp_id) WHERE DATE(act_date_publi) = '". $date ."';");
			if ($query == false) //Erreur lors de l’exécution de la requête
            { // La requête a echoué
                echo "Error: La requête a echoué \n";
                echo "Errno: " . $mysqli->errno . "\n";
                echo "Error: " . $mysqli->error . "\n";
                exit();
            }
			return $query->result_array();
		}
		



		/*-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
		# -- EN TANT QUE FORMATEUR/ADMINISTRATEUR -- #
		+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-*/

		/**
		 * Fonction donnant la liste des actualites écritent par un auteur donné.
		 * Prend un pseudo $auteur en argument.
		 * Retourne les actualités dont le pseudo associé à rsp_id de la table des actualités est $auteur.
		 *
		 * @param String	$auteur	Pseudo exacte de l'auteur.
		 * 
		 * @return Array	Données des actualités
		 */
		public function get_all_actualite_auteur($auteur) {

			$query = $this->db->query("SELECT t_actualite_act.*, rsp_pseudo
										FROM t_actualite_act JOIN t_responsable_rsp USING(rsp_id)
										WHERE rsp_pseudo = '". $auteur ."';");
			return $query->result_array();

		}


		/**
		 * Fonction inserrant une nouvelle ligne dans la table des actualités.
		 *
		 * @param String	$titre			Titre de la nouvelle actualité.
		 * @param String	$pseudo_auteur	Auteur de la nouvelle actualité.
		 * @param String	$contenu		Contenu de la nouvelle actualité (OPTIONNEL).
		 * 
		 * @return Status	
		 */
		public function create_actualite($titre, $pseudo_auteur, $contenu=NULL) {

			if(is_null($contenu))
				$query = $this->db->query("INSERT INTO `t_actualite_act` (`act_id`, `act_titre`, `act_contenu`, `act_date_publi`, `rsp_id`)
											SELECT NULL, '". $titre ."', NULL, NOW(), rsp_id
    										FROM t_responsable_rsp
    										WHERE rsp_pseudo = '". $pseudo_auteur ."';");
			else
				$query = $this->db->query("INSERT INTO `t_actualite_act` (`act_id`, `act_titre`, `act_contenu`, `act_date_publi`, `rsp_id`)
											SELECT NULL, '". $titre ."', '". $contenu ."', NOW(), rsp_id
    										FROM t_responsable_rsp
    										WHERE rsp_pseudo = '". $pseudo_auteur ."';");

			return $query->result_array();

		}







		/*###########################################################################################################################
		#                                       FONCTIONS MEMBRES DE GESTION CRUD DES MATCHS                                        #
		###########################################################################################################################*/


		/**
		 * Fonction récupérant toutes les informations de tous les matchs dans la base de données
		 * 
		 * @return Array	
		 */
		public function get_all_match() {

			$query = $this->db->query("SELECT *	FROM t_match_mch");

			return $query->row_array();

		}


		/**
		 * Fonction récupérant toutes les données (questions, choix possibles) d’un questionnaire associé à un match dont on connaît le code
		 *
		 * @param String	$code_match		Code du match.
		 * 
		 * @return Array	
		 */
		public function get_match_infos($code_match) {

			$query = $this->db->query("SELECT *, (mch_actif && (mch_date_deb < NOW())) AS ouvert
										FROM t_match_mch
										WHERE mch_code = '". $code_match ."';");

			return $query->row_array();

		}


		/**
		 * Fonction récupérant toutes les données (questions, choix possibles) d’un questionnaire associé à un match dont on connaît le code
		 *
		 * @param String	$code_match		Code du match.
		 * 
		 * @return Array	
		 */
		public function get_match_qst_rep($code_match) {

			$query = $this->db->query("SELECT *
										FROM t_match_mch JOIN t_quiz_qiz USING(qiz_id) JOIN t_question_qst USING(qiz_id) JOIN t_reponse_rep USING(qst_id)
										WHERE mch_code = '". $code_match ."'
										ORDER BY RAND();");

			return $query->result_array();

		}


		/**
		 * Fonction vérifiant si il existe déjà un joueur avec un pseudo donné dans un match.
		 *
		 * @param String	$code_match		Code du match.
		 * @param String	$pseudo			Pseudo du joueur.
		 * 
		 * @return Status	
		 */
		public function get_match_joueur($code_match, $pseudo) {
			$query = $this->db->query("SELECT *
										FROM t_joueur_jou
										WHERE mch_code = '". $code_match ."'
										AND jou_pseudo = '". $pseudo ."';");

			return $query->result_array();
		}



		/**
		 * Fonction inserrant une nouvelle ligne dans la table des joueurs.
		 * 
		 * @return Status	
		 */
		public function create_joueur() {
			$this->load->helper('url');

			$pseudo=$this->input->post('pseudo');
			$code_match=$this->input->post('code_match');

			$query = $this->db->query("INSERT INTO `t_joueur_jou` (`jou_id`, `jou_pseudo`, `jou_score`, `mch_code`)
											VALUES (NULL, '". $pseudo ."', NULL, '". $code_match ."');");
			return ($query);

		}


		/**
		 * Fonction récupérant les information concernant les matchs créés par un formateur donné.
		 * 
		 * @param $formateur Le pseudo du formateur dont on doit récupérer les matchs
		 * 
		 * @return Status	
		 */
		public function match_all_by_form($formateur) {
			$query = $this->db->query("SELECT *, moyenne_match
							FROM t_match_mch JOIN info_match USING(mch_code) JOIN t_quiz_qiz USING(qiz_id)
							WHERE t_match_mch.rsp_id = (SELECT rsp_id FROM t_responsable_rsp WHERE rsp_pseudo = '". $formateur ."');");

			return $query->result_array();
		}


		/**
		 * Fonction de fermeture d'un match donné.
		 * 
		 * @param $code Le code du match devant être fermé
		 * 
		 * @return Boolean true si la fermeture a bien été faite, sinon false
		 */
		public function match_lock($code_match) {
			$query = $this->db->query("UPDATE t_match_mch SET mch_actif = 0, mch_date_fin = NOW() WHERE mch_code = '". $code_match ."';");

			return ($query);
		}

		/**
		 * Fonction retournant le score final d'un match donné.
		 * 
		 * @param $code_match Le code du match dont on veut calculer le score
		 * 
		 * @return Array
		 */
		public function match_get_total_score($code_match) {
			$query = $this->db->query("SELECT moyenne_match FROM info_match WHERE mch_code = '". $code_match ."';");

			return $query->row_array();
		}

		/**
		 * Fonction récupérant les scores de tous les joueur ayant participé à un match donné.
		 * 
		 * @param $code_match Le code du match dont on veut récupérer les scores de joueurs
		 * 
		 * @return Array 
		 */
		public function match_get_score_joueur($code_match) {
			$query = $this->db->query("SELECT * FROM t_joueur_jou WHERE mch_code = '". $code_match ."' AND jou_score IS NOT NULL;");

			return $query->result_array();
		}


		/**
		 * Fonction modifiant le score associé à un joueur participant à un match donné.
		 * 
		 * @param $code_match Le code du match au quel le joueur participe
		 * @param $joueur Le pseudo du joueur sont on veut changer le score
		 * @param $points Le nouveau score du joueur
		 * 
		 * @return Boolean 
		 */
		public function match_set_score_joueur($code_match, $joueur, $points) {
			$query = $this->db->query("UPDATE t_joueur_jou SET jou_score = ". $points ." WHERE jou_pseudo = '". $joueur ."' AND mch_code = '". $code_match ."';");

			return ($query);
		}



		/*###########################################################################################################################
		#                                        FONCTIONS MEMBRES DE GESTION CRUD DES QUIZ                                         #
		###########################################################################################################################*/

		/**
		 * Fonction les informations associé à une réponse données.
		 * 
		 * @param $rep_id L'identifiant de la réponse dont on veut obtenir les informations
		 * 
		 * @return Array 
		 */
		public function quiz_get_reponse($rep_id) {
			$query = $this->db->query("SELECT * FROM t_reponse_rep WHERE rep_id = '". $rep_id ."';");

			return $query->row_array();
		}




	}

?>