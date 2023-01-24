            <main class="content">
                <div class="container-fluid p-0">

                    <div class="mb-3">
                        <h1 class="h3 d-inline align-middle">Changement du mot de passe</h1>
                    </div>

                    <div class="row">
                        <div class="col-12 col-lg-6">
                            <div class="card">
                                <div class="card-header">
                                    <h3 class="card-title mb-0">Changez votre mot de passe</h3>
                                </div>
                                <div class="card-body">

                                    <?php
                                    echo validation_errors("<p class='text-danger'>","</p>");

                                    if(isset($echec) && $echec == TRUE) echo "<p class='text-success'>Mot de passe modifié avec succes !</p>";

                                    echo form_open('changer_mdp');

                                    echo form_label('Nouveau mot de passe :');
                                    $champ1=array('class'=>'form-control', 'name'=>'mdp', 'required'=>'required', 'placeholder'=>'Mot de passe', 'value' => '');
                                    echo form_password($champ1);

                                    echo "<br/>";

                                    echo form_label('Confirmation du nouveau mot de passe :');
                                    $champ2=array('class'=>'form-control', 'name'=>'mdp_conf', 'required'=>'required', 'placeholder'=>'Confirmation du mot de passe', 'value' => '');
                                    echo form_password($champ2);

                                    echo "<br/>";
                                ?>

                                <input class="btn btn-primary" type="submit" name="submit" value="Changer le mot de passe" />
                                </form>
                                <br/>
                                <a href="<?php echo base_url();?>index.php/compte/afficher_profil"><button class="btn btn-secondary">Retour</button></a>
                                </div>
                            </div>


                        </div>
                    </div>

                </div>
            </main>