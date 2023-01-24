
<?php  ?>

<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="description" content="Responsive Admin &amp; Dashboard Template based on Bootstrap 5">
	<meta name="author" content="AdminKit">
	<meta name="keywords" content="adminkit, bootstrap, bootstrap 5, admin, dashboard, template, responsive, css, sass, html, theme, front-end, ui kit, web">

	<link rel="preconnect" href="https://fonts.gstatic.com">
	<link rel="shortcut icon" href="<?php echo base_url();?>styleback/static/img/icons/icon-48x48.png" />

	<link rel="canonical" href="https://demo-basic.adminkit.io/" />

	<title>AdminKit Demo - Bootstrap 5 Admin Template</title>

	<link href="<?php echo base_url();?>styleback/static/css/app.css" rel="stylesheet">
	<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
</head>

<body>
	<div class="wrapper">
		<nav id="sidebar" class="sidebar js-sidebar">
			<div class="sidebar-content js-simplebar">
				<a class="sidebar-brand" href="<?php echo base_url();?>">
          <span class="align-middle">E-Quizine</span>
        </a>

				<ul class="sidebar-nav">
					<li class="sidebar-header">
						Pages
					</li>

					<li class="sidebar-item <?php if(isset($accueil)) echo "active"; ?>">
						<a class="sidebar-link" href="<?php echo base_url();?>index.php/compte/afficher">
              <i class="align-middle" data-feather="sliders"></i> <span class="align-middle">Dashboard</span>
            </a>
					</li>

					<li class="sidebar-item <?php if(isset($profil)) echo "active"; ?>">
						<a class="sidebar-link" href="<?php echo base_url();?>index.php/compte/afficher_profil">
              <i class="align-middle" data-feather="user"></i> <span class="align-middle">Votre profil</span>
            </a>
					</li>


					<?php

						if($this->session->userdata('role') == 'F') {
							echo "<li class='sidebar-item ";
							if(isset($matchs)) echo "active";
							echo "'>
						<a class='sidebar-link' href='". base_url() ."index.php/match/matchs_formateur'>
              <i class='align-middle' data-feather='book'></i> <span class='align-middle'>Vos matchs</span>
            </a>
					</li>";
						} else {
							echo "<li class='sidebar-item ";
							if(isset($liste)) echo "active";
							echo "'>
						<a class='sidebar-link' href='". base_url() ."index.php/compte/lister_profils'>
              <i class='align-middle' data-feather='book'></i> <span class='align-middle'>Profils utilisateurs</span>
            </a>
					</li>";
						}

					?>


					

					<li class="sidebar-item">
						<a class="sidebar-link" href="<?php echo base_url();?>index.php/compte/fermer">
              <i class="align-middle" data-feather="book"></i> <span class="align-middle">Déconnexion</span>
            </a>
					</li>


			</div>
		</nav>

		<div class="main">
			<nav class="navbar navbar-expand navbar-light navbar-bg">
				<a class="sidebar-toggle js-sidebar-toggle">
          <i class="hamburger align-self-center"></i>
        </a>

				
			</nav>