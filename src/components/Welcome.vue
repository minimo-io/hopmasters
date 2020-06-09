<style>
@import '../assets/css/animate.css';
</style>
<template>
    <div class="text-center mt-4 mb-5">
      <b-img :src="require('../assets/logo.png')" fluid alt="bienvenido-a-hopmasters" class="animated infinite pulse"></b-img>
      <h2 v-html="$t('homepage.slogan')" class="mt-2"></h2>
    </div>
</template>

<script>
import Welcome from './Welcome.vue'

export default {
  components:{
    'welcome' : Welcome,
  },
  data () {
    return {
    }
  }
}
</script>
