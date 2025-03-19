// Import the necessary modules from Firebase Functions
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Initialize Firebase Admin SDK to access Firestore and Firebase Messaging
admin.initializeApp();

// Example HTTP function (you can keep or remove this as per your needs)
exports.helloWorld = onRequest((request, response) => {
  logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

// Firestore trigger for sending notifications
exports.sendEventNotification = functions.firestore
    // eslint-disable-next-line max-len
    .document("notifications/{docId}") // Listen for new documents in the "notifications" collection
    .onCreate(async (snap, context) => {
      const data = snap.data(); // Get the data of the newly added document

      // Prepare the notification message
      const message = {
        notification: {
          title: data.title, // Use the title from the document
          body: data.body, // Use the body from the document
        },
        // eslint-disable-next-line max-len
        topic: "events", // All users subscribed to the "events" topic will receive this notification
      };

      try {
      // Send the notification to all users subscribed to the "events" topic
        await admin.messaging().send(message);
        console.log("Notification sent successfully");
      } catch (error) {
        console.error("Error sending notification:", error);
      }
    });
