        <!--? slider Area Start-->
        <section class="slider-area ">
            <div class="slider-active">
                <!-- Single Slider -->
                <div class="single-slider slider-height d-flex align-items-center">
                    <div class="container">
                        <div class="row">
                            <div class="col-xl-6 col-lg-7 col-md-12">
                                <div class="hero__caption">
                                    <h1 data-animation="fadeInLeft" data-delay="0.2s">E-Quizine</h1>
                                    <p data-animation="fadeInLeft" data-delay="0.4s">Pour concocter de bons petits quiz !</p>
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
                    <h1>Participer à un match ?</h1>
                </div>

                <div class="row">

                    <?php

                        if($matchs == null) {
                            echo "Aucun match pour l'instant !";
                        } else {

                            if(isset($code_valide)) {
                                if($code_valide == 0) echo "</div><p>Code de match inexistant, veuillez saisir le code fourni par votre formateur !</p><div class='row'>";
                                else echo "</div><p>Match désactivé ou non démarré !</p><div class='row'>";
                            }

                            echo "</div>".validation_errors()."<div class='row'>";
                            echo form_open('match_verifier');


                            echo form_label('Entrer son code :');
                            $champ1=array('class'=>'single-input-primary', 'name'=>'code_match', 'id'=>'code_match', 'required'=>'required', 'placeholder'=>'Code du match', 'maxlength'=>'8', 'pattern' =>'[0-9a-zA-Z]{8}');
                            echo form_input($champ1);

                            echo "<br/>
                            <input class='genric-btn info-border circle arrow' type='submit' name='submit' value='Rejoindre'>
                        </form>";
                        }

                        
                    ?>
                        

                </div>

                <br/>

                <div class="row">
                    <div>
                    <h1><?php echo $titre;?></h1>

                    <?php
                        if($actualites != false) {
                            echo "
                    <table class='my-table'>
                        <thead>
                            <tr>
                                <th>Titre</th>
                                <th>Contenu</th>
                                <th>Date de publication</th>
                                <th>Auteur</th>
                            </tr>
                        </thead>
                        <tbody>";


                            foreach ($actualites as $actu) {
                                echo "
                        <tr>
                            <td><a href='" . base_url() . "index.php/actualite/afficher/". $actu['act_id'] ."'>" . $actu['act_titre'] . "</a></td>
                            <td>" . $actu['act_contenu'] . "</td>
                            <td>" . $actu['date'] . "</td>
                            <td>" . $actu['rsp_pseudo'] . "</td>
                        </tr>";
                        }

                            echo "
                        </tbody>
                    </table>";

                        } else {
                            echo "
                    Aucune actuaité pour l'instant !";
                        }

                    ?>
                    </div>
                </div>
            </div>
        </section>
        <!-- Blog Area End -->