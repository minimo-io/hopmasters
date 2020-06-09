import Vue from 'vue'
import App from './App.vue'
import NProgress from 'vue-nprogress'
import VueRouter from 'vue-router'
import Routes from './routes'
import { BootstrapVue, IconsPlugin } from 'bootstrap-vue'


import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'
import i18n from './i18n'
// import 'nprogress/nprogress.css';

// Install BootstrapVue
Vue.use(BootstrapVue);
// Optionally install the BootstrapVue icon components plugin
Vue.use(IconsPlugin);
// Router plugin
Vue.use(VueRouter);
// Progress bar for lazy loading
Vue.use(NProgress);

// const nprogress = new NProgress({ parent: '.nprogress-container' });

const router = new VueRouter({
  routes: Routes,
  mode: 'history',
  scrollBehavior (to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    } else {
      return { x: 0, y: 0 }
    }
  }
});
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
  el: '#app',
  render: h => h(App),
  i18n,
  router: router
});
