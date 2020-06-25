<template>
  <div>
    <h1>{{ this.title }}</h1>
    <p>
      Miles de cosas sobre la Maracuyipa, un enorme bla bla bla con cosas
      bastante saladas que cuenta la verdad sobre la mejor IPA saborizada del Uruguay.
    </p>
  </div>
</template>

<script>
export default {
  name: "Beer",
  data () {
    return {
      title: this.$t("beer.titlebase") + " " + this.sanitize(this.$route.params.slug_beer) + " " + this.$t("global.from") + " " + this.sanitize(this.$route.params.slug_brewery),
      // slug:this.$route.params.slug_brewery,
    }
  },
  watch: {
    $route(to, from) {
      document.title = this.title + this.$t("global.delimiter") + this.$t("global.basetitle");
    }
  },
  created(){

    document.title = this.title + this.$t("global.delimiter") + this.$t("global.basetitle");
  },

}
</script>
