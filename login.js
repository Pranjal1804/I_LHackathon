import { initializeApp } from "https://www.gstatic.com/firebasejs/11.1.0/firebase-app.js";
import {
  getAuth,
  signInWithEmailAndPassword,
  signOut,
} from "https://www.gstatic.com/firebasejs/11.1.0/firebase-auth.js";

const firebaseConfig = {
  apiKey: "AIzaSyBVZgfQaHQyPhVqYkr4at0va68mUTrK3OQ",
  authDomain: "logintest-4702b.firebaseapp.com",
  projectId: "logintest-4702b",
  storageBucket: "logintest-4702b.appspot.com",
  messagingSenderId: "187749250650",
  appId: "1:187749250650:web:7fd49106e747d4bd93ca63",
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);

// Wait for the DOM to load
document.addEventListener("DOMContentLoaded", () => {
  // Login functionality
  const submit = document.getElementById("submit");
  if (submit) {
    submit.addEventListener("click", (event) => {
      event.preventDefault();

      const email = document.getElementById("email").value;
      const password = document.getElementById("password").value;

      if (email && password) {
        signInWithEmailAndPassword(auth, email, password)
          .then((userCredential) => {
            alert("Logged In successfully!");
            window.location.href = "index_after_login.html";
          })
          .catch((error) => {
            alert(`Error: ${error.message} (${error.code})`);
          });
      } else {
        alert("Please fill out both email and password fields.");
      }
    });
  }

  // Logout functionality
  const logout = document.getElementById("logout");
  if (logout) {
    logout.addEventListener("click", (event) => {
      event.preventDefault();
      signOut(auth)
        .then(() => {
          alert("User logged out successfully");
          window.location.href = "index.html"; // Redirect after logout
        })
        .catch((error) => {
          alert(`Logout failed: ${error.message}`);
        });
    });
  }
});
