const express = require("express");
const bodyParser = require("body-parser");
const mysql = require("mysql2");
const cors = require("cors");

const app = express();
const PORT = 5000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Database connection
const db = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "ZXC123#zxc",
    database: "ticketbooking"
});

db.connect((err) => {
    if (err) {
        console.error("Database connection failed: ", err.message);
    } else {
        console.log("Connected to the Database.");
    }
});

// New route to store additional user details
app.post("/store-user-details", (req, res) => {
    const { fullName, email, phone, uid } = req.body;

    // Check if all fields are provided
    if (!fullName || !email || !phone || !uid) {
        return res.status(400).json({ message: "All fields are required" });
    }

    // Query to insert user details
    const query = "INSERT INTO Users (name, email, phone_no, firebase_uid) VALUES (?, ?, ?, ?)";

    db.query(query, [fullName, email, phone, uid], (err, result) => {
        if (err) {
            console.error("Error inserting user details: ", err);
            return res.status(500).json({
                message: "Database error",
                error: err.message
            });
        }

        res.status(201).json({
            message: "User details stored successfully!"
        });
    });
});

// Start the server
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});