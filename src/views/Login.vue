<template>
  <div>
    <!-- Login form -->
    <b-card
      title="Formulario de ingreso"
      sub-title="Ingresa y vota o encuentra la mejor cerveza">
      <b-form @submit.stop.prevent inline class="mt-4">
      <label class="sr-only" for="login_username">{{ $t("login.username") }}</label>
      <b-input
        id="login_username"
        class="mb-2 mr-sm-2 mb-sm-0"
        :placeholder="$t('login.username')"
      ></b-input>

      <label class="sr-only" for="login_password">{{ $t("login.password") }}</label>
      <b-input-group class="mb-2 mr-sm-2 mb-sm-0">
        <b-input type="password" id="login_password" :placeholder="$t('login.password')"></b-input>
      </b-input-group>

      <b-form-checkbox class="mb-2 mr-sm-2 mb-sm-0">{{ $t("login.remember") }}</b-form-checkbox>

      <b-button variant="primary">{{ $t("login.signin") }}</b-button>
      </b-form>
    </b-card>
    <!-- Signup form -->
    <b-card title="Formulario de registro" sub-title="Registrate en Hopmasters y disfutá de todas las funciones cerveceras" class="mt-4">
      <b-form @submit="onSubmit" @reset="onReset" v-if="show">

        <b-form-group
          id="input-group-name"
          :label="$t('login.name')"
          label-for="input-name"
        >
          <b-form-input
            id="input-name"
            required
            :placeholder="$t('login.name')"
          ></b-form-input>
        </b-form-group>

        <b-form-group
          id="input-group-1"
          label="Email address:"
          label-for="input-1"
        >
          <b-form-input
            id="input-1"
            v-model="form.email"
            type="email"
            required
            placeholder="Enter email"
          ></b-form-input>
        </b-form-group>

        <b-form-group id="input-group-2" :label="$t('login.password')" label-for="input-2">
          <b-form-input
            id="input-2"
            type="password"
            v-model="form.name"
            required
            :placeholder="$t('login.password')"
          ></b-form-input>
        </b-form-group>

        <b-button type="submit" variant="primary">Submit</b-button>
        <b-button type="reset" variant="danger">Reset</b-button>
      </b-form>
      <b-card class="mt-3" header="Form Data Result">
        <pre class="m-0">{{ form }}</pre>
      </b-card>
    </b-card>


  </div>
</template>

<script>
export default {
  name: "Login",
  data () {
    return {
      form: {
        email: '',
        name: '',
      },
      show: true
    }
  },
  methods: {
    onSubmit(evt) {
      evt.preventDefault()
      alert(JSON.stringify(this.form))
    },
    onReset(evt) {
      evt.preventDefault()
      // Reset our form values
      this.form.email = ''
      this.form.name = ''
      // Trick to reset/clear native browser form validation state
      this.show = false
      this.$nextTick(() => {
        this.show = true
      })
    }
  }
}
</script>
