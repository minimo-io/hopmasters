<template>
  <div class="container primary-container pt-0 px-0 mt-3 mt-lg-5">
      <header class="alt-post-header alt-top-title mx-0">
        <b-link @click.prevent="app_goback(-1)" class="breadcrumb-back-button">
          <i class="fas fa-reply"></i>&nbsp;{{ $t("global.back") }}
        </b-link>

        <h1 class="post-title category-title d-none" itemprop="name headline">
          <span v-html="$t(this.slug + '.title')"></span>
        </h1>

        <h2 class="post-subtitle category-subtitle mt-3">
          <b-alert show variant="warning">
            <i class="fas fa-code mr-1"></i><span v-html="$t(this.slug + '.content.alert')"></span>
            <span  v-if="app_link('whatsapp')">
              {{ $t(this.slug + '.content.alert-soon-instagram') }}
              <b-link :href="app_link('instagram')" target="_blank" class="text-nowrap"><i class="fab fa-instagram mr-1"></i>Instagram</b-link>.
            </span>
          </b-alert>

          <figure class="figure">
            <b-img src="@/assets/homebrewing-adam-wilson.jpg" rounded fluid alt="imagen-de-cerveza"></b-img>
            <figcaption class="figure-caption">{{ $t(this.slug + '.content.photo-figure') }}</figcaption>
          </figure>


          <a href="#what" class="app-text-selected"><i class="fas fa-location-arrow"></i> {{ $t(this.slug + '.content.title-what') }}</a>
          <p class="mt-2" v-html="$t(this.slug + '.content.what-content-1')"></p>
          <p>
            <ol class='beer-list'>
              <li>
                {{ $t('global.a-female') }} <b-link to="/store"><i class='fas fa-shopping-cart mr-1'></i>{{ $t("nav.store") }}</b-link>
                {{ $t(this.slug + '.content.what-content-2') }}
              </li>
              <li>
                {{ $t('global.a-male') }} <b-link to='/'><i class='fas fa-medal mr-1'></i>{{ $t("nav.ranking") }}</b-link>
                {{ $t(this.slug + '.content.what-content-3') }}
              </li>
              <li>
                {{ $t('global.a-female') }} <b-link to='/school'><i class='fas fa-graduation-cap mr-1'></i>{{ $t("nav.school") }}</b-link>
                {{ $t(this.slug + '.content.what-content-4') }}
              </li>
            </ol>
          </p>

          <b-link href="#why" class="app-text-selected"><i class="fas fa-location-arrow"></i> {{ $t(this.slug + '.content.title-why') }}</b-link>
          <p class="mt-2" v-html="$t(this.slug + '.content.why-content-1')"></p>
          <p v-html="$t(this.slug + '.content.why-content-2')"></p>
          <p v-html="$t(this.slug + '.content.why-content-3')"></p>

          <b-link href="#who" class="app-text-selected"><i class="fas fa-location-arrow"></i> {{ $t(this.slug + '.content.title-who') }}</b-link>
          <p class="mt-2">{{ $t(this.slug + '.content.who-content-1') }} <i class="fas fa-grin-beam-sweat"></i>
          <p>
            {{ $t(this.slug + '.content.who-content-2') }} <b-link :href="$t('global.dev-link')" target="_blank" class="text-nowrap"><i class="fas fa-circle mr-1"></i>{{ $t("global.dev-name") }}</b-link>,
            {{ $t(this.slug + '.content.who-content-3') }}
            {{ $t(this.slug + '.content.who-content-4') }}
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
