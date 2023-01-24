<?php
class Accueil extends CI_Controller {

	public function __construct()
	{
		parent::__construct();
		$this->load->model('db_model');
		$this->load->helper('url');
	}

	public function afficher($code_valide=null)
	{
		$data['actualites'] = $this->db_model->get_last_5_actualite();
		$data['titre'] = "Actualités :";
		$data['matchs'] = $this->db_model->get_all_match();
		if($code_valide != null) $data['code_valide'] = $code_valide;

		$this->load->library('form_validation');

		// Chargement de la view 'haut.php'
		$this->load->view("templates/haut");

		// Chargement de la view 'menu_visiteur.php'
		$this->load->view("templates/menu_visiteur");

		// Chargement de la view 'page_accueil.php'
		$this->load->view("page_accueil", $data);

		// Chargement de la view 'bas.php'
		$this->load->view("templates/bas");

	}
}
?>