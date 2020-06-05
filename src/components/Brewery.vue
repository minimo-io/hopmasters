<template>
  <div>
    Brewery: {{ $route.params.slug }}
     <router-view></router-view>
  </div>
</template>

<script>
export default {
  data () {
    return {
      slug:this.$route.params.slug,
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
