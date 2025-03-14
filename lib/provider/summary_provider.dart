import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SummaryProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int totalProducts = 0;
  int totalInquiries = 0;
  int viewedInquiries = 0;
  int newInquiries = 0;

  // get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  //fetch all stats for cuerrent user
  Future<void> fetchStats() async {
    if (currentUserId == null) return;

    await Future.wait([
      _fetchProductStats(),
      _fetchInquiryStats(),
    ]);

    notifyListeners();
  }

  //fetch product Statistics
  Future<void> _fetchProductStats() async {
    try {
      final productsQuery = await _firestore
          .collection('stores')
          .where('userId', isEqualTo: currentUserId)
          .get();

      totalProducts = 0;

      for (var storeDoc in productsQuery.docs) {
        if (storeDoc.data().containsKey('products')) {
          final products = storeDoc.data()['products'] as List;
          totalProducts += products.length;
        }
      }
    } catch (e) {
      print("Error fetching product stats: $e");
    }
  }

  //fetch Inquiry Statistics
  Future<void> _fetchInquiryStats() async {
    try {
      // get all inquiries for
      final InquiriesQuery = await _firestore
          .collection('user_inquiries')
          .where('productOwnerId', isEqualTo: currentUserId)
          .get();

      totalInquiries = InquiriesQuery.docs.length;

      viewedInquiries = InquiriesQuery.docs
          .where((doc) => doc.data()['isViewed'] == true)
          .length;

      newInquiries = totalInquiries - viewedInquiries;
    } catch (e) {
      print("Error fetching inquiry stats: $e");
    }
  }

  //precentage of viewed inquiries
  double get viewedInquiriesPercentage {
    if (totalInquiries == 0) return 0.0;
    return (viewedInquiries / totalInquiries) * 100;
  }

  //precentage of new inquiries
  double get newInquiriesPercentage {
    if (totalInquiries == 0) return 0.0;
    return (newInquiries / totalInquiries) * 100;
  }
}
