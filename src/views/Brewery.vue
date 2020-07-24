<template>
  <div>
    <!-- <h2 class="card-title">{{ title }}</h2> -->
    <div v-if="breweryLoadedOk">
      <b-card class="mt-4">
        <!-- <div class="container-fluid"> -->
    			<div class="container px-0">
            <div class="row">
        				<div class="col-md-4">
        						<center>
        							<b-img rounded="circle" :src="brewery.breweryLogo" alt=""></b-img>
        						</center>
        				</div>
        				<div class="col-md-7">
        					<div class="beer-title text-center text-sm-left font-weight-bold">
                    Cervecería {{ brewery.breweryName }}
                  </div>
                  <div class="beer-origin text-center text-sm-left">
                    De
                    <b-avatar class="no-shadow mr-1" size="1.2rem" :src="require('@/assets/flags/svg/uy.svg')"></b-avatar>Uruguay
                  </div>
                  <!-- <div class="beer-meta softer mb-3 text-center text-sm-left">
                    <b-badge variant="info mr-2">{{ beer.type.typeName }}</b-badge>
                    <b-badge variant="primary mr-2">ABV: {{ beer.ABV }}%</b-badge>
                    <b-badge variant="green">IBU: {{ beer.IBU }}</b-badge>
                  </div> -->

        					<div class="product-desc text-center text-sm-left">
                    <p>Una cervecería uruguaya de gran prestigo y calidad, conocida por su fuerte apuesta a la innovación en materia de variedades de cervezas artesanales (<b-link href="#info-tab">+Mas</b-link>).</p>
                  </div>

        					<div class="product-rating mt-3 mb-3 text-center text-sm-left">
                    <i class="fa fa-star gold"></i>
                    <i class="fa fa-star gold"></i>
                    <i class="fa fa-star gold"></i>
                    <i class="fa fa-star"></i>
                    <i class="fa fa-star"></i>
                  </div>
                  <!-- <div class="beer-signature text-center text-sm-left">
                    Por
                    <b-link class="brewerylink text-uppercase font-weight-bold" :to="lg_build_path('/brewery/' + beer.brewery.brewerySlug)">
                      <b-avatar class="no-shadow" :src="beer.brewery.breweryLogo"></b-avatar>
                      {{ beer.brewery.breweryName }}
                    </b-link>
                  </div> -->
        					<hr>
        					<div class="product-price text-center text-sm-left">627 seguidores</div>
        					<!-- <div class="product-stock">In Stock</div> -->
        					<hr>
                  <b-button size="sm" variant="outline-danger" class="btn-sm-block mr-3"><i class="far fa-heart mr-2"></i>Seguir</b-button>
                  <b-button size="sm" variant="outline-dark" class="btn-sm-block mt-3 mt-sm-0 mr-3"><i class="far fa-thumbs-up mr-2"></i>Votar</b-button>
                  <b-button size="sm" variant="outline-success" class="btn-sm-block mt-3 mt-sm-0">
                    <i class="fas fa-beer mr-2"></i>Cervezas <b-badge variant="success">22</b-badge>
                  </b-button>
        				</div>
            </div>
          </div>
        <!-- </div> -->
      </b-card>

      <b-carousel
        id="carousel-fade"
        style="text-shadow: 0px 0px 2px #000"
        fade
        indicators
        img-width="1024"
        img-height="480"
        class="mt-3"
      >
        <b-carousel-slide
          caption="First slide"
          img-src="https://picsum.photos/1024/480/?image=10"
        ></b-carousel-slide>
        <b-carousel-slide
          caption="Second Slide"
          img-src="https://picsum.photos/1024/480/?image=12"
        ></b-carousel-slide>
        <b-carousel-slide
          caption="Third Slide"
          img-src="https://picsum.photos/1024/480/?image=22"
        ></b-carousel-slide>
      </b-carousel>

      <b-card class="mt-3">
        <b-card-title>Cervezas <b-badge variant="primary softer">22</b-badge></b-card-title>
        <b-card-text>

        </b-card-text>
      </b-card>

      <b-card class="mt-3">
        <b-card-title>Seguidores <b-badge variant="primary softer">285</b-badge></b-card-title>
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
  name: "Brewery",
  data () {
    return {
      title: this.$t("brewery.titlebase") + " " + this.sanitize(this.$route.params.slug_brewery),
      brewerySlug:this.$route.params.slug_brewery,
      brewery: null,
      breweryLoadedOk: false
    }
  },
  watch: {
    $route(to, from) {
      document.title = this.title + this.$t("global.delimiter") + this.$t("global.basetitle");
    }
  },
  mounted(){
    let breweriesRef = Firebase.database().ref("breweries");
    let o_brewery = this;


    breweriesRef.orderByChild('brewerySlug').equalTo(this.brewerySlug).limitToLast(1).on("value", function(snapshot) {
      snapshot.forEach(function(data) {
        o_brewery.brewery = data.val();
        o_brewery.breweryLoadedOk = true;
      });
    });

    // breweriesRef.push().set({
    //   breweryLogo: "data:image/jpeg;base64,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",
    //   breweryName: "Malafama",
    //   brewerySlug: "malafama",
    //   country: {
    //     countryName: "Uruguay",
    //     countrySlug: "uruguay",
    //     countryCode: "uy"
    //   }
    // });

  },
  created(){

    document.title = this.title + this.$t("global.delimiter") + this.$t("global.basetitle");
  },

}
</script>
