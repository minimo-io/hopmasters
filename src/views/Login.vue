<template>
  <div class="mt-3">
    <!-- Login form -->
    <b-overlay :show="isLoading" z-index="8000" rounded="sm">
      <b-card
        class="alt-form alt-form-dark"
        no-body>

          <b-card-body class="z-index-6000">
            <b-card-title>Formulario de ingreso</b-card-title>
            <b-card-sub-title>{{ $t("nav.signin.description") }}</b-card-sub-title>

            <b-form @submit.prevent="onLogin" class="mt-4">

              <b-form-group id="input-group-1" :label="$t('login.email')" label-for="login_username">
                <b-form-input
                  id="login_username"
                  v-model="login.username"
                  type="email"
                  required
                  :placeholder="$t('login.email')"></b-form-input>
              </b-form-group>

              <b-form-group id="input-group-1" :label="$t('login.password')" label-for="login_password">
                <b-form-input
                  id="login_password"
                  v-model="login.password"
                  type="password"
                  required
                  :placeholder="$t('login.password')"></b-form-input>
              </b-form-group>

              <b-button type="submit" variant="dark" class="btn-xs-block btn-dark">{{ $t("login.signin") }}</b-button>
            </b-form>
          </b-card-body>
          <div class="overlay overlay-dark"></div>
      </b-card>

    </b-overlay>
    <!-- Signup form -->
    <b-overlay :show="isLoading" rounded="sm" z-index="8000">
      <b-card title="Formulario de registro" :sub-title="$t('nav.signup.description')" class="mt-4">
        <b-form @submit.prevent="onSignup" v-if="show_signup">

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
        </b-form>
      </b-card>
    </b-overlay>

  </div>
</template>
<script>
import fireDb from '@/firebase/init.js'
import firebase from 'firebase'
import NProgress from 'nprogress'
import store from '@/store'

export default {
  name: "Login",
  data () {
    return {
      isLoading: false,
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
        this.isLoading = true;
        NProgress.start();
        // create user
        firebase.auth().createUserWithEmailAndPassword(
          this.signup.email,
          this.signup.password
        ).then(data => {
          data.user
            .updateProfile({
              displayName: this.signup.name // this seems to not be working
            })
            .then(() => {

              fireDb.push().set({
                author: "alanisawesome",
                title: "The Turing Machine"
              }, function(error) {

                if (error) {
                  this.app_notification( error );
                } else {

                  store.getters.user.data.displayName = this.signup.name;

                  this.isLoading = false;
                  NProgress.done();
                  this.app_notification( 'notifications.ok-signup', true );
                  this.$router.push({ path: this.lg_build_path("/") });
                }

              });


            });
        }).catch( err => {
          this.isLoading = false;
          NProgress.done();
          this.app_notification( err.message );
        });

      }

      // alert(JSON.stringify(this.form))
    },
    onLogin: function(evt){
      if (this.login.username && this.login.password){
        this.isLoading = true;
        NProgress.start();
        // create user
        firebase.auth().signInWithEmailAndPassword(
          this.login.username,
          this.login.password
        ).then(user => {
          this.isLoading = false;
          NProgress.done();
          this.app_notification( 'notifications.ok-login', true );
          this.$router.push({path: this.lg_build_path("/") });

        }).catch( err => {
          this.isLoading = false;
          NProgress.done();
          this.app_notification( err.message );
        });

      }
    },

  }
}
</script>
