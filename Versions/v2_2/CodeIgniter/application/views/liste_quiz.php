            <main class="content">
                <div class="container-fluid p-0">

                    <div class="mb-3">
                        <h1 class="h3 d-inline align-middle">Les Quiz :</h1>
                    </div>

                    <div class="row">
                        <div class="col-12 col-lg-12">
                            <div class="card">

                                <?php
                                    if(isset($raz)) {
                                        echo "<div class='card-header'>
                                    <h5 class='card-title'>Remise à zéro</h5>
                                    <p class='card-subtitle ". ($raz ? "text-success'>REUSSITE" : "text-danger'>ECHEC") ."</p>
                                </div>";
                                    }
                                    if(isset($del)) {
                                        echo "<div class='card-header'>
                                    <h5 class='card-title'>Suppression du match</h5>
                                    <p class='card-subtitle ". ($del ? "text-success'>REUSSITE" : "text-danger'>ECHEC") ."</p>
                                </div>";
                                    }
                                    if(isset($act)) {
                                        echo "<div class='card-header'>
                                    <h5 class='card-title'>Activation/Desactivation du match</h5>
                                    <p class='card-subtitle ". ($act ? "text-success'>REUSSITE" : "text-danger'>ECHEC") ."</p>
                                </div>";
                                    }
                                    if(isset($cree)) {
                                        echo "<div class='card-header'>
                                    <h5 class='card-title'>Création du match</h5>
                                    <p class='card-subtitle ". ($cree ? "text-success'>REUSSITE (code : ". $new_code['mch_code'] ." )" : "text-danger'>ECHEC (ce quiz ne contient aucune question ayant de réponse et ne peut pas faire de match)") ."</p>
                                </div>";
                                    }
                                ?>

                                <div class="card-body">
                                    
                                    <?php
                                        if($liste_quiz != null) {

                                            echo "<table class='table table-hover my-0'>
                                        <thead>
                                            <tr>
                                                <th></th>
                                                <th>Titre</th>
                                                <th>Theme</th>
                                                <th>Auteur</th>
                                                <th></th>
                                            </tr>
                                        </thead>
                                        <tbody>";

                                            foreach ($liste_quiz as $quiz) {
                                                if(!(isset($quiz_traite[$quiz['qiz_id']])) && $quiz['qiz_actif'] == 1) {
                                                    echo "
                                            <tr style='background : #cfd4da'>
                                                <td><img src='". base_url() ."image/icon/". $quiz['qiz_image'] ."' style='width : 25px;'></td>
                                                <td>". $quiz['qiz_titre'] ."</td>
                                                <td>". $quiz['qiz_theme'] ."</td>
                                                <td>". $quiz['qiz_auteur'] ."</td>
                                                <td>". form_open('form_create_match', array('id' => 'form_create_'.$quiz['qiz_id'])) . "<input type='hidden' name='id_quiz' value='". $quiz['qiz_id'] ."'></form><button form='form_create_". $quiz['qiz_id'] ."' class='btn btn-primary btn-sm'>Creer un match</button></td>
                                            </tr>
                                            <tr>
                                                <td><i class='align-middle' data-feather='corner-down-right'></i></td>
                                                <td colspan='4'>";

                                                    if($quiz['mch_code'] != null) {

                                                        echo "
                                                    <table class='table table-hover my-0'>
                                                        <thead>
                                                            <tr>
                                                                <th>Code</th>
                                                                <th>Intitulé</th>
                                                                <th>Date de début</th>
                                                                <th>Formateur</th>
                                                                <th>Actif</th>
                                                                <th></th>
                                                                <th></th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>";

                                                        foreach ($liste_quiz as $match) {
                                        
                                                        if($quiz['qiz_id'] == $match['qiz_id'])
                                                            echo "
                                                            <tr>
                                                                <td><a href='". base_url() ."index.php/match/afficher/". $match['mch_code'] ."'>". $match['mch_code'] ."<a></td>
                                                                <td>". $match['mch_intitule'] ."</td>
                                                                <td>". $match['mch_date_deb'] ."</td>
                                                                <td>". $match['mch_auteur'] ."</td>
                                                                <td style='text-align : center;'>". ($match['mch_auteur'] == $this->session->userdata('username') ?
                                                                            form_open('act_match', array('id' => 'form_act'.$match['mch_code'])) . "<input type='hidden' name='code_match' value='". $match['mch_code'] ."'></form>" 
                                                                            : 
                                                                            "" ). 
                                                                        ($match['mch_actif'] == 1 ? "<button form='form_act". $match['mch_code'] ."' class='btn btn-success btn-sm' " 
                                                                            : 
                                                                            "<button form='form_act". $match['mch_code'] ."' class='btn btn-danger btn-sm' "). ($match['mch_auteur'] == $this->session->userdata('username') ? "" : "disabled=''" ) ."></button></td>
                                                                <td>". ($match['mch_auteur'] == $this->session->userdata('username') ? form_open('del_match', array('id' => 'form'.$match['mch_code'])) . "<input type='hidden' name='code_match' value='". $match['mch_code'] ."'></form>
                                                                    <button form='form".$match['mch_code']."' class='btn btn-danger btn-sm'><i class='align-middle' data-feather='trash-2'></i></button>" : "") ."</td>
                                                                <td>". ($match['mch_auteur'] == $this->session->userdata('username') ? form_open('raz_match') . "<input type='hidden' name='code_match' value='". $match['mch_code'] ."'><input type='submit' class='btn btn-warning btn-sm' value='RAZ'></form>" : "") ."</td>
                                                            </tr>";
                                                        }

                                                        echo "
                                                        </tbody>
                                                    </table>";
                                                        $quiz_traite[$quiz['qiz_id']] = 1;


                                                    } else {
                                                        echo "Aucuns matchs pour ce quiz.";
                                                    }

                                                    echo "</td>";
                                                }
                                            }

                                            echo "
                                        </tbody>
                                    </table>";
                                        } else {
                                            echo "<p>Aucuns quiz existant</p>";
                                        }
                                    ?>


                                </div>
                            </div>
                        </div>

                    </div>

                </div>
            </main>