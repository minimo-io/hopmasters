<template>
  <div>
        <b-container>
          <!-- <br><br><br><br><br> -->
            <!-- Country: {{ this.country }}
            Brewery: {{ this.brewery }}
            Beer: {{ this.beer }} -->

            <router-view></router-view>

            <!-- User Interface controls -->
            <b-row class="text-center mt-4">
                <b-col lg="12" class="my-1">
                    <h2 class="text-uppercase font-weight-bold mb-2">{{ $t("global.searchForTheBest") }}</h2>
                    <b-form inline style="text-align:center;" class="justify-content-center">
                      <b-form-select
                        id="beer_type"
                        class="mb-2 mr-sm-2 mb-sm-0"
                        :options="options"
                        v-model="selected"
                      ></b-form-select>
                      <b-form-select
                        id="country"
                        class="mb-2 mr-sm-2 mb-sm-0"
                        @change="onChangeCountry"
                        :options="countries"
                        v-model="country_selected"
                      ></b-form-select>
                      <b-button variant="success" class="btn-sm-block">Buscar</b-button>
                    </b-form>

                  </b-col>
            </b-row>

            <br>
            <div class="text-right">
              <div class="btn-group btn-group-sm" role="group" aria-label="Tipo de visualización">
                <button type="button" class="btn btn-light btn-galleryview active" v-b-tooltip.hover :title="$t('global.grid')"><i class="fa fa-th" aria-hidden="true"></i></button>
                <button type="button" class="btn btn-light btn-listview" v-b-tooltip.hover :title="$t('global.list')"><i class="fa fa-th-list" aria-hidden="true"></i></button>
                <button type="button" class="btn btn-light btn-listview" v-b-tooltip.hover :title="$t('global.map')"><i class="fas fa-map-marker-alt"></i></button>
              </div>
            </div>

              <div class="text-center"><b-spinner v-if="isLoadingBeers" variant="info" type="grow" label="Spinning"></b-spinner></div>
              <b-container class="px-0 mx-0">
                <!-- <b-row class="px-0 mx-0">
                  <b-col class="mb-3 mt-3 px-0 mx-0">
                    <b-card>
                      <b-card-title>{{ $t("global.breweries") }} <b-badge variant="danger softer">28</b-badge></b-card-title>
                      <b-card-text>
                        <b-avatar-group size="50px">
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
                  </b-col>
                </b-row> -->
                <b-row>

                  <b-col v-for="beer in beers" :key="beer.key" sm="4" class="px-2 px-sm-0">


                    <b-card
                      :title="beer.beerName"
                      class="beer-card mb-2 mr-0 mr-md-2"
                    >
                      <div class="beer-favoriter" v-b-tooltip.hover :title="$t('global.favorite')"><b-link href="#"><i class="fas fa-heart"></i></b-link></div>
                      <div class="beer-signature text-center justify-content-center mb-3">
                        <b-link class="brewerylink text-uppercase" :to="lg_build_path('/brewery/' + beer.brewery.brewerySlug)">
                          <!-- <b-avatar size="1.5rem" class="no-shadow" :src="beer.brewery.breweryLogo"></b-avatar> -->
                            <b-avatar class="no-shadow mr-1" size="1.2rem" :src="require('@/assets/flags/svg/uy.svg')"></b-avatar>
                          {{ beer.brewery.breweryName }}
                        </b-link>
                      </div>
                      <b-card-text class="text-center">
                        <img :src="beer.beerImage" />
                      </b-card-text>
                      <div class="product-rating mt-3 mb-0 text-center">
                        <i class="fa fa-star gold"></i>
                        <i class="fa fa-star gold"></i>
                        <i class="fa fa-star gold"></i>
                        <i class="fa fa-star"></i>
                        <i class="fa fa-star"></i>
                      </div>

                      <div class="product-price text-center mb-3">627 fanáticos</div>

                      <div class="beer-meta softer mb-2 text-center">
                        <b-badge variant="info" class="mr-2">{{ beer.type.typeName }}</b-badge>
                        <b-badge variant="primary" class="mr-2">ABV: {{ beer.ABV }}%</b-badge>
                        <b-badge variant="green">IBU: {{ beer.IBU }}</b-badge>
                      </div>
                      <template v-slot:footer>
                        <div class="text-center">
                          <b-button :to="{ path: lg_build_path('/beer/' + beer.beerSlug) }" variant="outline-info" size="sm" class="mr-2" block>
                            <i class="fas fa-info-circle mr-1"></i>{{ $t("global.details") }}
                          </b-button>
                          <!-- <b-button :to="{ path: lg_build_path('/beer/' + beer.beerSlug) }" variant="outline-danger" size="sm">
                            <i class="far fa-heart"></i>
                          </b-button> -->

                        </div>
                      </template>
                    </b-card>

                  </b-col>
                  <button class="btn btn-outline-info btn-block mt-3 mx-1"><i class="fa fa-plus fa-fw"></i></button>
                </b-row>


              </b-container>



            <!-- <ul>
              <li v-for="beer in beers" :key="beer.key">
                <router-link :to="{ path: lg_build_path('/beer/' + beer.beerSlug) }">
                    {{ beer.beerName }}
                </router-link>
                -
                <router-link :to="{ path: '/brewery/' + beer.brewerySlug }">
                  {{ beer.brewery.breweryName }}
                </router-link>
                -
                <router-link :to="{ path: '/country/' + beer.countrySlug }">
                  {{ beer.country.countryName }}
                </router-link>
              </li>

            </ul> -->

          </b-container>


  </div>
</template>
<style scoped>
  .beermaster-table td{
    vertical-align: middle;
  }
</style>
<script>
import fireDb from '@/firebase/init.js'
import Firebase from 'firebase'

export default {
  data () {
    return {
      isLoadingBeers: false,
      country: this.$route.params.slug_country || false,
      brewery: this.$route.params.slug_brewery || false,
      beer: this.$route.params.slug_beer || false,

      beers: [],

      selected: 'ipa',
      options: [
        { value: 'ipa', text: 'IPA' },
        { value: 'ale', text: 'Ale', disabled: true },
        { value: 'kellerbier', text: 'Kellerbier' },
        { value: 'lager', text: 'Lager' },
        { value: 'bock', text: 'Bock' },
        { value: 'kolsch', text: 'Kölsch' },
        { value: 'pilsener', text: 'Pilsener' },
        { value: 'porter', text: 'Porter' },
        { value: 'stout', text: 'Stout' },
        { value: 'weissbier', text: 'Weissbier' },
      ],
      country_selected: '/',
      countries: [
        { value: '/', text: 'Del Mundo' },
        { value: '/country/uruguay', text: 'De Uruguay' },
        { value: '/country/usa', text: 'De USA' },
      ],

    }
  },
  beforeRouteUpdate(to, from, next) {
    // console.log('UPDATINGGG slug from'+from+' to '+to);
    next() //make sure you always call next()
  },
  beforeRouteEnter(to, from, next){
    console.log(from);
    console.log(to);
    console.log('UPDATINGGG view from'+from+' to '+to);
    // this.$forceUpdate();
    next() //make sure you always call next()
  },
  computed: {
    sortOptions() {
      // Create an options list from our fields
      return this.fields
        .filter(f => f.sortable)
        .map(f => {
          return { text: f.label, value: f.key }
        })
    }
  },
  mounted() {
    // Set the dropdown value on init
    if (this.$route.path) this.country_selected = this.$route.path;
    this.isLoadingBeers = true;
    let dbBeers = fireDb.ref("beers");

    // dbBeers.push().set({
    //   ABV: 4,
    //   IBU: 91,
    //   beerDescription: "Esta es una descripción sobre la bilirrubina",
    //   beerImage: '',
    //   beerName: "Starcarster",
    //   beerSlug: "starcarster",
    //   brewerySlug: "malafama",
    //   countrySlug: "uruguay",
    //   votes: 0,
    //   brewery: {
    //     breweryName: "Malafama",
    //     brewerySlug: "malafama",
    //     breweryLogo: ""
    //   },
    //   country: {
    //     countryName: "Uruguay"
    //   },
    //   type: {
    //     typeColor: "green",
    //     typeName: "IPA"
    //   }
    // }, function(error) {
    //
    //   if (error) {
    //     console.log("Error");
    //     console.log(error);
    //   } else {
    //     console.log("OK!");
    //   }
    //
    // });

    dbBeers.on("value", snapshot => {
       let data = snapshot.val();

       this.beers = data;
       this.isLoadingBeers = false;
       // let messages = [];
       Object.keys(data).forEach(key => {
         // messages.push({
         //   id: key,
         //   username: data[key].username,
         //   text: data[key].text
         // });
         // console.log(data[key].book);
       });
     });

  },
  methods: {
    onChangeCountry(value) {
      this.$router.push(value);
    },
  },
  watch: {
    $route(to, from) {

      this.country_selected = to.path;
      // document.title = "";

    }
  },
  created(){
    // document.title = "";
  }

}
</script>
