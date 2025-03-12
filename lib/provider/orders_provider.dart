// lib/providers/orders_provider.dart
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/services/statistic_service.dart';

class OrdersProvider with ChangeNotifier {
  // Order statistics
  Map<String, dynamic> _orderStats = {
    'totalOrders': 0,
    'completedOrders': 0,
    'overdueOrders': 0,
    'pendingOrders': 0,
    'cancelledOrders': 0,
    'awaitingConfirmation': 0,
  };

  Map<String, dynamic> get orderStats => _orderStats;

  // Stream subscription
  StreamSubscription<Map<String, dynamic>>? _orderStatsSubscription;

  OrdersProvider() {
    _initializeOrderStats();
  }

  Future<void> _initializeOrderStats() async {
    // Fetch initial data
    try {
      _orderStats = await FirebaseService.getOrderStatistics();
      notifyListeners();

      // Setup stream for real-time updates
      _orderStatsSubscription = FirebaseService.orderStatisticsStream().listen((stats) {
        _orderStats = stats;
        notifyListeners();
      });
    } catch (e) {
      print('Error initializing order stats: $e');
    }
  }

  // Add a new order
  Future<void> addOrder(String status) async {
    try {
      // Update statistics based on status
      final stats = Map<String, dynamic>.from(_orderStats);
      stats['totalOrders'] = (stats['totalOrders'] ?? 0) + 1;

      switch (status) {
        case 'completed':
          stats['completedOrders'] = (stats['completedOrders'] ?? 0) + 1;
          break;
        case 'overdue':
          stats['overdueOrders'] = (stats['overdueOrders'] ?? 0) + 1;
          break;
        case 'pending':
          stats['pendingOrders'] = (stats['pendingOrders'] ?? 0) + 1;
          break;
        case 'cancelled':
          stats['cancelledOrders'] = (stats['cancelledOrders'] ?? 0) + 1;
          break;
        case 'awaiting':
          stats['awaitingConfirmation'] = (stats['awaitingConfirmation'] ?? 0) + 1;
          break;
      }

      // Update in Firebase
      await FirebaseService.updateOrderStatistics(stats);
    } catch (e) {
      print('Error adding order: $e');
      throw e;
    }
  }

  // Update an existing order's status
  Future<void> updateOrderStatus(String oldStatus, String newStatus) async {
    try {
      final stats = Map<String, dynamic>.from(_orderStats);

      // Decrement old status count
      switch (oldStatus) {
        case 'completed':
          stats['completedOrders'] = (stats['completedOrders'] ?? 1) - 1;
          break;
        case 'overdue':
          stats['overdueOrders'] = (stats['overdueOrders'] ?? 1) - 1;
          break;
        case 'pending':
          stats['pendingOrders'] = (stats['pendingOrders'] ?? 1) - 1;
          break;
        case 'cancelled':
          stats['cancelledOrders'] = (stats['cancelledOrders'] ?? 1) - 1;
          break;
        case 'awaiting':
          stats['awaitingConfirmation'] = (stats['awaitingConfirmation'] ?? 1) - 1;
          break;
      }

      // Increment new status count
      switch (newStatus) {
        case 'completed':
          stats['completedOrders'] = (stats['completedOrders'] ?? 0) + 1;
          break;
        case 'overdue':
          stats['overdueOrders'] = (stats['overdueOrders'] ?? 0) + 1;
          break;
        case 'pending':
          stats['pendingOrders'] = (stats['pendingOrders'] ?? 0) + 1;
          break;
        case 'cancelled':
          stats['cancelledOrders'] = (stats['cancelledOrders'] ?? 0) + 1;
          break;
        case 'awaiting':
          stats['awaitingConfirmation'] = (stats['awaitingConfirmation'] ?? 0) + 1;
          break;
      }

      // Update in Firebase
      await FirebaseService.updateOrderStatistics(stats);
    } catch (e) {
      print('Error updating order status: $e');
      throw e;
    }
  }

  // Manually set stats (useful for testing or admin operations)
  Future<void> setOrderStats(Map<String, dynamic> stats) async {
    try {
      await FirebaseService.updateOrderStatistics(stats);
    } catch (e) {
      print('Error setting order stats: $e');
      throw e;
    }
  }

  @override
  void dispose() {
    _orderStatsSubscription?.cancel();
    super.dispose();
  }
}