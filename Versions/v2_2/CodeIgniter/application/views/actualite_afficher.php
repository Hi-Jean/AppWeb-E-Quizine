        <section class="slider-area slider-area2">
            <div class="slider-active">
                <!-- Single Slider -->
                <div class="single-slider slider-height2">
                    <div class="container">
                        <div class="row">
                            <div class="col-xl-8 col-lg-11 col-md-12">
                                <div class="hero__caption hero__caption2">
                                    <h1 data-animation="bounceIn" data-delay="0.2s">Actualite</h1>
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
                        if(isset($actu)) {
                            
                            echo "<h1>". $actu['act_titre'] ."<small><small> &ndash; ". $actu['rsp_pseudo'] ."</small></small></h1>
                            <small>". $actu['date'] ."</small>
                            <div class='contenu-actu'>
                                ". $actu['act_contenu'] ."
                            </div>"; 

                        } else {
                            echo "
                    <h3>Erreur :</h3>
                    Cette actualité n'existe pas, ou n'a pas put être récupérées";
                        }

                    ?>
                    </div>
                </div>
            </div>
        </section>
        <!-- Blog Area End -->