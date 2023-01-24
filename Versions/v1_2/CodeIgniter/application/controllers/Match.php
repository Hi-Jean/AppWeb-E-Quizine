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

		//$data['match'] = $this->db_model->get_match_infos($code);
		$data['qst_rep'] = $this->db_model->get_match_qst_rep($code);
		$data['joueur'] = $this->input->post('pseudo');

		// Chargement de la view 'haut.php'
		$this->load->view("templates/haut");

		// Chargement de la view 'menu_visiteur.php'
		$this->load->view("templates/menu_visiteur");

		// Chargement de la view 'page_accueil.php'
		$this->load->view("affichage_match", $data);

		// Chargement de la view 'bas.php'
		$this->load->view("templates/bas");

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

			$data['match'] = $this->db_model->get_match_infos($this->input->post('code_match'));

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

		$code = $this->input->post('code_match');
		$joueur = $this->input->post('pseudo');

		$data['rep_validees'] = $this->db_model->match_set_score_joueur($code, $joueur, $points);
		$data['joueur'] = $joueur;

		$this->load->view("templates/haut");
		$this->load->view("templates/menu_visiteur");
		$this->load->view("reponse_recue", $data);
		$this->load->view("templates/bas");


	}



	public function matchs_formateur() {
		if($this->session->userdata('username') == null || $this->session->userdata('role') != 'F') {
			redirect('');
		}

		$this->load->helper('form');
		$this->load->library('form_validation');
		$data['matchs'] = $this->db_model->match_all_by_form($this->session->userdata('username'));


		$this->load->view('templates/haut_back', $data);
		$this->load->view('matchs_form', $data);
		$this->load->view('templates/bas_back');
	}


}
?>