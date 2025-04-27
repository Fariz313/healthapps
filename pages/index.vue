<template>
    <div>
        <!-- Slider Area -->
        <section class="slider">
            <div class="hero-slider">
                <div class="single-slider imgbackground">
                    <div class="container">
                        <div class="row flex-row-reverse">
                            <div class="col-lg-7">
                                <div class="text text-right">
                                    <h1> <span>Pelayanan</span> Pintar <br> Kesehatan Masyarakat</h1>
                                    <p>Puskesmas menyediakan layanan kesehatan dasar bagi masyarakat, 
                                        <br>termasuk
                                        imunisasi, pemeriksaan kehamilan, dan konsultasi gizi.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Schedule Area -->
        <section class="schedule">
            <div class="container">
                <div class="schedule-inner">
                    <div class="row">
                        <div class="col-lg-4 col-md-6 col-12">
                            <div class="single-schedule first">
                                <div class="inner">
                                    <div class="icon">
                                        <i class="fa fa-ambulance"></i>
                                    </div>
                                    <div class="single-content">
                                        <span>Layanan Gawat Darurat</span>
                                        <h4>Kasus Darurat</h4>
                                        <p>Puskesmas menyediakan layanan gawat darurat untuk masyarakat dalam kondisi
                                            kesehatan yang memerlukan tindakan cepat.</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4 col-md-6 col-12">
                            <div class="single-schedule middle">
                                <div class="inner">
                                    <div class="icon">
                                        <i class="icofont-prescription"></i>
                                    </div>
                                    <div class="single-content">
                                        <span>Jadwal Dokter</span>
                                        <h4>Pelayanan Medis</h4>
                                        <p>Setiap hari kerja, dokter puskesmas siap melayani pasien untuk pemeriksaan
                                            kesehatan dan konsultasi.</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4 col-md-12 col-12">
                            <div class="single-schedule last">
                                <div class="inner">
                                    <div class="icon">
                                        <i class="icofont-ui-clock"></i>
                                    </div>
                                    <div class="single-content">
                                        <span>Jam Operasional</span>
                                        <h4>Pelayanan Puskesmas</h4>
                                        <ul class="time-sidual">
                                            <li class="day">Senin - Kamis <span>08.00 - 15.00</span></li>
                                            <li class="day">Jumat <span>08.00 - 14.30</span></li>
                                            <li class="day">Sabtu <span>08.00 - 14.00</span></li>
                                            <li class="day">Minggu <span>Libur</span></li>
                                        </ul>
                                        <!-- <a href="#">BACA SELENGKAPNYA<i class="fa fa-long-arrow-right"></i></a> -->
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Start Fitur -->
        <section class="Fitur section">
            <div class="container">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="section-title">
                            <h2>Kami Selalu Siap Membantu Anda & Keluarga</h2>
                            <img src="/assets/img/section-img.png" alt="#">
                            <p>Kami berkomitmen memberikan layanan kesehatan terbaik untuk Anda dan keluarga.</p>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-4 col-12">
                        <!-- Start Single features -->
                        <div class="single-features">
                            <div class="signle-icon">
                                <i class="icofont icofont-ambulance-cross"></i>
                            </div>
                            <h3>Bantuan Darurat</h3>
                            <p>Kami siap memberikan bantuan medis darurat dengan cepat dan tepat.</p>
                        </div>
                        <!-- End Single features -->
                    </div>
                    <div class="col-lg-4 col-12">
                        <!-- Start Single features -->
                        <div class="single-features">
                            <div class="signle-icon">
                                <i class="icofont icofont-medical-sign-alt"></i>
                            </div>
                            <h3>Apotek Lengkap</h3>
                            <p>Berbagai macam obat-obatan tersedia untuk memenuhi kebutuhan kesehatan Anda.</p>
                        </div>
                        <!-- End Single features -->
                    </div>
                    <div class="col-lg-4 col-12">
                        <!-- Start Single features -->
                        <div class="single-features last">
                            <div class="signle-icon">
                                <i class="icofont icofont-stethoscope"></i>
                            </div>
                            <h3>Perawatan Medis</h3>
                            <p>Layanan kesehatan berkualitas untuk memastikan kesejahteraan pasien.</p>
                        </div>
                        <!-- End Single features -->
                    </div>
                </div>
            </div>
        </section>
        <!--/ End Fitur -->



    </div>
</template>
<style>
.imgbackground {
    background-image: 
        /* Gradient atas-bawah (transparan di atas & bawah) */
        linear-gradient(to bottom, 
            rgba(255, 255, 255, 0.8), 
            rgba(255, 255, 255, 0) 15%,
            rgba(255, 255, 255, 0) 85%,
            rgba(255, 255, 255, 0.8) 100%),
        
        /* Gradient kiri-kanan (transparan di kiri, solid di kanan) */
        linear-gradient(to right, 
            rgba(255, 255, 255, 0), 
            rgba(255, 255, 255, 0) 20%, 
            rgba(255, 255, 255, 0.9) 50%),
        
        /* Gambar asli */
        url('/assets/img/puskesmas.jpeg');
    
    background-size: cover;
    height: 100vh;
    width: 100%;
}
</style>