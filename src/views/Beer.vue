<template>
  <div class="container">
    <!-- <h2 class="card-title">{{ title }}</h2> -->
    <div v-if="beerLoadedOk">
      <b-card class="mt-4">
        <!-- <div class="container-fluid"> -->
    			<div class="container px-0">
            <div class="row">
        				<div class="col-md-4">
        						<center>
        							<img id="item-display" :src="this.beer.beerImage" alt="" />
        						</center>
        				</div>
        				<div class="col-md-7">
        					<div class="beer-title text-center text-sm-left font-weight-bold">
                    Cerveza {{ beer.beerName }}
                  </div>
                  <div class="beer-origin text-center text-sm-left">
                    De
                    <b-avatar class="no-shadow mr-1" size="1.2rem" :src="require('@/assets/flags/spain.png')"></b-avatar>España
                  </div>
                  <div class="beer-meta softer mb-3 text-center text-sm-left">
                    <b-badge variant="info mr-2">{{ beer.type.typeName }}</b-badge>
                    <b-badge variant="primary mr-2">ABV: {{ beer.ABV }}%</b-badge>
                    <b-badge variant="green">IBU: {{ beer.IBU }}</b-badge>
                  </div>

        					<div class="product-desc text-center text-sm-left">
                    <p>The Corsair Gaming Series GS600 is the ideal price/performance choice for mid-spec gaming PC (<b-link href="#info-tab">+Mas</b-link>).</p>
                  </div>

        					<div class="product-rating mt-3 mb-3 text-center text-sm-left">
                    <i class="fa fa-star gold"></i>
                    <i class="fa fa-star gold"></i>
                    <i class="fa fa-star gold"></i>
                    <i class="fa fa-star"></i>
                    <i class="fa fa-star"></i>
                  </div>
                  <div class="beer-signature text-center text-sm-left">
                    Por
                    <b-link class="brewerylink text-uppercase font-weight-bold" :to="lg_build_path('/brewery/' + beer.brewery.brewerySlug)">
                      <b-avatar class="no-shadow" :src="beer.brewery.breweryLogo"></b-avatar>
                      {{ beer.brewery.breweryName }}
                    </b-link>
                  </div>
        					<hr>
        					<div class="product-price text-center text-sm-left">$ 1234.00</div>
        					<!-- <div class="product-stock">In Stock</div> -->
        					<hr>
                  <b-button size="sm" variant="outline-danger" class="btn-sm-block mr-3"><i class="far fa-heart mr-2"></i>Favorita</b-button>
                  <b-button size="sm" variant="outline-dark" class="btn-sm-block mt-3 mt-sm-0 mr-3"><i class="far fa-thumbs-up mr-2"></i>Votar</b-button>
                  <b-button size="sm" variant="outline-success" class="btn-sm-block mt-3 mt-sm-0"><i class="fas fa-shopping-cart mr-2"></i>Comprar</b-button>
        				</div>
            </div>
          </div>
        <!-- </div> -->
      </b-card>

      <b-card class="mt-3">
        <b-card-title>Fanáticos <b-badge variant="primary softer">285</b-badge></b-card-title>
        <b-card-text>
          <b-avatar-group size="40px">
            <b-avatar></b-avatar>
            <b-avatar text="BV" variant="primary"></b-avatar>
            <b-avatar src="https://placekitten.com/300/300" variant="info"></b-avatar>
            <b-avatar text="OK" variant="danger"></b-avatar>
            <b-avatar variant="warning"></b-avatar>
            <b-avatar src="https://placekitten.com/320/320" variant="dark"></b-avatar>
            <b-avatar icon="music-note" variant="success"></b-avatar>
            <b-avatar variant="warning"></b-avatar>
            <b-avatar src="https://placekitten.com/320/320" variant="dark"></b-avatar>
            <b-avatar icon="music-note" variant="success"></b-avatar>
          </b-avatar-group>
        </b-card-text>
      </b-card>

      <div class="mt-3">
        <!-- TABS -->
        <div class="container-fluid px-0">


          <b-card no-body>
            <b-tabs class="beer-tabs" card>
              <b-tab id="info-tab" title="INFO" active>
                <b-card-text>

                  <section class="product-info mt-0 p-0 p-sm-3">
                    The Corsair Gaming Series GS600 power supply is the ideal price-performance solution for building or upgrading a Gaming PC. A single +12V rail provides up to 48A of reliable, continuous power for multi-core gaming PCs with multiple graphics cards. The ultra-quiet, dual ball-bearing fan automatically adjusts its speed according to temperature, so it will never intrude on your music and games. Blue LEDs bathe the transparent fan blades in a cool glow. Not feeling blue? You can turn off the lighting with the press of a button.
                    <br><br>
                    <h3>Corsair Gaming Series GS600 Features:</h3>
                    <li>It supports the latest ATX12V v2.3 standard and is backward compatible with ATX12V 2.2 and ATX12V 2.01 systems</li>
                    <li>An ultra-quiet 140mm double ball-bearing fan delivers great airflow at an very low noise level by varying fan speed in response to temperature</li>
                    <li>80Plus certified to deliver 80% efficiency or higher at normal load conditions (20% to 100% load)</li>
                    <li>0.99 Active Power Factor Correction provides clean and reliable power</li>
                    <li>Universal AC input from 90~264V — no more hassle of flipping that tiny red switch to select the voltage input!</li>
                    <li>Extra long fully-sleeved cables support full tower chassis</li>
                    <li>A three year warranty and lifetime access to Corsair’s legendary technical support and customer service</li>
                    <li>Over Current/Voltage/Power Protection, Under Voltage Protection and Short Circuit Protection provide complete component safety</li>
                    <li>Dimensions: 150mm(W) x 86mm(H) x 160mm(L)</li>
                    <li>MTBF: 100,000 hours</li>
                    <li>Safety Approvals: UL, CUL, CE, CB, FCC Class B, TÜV, CCC, C-tick</li>
                  </section>

                </b-card-text>
              </b-tab>
              <b-tab title="RESEÑAS" disabled>
                <b-card-text>
                  <section class="product-info mt-0 p-0 p-sm-3">

                  </section>
                </b-card-text>
              </b-tab>
              <b-tab title="COMPRAR" disabled>
                <b-card-text>
                  <section class="product-info mt-0 p-0 p-sm-3">

                  </section>
                </b-card-text>
              </b-tab>
            </b-tabs>
          </b-card>

        </div>

      </div>


    </div>

  </div>
</template>
<script>
import fireDb from '@/firebase/init.js'
import Firebase from 'firebase'

export default {
  name: "Beer",
  data () {
    return {
      title: this.$t("beer.titlebase") + " " + this.sanitize(this.$route.params.slug_beer),
      beerSlug:this.$route.params.slug_beer,
      beer: null,
      beerLoadedOk: false
    }
  },
  watch: {
    $route(to, from) {
      document.title = this.title + this.$t("global.delimiter") + this.$t("global.basetitle");
    }
  },
  mounted(){

    let beersRef = Firebase.database().ref("beers");
    let o_beer = this;

    // let o_store = this.$store;
    // this.$store.commit("setLoading"); // app loading something
    beersRef.orderByChild('beerSlug').equalTo(this.beerSlug).limitToLast(1).on("value", function(snapshot) {
      snapshot.forEach(function(data) {
        o_beer.beer = data.val();
        o_beer.beerLoadedOk = true;
      });
    });

  },
  created(){

    document.title = this.title + this.$t("global.delimiter") + this.$t("global.basetitle");
  },

}
</script>
