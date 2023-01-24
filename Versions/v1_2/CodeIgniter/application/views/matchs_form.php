            <main class="content">
                <div class="container-fluid p-0">

                    <div class="mb-3">
                        <h1 class="h3 d-inline align-middle">Vos Matchs</h1>
                    </div>

                    <div class="row">
                        <div class="col-12 col-lg-12">
                            <div class="card">

                                <div class="card-body">
                                    <h4>Matchs :</h4>
                                    
                                    <?php
                                        if($matchs != null) {

                                            echo "<table class='table table-hover my-0'>
                                        <thead>
                                            <tr>
                                                <th>Code</th>
                                                <th>Intitulé</th>
                                                <th>Quiz concerné</th>
                                                <th>Actif</th>
                                                <th>Date de début</th>
                                                <th>Date de fin</th>
                                                <th>Score</th>
                                            </tr>
                                        </thead>
                                        <tbody>";

                                            foreach ($matchs as $match) {
                                                echo "
                                            <tr>
                                                <td><a href='". base_url() ."index.php/match/afficher/". $match['mch_code'] ."'>". $match['mch_code'] ."<a></td>
                                                <td>". $match['mch_intitule'] ."</td>
                                                <td>". $match['qiz_titre'] ."</td>
                                                <td>". $match['mch_actif'] ."</td>
                                                <td>". $match['mch_date_deb'] ."</td>
                                                <td>". ($match['mch_date_fin'] != null ? $match['mch_date_fin'] : "<i>NULL</i>") ."</td>
                                                <td>". ($match['moyenne_match'] != null ? $match['moyenne_match'] : "<i>NULL</i>") ."</td>
                                            </tr>";
                                            }

                                            echo "
                                        </tbody>
                                    </table>";
                                        } else {
                                            echo "<p>Aucun matchs ne vous est associé !</p>";
                                        }
                                    ?>


                                </div>
                            </div>
                        </div>

                    </div>

                </div>
            </main>