import '@babel/polyfill'
import 'mutationobserver-shim'
import Vue from 'vue'
import './plugins/bootstrap-vue'
import App from './App.vue'
import router from './router'
import NProgress from 'vue-nprogress'
import 'nprogress/nprogress.css';
import i18n from './i18n'

Vue.config.productionTip = false

Vue.use(NProgress)


router.beforeEach((to, from, next) => {
  let language = to.params.lang;
  if (!language) language = "es";
  i18n.locale = language;
  next();
});



Vue.mixin({
  data: function() {
    return {
      get app_title() {
        return "Hopmasters";
      }
    }
  }
});


const app = new Vue({
  router,
  i18n,
  render: h => h(App)
}).$mount('#app')


router.beforeResolve((to, from, next) => {
  if (to.path){
    NProgress.start();
  }
  next();
});
router.afterEach( () => {
  NProgress.done()
});
