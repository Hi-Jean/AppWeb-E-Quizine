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
                    <div>
                    <h1><?php echo $titre;?></h1>

                    <?php
                        if(isset($comptes)) {
                            echo "
                    <table class='my-table col-md-12'>
                        <thead>
                            <tr>
                                <th>Pseudos existant (total ". $count['total'] .") :</th>
                            </tr>
                        </thead>
                        <tbody>";


                            foreach ($comptes as $pseudo) {
                                echo "
                        <tr>
                            <td> " . $pseudo['rsp_pseudo'] . " </td>
                        </tr>";
                        }

                            echo "
                        </tbody>
                    </table>";

                        } else {
                            echo "
                    <h3>Erreur :</h3>
                    Les pseudos n'ont pas pu être récupérées";
                        }

                    ?>
                    </div>
                </div>
            </div>
        </section>
        <!-- Blog Area End -->