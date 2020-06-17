<template>
  <div>
    <!-- Login form -->
    <b-card
      title="Formulario de ingreso"
      sub-title="Ingresa y vota o encuentra la mejor cerveza">
      <b-form @submit.prevent="onLogin" inline class="mt-4">
        <label class="sr-only" for="login_username">{{ $t("login.email") }}</label>
        <b-input
          id="login_username"
          type="email"
          v-model="login.username"
          class="mb-2 mr-sm-2 mb-sm-0"
          required
          :placeholder="$t('login.email')"
        ></b-input>

        <label class="sr-only" for="login_password">{{ $t("login.password") }}</label>
        <b-input-group class="mb-2 mr-sm-2 mb-sm-0">
          <b-input
            type="password"
            id="login_password"
            v-model="login.password"
            required
            :placeholder="$t('login.password')"></b-input>
        </b-input-group>

        <b-form-checkbox class="mb-2 mr-sm-2 mb-sm-0">{{ $t("login.remember") }}</b-form-checkbox>

        <b-button type="submit" variant="primary">{{ $t("login.signin") }}</b-button>
      </b-form>
    </b-card>
    <!-- Signup form -->
    <b-card title="Formulario de registro" sub-title="Registrate en Hopmasters y disfutá de todas las funciones cerveceras" class="mt-4">
      <b-form @submit.prevent="onSignup" @reset="onReset" v-if="show_signup">

        <b-form-group id="input-group-0" :label="$t('login.name')" label-for="input-name">
          <b-form-input
            id="input-name"
            v-model="signup.name"
            required
            :placeholder="$t('login.name')"
          ></b-form-input>
        </b-form-group>

        <b-form-group id="input-group-1" label="Email address:" label-for="input-1">
          <b-form-input
            id="input-email"
            v-model="signup.email"
            type="email"
            required
            placeholder="Enter email"
          ></b-form-input>
        </b-form-group>

        <b-form-group id="input-group-2" :label="$t('login.password')" label-for="input-pwd">
          <b-form-input
            id="input-pwd"
            type="password"
            v-model="signup.password"
            required
            :placeholder="$t('login.password')"
          ></b-form-input>
        </b-form-group>

        <b-form-group id="input-group-3" :label="$t('login.password-repeat')" label-for="input-pwd-repeat">
          <b-form-input
            id="input-pwd-repeat"
            type="password"
            v-model="signup.password_repeat"
            required
            :placeholder="$t('login.password-repeat')"
          ></b-form-input>
        </b-form-group>

        <b-button type="submit" variant="primary">Submit</b-button>
        <b-button type="reset" variant="danger">Reset</b-button>
      </b-form>
      <b-card class="mt-3" header="Form Data Result">
        <!-- <pre class="m-0">{{ form }}</pre> -->
      </b-card>
    </b-card>


  </div>
</template>
<script>
import fireDb from '@/firebase/init.js'
import firebase from 'firebase'

export default {
  name: "Login",
  data () {
    return {
      login: {
        username: '',
        password: '',
      },
      signup: {
        name: '',
        email: '',
        password: '',
        password_repeat: ''
      },
      show_signup: true
    }
  },
  methods: {
    onSignup(evt) {

      if (this.signup.name && this.signup.email && this.signup.password){
        if (this.signup.password != this.signup.password_repeat){
          this.app_notification( this.$t("error.passwords-dont-match") );
          return;
        }

        // create user
        firebase.auth().createUserWithEmailAndPassword(
          this.signup.email,
          this.signup.password
        ).then(data => {
          data.user
            .updateProfile({
              displayName: this.signup.name
            })
            .then(() => {

              this.app_notification( 'notifications.ok-signup', true );
              //this.$router.push({ path: "/" });
            });
        }).catch( err => {
          this.app_notification( err.message );
        });

      }

      // alert(JSON.stringify(this.form))
    },
    onLogin: function(evt){
      if (this.login.username && this.login.password){

        // create user
        firebase.auth().signInWithEmailAndPassword(
          this.login.username,
          this.login.password
        ).then(user => {
          this.app_notification( 'notifications.ok-login', true );
          //this.$router.replace({ path: "/" });
        }).catch( err => {
          this.app_notification( err.message );
        });

      }
    },
    onReset(evt) {
      evt.preventDefault()
      // Reset our form values
      // this.form.email = ''
      // this.form.name = ''
      // // Trick to reset/clear native browser form validation state
      // this.show = false
      // this.$nextTick(() => {
      //   this.show = true
      // })
    }
  }
}
</script>
