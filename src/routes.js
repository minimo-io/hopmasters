import Homepage from './components/Homepage.vue';
import NotFound from './components/NotFound.vue';
import BeerMaster from './components/BeerMaster.vue';
import Login from './components/Login.vue';
import Signup from './components/Signup.vue';
import Page from './components/Page.vue';
import School from './components/School.vue';
import News from './components/News.vue';
import Store from './components/Store.vue';
import SingleBrewery from './components/SingleBrewery.vue';
import SingleBeer from './components/SingleBeer.vue';

export default[
  { path: '*', component: NotFound },
  { path: '/', component: Homepage },

  { path: '/login', component: Login },
  { path: '/signup', component: Signup },
  { path: '/school', component: School },
  { path: '/news', component: News },
  { path: '/store', component: Store },

  { path: '/page/:slug', component: Page },

  { path: '/:slug_country', component: BeerMaster, children: [
      {
        path: ':slug_brewery',
        component: SingleBrewery,
        children:[ { path: ':slug_beer', component: SingleBeer } ]
      }
    ]
  },

]
