<template>
  <div>
    Country: {{ $route.params.slug_country }}
    <!-- BEER VIEW -->
    <router-view :key="$route.path"></router-view>
    <br>
    <b-link :to="{ name: 'country', params: { slug_country:'peru'} }">Perú</b-link>
    |
    <b-link :to="{ name: 'country', params: { slug_country:'uruguay'} }">Uruguay</b-link>
    <br><br>
    <b-link :to="{ name: 'brewery', params: { slug_country:'uruguay', slug_brewery:'oso-pardo' } }">Oso Pardo</b-link>
    |
    <b-link :to="{ name: 'brewery', params: { slug_country:'uruguay', slug_brewery:'malafama' } }">Malafama</b-link>

  </div>
</template>

<script>
export default {
  name: "Country",
  data () {
    return {
      // slug:this.$route.params.slug_brewery,
      content: {}
    }
  },
  // watch: {
  //   $route(to, from) {
  //     // react to route changes in the same (reused) component
  //     this.content = "Page for " + to.params.slug;
  //   }
  // },
  // created(){
  //   this.content = "Page for " + this.slug;
  // },

}
</script>
