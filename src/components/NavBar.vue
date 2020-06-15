<template>
  <div>
    <header class="alt-header alt-header--top" :class="{ 'alt-fixed-top': hasScrolled }">
      <div class="alt-container alt-header__container">
        <!-- left nav -->
        <nav class="alt-header__left">
          <h1 class="app-logo zoom" :title="app_title" itemprop="name headline">
            <b-link :to="{ path: '/' }">{{ app_title }}</b-link>
          </h1>
        </nav>

        <!-- right nav -->
        <nav class="alt-header__right">

          <a class="alt-header__left__menu-trigger" v-b-toggle.sidebar-1 role="button" aria-expanded="true">
            {{ $t('nav.menu') }}
          </a>

          <span class="alt-header__separator alt-separator d-none d-sm-inline-block">/</span>
          <div class="alt-header__user alt-header__user--anonymous d-none d-sm-inline-block">
            <div class="alt-user-nav">
              <b-link :to="{ path: '/login' }" :title="$t('nav.signin')" class="alt-header__sign-in">{{ $t('nav.signin') }}</b-link>
            </div>
          </div>

          <span class="alt-header__separator alt-separator">/</span>
          <b-link href="#"><i class="fas fa-search"></i></b-link>
          <span class="alt-header__separator alt-separator">/</span>
          <b-link :to="{ path: '/store' }" :title="$t('nav.store')" class="alt-header__sign-in"><i class="fas fa-shopping-cart"></i></b-link>

          <span class="alt-header__separator alt-separator d-none d-sm-inline-block">/</span>
          <b-nav class="navbar-nav navbar-main ml-auto order-1 d-none d-sm-inline-block">
            <b-nav-item-dropdown
                  :text="$i18n.locale"
                  toggle-class="nav-link-custom"
                >
                  <b-dropdown-item :to="language_url(lang)" :key="lang" v-for="(lang) in $i18n.availableLocales">{{ language_name(lang) }}</b-dropdown-item>
              </b-nav-item-dropdown>
          </b-nav>



        </nav>
      </div>
    </header>

    <!-- Sidebar -->
    <b-sidebar id="sidebar-1" title="HOPMASTERS"  backdrop-variant="appyellow" lazy backdrop shadow>


      <div class="px-3 py-2 mt-2">
        <b-button to="login" block variant="outline-secondary" size="sm" class="mb-1">{{ $t('nav.signin') }}</b-button>

        <b-dropdown :text="language_name($i18n.locale)" variant="outline-secondary" toggle-class="nav-link-custom" block size="sm" class="mb-4">
          <b-dropdown-item :to="language_url(lang)" :key="lang" v-for="(lang) in $i18n.availableLocales">{{ language_name(lang) }}</b-dropdown-item>
        </b-dropdown>

        <!-- <b-form-group label="Hopmasters de" label-for="beer-type">
          <b-form-select id="beer-type" v-model="country_selected" :options="countries"></b-form-select>
        </b-form-group>
        {{ country_selected }} -->
        <!-- <h2>Essential Links</h2> -->
        <ul>
          <li><b-link :to="{ path: '/' }"><i class="fas fa-home mr-1"></i>{{ $t('nav.home') }}</b-link></li>
          <li><b-link :to="{ path: '/store' }"><i class="fas fa-shopping-cart mr-1"></i>{{ $t('nav.store') }}</b-link></li>
          <li><b-link :to="{ path: '/school' }"><i class="fab fa-leanpub mr-1"></i>{{ $t('nav.school') }}</b-link></li>
          <li><b-link :to="{ path: '/news' }"><i class="fas fa-newspaper mr-1"></i>{{ $t('nav.news') }}</b-link></li>
        </ul>

        <h2>{{ $t('nav.information') }}</h2>
        <ul>
          <li><b-link :to="{ path: '/page/about-us' }">{{ $t('nav.about_us') }}</b-link></li>
          <li><b-link :to="{ path: '/page/faq' }">{{ $t('nav.faq') }}</b-link></li>
        </ul>

        <h2>{{ $t('nav.networks') }}</h2>
        <ul>
          <li v-if="app_link('instagram')"><a rel="nofollow" target="_blank" :href="app_link('instagram')"><i class="fab fa-instagram-square mr-1"></i>Instagram</a></li>
          <li v-if="app_link('facebook')"><a rel="nofollow" target="_blank" :href="app_link('facebook')"><i class="fab fa-facebook-square mr-1"></i>Facebook</a></li>
          <li v-if="app_link('github')"><a rel="nofollow" target="_blank" :href="app_link('github')"><i class="fab fa-github-square mr-1"></i>Github</a></li>
        </ul>
      </div>
    </b-sidebar>
  </div>
</template>

<script>
export default{
  data(){
    return {
      hasScrolled : false
    }
  },
  created () {
    window.addEventListener('scroll', this.handleScroll);
  },
  destroyed () {
    window.removeEventListener('scroll', this.handleScroll);
  },

  methods: {
    language_url(lang){
      return "/" + lang
    },
    language_name(lang_code){
      if (lang_code == "es") return "Español";
      if (lang_code == "en") return "English";
    },
    handleScroll: function (event) {
      if (window.scrollY > 200) {
        this.hasScrolled = true;
      } else {
        this.hasScrolled = false;
      }
      // console.log(window.scrollY);

    }
  },
  computed: {
    // get_language_name($){
    //   return this.lang_names[];
    // },
    isAuthenticated() {
      // return this.$store.getters.isAuthenticated
      return true;
    },
  }
}
</script>
