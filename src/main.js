import '@babel/polyfill'
import 'mutationobserver-shim'
import Vue from 'vue'
import './plugins/bootstrap-vue'
import App from './App.vue'
import VueRouter from 'vue-router'
import i18n from './i18n'
import * as firebase from "firebase";

Vue.config.productionTip = false

import router from './router'
import mixins from './mixins'
import store from './store'

Vue.mixin(mixins);

let app = null;

firebase.auth().onAuthStateChanged(user => {
  store.dispatch("fetchUser", user);
  // only create app after firebase returned the state
  if (!app){
    app = new Vue({
      render: h => h(App),
      i18n,
      store,
      router
    }).$mount('#app')
  }


});
