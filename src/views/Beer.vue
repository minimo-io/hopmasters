<template>
  <div>
    Single Beer: {{ $route.params.slug_beer }}


    <!-- {{ $route.params.slug }}  -->
  </div>
</template>

<script>
export default {
  name: "Beer",
  data () {
    return {
      // slug:this.$route.params.slug_beer,
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
