import Homepage from './components/views/Homepage.vue';
import NotFound from './components/views/NotFound.vue';
import Login from './components/views/Login.vue';
import Store from './components/views/Store.vue';

import Page from './components/views/Page.vue';
import School from './components//views/School.vue';
import News from './components/views/News.vue';

import Country from './components/views/Country.vue';
import Brewery from './components/views/Brewery.vue';
import Beer from './components/views/Beer.vue';


export default[
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
