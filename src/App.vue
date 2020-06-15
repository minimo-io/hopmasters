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

  </div>
</template>
<script>
import NavBar from '@/components/NavBar.vue'
import Footer from '@/components/Foot.vue'

// const BeerMaster = () => ({
//   component: import("@/components/BeerMaster"),
//   loading: NprogressContainer,
//   delay: 500
// });


export default {
  name: 'app',
  components:{
    'navbar' : NavBar,
    'foot' : Footer,
  },
  methods:{
    start_nprogress(){

    }
  },
  data () {
    return {

    }
  }
}
</script>
