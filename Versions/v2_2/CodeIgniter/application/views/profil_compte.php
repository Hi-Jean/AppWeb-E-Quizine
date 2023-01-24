            <main class="content">
                <div class="container-fluid p-0">

                    <div class="mb-3">
                        <h1 class="h3 d-inline align-middle">Vos Informations Personnelles</h1>
                    </div>

                    <div class="row">
                        <div class="col-12 col-lg-6">
                            <div class="card">

                                <div class="card-body">
                                    <h4>Nom :</h4>
                                    <p class="text-muted"> <?php echo $infos['pro_nom']; ?> </p>
                                    <h4>Prenom :</h4>
                                    <p class="text-muted"> <?php echo $infos['pro_prenom']; ?> </p>
                                    <h4>Role :</h4>
                                    <p class="text-muted"> <?php if($infos['pro_role'] == 'A') {echo "Administrateur";} else {echo "Formateur";}  ?> </p>
                                    <h4>Mail :</h4>
                                    <p class="text-muted"> <?php echo $infos['pro_mail'] ?> </p>
                                    <a href="changer_mdp"><button class="btn btn-primary"><i class='align-middle' data-feather='lock'> </i> Modifier vos informations</button></a>
                                </div>
                            </div>
                        </div>

                    </div>

                </div>
            </main>