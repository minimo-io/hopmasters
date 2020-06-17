import firebase from 'firebase'
import firestore from 'firebase/firestore'

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyBMwbEIIh0x33bBRCcIRDAxeH-K5aZeU7A",
  authDomain: "hopmasters-net.firebaseapp.com",
  databaseURL: "https://hopmasters-net.firebaseio.com",
  projectId: "hopmasters-net",
  storageBucket: "hopmasters-net.appspot.com",
  messagingSenderId: "676210559169",
  appId: "1:676210559169:web:97f9df26fc03bb094aec40",
  measurementId: "G-DZXSFXN5HB"
};
// Initialize Firebase
// firebase.initializeApp(firebaseConfig);
// firebase.analytics();

const firebaseApp = firebase.initializeApp(firebaseConfig);
// firebaseApp.firestore().settings({
//   timestampsInSnapshot: true
// });

export default firebaseApp.firestore();
