
import { initializeApp } from "https://www.gstatic.com/firebasejs/11.1.0/firebase-app.js";
import { getAuth, createUserWithEmailAndPassword } from "https://www.gstatic.com/firebasejs/11.1.0/firebase-auth.js";


const firebaseConfig = {
  apiKey: "AIzaSyBVZgfQaHQyPhVqYkr4at0va68mUTrK3OQ",
  authDomain: "logintest-4702b.firebaseapp.com",
  projectId: "logintest-4702b",
  storageBucket: "logintest-4702b.appspot.com",
  messagingSenderId: "187749250650",
  appId: "1:187749250650:web:7fd49106e747d4bd93ca63",
};


const app = initializeApp(firebaseConfig);
const auth = getAuth(app);

const submit = document.getElementById("submit");
submit.addEventListener("click", function (event) {
  event.preventDefault();

  const email = document.getElementById("email").value;
  const password = document.getElementById("password").value;

  if (email && password) {
    createUserWithEmailAndPassword(auth, email, password)
      .then((userCredential) => {
        const user = userCredential.user;
        alert("Account created successfully!");
        window.location.href = 'login.html';
      })
      .catch((error) => {
        const errorMessage = error.message;
        alert(errorMessage);
      });
  } else {
    alert("Please fill out both email and password fields.");
  }
});
