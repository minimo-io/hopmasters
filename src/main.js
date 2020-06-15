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

  // in case is /es/ then remove the prefix since spanish is the default
  if (to.path.includes('/es/')){
    var goto = "/" + to.path.replace(/\/es\//g, '')
    next(goto);
  }else{
    next();
  }

});

Vue.mixin({
  data: function() {
    return {
      get app_title() {
        return "Hopmasters";
      },
    }
  },
  methods:{
    app_goback(steps){
      this.$router.go(steps)
    },
    app_version(){
      return require('../package.json').version || '0';
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

const app = new Vue({
  router,
  i18n,
  render: h => h(App)
}).$mount('#app')


router.beforeResolve((to, from, next) => {
  if (to.path){
    //NProgress.start();
  }
  next();
});
router.afterEach( () => {
  //NProgress.done()
});
