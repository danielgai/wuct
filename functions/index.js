/* eslint-disable operator-linebreak */
const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.sendAnnouncementNotification = functions.https.onRequest(
  async (req, res) => {
    try {
      // ✅ Require Authorization (Token from Firebase Auth)
      if (
        !req.headers.authorization ||
        !req.headers.authorization.startsWith('Bearer ')
      ) {
        return res.status(403).send('Unauthorized');
      }

      const idToken = req.headers.authorization.split('Bearer ')[1];
      const decodedToken = await admin.auth().verifyIdToken(idToken);
      if (!decodedToken) {
        return res.status(403).send('Unauthorized');
      }

      const userId = decodedToken.uid; // Firebase UID (safer than email)

      const { title, message, timestamp } = req.body;

      if (!title || !message) {
        return res
          .status(400)
          .send('Title and message are required.');
      }

      // ✅ Fetch sender's user document from Firestore using UID
      const senderDoc = await admin
        .firestore()
        .collection('users')
        .doc(userId)
        .get();

      if (!senderDoc.exists) {
        return res.status(404).send('Sender not found.');
      }

      const senderData = senderDoc.data();
      // ✅ Check if sender is an admin
      if (!senderData.admin) {
        // eslint-disable-next-line max-len
        return res.status(403).send('Unauthorized: Only admins can send notifications.');
      }

      // ✅ Implement Rate Limiting (1 notification per minute per user)
      const rateLimitKey = `notifications_${userId}`;
      const rateLimitDoc = await admin
        .firestore()
        .collection('rateLimits')
        .doc(rateLimitKey)
        .get();
      const lastSent = rateLimitDoc.exists
        ? rateLimitDoc.data().lastSent.toDate()
        : null;

      if (lastSent && Date.now() - lastSent.getTime() < 60000) {
        // 1 minute cooldown
        return res
          .status(429)
          .send('Please wait 60 seconds before sending another notification.');
      }

      // ✅ Fetch all users and their valid FCM tokens (excluding sender)
      const usersSnapshot = await admin.firestore().collection('users').get();
      const fcmTokens = [];

      usersSnapshot.forEach((doc) => {
        const userData = doc.data();
        if (
          doc.id !== userId && // Exclude sender
          userData.fcmTokens &&
          userData.fcmTokens.length > 0
        ) {
          fcmTokens.push(...userData.fcmTokens);
        }
      });

      if (fcmTokens.length === 0) {
        return res.status(200).send('No FCM tokens found.');
      }

      // ✅ Send notification
      const multicastMessage = {
        tokens: fcmTokens,
        notification: {
          title: title,
          body: message,
        },
      };

      const response = await admin
        .messaging()
        .sendEachForMulticast(multicastMessage);

      // ✅ Handle invalid FCM tokens
      const failedTokens = [];
      response.responses.forEach((resp, idx) => {
        if (!resp.success) {
          failedTokens.push(multicastMessage.tokens[idx]);
        }
      });

      if (failedTokens.length) {
        console.log('Removing invalid FCM tokens:', failedTokens);
        for (const doc of usersSnapshot.docs) {
          const userData = doc.data();
          if (userData.fcmTokens) {
            const validTokens = userData.fcmTokens.filter(
              (token) => !failedTokens.includes(token),
            );
            await doc.ref.update({ fcmTokens: validTokens });
          }
        }
      }

      // ✅ Save Notification to Firestore
      const notification = {
        title,
        text: message,
        sender: senderData.email, // Store sender email for reference
        timestamp,
        hasSeen: false,
      };

      const updatePromises = usersSnapshot.docs.map(async (doc) => {
        const userData = doc.data();
        if (doc.id === userId) return; // Skip sender

        const notifications = userData.notifications || [];
        const updatedNotifications =
          notifications.length >= 100
            ? [...notifications.slice(-99), notification]
            : [...notifications, notification];

        return doc.ref.update({ notifications: updatedNotifications });
      });

      await Promise.all(updatePromises);

      // ✅ Update rate limit
      await admin.firestore().collection('rateLimits').doc(rateLimitKey).set({
        lastSent: admin.firestore.Timestamp.now(),
      });

      return res.status(200).send('Notifications sent and saved successfully.');
    } catch (error) {
      console.error('Error sending notifications:', error);
      return res.status(500).send('Internal Server Error');
    }
  },
);
