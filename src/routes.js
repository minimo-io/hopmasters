import BeerMaster from './components/BeerMaster.vue';
import Homepage from './components/Homepage.vue';
import Login from './components/Login.vue';
import Signup from './components/Signup.vue';
import Page from './components/Page.vue';

export default[
  { path: '/', component: Homepage },
  { path: '/uruguay', component: BeerMaster },
  { path: '/login', component: Login },
  { path: '/signup', component: Signup },
  { path: '/page/:slug', component: Page },
  // { path: '*', component: NotFound },
]
