import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  static String? get currentUserId => _auth.currentUser?.uid;

  // Initialize Firebase
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  // Get order statistics for the current user
  static Future<Map<String, dynamic>> getOrderStatistics() async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw Exception('No user logged in');
      }

      DocumentSnapshot statsDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('statistics')
          .doc('orders')
          .get();

      if (statsDoc.exists) {
        return statsDoc.data() as Map<String, dynamic>;
      } else {
        return {
          'totalOrders': 0,
          'completedOrders': 0,
          'overdueOrders': 0,
          'pendingOrders': 0,
          'cancelledOrders': 0,
          'awaitingConfirmation': 0,
        };
      }
    } catch (e) {
      print('Error getting order statistics: $e');
      return {
        'totalOrders': 0,
        'completedOrders': 0,
        'overdueOrders': 0,
        'pendingOrders': 0,
        'cancelledOrders': 0,
        'awaitingConfirmation': 0,
      };
    }
  }

  // Update order statistics
  static Future<void> updateOrderStatistics(Map<String, dynamic> stats) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw Exception('No user logged in');
      }

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('statistics')
          .doc('orders')
          .set(stats, SetOptions(merge: true));
    } catch (e) {
      print('Error updating order statistics: $e');
      throw e;
    }
  }

  // Stream of order statistics for real-time updates
  static Stream<Map<String, dynamic>> orderStatisticsStream() {
    final userId = currentUserId;
    if (userId == null) {
      return Stream.value({
        'totalOrders': 0,
        'completedOrders': 0,
        'overdueOrders': 0,
        'pendingOrders': 0,
        'cancelledOrders': 0,
        'awaitingConfirmation': 0,
      });
    }

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('statistics')
        .doc('orders')
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        return {
          'totalOrders': 0,
          'completedOrders': 0,
          'overdueOrders': 0,
          'pendingOrders': 0,
          'cancelledOrders': 0,
          'awaitingConfirmation': 0,
        };
      }
    });
  }
}