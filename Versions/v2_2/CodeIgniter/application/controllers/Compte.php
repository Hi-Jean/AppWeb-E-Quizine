<?php
class Compte extends CI_Controller {

	public function __construct()
	{
		parent::__construct();
		$this->load->model('db_model');
		$this->load->helper('url');
	}

	public function lister()
	{
		$data['comptes'] = $this->db_model->get_all_compte();
		$data['count'] = $this->db_model->get_count_compte();
		$data['titre'] = "Comptes :";

		// Chargement de la view 'haut.php'
		$this->load->view("templates/haut");

		// Chargement de la view 'menu_visiteur.php'
		$this->load->view("templates/menu_visiteur");

		// Chargement de la view 'page_accueil.php'
		$this->load->view("affichage_compte", $data);

		// Chargement de la view 'bas.php'
		$this->load->view("templates/bas");

	}


	public function creer() {
		if($this->session->userdata('username') != null) {
			
			redirect('');
		}

		$this->load->helper('form');
		$this->load->library('form_validation');

		$this->form_validation->set_rules('id', 'id', 'required');
		$this->form_validation->set_rules('mdp', 'mdp', 'required');

		if ($this->form_validation->run() == FALSE) {
			$this->load->view('templates/haut');
			$this->load->view('templates/menu_visiteur');
			$this->load->view('compte_creer');
			$this->load->view('templates/bas');
		} else {
			$this->db_model->set_compte();
			$this->load->view('templates/haut');
			$this->load->view('templates/menu_visiteur');
			$this->load->view('compte_succes');
			$this->load->view('templates/bas');
		}
	}



	public function connecter() {

		if($this->session->userdata('username') != null) {
			
			redirect('');
		}

		$this->load->helper('form');
		$this->load->library('form_validation');
		$this->form_validation->set_rules('pseudo', 'pseudo', 'required');
		$this->form_validation->set_rules('mdp', 'mdp', 'required');

		if ($this->form_validation->run() == FALSE)	{

			$this->load->view('templates/haut');
			$this->load->view('templates/menu_visiteur');
			$this->load->view('compte_connecter');
			$this->load->view('templates/bas');

		} else {

			$username = $this->input->post('pseudo');
			$password = $this->input->post('mdp');

			if($this->db_model->connect_compte($username,$password)) {

				$infos = $this->db_model->get_compte_info($username);

				$session_data = array('username' => $username , 'role' => $infos['pro_role']);
				$this->session->set_userdata($session_data);
				$data['accueil'] = 1;

				$this->load->view('templates/haut_back', $data);
				$this->load->view('compte_menu');
				$this->load->view('templates/bas_back');

			} else {
				
				$this->load->view('templates/haut');
				$this->load->view('templates/menu_visiteur');
				$this->load->view('compte_connecter');
				$this->load->view('templates/bas');
			}
		}
	}



	public function afficher() {
		if($this->session->userdata('username') == null) {
			
			redirect('');
		
		}
		$data['accueil'] = 1;

		$this->load->view('templates/haut_back', $data);
		$this->load->view('compte_menu');
		$this->load->view('templates/bas_back');
	}



	public function afficher_profil() {
		if($this->session->userdata('username') == null) {
			
			redirect('');
		
		}


		$data['infos'] = $this->db_model->get_compte_info($this->session->userdata('username'));
		$data['profil'] = 1;

		$this->load->view('templates/haut_back', $data);
		$this->load->view('profil_compte', $data);
		$this->load->view('templates/bas_back');
	}



	public function lister_profils() {
		$this->load->helper('form');
		$this->load->library('form_validation');
		if($this->session->userdata('username') == null || $this->session->userdata('role') != 'A') {
			redirect('');
		}

		$data['liste'] = 1;
		$data['profils'] = $this->db_model->get_all_compte_info();

		$this->load->view('templates/haut_back', $data);
		$this->load->view('liste_profils', $data);
		$this->load->view('templates/bas_back');		 

	}



	public function changer_mdp() {
		if($this->session->userdata('username') == null) {
			
			redirect('');
		
		}

		$this->load->helper('form');
		$this->load->library('form_validation');
		$this->form_validation->set_rules('mdp', 'mdp', 'required|matches[mdp_conf]', array('required'=> 'Le champ de mot de passe ne peux pas être vide', 'matches'=> 'Le mot de passe et sa confimation diffère'));
		$this->form_validation->set_rules('mdp_conf', 'mdp_conf', 'required|matches[mdp_conf]', array('required'=> 'Le champ de confirmation du mot de passe ne peux pas être vide', 'matches'=> 'Le mot de passe et sa confimation diffère'));
		$this->form_validation->set_rules('nom', 'nom', 'required', array('required'=> 'Le champ de nom ne peux pas être vide'));
		$this->form_validation->set_rules('prenom', 'prenom', 'required', array('required'=> 'Le champ de prenom ne peux pas être vide'));

		if ($this->form_validation->run() == TRUE)	{

			$password = $this->input->post('mdp');
			$nom = $this->input->post('nom');
			$prenom = $this->input->post('prenom');

			$data['echec'] = $this->db_model->compte_change_infos($this->session->userdata('username'),$password, $nom, $prenom);

		}

		$data['infos'] = $this->db_model->get_compte_info($this->session->userdata('username'));
		$data['profil'] = 1;

		$this->load->view('templates/haut_back', $data);
		$this->load->view('modifier_mdp', $data);
		$this->load->view('templates/bas_back');
	}



	public function act_desact() {
		$this->load->helper('form');
		$this->load->library('form_validation');
		$this->form_validation->set_rules('id_resp', 'IDResponsable', 'required');

		if($this->session->userdata('role') != 'A' || $this->form_validation->run() == FALSE) {
			redirect('');
		}

		$data['act'] = $this->db_model->profil_activate_unactivate($this->input->post('id_resp'));

		$data['liste'] = 1;
		$data['profils'] = $this->db_model->get_all_compte_info();

		$this->load->view('templates/haut_back', $data);
		$this->load->view('liste_profils', $data);
		$this->load->view('templates/bas_back');	

	}



	public function fermer() {
		if($this->session->userdata('username') != null) {
			$this->session->sess_destroy();
		}

		redirect('');
	}
}
?>