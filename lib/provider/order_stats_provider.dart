import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderStatsProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Order stats
  Map<String, int> orderStats = {
    'totalOrders': 0,
    'completedOrders': 0,
    'overdueOrders': 0,
    'pendingOrders': 0,
    'cancelledOrders': 0,
    'awaitingConfirmation': 0,
  };

  bool isLoading = true;

  OrderStatsProvider() {
    loadOrderStats();
  }

  Future<void> loadOrderStats() async {
    isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot querySnapshot = await _firestore.collection('orders').get();

      // Reset counters
      int totalOrders = querySnapshot.docs.length;
      int completedOrders = 0;
      int overdueOrders = 0;
      int pendingOrders = 0;
      int cancelledOrders = 0;
      int awaitingConfirmation = 0;

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        switch (data['status']) {
          case 'completed':
            completedOrders++;
            break;
          case 'overdue':
            overdueOrders++;
            break;
          case 'pending':
            pendingOrders++;
            break;
          case 'cancelled':
            cancelledOrders++;
            break;
          case 'awaiting_confirmation':
            awaitingConfirmation++;
            break;
        }
      }

      orderStats = {
        'totalOrders': totalOrders,
        'completedOrders': completedOrders,
        'overdueOrders': overdueOrders,
        'pendingOrders': pendingOrders,
        'cancelledOrders': cancelledOrders,
        'awaitingConfirmation': awaitingConfirmation,
      };

      isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading order stats: $e');
      isLoading = false;
      notifyListeners();
    }
  }

  // Get all orders
  Stream<QuerySnapshot> getOrdersStream() {
    return _firestore.collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Add new order
  Future<void> addOrder(Map<String, dynamic> orderData) async {
    try {
      await _firestore.collection('orders').add({
        ...orderData,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await loadOrderStats(); // Refresh stats after adding
    } catch (e) {
      print('Error adding order: $e');
      throw e;
    }
  }
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await loadOrderStats(); // Refresh stats after updating
    } catch (e) {
      print('Error updating order status: $e');
      throw e;
    }
  }
}