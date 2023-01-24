        <section class="slider-area slider-area2">
            <div class="slider-active">
                <!-- Single Slider -->
                <div class="single-slider slider-height2">
                    <div class="container">
                        <div class="row">
                            <div class="col-xl-8 col-lg-11 col-md-12">
                                <div class="hero__caption hero__caption2">
                                    <h1 data-animation="bounceIn" data-delay="0.2s">Match <?php echo "&ndash; ". $qst_rep[0]['mch_code']; ?> <br/>
                                        <h3 class="text-white"><?php echo $qst_rep[0]['mch_intitule'];?> </h3>
                                    </h1>
                                </div>
                            </div>
                        </div>
                    </div>          
                </div>
            </div>
        </section>
        <!--? Blog Area Start-->
        <section class="blog_area section-padding">
            <div class="container">
                <div class="row">
                    <div>

                    <?php
                        echo "
                        <h1>Score des joueurs participants :</h1>
                        
                        <table class='my-table col-md-12'>
                            <thead>
                                <tr>
                                    <th>Joueur</th>
                                    <th>Score</th>
                                </tr>
                            </thead>
                            <tbody>";

                        foreach ($score_joueurs as $jou) {
                            echo "
                                <tr>
                                    <td>". $jou['jou_pseudo'] ."</td>
                                    <td>". ($jou['jou_score'] == null ? "0" : $jou['jou_score']) ."</td>
                                </tr>";
                        }

                        echo "
                            <tr>
                                <th>NOMBRE DE JOUEURS: ". $score_total['nb_joueur'] ."</th>
                                <th>MOYENNE: ". $score_total['moyenne_match'] ."</th>
                            </tr>
                            </tbody>
                        </table>";


                        echo "
                    </div>
                </div>
                </br>
                </br>
                <div class='row'>
                    <div>
                        <h1>Bonnes réponses :</h1>
                        <br/>";


                        foreach($qst_rep as $qst) {
                            if(!(isset($qst_traite[$qst['qst_id']]))) {
                                
                                echo "
                        <h4>" . $qst['qst_intitule'] . "</h4>";

                                foreach ($qst_rep as $rep) {
                                    
                                    if($qst['qst_id'] == $rep['qst_id'])

                                        echo "
                        <p style='". ($rep['rep_valide'] == 1 ? "background: #73fbaf;" : "background: #e66686;") ."'>". $rep['rep_libelle'] ."</p>";
                                }

                                echo "
                        <br/>";
                                $qst_traite[$qst['qst_id']] = 1;
                            }
                        }

                    ?>
                    </div>
                </div>
            </div>
        </section>
        <!-- Blog Area End -->