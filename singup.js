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

  // Get all form values
  const fullName = document.getElementById("username").value;
  const email = document.getElementById("email").value;
  const phone = document.getElementById("Phone").value;
  const password = document.getElementById("password").value;

  // Validate all fields
  if (!fullName || !email || !phone || !password) {
    alert("Please fill out all fields.");
    return;
  }

  createUserWithEmailAndPassword(auth, email, password)
    .then((userCredential) => {
      const user = userCredential.user;
      
      // Store additional user details in MySQL database
      return fetch('http://localhost:5000/store-user-details', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          fullName,
          email,
          phone,
          uid: user.uid
        })
      });
    })
    .then((response) => {
      if (!response.ok) {
        throw new Error('Failed to store user details');
      }
      return response.json();
    })
    .then((data) => {
      alert("Account created successfully!");
      window.location.href = 'login.html';
    })
    .catch((error) => {
      const errorMessage = error.message;
      alert(errorMessage);
    });
});