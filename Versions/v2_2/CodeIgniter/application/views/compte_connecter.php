        <section class="slider-area slider-area2">
            <div class="slider-active">
                <!-- Single Slider -->
                <div class="single-slider slider-height2">
                    <div class="container">
                        <div class="row">
                            <div class="col-xl-8 col-lg-11 col-md-12">
                                <div class="hero__caption hero__caption2">
                                    <h1 data-animation="bounceIn" data-delay="0.2s">Connexion</h1>
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
                        <h2>Saisissez vos identifiants ici :</h2>
                        <?php echo validation_errors(); ?>
                        <?php echo form_open('compte/connecter'); ?>
                            <input type="text" class="single-input-primary" name="pseudo" placeholder="Pseudo" required="required" maxlength="20"/>
                            <input type="password" class="single-input-primary" name="mdp" placeholder="Mot de passe" required="required"/>
                            <br/>
                            <input type="submit" class="genric-btn info-border circle arrow" value="Connexion"/>
                        </form>
                    
                    </div>
                </div>
            </div>
        </section>
        <!-- Blog Area End -->