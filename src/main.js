import '@babel/polyfill'
import 'mutationobserver-shim'
import Vue from 'vue'
import './plugins/bootstrap-vue'
import App from './App.vue'
import VueRouter from 'vue-router'
import i18n from './i18n'

Vue.config.productionTip = false

import router from './router'


Vue.mixin({
  data: function() {
    return {
      get app_title() {
        return "Hopmasters";
      },
      get app_version(){
        return require('../package.json').version || '0';
      }
    }
  },
  methods:{
    app_goback(steps){
      this.$router.go(steps)
    },
    app_link(name){
      switch(name){
        case "whatsapp":
          if (this.$i18n.locale == "es" ) return "https://web.whatsapp.com"; // whatsapp group name
          if (this.$i18n.locale == "en" ) return "https://web.whatsapp.com"; // whatsapp group name
          /* eslint-disable no-unreachable */
          break;
          /* eslint-enable */
        case "instagram":
          return "https://www.instagram.com/hopmasters/";
          /* eslint-disable no-unreachable */
          break;
          /* eslint-enable */
        case "github":
          return "https://github.com/minimo-io/hopmasters";
          /* eslint-disable no-unreachable */
          break;
          /* eslint-enable */
      }
    },
  }
});

new Vue({
  render: h => h(App),
  i18n,
  router
}).$mount('#app')
