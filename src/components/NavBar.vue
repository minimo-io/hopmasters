<template>
  <div>
    <header class="alt-header alt-header--top">
      <div class="alt-container alt-header__container">
        <!-- left nav -->
        <nav class="alt-header__left">
          <h1 class="app-logo zoom" :title="app_title" itemprop="name headline">
            <b-link :to="{ path: '/' }">{{ app_title }}
              <!-- <span class="text-app">.</span> -->
            </b-link>
          </h1>

        </nav>

        <!-- right nav -->
        <nav class="alt-header__right">

          <a class="alt-header__left__menu-trigger" v-b-toggle.sidebar-1 role="button" aria-expanded="true">
            Menú
          </a>

          <span class="alt-header__separator alt-separator d-none d-sm-inline-block">/</span>
          <div class="alt-header__user alt-header__user--anonymous d-none d-sm-inline-block">
            <div class="alt-user-nav">
              <b-link :to="{ path: '/login' }" title="Ingresar" class="alt-header__sign-in">Ingresar</b-link>
            </div>
          </div>

          <span class="alt-header__separator alt-separator">/</span>
          <a href="#"><i class="fas fa-search"></i></a>
          <span class="alt-header__separator alt-separator">/</span>
          <b-link :to="{ path: '/store' }" title="Tienda" class="alt-header__sign-in"><i class="fas fa-shopping-cart"></i></b-link>

          <span class="alt-header__separator alt-separator d-none d-sm-inline-block">/</span>
          <b-nav class="navbar-nav navbar-main ml-auto order-1 d-none d-sm-inline-block">
            <b-nav-item-dropdown
                  text="ES"
                  toggle-class="nav-link-custom"
                >
                  <b-dropdown-item>Español</b-dropdown-item>
                  <b-dropdown-item>Inglés</b-dropdown-item>
              </b-nav-item-dropdown>
          </b-nav>



        </nav>
      </div>
    </header>

    <!-- Sidebar -->
    <b-sidebar id="sidebar-1" title="HOPMASTERS"  backdrop-variant="warning" lazy backdrop shadow>


      <div class="px-3 py-2 mt-2">
        <b-button to="login" pill block variant="outline-secondary" size="sm" class="mb-4">Ingresar</b-button>
        <!-- <b-button to="signup" pill block variant="secondary" size="sm" class="mb-4">Registrarse</b-button> -->

        <b-form-group label="Idioma" label-for="side-language" class="d-block d-sm-none">
          <b-form-select id="side-language" class="mb-0" v-model="lang_selected" :options="langs"></b-form-select>
        </b-form-group>

        <!-- <b-form-group label="Hopmasters de" label-for="beer-type">
          <b-form-select id="beer-type" v-model="country_selected" :options="countries"></b-form-select>
        </b-form-group>
        {{ country_selected }} -->
        <!-- <h2>Essential Links</h2> -->
        <ul>
          <li><b-link :to="{ path: '/' }"><i class="fas fa-home mr-1"></i>Inicio</b-link></li>
          <li><b-link :to="{ path: '/store' }"><i class="fas fa-shopping-cart mr-1"></i>Tienda</b-link></li>
          <li><b-link :to="{ path: '/school' }"><i class="fab fa-leanpub mr-1"></i>Escuela</b-link></li>
          <li><b-link :to="{ path: '/news' }"><i class="fas fa-newspaper mr-1"></i>Notícias</b-link></li>
        </ul>

        <h2>Información</h2>
        <ul>
          <li><b-link :to="{ path: '/page/about-us' }">Nosotros</b-link></li>
          <li><b-link :to="{ path: '/page/faq' }">F.A.Q</b-link></li>
        </ul>

        <h2>Redes</h2>
        <ul>
          <li><a rel="nofollow" target="_blank" href="https://www.instagram.com/hopmasters/"><i class="fab fa-instagram-square mr-1"></i>Instagram</a></li>
          <li><a rel="nofollow" target="_blank" href="#"><i class="fab fa-facebook-square mr-1"></i>Facebook</a></li>
        </ul>
      </div>
    </b-sidebar>
  </div>
</template>

<script>
export default{
  data(){
    return {
      lang_selected : 'Español',
      langs: [
        "Español",
        "English",
        "Português",
      ],
    }
  },
  computed: {
    isAuthenticated() {
      // return this.$store.getters.isAuthenticated
      return true;
    },
  }
}
</script>
