<style>
@import '../assets/css/animate.css';
</style>
<template>
    <div class="text-center mt-4 mb-5">
      <b-img :src="require('../assets/logo.png')" fluid alt="bienvenido-a-hopmasters" class="animated infinite pulse"></b-img>
      <h2 class="mt-2">
        ¿Quienes son los <strong><u>Maestros del Lúpulo</u></strong> en tu país?
        <br>
        ¿Y en el mundo?
      </h2>
      <b-link to="/uruguay">Uruguay</b-link> |
      <b-link to="/uruguay/oso-pardo">Oso Pardo</b-link> |
      <b-link to="/uruguay/oso-pardo/maracuyipa">Maracuyipa</b-link>
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
