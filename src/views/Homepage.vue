<template>
  <div>
    <welcome></welcome>
    <topbreweries></topbreweries>
    <beermaster slot="homepage"></beermaster>

  </div>
</template>

<script>
import BeerMaster from '@/components/BeerMaster.vue'
import Welcome from '@/components/Welcome.vue'
import TopBreweries from '@/components/TopBreweries.vue'


export default {
  components:{
    'beermaster': BeerMaster,
    'welcome': Welcome,
    'topbreweries': TopBreweries
  },
  data () {
    return {
      beers: []
    }
  },
  mounted(){
  },
}
</script>
