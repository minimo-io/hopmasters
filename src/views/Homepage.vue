<template>
  <div>
    <welcome></welcome>
    <beermaster></beermaster>

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
