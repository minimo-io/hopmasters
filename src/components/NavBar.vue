<template>
  <div>
    <header class="alt-header alt-header--top" :class="{ 'alt-fixed-top': hasScrolled }">
      <div class="alt-container alt-header__container">
        <!-- left nav -->
        <nav class="alt-header__left">
          <h1 class="app-logo zoom" :title="app_title" itemprop="name headline">
            <b-link :to="{ path: lg_build_path('/') }">{{ app_title }}</b-link>
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
              <b-link v-if="user.loggedIn" @click.prevent="signOut" :title="$t('nav.logout')" class="alt-header__sign-in">{{ $t('nav.logout') }} {{ user.data.displayName }}</b-link>
              <b-link v-else :to="{ path: lg_build_path('/login') }" :title="$t('nav.signin')" class="alt-header__sign-in">{{ $t('nav.signin') }}</b-link>

            </div>
          </div>

          <span class="alt-header__separator alt-separator">/</span>
          <b-link href="#"><i class="fas fa-search"></i></b-link>
          <span class="alt-header__separator alt-separator">/</span>
          <b-link :to="{ path: lg_build_path('/store') }" :title="$t('nav.store')" class="alt-header__sign-in"><i class="fas fa-shopping-cart"></i></b-link>

          <span class="alt-header__separator alt-separator d-none d-sm-inline-block">/</span>
          <b-nav class="navbar-nav navbar-main ml-auto order-1 d-none d-sm-inline-block">
            <b-nav-item-dropdown
                  :text="$i18n.locale"
                  toggle-class="nav-link-custom"
                >
                  <b-dropdown-item :to="language_switcher(lang)" :key="lang" v-for="(lang) in $i18n.availableLocales">{{ language_name(lang) }}</b-dropdown-item>
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
          <b-dropdown-item :to="language_switcher(lang)" :key="lang" v-for="(lang) in $i18n.availableLocales">{{ language_name(lang) }}</b-dropdown-item>
        </b-dropdown>

        <!-- <b-form-group label="Hopmasters de" label-for="beer-type">
          <b-form-select id="beer-type" v-model="country_selected" :options="countries"></b-form-select>
        </b-form-group>
        {{ country_selected }} -->
        <!-- <h2>Essential Links</h2> -->
        <ul>
          <li><b-link :to="{ path: lg_build_path('/') }"><i class="fas fa-home mr-1"></i>{{ $t('nav.home') }}</b-link></li>
          <li><b-link :to="{ path: lg_build_path('/store') }"><i class="fas fa-shopping-cart mr-1"></i>{{ $t('nav.store') }}</b-link></li>
          <li><b-link :to="{ path: lg_build_path('/school') }"><i class="fab fa-leanpub mr-1"></i>{{ $t('nav.school') }}</b-link></li>
          <li><b-link :to="{ path: lg_build_path('/news') }"><i class="fas fa-newspaper mr-1"></i>{{ $t('nav.news') }}</b-link></li>
        </ul>

        <h2>{{ $t('nav.information') }}</h2>
        <ul>
          <li><b-link :to="{ path: lg_build_path('/page/about-us') }">{{ $t('nav.about_us') }}</b-link></li>
          <li><b-link :to="{ path: lg_build_path('/page/faq') }">{{ $t('nav.faq') }}</b-link></li>
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
import i18n from '../i18n'
import { mapGetters } from "vuex";
import firebase from "firebase";

export default{
  data(){
    return {
      hasScrolled : false
    }
  },
  computed: {
    ...mapGetters({
      // map `this.user` to `this.$store.getters.user`
      user: "user"
    })
  },
  created () {
    window.addEventListener('scroll', this.handleScroll);
  },
  destroyed () {
    window.removeEventListener('scroll', this.handleScroll);
  },

  methods: {
    language_switcher(lang){
      // console.log("---------------");
      // console.log("Current path: " + this.$route.path);
      // console.log("Current lang: " + this.$i18n.locale);
      // console.log("Goto Lang: " + lang);

      var goto = "";

      // if what is current lang is es, the we have to add the
      // language code to the base url, else we have to remove it
      if (this.$i18n.locale == "es"){
        goto = "/" + lang + this.$route.path;
        if (goto.slice(-1) == "/") goto = goto.slice(0, -1);
      }
      // if goto language is spanish, replace the lang base code and go
      if (lang == "es"){
        var goto = this.$route.path.replace("/"+this.$i18n.locale, '');
        if (goto == "") goto = "/";
      }
      return goto;
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

    },
    signOut() {
      firebase
        .auth()
        .signOut()
        .then(() => {
          this.app_notification("notifications.bye", true);
          this.$router.replace({path: "/"});
        });
    }
  },
}
</script>
