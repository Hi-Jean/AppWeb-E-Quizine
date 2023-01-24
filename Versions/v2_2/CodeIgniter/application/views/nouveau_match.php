            <main class="content">
                <div class="container-fluid p-0">

                    <div class="mb-3">
                        <h1 class="h3 d-inline align-middle">Quiz <i>'<?php echo $info['qiz_titre'] ?>'</i> :</h1>
                    </div>

                    <div class="row">
                        <div class="col-12 col-lg-6">
                            <div class="card">

                                <div class="card-header">
                                    <h2 class='card-title'>Nouveau match</h2>
                                </div>

                                <div class="card-body">
                                    <h5>Intitulé du match :</h5>
                                    <?php
                                        echo validation_errors("<p class='text-danger'>","</p>");

                                        echo form_open('nouveau_match');
                                        $champ1=array('class'=>'form-control', 'name'=>'intitule', 'required'=>'required', 'placeholder'=>'Titre', 'value' => '');
                                        echo form_input($champ1);

                                        echo "<br/>";
                                    ?>
                                        <input type="hidden" name="id_quiz" value="<?php echo $this->input->post('id_quiz') ?>"/>
                                        <input class="btn btn-primary" type="submit" name="submit" value="Nouveau match" />
                                    </form>


                                </div>
                            </div>
                        </div>

                    </div>

                </div>
            </main>