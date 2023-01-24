            <main class="content">
                <div class="container-fluid p-0">

                    <div class="mb-3">
                        <h1 class="h3 d-inline align-middle">Changement de vos informations</h1>
                    </div>

                    <div class="row">
                        <div class="col-12 col-lg-6">
                            <div class="card">
                                <div class="card-body">

                                    <?php
                                    echo validation_errors("<p class='text-danger'>","</p>");

                                    if(isset($echec) && $echec == TRUE) echo "<p class='text-success'>Informations modifiées avec succes !</p>";

                                    echo form_open('changer_mdp');

                                    echo form_label('Nouveau nom :');
                                    $champ1=array('class'=>'form-control', 'name'=>'nom', 'required'=>'required', 'placeholder'=>'Nom', 'value' => $infos['pro_nom']);
                                    echo form_input($champ1);

                                    echo "<br/>";

                                    echo form_label('Nouveau prenom :');
                                    $champ2=array('class'=>'form-control', 'name'=>'prenom', 'required'=>'required', 'placeholder'=>'Prenom', 'value' => $infos['pro_prenom']);
                                    echo form_input($champ2);

                                    echo "<br/>";

                                    echo form_label('Nouveau mot de passe :');
                                    $champ3=array('class'=>'form-control', 'name'=>'mdp', 'required'=>'required', 'placeholder'=>'Mot de passe', 'value' => '');
                                    echo form_password($champ3);

                                    echo "<br/>";

                                    echo form_label('Confirmation du nouveau mot de passe :');
                                    $champ4=array('class'=>'form-control', 'name'=>'mdp_conf', 'required'=>'required', 'placeholder'=>'Confirmation du mot de passe', 'value' => '');
                                    echo form_password($champ4);

                                    echo "<br/>";
                                ?>

                                <input class="btn btn-primary" type="submit" name="submit" value="Changer les informations" />
                                </form>
                                <br/>
                                <a href="<?php echo base_url();?>index.php/compte/afficher_profil"><button class="btn btn-secondary">Retour</button></a>
                                </div>
                            </div>


                        </div>
                    </div>

                </div>
            </main>