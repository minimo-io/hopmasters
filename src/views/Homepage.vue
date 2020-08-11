<template>
  <div>
    <welcome></welcome>
    <!-- <hr class="mt-0 pt-0 mb-5"> -->
    <beermaster slot="homepage"></beermaster>

  </div>
</template>

<script>
import BeerMaster from '@/components/BeerMaster.vue'
import Welcome from '@/components/Welcome.vue'


export default {
  components:{
    'beermaster': BeerMaster,
    'welcome': Welcome,
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
