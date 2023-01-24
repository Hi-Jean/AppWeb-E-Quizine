<?php
class Match extends CI_Controller {

	public function __construct()
	{
		parent::__construct();
		$this->load->model('db_model');
		$this->load->helper('url');
	}

	public function afficher($code)
	{

		//if($this->input->post('pseudo') == NULL) redirect('');
		$this->load->helper('form');
		$this->load->library('form_validation');

		$data['qst_rep'] = $this->db_model->get_match_qst_rep($code);
		$data['joueur'] = $this->input->post('pseudo');

		if($this->session->userdata('role') == 'F' && $data['qst_rep'][0]['mch_date_fin'] != NULL) {
			$data['score_joueurs'] = $this->db_model->match_get_score_joueur($code);
			$data['score_total'] = $this->db_model->match_get_total_score($code);
			$data['qst_rep'] = $this->db_model->get_match_qst_rep($code);

			$this->load->view("templates/haut");
			$this->load->view("templates/menu_visiteur");
			$this->load->view("fermeture_match", $data);
			$this->load->view("templates/bas");
		} else {

			// Chargement de la view 'haut.php'
			$this->load->view("templates/haut");

			// Chargement de la view 'menu_visiteur.php'
			$this->load->view("templates/menu_visiteur");

			// Chargement de la view 'page_accueil.php'
			$this->load->view("affichage_match", $data);

			// Chargement de la view 'bas.php'
			$this->load->view("templates/bas");
		}
	}

	

	public function verifier() {
		$this->load->helper('form');
		$this->load->library('form_validation');

		$this->form_validation->set_rules('code_match', 'CodeMatch', 'required|exact_length[8]', array('exact_length' => 'Format du code de match non valide (doit faire 8 caractères de long)'));
		//$this->form_validation->set_rules('pseudo', 'Pseudo', 'required');

		if ($this->form_validation->run() == FALSE) {
			//redirect('');

			$data['actualites'] = $this->db_model->get_last_5_actualite();
			$data['titre'] = "Actualités :";
			$data['matchs'] = $this->db_model->get_all_match();

			$this->load->library('form_validation');

			// Chargement de la view 'haut.php'
			$this->load->view("templates/haut");

			// Chargement de la view 'menu_visiteur.php'
			$this->load->view("templates/menu_visiteur");
			
			// Chargement de la view 'page_accueil.php'
			$this->load->view("page_accueil", $data);

			// Chargement de la view 'bas.php'
			$this->load->view("templates/bas");

		} else {

			$data['match'] = $this->db_model->get_match_infos(addslashes($this->input->post('code_match')));

			if($data['match'] != false) {
				if($data['match']['ouvert'] == 0) redirect('/accueil/afficher/1');


				$this->form_validation->set_rules('pseudo', 'Pseudo', 'required|max_length[20]', array('max_length' => 'Le %s entré est trop long trop long.'));

				if ($this->form_validation->run() == FALSE) {

					$this->load->view('templates/haut');
					$this->load->view('templates/menu_visiteur');
					$this->load->view('formulaire_joueur');			
					$this->load->view('templates/bas');
				} else {
					$data['joueur'] = $this->db_model->get_match_joueur($this->input->post('code_match'), $this->input->post('pseudo'));

					if($data['joueur'] != false) {
						$this->load->view('templates/haut');
						$this->load->view('templates/menu_visiteur');
						$this->load->view('formulaire_joueur');			
						$this->load->view('templates/bas');
					} else {

						$this->db_model->create_joueur();

						$this->afficher($this->input->post('code_match'));
						//redirect('/match/afficher/'.$this->input->post('code_match'));
					}

				}
			} else {
				/*
				$this->load->library('../controllers/accueil');
				$this->accueil->afficher(0);
				*/

				redirect('/accueil/afficher/0');
				
				/*
				$data['actualites'] = $this->db_model->get_last_5_actualite();
				$data['titre'] = "Actualités :";
				$data['code_valide'] = 0;

				$this->load->library('form_validation');

				// Chargement de la view 'haut.php'
				$this->load->view("templates/haut");

				// Chargement de la view 'menu_visiteur.php'
				$this->load->view("templates/menu_visiteur");
				
				// Chargement de la view 'page_accueil.php'
				$this->load->view("page_accueil", $data);

				// Chargement de la view 'bas.php'
				$this->load->view("templates/bas");
				*/
			}

			
		}
	}



	public function fermer() {
		
		if($this->session->userdata('username') == null || $this->session->userdata('role') != 'F') {
			redirect('');
		}
		
		$this->load->helper('form');
		$this->load->library('form_validation');

		$this->form_validation->set_rules('code_match', 'CodeMatch', 'required');

		if ($this->form_validation->run() == FALSE) {
			
			redirect('');

		} else {
			$code = $this->input->post('code_match');

			$data['fermeture'] = $this->db_model->match_lock($code);
			$data['score_joueurs'] = $this->db_model->match_get_score_joueur($code);
			$data['score_total'] = $this->db_model->match_get_total_score($code);
			$data['qst_rep'] = $this->db_model->get_match_qst_rep($code);

			$this->load->view("templates/haut");
			$this->load->view("templates/menu_visiteur");
			$this->load->view("fermeture_match", $data);
			$this->load->view("templates/bas");

		}

	}


	public function valider_rep() {
		$this->load->helper('form');
		$this->load->library('form_validation');
		$this->form_validation->set_rules('code_match', 'CodeMatch', 'required|exact_length[8]');
		$this->form_validation->set_rules('pseudo', 'Pseudo', 'required');

		if($this->session->userdata('username') != null || $this->form_validation->run() == FALSE) {
			redirect('');
		}

		$reponses = $this->input->post(NULL, true);
		$points = 0;

		foreach ($reponses as $rep) {
			 $res = $this->db_model->quiz_get_reponse($rep);

			 if($res != null && $res['rep_valide'] == 1) $points++;

		}

		$points = 100 * $points / (count($reponses) - 2);
		$code = $this->input->post('code_match');
		$joueur = $this->input->post('pseudo');

		$data['rep_validees'] = $this->db_model->match_set_score_joueur($code, $joueur, $points);
		$data['joueur'] = $joueur;
		$data['score'] = $points;
		$data['info_match'] = $this->db_model->get_match_infos($code);

		$this->load->view("templates/haut");
		$this->load->view("templates/menu_visiteur");
		$this->load->view("reponse_recue", $data);
		$this->load->view("templates/bas");


	}




	public function visu_corrige() {
		$this->load->helper('form');
		$this->load->library('form_validation');
		$this->form_validation->set_rules('code_match', 'CodeMatch', 'required|exact_length[8]');

		if($this->session->userdata('username') != null || $this->form_validation->run() == FALSE) {
			redirect('');
		}

		$data['qst_rep'] = $this->db_model->get_match_qst_rep($this->input->post('code_match'));

		$this->load->view("templates/haut");
		$this->load->view("templates/menu_visiteur");
		$this->load->view("corrige_match", $data);
		$this->load->view("templates/bas");

	}



	public function remise_a_zero() {
		$this->load->helper('form');
		$this->load->library('form_validation');
		$this->form_validation->set_rules('code_match', 'CodeMatch', 'required|exact_length[8]');

		if($this->session->userdata('role') != 'F' || $this->form_validation->run() == FALSE) {
			redirect('');
		}

		$data['raz'] = $this->db_model->match_raz($this->input->post('code_match'));

		$data['liste_quiz'] = $this->db_model->quiz_get_all_match();
		$data['quiz'] = 1;

		$this->load->view('templates/haut_back', $data);
		$this->load->view('liste_quiz', $data);
		$this->load->view('templates/bas_back');

	}


	public function supprimer() {
		$this->load->helper('form');
		$this->load->library('form_validation');
		$this->form_validation->set_rules('code_match', 'CodeMatch', 'required|exact_length[8]');

		if($this->session->userdata('role') != 'F' || $this->form_validation->run() == FALSE) {
			redirect('');
		}

		$data['del'] = $this->db_model->match_delete($this->input->post('code_match'));

		$data['liste_quiz'] = $this->db_model->quiz_get_all_match();
		$data['quiz'] = 1;

		$this->load->view('templates/haut_back', $data);
		$this->load->view('liste_quiz', $data);
		$this->load->view('templates/bas_back');

	}


	public function act_desact() {
		$this->load->helper('form');
		$this->load->library('form_validation');
		$this->form_validation->set_rules('code_match', 'CodeMatch', 'required|exact_length[8]');

		if($this->session->userdata('role') != 'F' || $this->form_validation->run() == FALSE) {
			redirect('');
		}

		$data['act'] = $this->db_model->match_activate_unactivate($this->input->post('code_match'));

		$data['liste_quiz'] = $this->db_model->quiz_get_all_match();
		$data['quiz'] = 1;

		$this->load->view('templates/haut_back', $data);
		$this->load->view('liste_quiz', $data);
		$this->load->view('templates/bas_back');

	}


	public function formulaire_nouveau_match() {
		$this->load->helper('form');
		$this->load->library('form_validation');
		$this->form_validation->set_rules('id_quiz', 'IDQuiz', 'required');

		if($this->session->userdata('role') != 'F' || $this->form_validation->run() == FALSE) {
			redirect('');
		}

		$quiz_vide = $this->db_model->get_quiz_qst_rep($this->input->post('id_quiz'));

		if(count($quiz_vide) == 0) {
			$data['cree'] = 0;
			$data['quiz'] = 1;
			$data['liste_quiz'] = $this->db_model->quiz_get_all_match();

			$this->load->view('templates/haut_back', $data);
			$this->load->view('liste_quiz', $data);
			$this->load->view('templates/bas_back');
		} else {

			$data['info'] = $this->db_model->quiz_get_single($this->input->post('id_quiz'));
			$data['quiz'] = 1;

			$this->load->view('templates/haut_back', $data);
			$this->load->view('nouveau_match', $data);
			$this->load->view('templates/bas_back');
		}

	}



	public function creer_match() {
		$this->load->helper('form');
		$this->load->library('form_validation');
		$this->form_validation->set_rules('id_quiz', 'IDQuiz', 'required');
		$this->form_validation->set_rules('intitule', 'Intitule', 'required');

		if($this->session->userdata('role') != 'F' || $this->form_validation->run() == FALSE) {
			redirect('');
		}

		$data['new_code'] = $this->db_model->match_new_code();
		$data['cree'] = $this->db_model->match_create($data['new_code']['mch_code'], $this->session->userdata('username'), $this->input->post('id_quiz'));
		$data['quiz'] = 1;
		$data['liste_quiz'] = $this->db_model->quiz_get_all_match();


		$this->load->view('templates/haut_back', $data);
		$this->load->view('liste_quiz', $data);
		$this->load->view('templates/bas_back');

	}




}
?>