        <!--? slider Area Start-->
        <section class="slider-area slider-area2">
            <div class="slider-active">
                <!-- Single Slider -->
                <div class="single-slider slider-height2">
                    <div class="container">
                        <div class="row">
                            <div class="col-xl-8 col-lg-11 col-md-12">
                                <div class="hero__caption hero__caption2">
                                    <h1 data-animation="bounceIn" data-delay="0.2s">Match</h1>
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
                    <h1>Quel pseudo choisisez-vous ?</h1>
                </div>

                <div class="row">
                    
                    <?php 
                        if($this->input->post('pseudo') != NULL)
                            echo "</div><p>Il y à déjà un joueur avec ce pseudo dans ce match.</p><div class='row'> <br/>";

                        //echo validation_errors();
                        echo form_open('match_verifier');
                    ?>
                        <label for="pseudo">Entrez votre pseudo :</label>
                        <input class="single-input-primary" type="text" name="pseudo" id="pseudo" required="required" placeholder="Votre pseudo" maxlength="20" pattern="[0-9a-zA-Z]+">
                        <br/>
                        <input type="hidden" name="code_match" value="<?php echo $this->input->post('code_match'); ?>">                        
                    
                    <?php
                        /*
                        echo validation_errors();
                        echo form_open('match_verifier');

                        echo form_label('Entrer votre pseudo :', 'pseudo');
                        $champ1=array('class'=>'single-input-primary', 'name'=>'pseudo', 'id'=>'pseudo', 'required'=>'required', 'placeholder'=>'Votre pseudo', 'maxlength'=>'20');
                        echo form_input($champ1);

                        $champ2=array('code_match' => $this->input->post('code_match'));
                        echo form_hidden($champ2);

                        echo "<br/>";
                        */
                    ?>
                        <input class="genric-btn info-border circle arrow" type="submit" name="submit" value="Rejoindre">
                    </form>

                </div>
            </div>
        </section>
        <!-- Blog Area End -->