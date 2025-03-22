// Import necessary Firebase functions and admin SDK for Firebase Messaging
const {onRequest} = require("firebase-functions/v2/https");
const {onDocumentWritten} = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");
const logger = require("firebase-functions/logger");

// Initialize Firebase Admin SDK
admin.initializeApp();

// Function triggered when an event document is updated in Firestore
exports.sendEventUpdateNotification = onDocumentWritten(
    "events/{eventId}",
    async (change, context) => {
    // Check if the document was created or updated
      if (!change.after.exists) {
        logger.info("Document deleted, no notification sent.");
        return null; // No notification if the document was deleted
      }

      // Get the event data from Firestore
      const eventData = change.after.data();

      // Define the notification payload
      const payload = {
        notification: {
          title: `Event Updated: ${eventData.title}`,
          // eslint-disable-next-line max-len
          body: `${eventData.description || "No description available"}\nDate: ${eventData.date}`,
        },
      };

      // eslint-disable-next-line max-len
      // Get the list of device tokens (assuming you store them in a collection like 'users')
      try {
        const usersSnapshot = await admin.firestore().collection("users").get();
        const tokens = [];
        usersSnapshot.forEach((doc) => {
          if (doc.exists && doc.data().fcmToken) {
            tokens.push(doc.data().fcmToken); // Collect user tokens
          }
        });

        // Send the notification to all users
        if (tokens.length > 0) {
          // eslint-disable-next-line max-len
          const response = await admin.messaging().sendToDevice(tokens, payload);
          logger.info("Notification sent successfully:", response);
        } else {
          logger.info("No FCM tokens found to send the notification");
        }
      } catch (error) {
        logger.error("Error sending notification:", error);
      }

      return null;
    },
);

// Function to send a basic HTTP request notification
exports.helloWorld = onRequest((request, response) => {
  logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});
