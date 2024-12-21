/* eslint-disable max-len */
const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.sendAnnouncementNotification = functions.https.onRequest(
  async (req, res) => {
    const { title, message, timestamp, sender } = req.body;

    if (!title || !message || !sender) {
      return res.status(400).send('Title, message, and sender are required.');
    }

    const notification = {
      title: title,
      text: message,
      sender: sender, // Include sender's email in the notification object
      timestamp: timestamp,
      hasSeen: false,
    };

    try {
      // Get all user documents from the "users" collection
      const usersSnapshot = await admin.firestore().collection('users').get();
      const fcmTokens = [];

      usersSnapshot.forEach((doc) => {
        const userData = doc.data();

        // Skip sender
        if (userData.email === sender) return;

        // Collect FCM tokens for users other than the sender
        if (userData.fcmTokens && userData.fcmTokens.length > 0) {
          fcmTokens.push(...userData.fcmTokens);
        }
      });

      if (fcmTokens.length === 0) {
        return res.status(200).send('No FCM tokens found.');
      }

      // Define the MulticastMessage payload
      const multicastMessage = {
        tokens: fcmTokens,
        notification: {
          title: title,
          body: message,
        },
      };

      // Send the multicast message
      const response = await admin
        .messaging()
        .sendEachForMulticast(multicastMessage);
      console.log('Multicast response:', response);

      const updatePromises = usersSnapshot.docs.map(async (doc) => {
        const userData = doc.data();

        // Skip the sender when updating notifications
        if (userData.email === sender) return;

        // Retrieve existing notifications
        const notifications = userData.notifications || [];

        // Add the new notification and ensure the limit is enforced
        // there is a limit of 100 notifications per user document
        const updatedNotifications =
          notifications.length >= 100 ?
            [...notifications.slice(-99), notification] : // Keep last 99 + new one
            [...notifications, notification]; // Just add the new one

        return doc.ref.update({
          notifications: updatedNotifications,
        });
      });

      // Wait for all updates to complete
      await Promise.all(updatePromises);
      return res.status(200).send('Notifications sent and saved successfully.');
    } catch (error) {
      console.error('Error sending notifications:', error);
      return res.status(500).send('Error sending notifications.');
    }
  },
);
