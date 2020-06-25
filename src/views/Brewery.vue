<template>
  <div>
    <h1>{{ this.title }}</h1>
    <b-link :to="lg_build_path('/country/uruguay/oso-pardo/maracuyipa')">Maracuyipa</b-link>
    <!-- BEER VIEW -->
    <router-view></router-view>

  </div>
</template>

<script>
export default {
  name: "Brewery",
  data () {
    return {
      title: this.$t("brewery.titlebase") + " " + this.sanitize(this.$route.params.slug_brewery) + " " + this.$t("global.from") + " " + this.sanitize(this.$route.params.slug_country),
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
