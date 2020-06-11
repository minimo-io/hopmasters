<template>
  <div class="container primary-container pt-0 px-0 mt-0">
      <header class="alt-post-header alt-top-title mx-0">
        <b-link @click.prevent="app_goback(-1)" class="breadcrumb-back-button">
          <i class="fas fa-reply"></i>&nbsp;{{ $t("global.back") }}
        </b-link>
        <h1 class="post-title category-title" itemprop="name headline">
          <span v-html="$t(this.slug + '-title')"></span>
        </h1>
        <h2 class="post-subtitle category-subtitle Xread-more" v-html="$t(this.slug + '-content')"></h2>

        <h2 class="post-subtitle category-subtitle mt-3">
          <a href="#what" class="app-text-selected"><i class="fas fa-location-arrow"></i> ¿Qué hacemos?</a>
          <p class="mt-2">
            Hopmasters pretende promover la cultura cervecera artesanal alrededor del <i class='fas fa-globe-americas'></i>
            <br>
            Para eso creamos 3 tipos de herramientas:
          </p>
          <p>
            <ul class="beer-list">
              <li>
                <i class="fas fa-arrow-circle-right mr-1"></i>Para que los brewers y microcervecerías puedan promocionar y vender sus productos a un precio justo sin tener que encargarse de la parte tecnológica.
              </li>
              <li>
                <i class="fas fa-arrow-circle-right mr-1"></i>Para que los usuarios puedan comentar, votar y comprar sus cervezas preferidas y encontrar novedades.
              </li>
              <li>
                <i class="fas fa-arrow-circle-right mr-1"></i>Para que los nuevos cerveceros puedan aprender cómo producir su propia cerveza artesanal
                junto a los maestros cerveceros de la  <b-link to='/school'><i class="fas fa-graduation-cap mr-0"></i>Escuela de Hopmasters</b-link>
                y mediante el intercambio con otros miembros de la comunidad.
              </li>
            </ul>
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
          <a href="#rutina" class="app-text-selected"><i class="fas fa-location-arrow"></i> ¿Quienes somos?</a>
          <p class="mt-2">Una manga de borrachos que saben programar y sacar fotos.</p>
        </h2>
      </header>
  </div>
</template>

<script>
export default {
  data () {
    return {
      slug:this.$route.params.slug,
      content: {}
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
