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
  // { path: '/', component: Homepage },
  //
  // { path: '/login', component: Login },
  // { path: '/school', component: School },
  // { path: '/news', component: News },
  // { path: '/store', component: Store },


  { path: '/', redirect: '/page/about-us' },
  { path: '/en', redirect: '/en/page/about-us' },
    { path: '/en/login', redirect: '/page/about-us' },
    { path: '/en/school', redirect: '/page/about-us' },
    { path: '/en/news', redirect: '/page/about-us' },
    { path: '/en/store', redirect: '/page/about-us' },
    { path: '/en/page/faq', redirect: '/page/about-us' },
    
  { path: '/es', redirect: '/page/about-us' },
    { path: '/login', redirect: '/page/about-us' },
    { path: '/school', redirect: '/page/about-us' },
    { path: '/news', redirect: '/page/about-us' },
    { path: '/store', redirect: '/page/about-us' },
    { path: '/page/faq', redirect: '/page/about-us' },

  { path: '/page/:slug', component: Page },

  // { path: '/country', redirect: '/' },
  // { name: 'country', path: '/country/:slug_country', component: Country, children: [
  //     {
  //       name: 'brewery',
  //       path: ':slug_brewery',
  //       component: Brewery,
  //       children:[ { name: 'beer', path: ':slug_beer', component: Beer } ]
  //     }
  //   ]
  // },

  {
    path: "/:lang",
    component: {
      render(c) { return c('router-view'); }
    },
    children:[
      { path: 'page/:slug', component: Page },
      { path: '/*', redirect: '/en/page/about-us' },
      // { path: '/', component: Homepage },
      //
      // { path: 'login', component: Login },
      // { path: 'school', component: School },
      // { path: 'news', component: News },
      // { path: 'store', component: Store },
      // { path: '/', redirect: '/page/about-us' },


      // { path: 'country', redirect: '/:lang' },
      // { name: 'country', path: 'country/:slug_country', component: Country, children: [
      //     {
      //       name: 'brewery',
      //       path: ':slug_brewery',
      //       component: Brewery,
      //       children:[ { name: 'beer', path: ':slug_beer', component: Beer } ]
      //     }
      //   ]
      // },
    ]
  },

  { path: '/*', redirect: '/page/about-us' },
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
