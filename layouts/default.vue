<template>
    <div style="min-height: 100vh;">
        <header class="header">
            <!-- Header Inner -->
            <div class="header-inner">
                <div class="container">
                    <div class="inner">
                        <div class="row">
                            <div class="col-lg-3 col-md-3 col-6 py-3">
                                <!-- Start Logo -->
                                <div class="logo h-100">
                                    <NuxtLink class="w-100 h-100" to="/"><img style="height: 50px;"
                                            src="/assets/img/logo.png" alt="#"></NuxtLink>
                                </div>
                                <!-- End Logo -->
                                <!-- Mobile Nav -->
                                <!-- End Mobile Nav -->
                            </div>
                            <div class="col-6 col-md-12 d-block d-md-none d-flex align-items-center  flex-row-reverse">
                                <button class="btn btn-primary my-auto" type="button" data-toggle="collapse"
                                    data-target="#NavBurger" aria-expanded="false" aria-controls="NavBurger">
                                    <i class="icofont-navigation-menu"></i>
                                </button>

                            </div>
                            <div class="col-xl-7 col-lg-9 col-md-9 col-12">
                                <!-- Main Menu -->
                                <div class="main-menu">
                                    <nav class="navigation">
                                        <ul class="nav menu">
                                            <li class="active"><router-link to="/">Home</router-link></li>

                                            <li v-if="isLoggedIn" class=""><router-link
                                                    to="/pasien">Pasien</router-link></li>
                                            <li v-if="isLoggedIn" class=""><router-link to="/ptm">Skrining
                                                    PTM</router-link></li>
                                            <li v-if="isLoggedIn" class=""><router-link to="/pregnant">Skrining Ibu
                                                    Hamil</router-link></li>
                                            <li v-if="isLoggedIn" class=""><router-link to="/gizi">Skrining
                                                    Gizi</router-link></li>

                                        </ul>
                                    </nav>
                                </div>
                                <!--/ End Main Menu -->
                            </div>
                            <div class="col-xl-2 col-12">
                                <div class="get-quote d-flex">
                                    <router-link v-if="!isLoggedIn" to="/login" class="btn ml-3">Masuk</router-link>                                    
                                    <button v-else class="btn btn-primary" @click="logout">Logout</button>


                                </div>
                            </div>
                        </div>
                        <div class="row collapse d-md-none" id="NavBurger">
                            <ul class="list-group">
                                <li class="list-group-item"><router-link to="/">Home</router-link></li>

                                <li v-if="isLoggedIn" class="list-group-item"><router-link
                                        to="/pasien">Pasien</router-link></li>
                                <li v-if="isLoggedIn" class="list-group-item"><router-link to="/ptm">Skrining
                                        PTM</router-link></li>
                                <li v-if="isLoggedIn" class="list-group-item"><router-link to="/pregnant">Skrining Ibu
                                        Hamil</router-link></li>
                                <li v-if="isLoggedIn" class="list-group-item"><router-link to="/gizi">Skrining
                                        Gizi</router-link></li>
                                <li v-if="!isLoggedIn" class="list-group-item">
                                    <router-link to="/login">Masuk</router-link>
                                </li>
                                <li v-else class="list-group-item">
                                    <button class="btn btn-primary" @click="logout">Logout</button>
                                </li>
                            </ul>
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
const isLoggedIn = ref(false)
if (process.client) {
    if (localStorage.getItem('authToken')) {
        isLoggedIn.value = true
    }
}
async function logout() {
    try {
        // Clear the authentication token and user data from localStorage
        localStorage.removeItem('authToken');
        localStorage.removeItem('user');

        // Optional: Send a request to the backend to invalidate the token
        // (if your API supports token invalidation)
        /*
        await $fetch('https://api.kaderpintar.id/api/user/logout', {
            method: 'POST',
            headers: {
                'Authorization': `Bearer ${localStorage.getItem('authToken')}`
            }
        });
        */

        // Refresh the session (if using a session utility)
        await refreshSession();

        // Redirect to the login page
        await navigateTo('/login');
    } catch (error) {
        console.error('Error during logout:', error);
        // Even if there's an error, we should still clear local storage and redirect
        localStorage.removeItem('authToken');
        localStorage.removeItem('user');
        await navigateTo('/login');
    }
}
</script>
<style>
.footer-top {
    padding: 0 !important;
}

@media screen and (max-width: 767px) {
    .logo {
        max-width: 100px;
    }
}
</style>