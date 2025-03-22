// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotifications =
//       FlutterLocalNotificationsPlugin();

//   Future<void> initialize() async {
//     // Request permission for notifications
//     await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     // Initialize local notifications
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
    
//     const DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );
    
//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );
    
//     await _localNotifications.initialize(initializationSettings);

//     // Subscribe to topic for all events
//     await _firebaseMessaging.subscribeToTopic('events');

//     // Handle notifications when app is in foreground
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       _showNotification(message);
//     });

//     // Handle notifications when app is opened from terminated state
//     FirebaseMessaging.instance.getInitialMessage().then((message) {
//       if (message != null) {
//         // Navigate to relevant screen if needed
//       }
//     });

//     // Handle notification click when app is in background
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       // Navigate to relevant screen if needed
//     });
//   }

//   Future<void> _showNotification(RemoteMessage message) async {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;

//     if (notification != null && android != null) {
//       await _localNotifications.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             'event_channel',
//             'Event Notifications',
//             importance: Importance.max,
//             priority: Priority.high,
//           ),
//           iOS: DarwinNotificationDetails(),
//         ),
//       );
//     }
//   }

//   // Get FCM token for this device
//   Future<String?> getToken() async {
//     return await _firebaseMessaging.getToken();
//   }
// }