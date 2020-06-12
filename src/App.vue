<style>
@import 'https://cdn.jsdelivr.net/npm/@minimo-labs/alt-template@0.5.7/dist/alt.min.css';
@import './assets/css/app.css';
</style>
<template>
  <div id="app">
    <navbar></navbar>

    <main class="container mt-4 px-lg-0">
      <transition name="fade" mode="out-in">
          <router-view></router-view>
      </transition>
    </main>

    <foot></foot>

    <nprogress-container></nprogress-container>

  </div>
</template>
<script>
import NavBar from './components/NavBar.vue'
import Footer from './components/Foot.vue'
import NprogressContainer from 'vue-nprogress/src/NprogressContainer'

const BeerMaster = () => ({
  component: import("@/components/BeerMaster"),
  loading: NprogressContainer,
  delay: 500
});


export default {
  name: 'app',
  components:{
    'navbar' : NavBar,
    'foot' : Footer,
    'nprogress-container' : NprogressContainer
  },
  data () {
    return {

    }
  }
}
</script>
