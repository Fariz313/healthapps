<template>
    <div style="min-height: 100vh;">
        <header class="header">
            <!-- Header Inner -->
            <div class="header-inner">
                <div class="container">
                    <div class="inner">
                        <div class="row">
                            <div class="col-lg-3 col-md-3 col-12">
                                <!-- Start Logo -->
                                <div class="logo">
                                    <NuxtLink to="/"><img src="/assets/img/logo.png" alt="#"></NuxtLink>
                                </div>
                                <!-- End Logo -->
                                <!-- Mobile Nav -->
                                <div class="mobile-nav"></div>
                                <!-- End Mobile Nav -->
                            </div>
                            <div class="col-lg-7 col-md-9 col-12">
                                <!-- Main Menu -->
                                <div class="main-menu">
                                    <nav class="navigation">
                                        <ul class="nav menu">
                                            <li class="active"><a href="#">Home <i class="icofont-rounded-down"></i></a>
                                                <ul class="dropdown">
                                                    <li><a href="index.html">Home Page 1</a></li>
                                                </ul>
                                            </li>
                                            <li><a href="#">Doctos </a></li>
                                            <li><a href="#">Services </a></li>
                                            <li><a href="#">Pages <i class="icofont-rounded-down"></i></a>
                                                <ul class="dropdown">
                                                    <li><a href="404.html">404 Error</a></li>
                                                </ul>
                                            </li>
                                            <li><a href="#">Blogs <i class="icofont-rounded-down"></i></a>
                                                <ul class="dropdown">
                                                    <li><a href="blog-single.html">Blog Details</a></li>
                                                </ul>
                                            </li>
                                            <li><a href="contact.html">Contact Us</a></li>
                                        </ul>
                                    </nav>
                                </div>
                                <!--/ End Main Menu -->
                            </div>
                            <div class="col-lg-2 col-12">
                                <div class="get-quote d-flex">
                                    <NuxtLink v-if="!isLoggedIn" to="/login" class="btn ml-3">Masuk</NuxtLink>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--/ End Header Inner -->
        </header>
        <slot />
        <footer id="footer" class="footer ">
            <!-- Footer Top -->
            <div class="footer-top">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-3 col-md-6 col-12">
                            <div class="single-footer">
                                <!-- Social -->
                                <ul class="social">
                                    <li><a href="#"><i class="icofont-facebook"></i></a></li>
                                    <li><a href="#"><i class="icofont-google-plus"></i></a></li>
                                    <li><a href="#"><i class="icofont-twitter"></i></a></li>
                                    <li><a href="#"><i class="icofont-vimeo"></i></a></li>
                                    <li><a href="#"><i class="icofont-pinterest"></i></a></li>
                                </ul>
                                <!-- End Social -->
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6 col-12">

                        </div>
                        <div class="col-lg-3 col-md-6 col-12">

                        </div>
                        <div class="col-lg-3 col-md-6 col-12">

                        </div>
                    </div>
                </div>
            </div>
            <!--/ End Footer Top -->
            <!-- Copyright -->
            <div class="copyright">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-12">
                        </div>
                    </div>
                </div>
            </div>
            <!--/ End Copyright -->
        </footer>
    </div>
</template>
<script setup>
const isLoggedIn=ref(false)
if (process.client) {
    if(localStorage.getItem('authToken')){
        isLoggedIn.value=true
    }
}

</script>
<style>
.footer-top{
    padding: 0!important;
}
@media screen and (max-width: 767px) {
    .logo{
        max-width: 100px;
    }
}
</style>