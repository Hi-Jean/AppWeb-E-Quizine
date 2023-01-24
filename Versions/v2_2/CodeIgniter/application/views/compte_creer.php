        <!--? slider Area Start-->
        <section class="slider-area slider-area2">
            <div class="slider-active">
                <!-- Single Slider -->
                <div class="single-slider slider-height2">
                    <div class="container">
                        <div class="row">
                            <div class="col-xl-8 col-lg-11 col-md-12">
                                <div class="hero__caption hero__caption2">
                                    <h1 data-animation="bounceIn" data-delay="0.2s">Creer un compte</h1>
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
                    
                    <?php
						echo validation_errors();
						echo form_open('compte_creer');

						echo form_label('Pseudo :');
						$champ1=array('class'=>'single-input-primary', 'name'=>'id', 'required'=>'required', 'maxlength'=>'20', 'placeholder'=>'Pseudo');
						echo form_input($champ1);

						echo "<br/>";

						echo form_label('Mot de passe :');
						$champ2=array('class'=>'single-input-primary', 'name'=>'mdp', 'required'=>'required', 'placeholder'=>'Mot de passe');
						echo form_input($champ2);

						echo "<br/>";
					?>

					<input class='genric-btn info-border circle arrow' type="submit" name="submit" value="Créer un compte" />
					</form>

                </div>
            </div>
        </section>
        <!-- Blog Area End -->