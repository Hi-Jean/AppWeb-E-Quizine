                        <div class="col-xl-10 col-lg-10">
                            <div class="menu-wrapper d-flex align-items-center justify-content-end">
                                <!-- Main-menu -->
                                <div class="main-menu d-none d-lg-block">
                                    <nav>
                                        <ul id="navigation">                                                                                          
                                            <li class="active" ><a href="<?php echo base_url();?>">Home</a></li>
                                            <li><a href="<?php echo base_url();?>stylefront/courses.html">Courses</a></li>
                                            <li><a href="<?php echo base_url();?>stylefront/about.html">About</a></li>
                                            <li><a href="#">Blog</a>
                                                <ul class="submenu">
                                                    <li><a href="<?php echo base_url();?>stylefront/blog.html">Blog</a></li>
                                                    <li><a href="<?php echo base_url();?>stylefront/blog_details.html">Blog Details</a></li>
                                                    <li><a href="<?php echo base_url();?>stylefront/elements.html">Element</a></li>
                                                </ul>
                                            </li>
                                            <li><a href="<?php echo base_url();?>stylefront/contact.html">Contact</a></li>
                                            <!-- Button -->
                                            

                                            <?php
                                                if($this->session->userdata('username') != null) {
                                                    echo "<li class='button-header margin-left '><a href='". base_url() ."index.php/compte/afficher' class='btn'>Votre compte</a></li>
                                            <li class='button-header'><a href='". base_url() ."index.php/compte/fermer' class='btn btn3'>Déconnexion</a></li>";
                                                } else {
                                                     echo "<li class='button-header margin-left '><a href='". base_url() ."index.php/compte/creer' class='btn'>Rejoindre</a></li>
                                            <li class='button-header'><a href='". base_url() ."index.php/compte/connecter' class='btn btn3'>Se connecter</a></li>";
                                                }
                                            
                                            ?>

                                        </ul>
                                    </nav>
                                </div>
                            </div>
                        </div> 
                        <!-- Mobile Menu -->
                        <div class="col-12">
                            <div class="mobile_menu d-block d-lg-none"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Header End -->
    <main>