<template>
  <div>
        <b-container fluid>
          <!-- <br><br><br><br><br> -->
            <!-- Country: {{ this.country }}
            Brewery: {{ this.brewery }}
            Beer: {{ this.beer }} -->

            <router-view></router-view>

            <!-- User Interface controls -->
            <b-row class="text-center">
                <b-col lg="12" class="my-1">

                    <b-form inline style="text-align:center;" class="justify-content-center">
                      <label class="mr-sm-2" for="beer_type">La mejor</label>
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
                      <b-button variant="success">Buscar</b-button>
                    </b-form>

                  </b-col>
            </b-row>

            <b-overlay :show="isLoadingBeers" spinner-variant="green" spinner-type="grow">
            <div>
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

                  <b-col v-for="beer in beers" :key="beer.key" sm="4" class="px-0">


                    <b-card
                      :title="beer.beerName"
                      class="beer-card mb-2 mr-0 mr-md-2"

                    >
                      <b-card-text class="text-center">
                        <img :src="beer.beerImage" />
                      </b-card-text>

                      <!-- <router-link class="text-center" :to="{ path: lg_build_path('/beer/' + beer.beerSlug) }">

                      </router-link> -->

                      <!-- <template v-slot:footer>
                        <small class="text-muted">Last updated 3 mins ago</small>
                      </template> -->
                      <!-- <b-button href="#" variant="primary">Go somewhere</b-button> -->

                      <b-button :to="{ path: lg_build_path('/beer/' + beer.beerSlug) }" variant="outline-info" size="sm" block>Details</b-button>
                    </b-card>

                  </b-col>

                </b-row>

              </b-container>

            </div>
            </b-overlay>

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
