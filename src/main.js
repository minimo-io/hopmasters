import '@babel/polyfill'
import 'mutationobserver-shim'
import Vue from 'vue'
import './plugins/bootstrap-vue'
import App from './App.vue'
import VueRouter from 'vue-router'
import i18n from './i18n'

Vue.config.productionTip = false

import router from './router'
import mixins from './mixins'

Vue.mixin(mixins);


new Vue({
  render: h => h(App),
  i18n,
  router
}).$mount('#app')
