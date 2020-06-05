<template>
  <div>
    <welcome></welcome>
    <beermaster></beermaster>
  </div>
</template>

<script>
import BeerMaster from './BeerMaster.vue'
import Welcome from './Welcome.vue'

export default {
  components:{
    'beermaster' : BeerMaster,
    'welcome' : Welcome,
  },
  data () {
    return {
    }
  }
}
</script>
