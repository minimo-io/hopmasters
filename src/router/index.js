import Vue from 'vue'
import Vuex from 'vuex'
import VueRouter from 'vue-router'
import i18n from '../i18n'
import NProgress from 'nprogress'
import 'nprogress/nprogress.css'
import fireDb from '@/firebase/init.js'
import firebase from 'firebase'
import store from '@/store'

import Homepage from '@/views/Homepage.vue';

Vue.use(VueRouter)


const routes = [

  { name:"NotFound", path: '*', component: () => import(/* webpackChunkName: "NotFound" */ '@/views/NotFound.vue') },
  {
    name:"Homepage",
    path: '/',
    component: Homepage,
    meta: {
      title: "global.title",
      metaTags:[
        {
            name: 'description',
            content: "global.description",
        },
      ]
    }
  },

  {
    name: "Login",
    path: '/login',
    component: () => import(/* webpackChunkName: "Login" */ '@/views/Login.vue'),
    meta: {
      title: "nav.signin.title",
      metaTags:[
        {
          name: 'description',
          content: "nav.signin.description",
        },
      ]
    }
  },
  {
    name: "School",
    path: '/school',
    component: () => import(/* webpackChunkName: "School" */ '@/views/School.vue'),
    meta: {
      title: "nav.school.title",
      metaTags:[
        {
          name: 'description',
          content: "nav.school.description",
        },
      ]
    }
  },
  {
    name: "Store",
    path: '/store',
    component: () => import(/* webpackChunkName: "Store" */ '@/views/Store.vue'),
    meta: {
      title: "nav.store.title",
      metaTags:[
        {
          name: 'description',
          content: "nav.store.description",
        },
      ]
    }
  },
  {
    name: "News",
    path: '/news',
    component: () => import(/* webpackChunkName: "News" */ '@/views/News.vue'),
    meta: {
      title: "nav.news.title",
      metaTags:[
        {
          name: 'description',
          content: "nav.news.description",
        },
      ]
    }
  },
  { name: "Admin",
    path: '/admin',
    component: () => import(/* webpackChunkName: "Admin" */ '@/views/Admin.vue'),
    meta: {
      requiresAuth: true,
      title: "nav.admin.title",
      metaTags:[
        {
          name: 'description',
          content: "nav.admin.description",
        },
      ]
    }
  },


  {
    name: "Page",
    path: '/page/:slug',
    component: () => import(/* webpackChunkName: "Page" */ '@/views/Page.vue')
  },
  {
    name: "Beer",
    path: '/beer/:slug_beer',
    component: () => import(/* webpackChunkName: "Beer" */ '@/views/Beer.vue'),
  },
  {
    name: "Brewery",
    path: '/brewery/:slug_brewery',
    component: () => import(/* webpackChunkName: "Brewery" */ '@/views/Brewery.vue')
  },
  { path: '/country', redirect: '/' },
  {
    name: "Country",
    path: '/country/:slug_country',
    component: () => import(/* webpackChunkName: "Country" */ '@/views/Country.vue'),
  },

  {
    // name: "Language",
    path: "/:lang",
    component: {
      render(c) { return c('router-view'); }
    },
    children:[
      {
        name: "Homepage_en",
        path: '/',
        component: Homepage,
        meta: {
          title: "global.title",
          metaTags:[
            {
                name: 'description',
                content: "global.description",
            },
          ]
        }
     },

     {
       name: "Login_en",
       path: 'login',
       component: () => import(/* webpackChunkName: "Login" */ '@/views/Login.vue'),
       meta: {
         title: "nav.signin.title",
         metaTags:[
           {
             name: 'description',
             content: "nav.signin.description",
           },
         ]
       }
     },
     {
       name: "School_en",
       path: 'school',
       component: () => import(/* webpackChunkName: "School" */ '@/views/School.vue'),
       meta: {
         title: "nav.school.title",
         metaTags:[
           {
             name: 'description',
             content: "nav.school.description",
           },
         ]
       }
     },
     {
       name: "Store_en",
       path: 'store',
       component: () => import(/* webpackChunkName: "Store" */ '@/views/Store.vue'),
       meta: {
         title: "nav.store.title",
         metaTags:[
           {
             name: 'description',
             content: "nav.store.description",
           },
         ]
       }
     },
      { name: "Admin_en",
        path: 'admin',
        component: () => import(/* webpackChunkName: "Admin" */ '@/views/Admin.vue'),
        meta: {
          requiresAuth: true,
          title: "nav.admin.title",
          metaTags:[
            {
              name: 'description',
              content: "nav.admin.description",
            },
          ]
        }
      },

      { name: "Page_en", path: 'page/:slug', component: () => import(/* webpackChunkName: "Page" */ '@/views/Page.vue') },
      {
        name: "Beer_en",
        path: 'beer/:slug_beer',
        component: () => import(/* webpackChunkName: "Beer" */ '@/views/Beer.vue'),
      },
      {
        name: "Brewery_en",
        path: 'brewery/:slug_brewery',
        component: () => import(/* webpackChunkName: "Brewery" */ '@/views/Brewery.vue')
      },
      { path: 'country', redirect: '/:lang' },
      {
        name: "Country_en",
        path: 'country/:slug_country',
        component: () => import(/* webpackChunkName: "Country" */ '@/views/Country.vue'),
      }
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
  var prev_locale = i18n.locale;
  if (!language) language = "es";
  i18n.locale = language;
  document.getElementsByTagName("html")[0].lang = i18n.locale;


  const nearestWithTitle = to.matched.slice().reverse().find(r => r.meta && r.meta.title);

  const nearestWithMeta = to.matched.slice().reverse().find(r => r.meta && r.meta.metaTags);
  const previousNearestWithMeta = from.matched.slice().reverse().find(r => r.meta && r.meta.metaTags);

  if (nearestWithTitle){
    let title_complement = i18n.t("global.delimiter") + i18n.t("global.basetitle");
    if (nearestWithTitle.name.includes("Homepage")){
      title_complement = "";
    }
    document.title = i18n.t(nearestWithTitle.meta.title) + title_complement;

  }else{
    document.title = i18n.t("global.basetitle");
  }

  Array.from(document.querySelectorAll('[data-vue-router-controlled]')).map(el => el.parentNode.removeChild(el));

  // if (!nearestWithMeta) return next();
  if (nearestWithMeta){
    nearestWithMeta.meta.metaTags.map(tagDef => {
            const tag = document.createElement('meta');

            Object.keys(tagDef).forEach(key => {
                let attr_value = tagDef[key];
                if (key == "content") attr_value = i18n.t(attr_value);
                tag.setAttribute(key, attr_value);
            });

            tag.setAttribute('data-vue-router-controlled', '');

            return tag;
        })
        .forEach(tag => document.head.appendChild(tag));


  }


  // protected views
  if (to.matched.some(route => route.meta.requiresAuth)){
    if (store.getters.user.loggedIn){
      next();
    }else{
      next({ path: '/login' });
    }
  }

  // if the current language is NOT es, then check if the goto url
  // has the language code, if NOT then add it
  if (prev_locale != "es"){
    if ( ! to.path.includes("/" + prev_locale) ){
      var goto = "/" + prev_locale + to.path;
      if (goto.slice(-1) == "/") goto = goto.slice(0, -1);
      next(goto);
    }else{
      next();
    }
  }
  // in case is /es/ then remove the prefix since spanish is the default
  if (to.path.includes('/es/')){
    var goto = "/" + to.path.replace(/\/es\//g, '')
    next(goto);
  }else{
    next();
  }




})


export default router
