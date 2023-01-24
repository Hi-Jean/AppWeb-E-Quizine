            <main class="content">
                <div class="container-fluid p-0">

                    <div class="mb-3">
                        <h1 class="h3 d-inline align-middle">Vos Matchs</h1>
                    </div>

                    <div class="row">
                        <div class="col-12 col-lg-12">
                            <div class="card">

                                <?php
                                    if(isset($act)) {
                                        echo "<div class='card-header'>
                                    <h5 class='card-title'>Activation/Desactivation du profil</h5>
                                    <p class='card-subtitle ". ($act ? "text-success'>REUSSITE" : "text-danger'>ECHEC") ."</p>
                                </div>";
                                    }
                                ?>


                                <div class="card-body">
                                    <h4>Profils :</h4>
                                    
                                    <?php
                                        if($profils != null) {

                                            echo "<table class='table table-hover my-0'>
                                        <thead>
                                            <tr>
                                                <th>Pseudo</th>
                                                <th>Nom</th>
                                                <th>Prenom</th>
                                                <th>Mail</th>
                                                <th>Rôle</th>
                                                <th>Activé</th>
                                                <th>Date de création</th>
                                            </tr>
                                        </thead>
                                        <tbody>";

                                            foreach ($profils as $profil) {
                                                echo "
                                            <tr>
                                                <td>". $profil['rsp_pseudo'] ."</td>
                                                <td>". $profil['pro_nom'] ."</td>
                                                <td>". $profil['pro_prenom'] ."</td>
                                                <td>". ($profil['pro_mail'] != null ? $profil['pro_mail'] : "<i>NULL</i>") ."</td>
                                                <td>". ($profil['pro_role'] == 'F' ? "Formateur" : "Admin") ."</td>
                                                <td style='text-align : center;'>". form_open('act_profil', array('id' => 'form_act_'.$profil['rsp_id'])) . "<input type='hidden' name='id_resp' value='". $profil['rsp_id'] ."'></form>" .
                                                ($profil['pro_actif'] == 1 ?
                                                    "<button form='form_act_". $profil['rsp_id'] ."' class='btn btn-success btn-sm'></button>"
                                                    :
                                                    "<button form='form_act_". $profil['rsp_id'] ."' class='btn btn-danger btn-sm'></button>") ."</td>
                                                <td>". ($profil['pro_date_crea'] != null ? $profil['pro_date_crea'] : "<i>NULL</i>") ."</td>
                                            </tr>";
                                            }

                                            echo "
                                        </tbody>
                                    </table>";
                                        } else {
                                            echo "<p>Aucuns profils existant</p>";
                                        }
                                    ?>


                                </div>
                            </div>
                        </div>

                    </div>

                </div>
            </main>