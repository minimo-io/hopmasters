<style>
@import '../assets/css/animate.css';
</style>
<template>
  <div class="row align-items-center mb-5 mt-5">
    <!-- <div class="col-4 col-lg-4 mx-auto order-lg-2">
      <b-img :src="require('../assets/logo.png')" fluid alt="bienvenido-a-hopmasters" class="animated infinite pulse"></b-img>

    </div> -->
    <div class="welcome-box col-lg-12 text-center text-lg-left pr-lg-5 order-lg-1">

      <!-- <b-alert show variant="warning" class="mt-0">
        <span v-html="$t('about-us.content.alert')"></span>
        <span  v-if="app_link('whatsapp')">
          {{ $t('about-us.content.alert-soon-instagram') }}
          <b-link :href="app_link('instagram')" target="_blank" class="text-nowrap"><i class="fab fa-instagram mr-1"></i>Instagram</b-link>.
        </span>
      </b-alert> -->

      <b-card no-body class="p-4 pt-0 mt-0">
        <b-card-body class="z-index-6000 text-center">
        <center>
          <!-- <span class="app-text-green">.</span> -->
          <h2 v-if="withText" v-html="$t('homepage.slogan')" class="hero-h1 mt-0 mb-5 bd-text-purple-bright display-4"></h2>

          <div class="row">
              <div class="col-md-4">
                  <center>
                    <b-img style="width:200px;" :src="require('../assets/logo.png')" fluid alt="bienvenido-a-hopmasters" class="mt-0 mb-0 animated infinite pulse"></b-img>
                  </center>
              </div>
              <div class="col-md-7 mt-2">

                  <h3 v-html="$t('homepage.description')"></h3>
                  <!-- <div class="container px-0">
                    <div class="text-left" Xstyle="margin:auto;">
                      <b-button class="mr-3" variant="outline-danger"  size="md"><i class="fas fa-beer mr-1"></i>Cervezas&nbsp;<b-badge variant="danger">158</b-badge></b-button>

                      <b-button  variant="outline-info"  size="md"><i class="fas fa-industry mr-1"></i>Cervecerías&nbsp;<b-badge variant="info">29</b-badge></b-button>

                    </div>
                  </div> -->
                  <div class="container px-0 text-left">
                  <b-button size="sm" variant="outline-danger" class="btn-sm-block mr-3">
                    <i class="fas fa-beer mr-1"></i>Cervezas
                    <!-- <b-badge pill variant="danger">28</b-badge> -->
                  </b-button>
                  <b-button size="sm" variant="outline-dark" class="btn-sm-block mt-3 mt-sm-0 mr-3">
                    <i class="fas fa-industry mr-1"></i>Cervecerías
                    <!-- <b-badge pill variant="dark">23</b-badge> -->
                  </b-button>
                  <b-button size="sm" variant="outline-success" class="btn-sm-block mt-3 mt-sm-0">
                    <i class="fas fa-shopping-cart mr-1"></i>Tienda
                  </b-button>
                </div>
              </div>
          </div>





        </center>
        </b-card-body>
        <div class="overlay overlay-dark"></div>
      </b-card>



    </div>
  </div>

</template>
<style scoped>
  h2{
    font-size:1.1rem;
    font-family: sans-serif;
    text-align: center;
    /* font-family: "Nunito", sans-serif; */

  }
  .hero-h1 {
      font-size: 35px !important;
      font-weight: 700;
      color: #3c3c3c;
      line-height: 1.35em;
  }

</style>
<script>
import Welcome from './Welcome.vue'

export default {
  props: {
    withText: { type: Boolean, default: true}
  },
  data () {
    return {
    }
  }
}
</script>
