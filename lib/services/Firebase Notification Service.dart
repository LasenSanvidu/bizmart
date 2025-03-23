import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  // Make this nullable to fix the initialization error
  static NotificationService? _instance;
  
  // Factory constructor with proper initialization check
  factory NotificationService() {
    // Initialize if not already initialized
    _instance ??= NotificationService._internal();
    return _instance!;
  }

  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  
  // Channel IDs
  final String eventChannelId = 'event_channel';
  final String eventChannelName = 'Event Notifications';
  final String eventChannelDescription = 'Notifications for calendar events';

  Future<void> initialize() async {
    // Request permission for notifications
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
        handleNotificationTap(details);
      },
    );

    // Create notification channel for Android
    await _createNotificationChannel();

    // Subscribe to topic for all events
    await _firebaseMessaging.subscribeToTopic('events');

    // Handle FCM messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showFCMNotification(message);
    });

    // Handle FCM messages when the app is opened from a terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        // Navigate to the relevant screen if needed
        _handleMessage(message);
      }
    });

    // Handle FCM notification clicks when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Navigate to the relevant screen if needed
      _handleMessage(message);
    });

    // Start listening for notifications in Firestore
    _listenForFirestoreNotifications();
  }

  Future<void> _createNotificationChannel() async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      eventChannelId,
      eventChannelName,
      description: eventChannelDescription,
      importance: Importance.max,
    );
    
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void _handleMessage(RemoteMessage message) {
    // Handle navigation based on notification data
    if (message.data.containsKey('eventId')) {
      // Navigate to event details page
      // You'll need to implement navigation logic here
    }
  }

  Future<void> _showFCMNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            eventChannelId,
            eventChannelName,
            channelDescription: eventChannelDescription,
            importance: Importance.max,
            priority: Priority.high,
            icon: android.smallIcon,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        payload: message.data['eventId'],
      );
    }
  }

  // Show a local notification (not from FCM)
  Future<void> showLocalNotification({
    required String title, 
    required String body, 
    String? payload,
  }) async {
    await _localNotifications.show(
      DateTime.now().millisecond,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          eventChannelId,
          eventChannelName,
          channelDescription: eventChannelDescription,
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }

  void handleNotificationTap(NotificationResponse details) {
    // Handle notification tap based on payload
    if (details.payload != null) {
      // Navigate to event details or appropriate screen
      // You'll need to implement navigation logic here
    }
  }

  // Listen for notifications stored in Firestore (client-side alternative to FCM)
  void _listenForFirestoreNotifications() {
    FirebaseFirestore.instance
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .limit(20)
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          var notification = change.doc.data();
          
          // Only show if it's a new notification (within last minute)
          if (notification?['timestamp'] != null) {
            Timestamp timestamp = notification?['timestamp'] as Timestamp;
            DateTime notificationTime = timestamp.toDate();
            if (DateTime.now().difference(notificationTime).inMinutes < 1) {
              showLocalNotification(
                title: notification?['title'] ?? 'New Notification',
                body: notification?['body'] ?? '',
                payload: notification?['eventId'],
              );
            }
          }
        }
      }
    });
  }

  // Get FCM token for this device
  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
}