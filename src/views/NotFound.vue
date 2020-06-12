<template>
    <div class="text-center mt-5 mb-5">
      <welcome :withText="false"></welcome>
      <h1 class="post-title">{{ $t("not-found.title") }}</h1>
    </div>
</template>

<script>
import Welcome from '@/components/Welcome'
export default {
  components:{
    'welcome': Welcome
  },
  data () {
    return {
    }
  }
}
</script>
