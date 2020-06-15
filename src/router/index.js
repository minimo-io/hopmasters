import Vue from 'vue'
import VueRouter from 'vue-router'
import i18n from '../i18n'
import NProgress from 'nprogress';
import 'nprogress/nprogress.css';

import Homepage from '@/views/Homepage.vue';

Vue.use(VueRouter)

const routes = [

  { name:"NotFound", path: '*', component: () => import(/* webpackChunkName: "NotFound" */ '@/views/NotFound.vue') },
  { name:"Homepage", path: '/', component: Homepage },

  { name: "Login", path: '/login', component: () => import(/* webpackChunkName: "Login" */ '@/views/Login.vue') },
  { name: "School", path: '/school', component: () => import(/* webpackChunkName: "School" */ '@/views/School.vue') },
  { name: "News", path: '/news', component: () => import(/* webpackChunkName: "News" */ '@/views/News.vue') },
  { name: "Store", path: '/store', component: () => import(/* webpackChunkName: "Store" */ '@/views/Store.vue') },


  { name: "Page", path: '/page/:slug', component: () => import(/* webpackChunkName: "Page" */ '@/views/Page.vue') },

  { path: '/country', redirect: '/' },
  { name: "Country",
    path: '/country/:slug_country',
    component: () => import(/* webpackChunkName: "Country" */ '@/views/Country.vue'),
    children: [
      {
        name: "Brewery",
        path: ':slug_brewery',
        component: () => import(/* webpackChunkName: "Brewery" */ '@/views/Brewery.vue'),
        children:[ {
          name: "Beer",
          path: ':slug_beer',
          component: () => import(/* webpackChunkName: "Beer" */ '@/views/Beer.vue'),
        } ]
      }
    ]
  },

  {
    name: "Language",
    path: "/:lang",
    component: {
      render(c) { return c('router-view'); }
    },
    children:[
      { name: "Homepage_en", path: '/', component: Homepage },

      { name: "Login_en", path: 'login', component: () => import(/* webpackChunkName: "Login" */ '@/views/Login.vue') },
      { name: "School_en", path: 'school', component: () => import(/* webpackChunkName: "School" */ '@/views/School.vue') },
      { name: "News_en", path: 'news', component: () => import(/* webpackChunkName: "News" */ '@/views/News.vue') },
      { name: "Store_en", path: 'store', component: () => import(/* webpackChunkName: "Store" */ '@/views/Store.vue') },

      { name: "Page_en", path: 'page/:slug', component: () => import(/* webpackChunkName: "Page" */ '@/views/Page.vue') },

      { path: 'country', redirect: '/:lang' },
      { name: "Country_en",
        path: 'country/:slug_country',
        component: () => import(/* webpackChunkName: "Country" */ '@/views/Country.vue'),
        children: [
          {
            name: "Brewery_en",
            path: ':slug_brewery',
            component: () => import(/* webpackChunkName: "Brewery" */ '@/views/Brewery.vue'),
            children:[ {
              name: "Beer_en",
              path: ':slug_beer',
              component: () => import(/* webpackChunkName: "Beer" */ '@/views/Beer.vue'),
            } ]
          }
        ]
      },
    ]
  },

]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  scrollBehavior (to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    } else {
      return { x: 0, y: 0 }
    }
  },
  routes
})

router.beforeResolve((to, from, next) => {
  if (to.name) {
      NProgress.start()
  }
  next()
})
router.afterEach((to, from) => {
  NProgress.done()
})
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

})


export default router
