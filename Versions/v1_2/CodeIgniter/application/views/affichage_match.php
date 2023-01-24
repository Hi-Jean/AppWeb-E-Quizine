        <section class="slider-area slider-area2">
            <div class="slider-active">
                <!-- Single Slider -->
                <div class="single-slider slider-height2">
                    <div class="container">
                        <div class="row">
                            <div class="col-xl-8 col-lg-11 col-md-12">
                                <div class="hero__caption hero__caption2">
                                    <h1 data-animation="bounceIn" data-delay="0.2s">Match <?php echo "&ndash; ". $qst_rep[0]['mch_code']; ?> <br/>
                                        <h3 class="text-white"><?php echo $qst_rep[0]['mch_intitule']; if(isset($joueur)) echo " &ndash; <small>". $joueur ."</small>"; ?> </h3>
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
                        if(isset($qst_rep)) {
                            /*
                            //// V1 AFFICHAGE
                            // Affiche plusieurs fois la même question pour chaque réponse associée
                            foreach ($qst_rep as $el) {
                                echo "
                        ". $el['qst_intitule'] ."
                        <ul>
                            <li>". $el['rep_libelle'] ."</li>
                        </ul>
                                ";
                            }
                            */

                            /*
                            //// V2 AFFICHAGE
                            // Affiche les reponses groupées par question
                            foreach($qst_rep as $qst) {
                                if(!(isset($qst_traite[$qst['qst_id']]))) {
                                    
                                    echo "
                            <h4>" . $qst['qst_intitule'] . "</h4>

                            <ul class='unordered-list'>";

                                    foreach ($qst_rep as $rep) {
                                        if($qst['qst_id'] == $rep['qst_id'])
                                            echo "
                                <li>". $rep['rep_libelle'] ."</li>";
                                    }

                                    echo "
                            </ul>
                            
                            <br/>";
                                    $qst_traite[$qst['qst_id']] = 1;
                                }
                            }
                            */


                            //// V3 AFFICHAGE
                            // Affiche les reponses groupées par question dans un formulaire
                            echo validation_errors();
                            echo form_open('envoyer_rep');


                            foreach($qst_rep as $qst) {
                                if(!(isset($qst_traite[$qst['qst_id']]))) {
                                    
                                    echo "
                            <h4>" . $qst['qst_intitule'] . "</h4>";

                                    foreach ($qst_rep as $rep) {
                                        
                                        if($qst['qst_id'] == $rep['qst_id'])
                                            echo "
                            <input type='radio' id='". $rep['rep_id'] ."' name='". $rep['qst_id'] ."' value='". $rep['rep_id'] ."' ". ($this->session->userdata('username') != null ? "disabled=''" : "required='required'") ." >
                            <label for='". $rep['rep_id'] ."'>". $rep['rep_libelle'] ."</label>
                            <br/>";
                                    }

                                    echo "
                            <br/>";
                                    $qst_traite[$qst['qst_id']] = 1;
                                }
                            }

                            if(isset($joueur)) echo "
                            <input type='hidden' name='pseudo' value='". $joueur ."'>";

                            echo "
                            <input type='hidden' name='code_match' value='". $qst_rep[0]['mch_code'] ."'>";

                            if($this->session->userdata('role') == null) {
                                echo "
                            <input class='genric-btn info-border circle arrow' type='submit' value='Valider les réponses' ". (isset($joueur) ? "" : "disabled=''") .">
                        </form>";

                            } else {
                                echo "
                        </form>";

                            }

                            if($this->session->userdata('role') == 'F') {
                                echo validation_errors();
                                echo form_open('fermer_match');
                                echo "
                            <input type='hidden' name='code_match' value='". $qst_rep[0]['mch_code'] ."'>
                            <input class='genric-btn info-border circle arrow' type='submit' value='Terminer le match'>
                        </form>";
                            }

                        } else {
                            echo "
                    <h3>Erreur :</h3>
                    Ce match n'existe pas, ou n'a pas put être récupérées";
                        }

                    ?>
                    </div>
                </div>
            </div>
        </section>
        <!-- Blog Area End -->