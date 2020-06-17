

export default{
  data: function() {
    return {
      get app_title() {
        return "Hopmasters";
      },
      get app_version(){
        return require('../../package.json').version || '0';
      }
    }
  },
  methods:{
    app_goback(steps){
      this.$router.go(steps)
    },
    app_link(name){
      switch(name){
        case "whatsapp":
          if (this.$i18n.locale == "es" ) return "https://web.whatsapp.com"; // whatsapp group name
          if (this.$i18n.locale == "en" ) return "https://web.whatsapp.com"; // whatsapp group name
          /* eslint-disable no-unreachable */
          break;
          /* eslint-enable */
        case "instagram":
          return "https://www.instagram.com/hopmasters/";
          /* eslint-disable no-unreachable */
          break;
          /* eslint-enable */
        case "github":
          return "https://github.com/minimo-io/hopmasters";
          /* eslint-disable no-unreachable */
          break;
          /* eslint-enable */
      }
    },
    app_notification(notification, isTranslate){
      var final_msg = notification;
      if (isTranslate) final_msg = this.$t(notification);

      this.$bvToast.toast(final_msg , {
        title: this.$t("notifications.notification-title"),
        autoHideDelay: 10000,
        appendToast: true
      });
    },
    // app_user_is_auth(){
    //   return (firebase.auth().currentUser ? true : false);
    //
    // },
    // app_user_logout(){
    //   alert("OUTTTT!");
    // },
    lg_build_path(to){
      let lg_prefix = "/" + this.$i18n.locale;
      if (this.$i18n.locale == "es") lg_prefix = "";

      let goto = lg_prefix + to;
      // console.log("Goto: " + goto);
      // console.log("Prefix: " + lg_prefix);
      // console.log("To: "+ to);
      if (this.$i18n.locale != "es" && goto.slice(-1) == "/"){
          goto = goto.slice(0, -1);
      }

      return goto;
    },
  }
}
