<template>
  <div class="container primary-container pt-0 px-0 mt-0">
      <header class="alt-post-header alt-top-title mx-0">
        <b-link @click.prevent="app_goback(-1)" class="breadcrumb-back-button">
          <i class="fas fa-reply"></i>&nbsp;{{ $t("global.back") }}
        </b-link>

        <h1 class="post-title category-title" itemprop="name headline">
          <span v-html="$t(this.slug + '.title')"></span>
        </h1>

        <h2 class="post-subtitle category-subtitle mt-3">
          <b-alert show variant="warning">
            <i class="fas fa-code mr-1"></i>{{ $t(this.slug + '.content.alert') }}
            <span  v-if="app_link('whatsapp')">
              {{ $t(this.slug + '.content.alert-soon-whatsapp') }}
              <b-link :href="app_link('whatsapp')" target="_blank"><i class="fab fa-whatsapp mr-1"></i>{{ app_title }}</b-link>
              {{ $t(this.slug + '.content.alert-soon-instagram') }}
              <b-link :href="app_link('instagram')" target="_blank"><i class="fab fa-instagram mr-1"></i>Instagram</b-link>.
            </span>
          </b-alert>

          <figure class="figure">
            <b-img src="@/assets/homebrewing-adam-wilson.jpg" rounded fluid alt="imagen-de-cerveza"></b-img>
            <figcaption class="figure-caption">{{ $t(this.slug + '.content.photo-figure') }}</figcaption>
          </figure>


          <a href="#what" class="app-text-selected"><i class="fas fa-location-arrow"></i> {{ $t(this.slug + '.content.title-what') }}</a>
          <p class="mt-2" v-html="$t(this.slug + '.content.what-content-1')"></p>
          <p v-html="$t(this.slug + '.content.what-content-2', {
            link_store: '#',
            link_rankings: '#',
            link_school: '#'
          })">
          </p>

          <a href="#why" class="app-text-selected"><i class="fas fa-location-arrow"></i> ¿Porqué lo hacemos?</a>
          <p class="mt-2">
            Junto con la cervercería artesanal crece una comunidad de entusiastas.
          </p>
          <p>
            Una que favorece las economías locales en el consumo de cerveza creada por la pasión misma en el producto.
            Una que investiga nuevos sabores y procesos, que comparte porque sabe
            que su fuerza y energía radica en eso, aumentando a su vez la diversidad y calidad de la oferta general.
          </p>
          <p>
            A esa comunidad es a la que Hopmasters quiere servir con herramientas e
            información de calidad que respete los principios que hacen que cada vez mas
            personas se decidan por la cerveza artesanal.
          </p>
          <br>
          <a href="#rutina" class="app-text-selected"><i class="fas fa-location-arrow"></i> ¿Quiénes somos?</a>
          <p class="mt-2">
            Una banda de borrachos con habilidades de programación y aficionados a la cerveza artensanal <i class="fas fa-smile-beam"></i>
            <br>
            En realidad, Hopmasters fue desarrollado por <b-link :href="$t('global.dev-link')" target="_blank"><i class="fas fa-circle mr-1"></i>Mínimo</b-link>,
            un laboratorio de ideas digitales basado en Uruguay,
            con la idea de aportar al fortalecimiento de la comunidad cervecera artesanal.
          </p>
        </h2>
      </header>
  </div>
</template>

<script>
export default {
  data () {
    return {
      slug:this.$route.params.slug,
    }
  },
  watch: {
    $route(to, from) {
      // react to route changes in the same (reused) component
      this.content = "Page for " + to.params.slug;
    }
  },
  created(){
    this.content = "Page for " + this.slug;
  }

}
</script>
