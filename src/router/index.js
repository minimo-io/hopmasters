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
  { path: '*', component: NotFound },
  { path: '/', component: Homepage },

  { path: '/login', component: Login },
  { path: '/school', component: School },
  { path: '/news', component: News },
  { path: '/store', component: Store },

  { path: '/page/:slug', component: Page },

  { path: '/country', redirect: '/' },
  { name: 'country', path: '/country/:slug_country', component: Country, children: [
      {
        name: 'brewery',
        path: ':slug_brewery',
        component: Brewery,
        children:[ { name: 'beer', path: ':slug_beer', component: Beer } ]
      }
    ]
  },

  {
    path: "/:lang",
    component: {
      render(c) { return c('router-view'); }
    },
    children:[
      { path: '/', component: Homepage },

      { path: 'login', component: Login },
      { path: 'school', component: School },
      { path: 'news', component: News },
      { path: 'store', component: Store },

      { path: '/page/:slug', component: Page },

      { path: 'country', redirect: '/:lang' },
      { name: 'country', path: 'country/:slug_country', component: Country, children: [
          {
            name: 'brewery',
            path: ':slug_brewery',
            component: Brewery,
            children:[ { name: 'beer', path: ':slug_beer', component: Beer } ]
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
