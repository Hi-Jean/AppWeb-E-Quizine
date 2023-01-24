<?php
class Actualite extends CI_Controller {

	public function __construct()
	{
		parent::__construct();
		$this->load->model('db_model');
		$this->load->helper('url');
	}

	public function afficher($id)
	{
		$data['actu'] = $this->db_model->get_single_actualite($id);

		// Chargement de la view 'haut.php'
		$this->load->view("templates/haut");

		// Chargement de la view 'menu_visiteur.php'
		$this->load->view("templates/menu_visiteur");

		// Chargement de la view 'page_accueil.php'
		$this->load->view("actualite_afficher", $data);

		// Chargement de la view 'bas.php'
		$this->load->view("templates/bas");

	}
}
?>