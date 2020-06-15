<template>
  <div>
    Brewery: {{ $route.params.slug_brewery }}
    <!-- BEER VIEW -->
    <router-view></router-view>
    <br>
    <b-link :to="{ name: 'brewery', params: { slug_country:'uruguay', slug_brewery:'oso-pardo' } }">Oso Pardo</b-link>
    <b-link :to="{ name: 'brewery', params: { slug_country:'uruguay', slug_brewery:'malafama' } }">Malafama</b-link>

    <br>
    <br>

    <b-link :to="{ name: 'beer', params: { slug_country:'uruguay', slug_brewery:'oso-pardo', slug_beer: 'atomica' } }">Atomica</b-link>
    |
    <b-link :to="{ name: 'beer', params: { slug_country:'uruguay', slug_brewery:'oso-pardo', slug_beer: 'maracuyipa' } }">Maracuyipa</b-link>

  </div>
</template>

<script>
export default {
  name: "Brewery",
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
