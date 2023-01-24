<?php
class Quiz extends CI_Controller {

	public function __construct()
	{
		parent::__construct();
		$this->load->model('db_model');
		$this->load->helper('url');
	}

	
	public function liste_quiz() {
		$this->load->helper('form');
		$this->load->library('form_validation');
		if($this->session->userdata('username') == null) {
			redirect('');
		}

		$data['liste_quiz'] = $this->db_model->quiz_get_all_match();
		$data['quiz'] = 1;

		$this->load->view('templates/haut_back', $data);
		$this->load->view('liste_quiz', $data);
		$this->load->view('templates/bas_back');


	}


}
?>