        <section class="slider-area slider-area2">
            <div class="slider-active">
                <!-- Single Slider -->
                <div class="single-slider slider-height2">
                    <div class="container">
                        <div class="row">
                            <div class="col-xl-8 col-lg-11 col-md-12">
                                <div class="hero__caption hero__caption2">
                                    <h1 data-animation="bounceIn" data-delay="0.2s">Fin du match<br/>
                                        <h3 class="text-white"> Envoi de vos reponses </h3>
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
                            if($rep_validees) {
                                echo "<h3>Vos réponses ont bien été envoyées ". $joueur ." !</h3>
                        <p>Attendez que votre formateur affiche les résultats.</p>";
                            } else {
                                echo "<h3>Une erreur s'est produite !</h3>
                        <p>Nous vous invitons à demander de l'aide à votre formateur.</p>";
                            }
                        ?>


                    </div>
                </div>
            </div>
        </section>
        <!-- Blog Area End -->