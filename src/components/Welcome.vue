<style>
@import '../assets/css/animate.css';
</style>
<template>
  <div class="align-items-center mb-4 mt-5">

    <div class="welcome-box col-lg-12 text-center text-lg-left order-lg-1 px-0">


      <b-card no-body class="p-0 pt-0 mt-0" style="border:0;">
        <div class="overlay overlay-dark"></div>
        <b-card-body class="z-index-6000 text-center p-5">
        <center>
          <h2 v-if="withText" v-html="$t('homepage.slogan')" class="hero-h1 mt-0 mb-4 mb-md-4 bd-text-purple-bright display-4"></h2>

          <div class="row">
              <!-- <div class="col-md-4 mb-3 welcome-image-box Xtext-right">

                    <b-img :src="require('../assets/logo.png')" fluid alt="bienvenido-a-hopmasters" class="mt-0 mb-0 animated infinite pulse"></b-img>

              </div> -->
              <div class="col-md-7 mt-2">

                  <h3 v-if="this.$i18n.locale == 'es'" class="post-subtitle">
                    Mira los <b-link :to="lg_build_path('/')"><span class="text-nowrap"><i class='fas fa-medal mr-1'></i>Rankings</span></b-link> cerveceros.
                    <span class='d-none d-lg-inline-block'>Vota y sigue a tus cervezas y cervecerías favoritas para conocer los nuevos lanzamientos.</span>
                    Aprende a fabricar en la <b-link :to="lg_build_path('/school')"><span class="text-nowrap"><i class='fas fa-graduation-cap mr-1'></i>Escuela</span></b-link> y accede a descuentos en la
                    <b-link :to="lg_build_path('/store')"><span class="text-nowrap"><i class='fas fa-shopping-cart mr-1'></i>Tienda</span></b-link>.
                    Si eres una cervecería contactanos en <b-link target="_blank" :href="app_link('instagram')"><span class="text-nowrap"><i class='fab fa-instagram-square mr-1'></i>Instagram</span></b-link> que queremos darte <b-link :to="lg_build_path('/')"><i class='fas fa-heart'></i></b-link>
                  </h3>
                  <h3 v-if="this.$i18n.locale == 'en'" class="post-subtitle">
                    Look at the beer <b-link :to="lg_build_path('/')"><span class="text-nowrap"><i class='fas fa-medal mr-1'></i>Rankings</span></b-link>.
                    <span class='d-none d-lg-inline-block'>Vote and follow your favorite beers and breweries to find out about new releases.</span>
                    Learn to brew at the <b-link :to="lg_build_path('/school')"><span class="text-nowrap"><i class='fas fa-graduation-cap mr-1'></i>School</span></b-link> and access discounts at the
                    <b-link :to="lg_build_path('/store')"><span class="text-nowrap"><i class='fas fa-shopping-cart mr-1'></i>Store</span></b-link>.
                    If you are a brewery contact us on <b-link target="_blank" :href="app_link('instagram')"><span class="text-nowrap"><i class='fab fa-instagram-square mr-1'></i>Instagram</span></b-link>, as we want to give you <b-link :to="lg_build_path('/')"><i class='fas fa-heart'></i></b-link>
                  </h3>


                  <div class="container px-0 mt-4 mb-0 text-left">
                    <b-button size="md" variant="danger" class="btn-sm-block mr-3">
                      <i class="fas fa-beer mr-1"></i>{{ $t("global.beers") }}
                      <b-badge pill variant="danger">28</b-badge>
                    </b-button>
                    <b-button size="md" variant="dark" class="btn-sm-block mt-3 mt-sm-0 mr-3">
                      <i class="fas fa-industry mr-1"></i>{{ $t("global.breweries") }}
                      <b-badge pill variant="dark">23</b-badge>
                    </b-button>
                    <b-button size="md" variant="success" class="btn-sm-block mt-3 mt-sm-0">
                      <i class="fas fa-shopping-cart mr-1"></i>{{ $t("nav.store.title") }}
                    </b-button>
                  </div>

              </div>

          </div>





        </center>
        </b-card-body>

      </b-card>


    </div>
  </div>

</template>
<script>
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
