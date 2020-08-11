<style>
@import '../assets/css/animate.css';
</style>
<template>
  <div class="row align-items-center mb-5 mt-5">
    <!-- <div class="col-4 col-lg-4 mx-auto order-lg-2">
      <b-img :src="require('../assets/logo.png')" fluid alt="bienvenido-a-hopmasters" class="animated infinite pulse"></b-img>

    </div> -->
    <div class="welcome-box col-lg-12 text-center text-lg-left order-lg-1">

      <!-- <b-alert show variant="warning" class="mt-0">
        <span v-html="$t('about-us.content.alert')"></span>
        <span  v-if="app_link('whatsapp')">
          {{ $t('about-us.content.alert-soon-instagram') }}
          <b-link :href="app_link('instagram')" target="_blank" class="text-nowrap"><i class="fab fa-instagram mr-1"></i>Instagram</b-link>.
        </span>
      </b-alert> -->

      <b-card no-body class="p-0 pt-0 mt-0" style="border:0;">
        <b-card-body class="z-index-6000 text-center p-5" Xstyle="border:1px solid blue;">
        <center>
          <!-- <span class="app-text-green">.</span> -->
          <h2 v-if="withText" v-html="$t('homepage.slogan')" class="hero-h1 mt-0 mb-5 bd-text-purple-bright display-4"></h2>

          <div class="row">
              <div class="col-md-4 text-right">

                    <b-img style="width:170px;" :src="require('../assets/logo.png')" fluid alt="bienvenido-a-hopmasters" class="mt-0 mb-0 animated infinite pulse"></b-img>

              </div>
              <div class="col-md-7 mt-2">

                  <h3 class="post-subtitle" v-html="$t('homepage.description')"></h3>
                  <div class="container px-0 mt-4 mb-0 text-left">
                    <b-button size="md" variant="outline-danger" class="btn-sm-block mr-3">
                      <i class="fas fa-beer mr-1"></i>Cervezas
                      <b-badge pill variant="danger">28</b-badge>
                    </b-button>
                    <b-button size="md" variant="outline-dark" class="btn-sm-block mt-3 mt-sm-0 mr-3">
                      <i class="fas fa-industry mr-1"></i>Cervecerías
                      <b-badge pill variant="dark">23</b-badge>
                    </b-button>
                    <b-button size="md" variant="outline-success" class="btn-sm-block mt-3 mt-sm-0">
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
  .overlay-dark::after {
      background: linear-gradient(to bottom left, transparent 20%, rgba(52, 58, 64, .8) 100%);
  }
  .overlay-dark:hover::after {
    background: linear-gradient(to bottom left, transparent 20%, rgba(52, 58, 64, .8) 100%) !important;
    opacity: unset;
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
