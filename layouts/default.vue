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
                                            <li class="active"><router-link to="/">Home</router-link></li>
                                            <li class=""><router-link to="/pasien">Pasien</router-link></li>
                                            <li class=""><router-link to="/ptm">Skrining PTM</router-link></li>
                                            <li class=""><router-link to="/pregnant">Skrining Ibu Hamil</router-link></li>
                                            <li class=""><router-link to="/gizi">Skrining Gizi</router-link></li>
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