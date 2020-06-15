import Vue from 'vue'
import VueRouter from 'vue-router'

import Homepage from '@/views/Homepage.vue';
import NotFound from '@/views/NotFound.vue';
import Login from '@/views/Login.vue';
import Store from '@/views/Store.vue';

import Page from '@/views/Page.vue';
import School from '@/views/School.vue';
import News from '@/views/News.vue';

import Country from '@/views/Country.vue';
import Brewery from '@/views/Brewery.vue';
import Beer from '@/views/Beer.vue';

Vue.use(VueRouter)



const routes = [

  { name:"NotFound", path: '*', component: NotFound },
  { name:"Homepage", path: '/', component: Homepage },

  { name: "Login", path: '/login', component: Login },
  { name: "School", path: '/school', component: School },
  { name: "News", path: '/news', component: News },
  { name: "Store", path: '/store', component: Store },


  { name: "Page", path: '/page/:slug', component: Page },

  { path: '/country', redirect: '/' },
  { name: "Country", path: '/country/:slug_country', component: Country, children: [
      {
        name: "Brewery",
        path: ':slug_brewery',
        component: Brewery,
        children:[ { name: "Beer", path: ':slug_beer', component: Beer } ]
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

      { name: "Login_en", path: 'login', component: Login },
      { name: "School_en", path: 'school', component: School },
      { name: "News_en", path: 'news', component: News },
      { name: "Store_en", path: 'store', component: Store },

      { path: 'country', redirect: '/:lang' },
      { name: "Country_en", path: 'country/:slug_country', component: Country, children: [
          {
            name: "Brewery_en",
            path: ':slug_brewery',
            component: Brewery,
            children:[ { name: "Beer_en", path: ':slug_beer', component: Beer } ]
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


export default router
