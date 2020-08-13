<template>
  <div class="container mt-5">
    <!-- Login form -->
    <b-overlay :show="isLoading" z-index="8000" rounded="sm">
      <b-card
        v-if="isLogin"
        class="alt-form alt-form-dark"
        no-body>
          <b-card-body class="z-index-6000">
            <b-card-title v-html="$t('login.title')"></b-card-title>
            <b-card-sub-title>{{ $t("nav.signin.description") }}</b-card-sub-title>

            <br>
            <b-button type="button" @click="googleLogin" block variant="outline-danger" class="btn-xs-block">
              <i class="fab fa-google mr-1"></i>
              {{ $t("login.btn-socialLogin") }} Google
            </b-button>
            <b-button type="button" @click="googleLogin" block variant="outline-success" class="btn-xs-block mt-3">
              <i class="fab fa-facebook-f mr-1"></i>
              {{ $t("login.btn-socialLogin") }} Facebook
            </b-button>
            <b-button type="button" @click="googleLogin" block variant="outline-dark" class="btn-xs-block mt-3">
              <i class="fas fa-envelope mr-1"></i>
              {{ $t("login.btn-socialLogin") }} Correo
            </b-button>
            <hr>

            <h6 class="text-center mt-4">
              {{ $t('login.orSingUpMessage') }}
              <b-button type="button" @click="showSignUp" block variant="outline-green" class="btn-xs-block mt-3">
                {{ $t('login.orSingUpButtonText') }}
              </b-button>
            </h6>

            <!-- <b-form @submit.prevent="onLogin" class="mt-4">

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

              <b-button type="submit" variant="green" class="btn-xs-block btn-dark mr-2">{{ $t("login.btn-signin") }}</b-button>
              <b-button type="button" @click="showSignUp" variant="light" class="btn-xs-block">{{ $t("login.btn-signup") }}</b-button>
            </b-form> -->


          </b-card-body>
          <div class="overlay overlay-dark"></div>
      </b-card>
    </b-overlay>


    <!-- Signup form -->
    <b-overlay v-if="isSignUp" :show="isLoading" rounded="sm" z-index="8000">
      <b-card no-body class="mt-4 alt-form alt-form-dark">

      <b-card-body class="z-index-6000">
        <b-card-title v-html="$t('signup.title')"></b-card-title>
        <b-card-sub-title>{{ $t("nav.signin.description") }}</b-card-sub-title>


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

          <b-button type="submit" variant="green" class="mr-2">Submit</b-button>
          <b-button type="button" variant="light" @click="cancelSignUp">Cancel</b-button>
        </b-form>
        </b-card-body>
        <div class="overlay overlay-green"></div>
      </b-card>
    </b-overlay>

    <p class="text-center mt-3">{{ $t("global.or") }}</p>

    <b-overlay :show="isLoading" z-index="8000" rounded="sm">
      <b-card
        class="alt-form alt-form-light mt-3"
        no-body>
          <b-card-body class="z-index-6000">
            <b-card-title class="text-center">{{ $t("login.areYouABrewery") }}</b-card-title>
            <b-button type="button" @click="googleLogin" block variant="outline-dark" class="btn-xs-block">
               {{ $t("login.contactWorkTogether") }}
            </b-button>
          </b-card-body>
          <div class="overlay overlay-secondary"></div>
      </b-card>
    </b-overlay>

  </div>
</template>
<style>
.b-toaster{
  z-index:8000 !important;
}
</style>
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
      isLogin: true,
      isSignUp: false,
      slug:this.$route.params.slug,
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
    googleLogin(evt){
      console.log("Login with Google");
      let provider = new firebase.auth.GoogleAuthProvider();
        this.isLoading = true;
        NProgress.start();
        // create user
        firebase.auth().signInWithPopup(provider).then(user => {
          this.isLoading = false;
          NProgress.done();
          this.app_notification( 'notifications.ok-login', true );
          this.$router.push({path: this.lg_build_path("/") });

        }).catch( err => {
          this.isLoading = false;
          NProgress.done();
          this.app_notification( err.message, false, 'danger' );
        });

    },
    onSignup(evt) {

      if (this.signup.name && this.signup.email && this.signup.password){
        if (this.signup.password != this.signup.password_repeat){
          this.app_notification( this.$t("error.passwords-dont-match") );
          return;
        }
        this.isLoading = true;
        NProgress.start();

        var o_this = this;
        // create user
        firebase.auth().createUserWithEmailAndPassword(
          this.signup.email,
          this.signup.password
        ).then(data => {
          console.log(data);
          data.user
            .updateProfile({
              displayName: o_this.signup.name // this seems to not be working
            })
            .then(() => {
              const db_users = fireDb.ref("users");

              db_users.push().set({
              // db_users.set({
                user_id: data.user.uid,
                user_name: o_this.signup.name
              }, function(error) {

                if (error) {
                  o_this.app_notification( error, false, "danger" );
                } else {

                  store.getters.user.data.displayName = o_this.signup.name;

                  o_this.isLoading = false;
                  NProgress.done();
                  o_this.app_notification( 'notifications.ok-signup', true );
                  o_this.$router.push({ path: o_this.lg_build_path("/") });
                }

              });


            });
        }).catch( err => {
          this.isLoading = false;
          NProgress.done();
          this.app_notification( err.message, false, 'danger' );
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
          this.app_notification( err.message, false, 'danger' );
        });

      }
    },
    showSignUp: function(){
      this.isSignUp = true;
      this.isLogin = false;
    },
    cancelSignUp: function(){
      this.isSignUp = false;
      this.isLogin = true;
    }
  }
}
</script>
