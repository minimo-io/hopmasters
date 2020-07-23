<template>
  <div>
    <!-- <h2 class="card-title">{{ title }}</h2> -->
    <div v-if="beerLoadedOk">
      <b-card :title="title" sub-title="Card subtitle" class="mt-4">
        <div class="container-fluid">
    			<div class="container px-0">
            <div class="row">
        				<div class="col-md-4">
        						<center>
        							<img id="item-display" :src="this.beer.beerImage" alt="" />
        						</center>
        				</div>
        				<div class="col-md-7">
        					<div class="product-title">Corsair GS600 600 Watt PSU</div>
        					<div class="product-desc">The Corsair Gaming Series GS600 is the ideal price/performance choice for mid-spec gaming PC</div>
        					<div class="product-rating"><i class="fa fa-star gold"></i> <i class="fa fa-star gold"></i> <i class="fa fa-star gold"></i> <i class="fa fa-star gold"></i> <i class="fa fa-star-o"></i> </div>
        					<hr>
        					<div class="product-price">$ 1234.00</div>
        					<div class="product-stock">In Stock</div>
        					<hr>
        					<div class="btn-group cart">
                    <b-button size="sm" variant="outline-success mr-3">Add to cart</b-button>
        					</div>
        					<div class="btn-group wishlist">
        						<b-button size="sm" variant="outline-danger"><i class="far fa-heart"></i> Favorita</b-button>
        					</div>
        				</div>
            </div>
          </div>
        </div>
      </b-card>

      <div class="mt-3">
        <!-- TABS -->
        <div class="container-fluid px-0">


          <b-card no-body>
            <b-tabs card>
              <b-tab title="PRODUCT INFO" active>
                <b-card-text>

                  <section class="container product-info mt-0">
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
              <b-tab title="REVIEWS">
                <b-card-text>Tab contents 2</b-card-text>
              </b-tab>
              <b-tab title="COMPRAR EN">
                <b-card-text>Tab contents 3</b-card-text>
              </b-tab>
            </b-tabs>
          </b-card>

        </div>

      </div>


    </div>

  </div>
</template>
<style scoped>
/*********************************************
					PRODUCTS
*********************************************/

.product{
	border: 1px solid #dddddd;
	height: 321px;
}

.product>img{
	max-width: 230px;
}

.product-rating{
	font-size: 20px;
	margin-bottom: 25px;
}

.product-title{
	font-size: 20px;
}

.product-desc{
	font-size: 14px;
}

.product-price{
	font-size: 22px;
}

.product-stock{
	color: #74DF00;
	font-size: 20px;
	margin-top: 10px;
}

.product-info{
		margin-top: 50px;
}


/* .container {
	padding-left: 0px;
	padding-right: 0px;
	max-width: 100%;
} */

</style>
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
