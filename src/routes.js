import Homepage from './components/Homepage.vue';
import NotFound from './components/NotFound.vue';
import BeerMaster from './components/BeerMaster.vue';
import Login from './components/Login.vue';
import Signup from './components/Signup.vue';
import Page from './components/Page.vue';
import School from './components/School.vue';
import News from './components/News.vue';
import Store from './components/Store.vue';
import Brewery from './components/Brewery.vue';
import Breweries from './components/Breweries.vue';
import SingleBeer from './components/SingleBeer.vue';

export default[
  { path: '*', component: NotFound },
  { path: '/', component: Homepage },
  { path: '/school', component: School },
  { path: '/news', component: News },
  { path: '/store', component: Store },
  { path: '/uruguay', component: BeerMaster },
  { path: '/login', component: Login },
  { path: '/signup', component: Signup },
  { path: '/page/:slug', component: Page },
  { path: '/breweries', component: Breweries },
  { path: '/brewery', redirect: '/breweries' },
  { path: '/brewery/:slug', component: Brewery, children: [
      {
        path: ':single_slug',
        component: SingleBeer
      }
    ]
  },
  // { path: '*', component: NotFound },
]
