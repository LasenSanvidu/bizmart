/*import 'package:flutter/material.dart';
import 'package:myapp/models/product_and_store_model.dart';

class InquiryProvider with ChangeNotifier {
  final List<Product> _inquiryList = [];

  List<Product> get inquiryList => _inquiryList;

  void addToInquiry(Product product) {
    if (!_inquiryList.contains(product)) {
      _inquiryList.add(product);
      notifyListeners();
    }
  }

  void removeFromInquiry(Product product) {
    if (_inquiryList.contains(product)) {
      _inquiryList.remove(product);
      notifyListeners();
    }
  }

  void clearAllInquiry() {
    _inquiryList.clear();
    notifyListeners();
  }
}*/
//
//
///
//
//
//
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/product_and_store_model.dart';
import 'package:uuid/uuid.dart';

class InquiryProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final List<Product> _inquiryList = [];
  final List<UserInquiry> _receivedInquiries = [];

  String? get currentUserId => _auth.currentUser?.uid;
  String get currentUserName =>
      _auth.currentUser?.displayName ?? 'Anonymous User';

  List<Product> get inquiryList => _inquiryList;
  List<UserInquiry> get receivedInquiries => _receivedInquiries;

  Future<void> fetchMyInquiries() async {
    if (currentUserId == null) return;

    try {
      final querySnapshot = await _firestore
          .collection('user_inquiries')
          .where('inquirerUserId', isEqualTo: currentUserId)
          .get();

      _inquiryList.clear();

      for (var doc in querySnapshot.docs) {
        // Fetch the product details for each inquiry
        final productDoc =
            await _firestore.collection('products').doc(doc['productId']).get();

        if (productDoc.exists) {
          final productData = productDoc.data()!;
          _inquiryList.add(Product(
            id: productData['id'],
            prodname: productData['prodname'],
            image: productData['image'],
            prodprice: productData['prodprice'].toDouble(),
            description: productData['description'],
          ));
        }
      }
      notifyListeners();
    } catch (e) {
      print("Error fetching inquiries: $e");
    }
  }

  Future<void> fetchReceivedInquiries() async {
    if (currentUserId == null) return;

    try {
      final querySnapshot = await _firestore
          .collection('user_inquiries')
          .where('productOwnerId', isEqualTo: currentUserId)
          .orderBy('createdAt', descending: true)
          .get();

      _receivedInquiries.clear();

      for (var doc in querySnapshot.docs) {
        _receivedInquiries.add(UserInquiry.fromMap(doc.data()));
      }
      notifyListeners();
    } catch (e) {
      print("Error fetching received inquiries: $e");
    }
  }

  Future<void> addToInquiry(Product product, String productOwnerId) async {
    if (currentUserId == null) return;

    print("Adding inquiry with product owner ID: $productOwnerId"); // Debug log
    print("Current user ID (inquirer): $currentUserId");

    try {
      // Check if this inquiry already exists
      final existingInquiry = await _firestore
          .collection('user_inquiries')
          .where('productId', isEqualTo: product.id)
          .where('inquirerUserId', isEqualTo: currentUserId)
          .get();

      if (existingInquiry.docs.isNotEmpty) {
        // Inquiry already exists, no need to add again
        if (!_inquiryList.any((p) => p.id == product.id)) {
          _inquiryList.add(product);
          notifyListeners();
        }
        return;
      }

      // Create new inquiry
      final inquiryId = Uuid().v4();
      final inquiry = UserInquiry(
        id: inquiryId,
        productId: product.id,
        productOwnerId: productOwnerId,
        inquirerUserId: currentUserId!,
        inquirerName: currentUserName,
        createdAt: DateTime.now(),
      );

      // Save to Firestore
      await _firestore
          .collection('user_inquiries')
          .doc(inquiryId)
          .set(inquiry.toMap());

      print("Inquiry saved with ID: $inquiryId");

      // Add to local list if not already there
      if (!_inquiryList.any((p) => p.id == product.id)) {
        _inquiryList.add(product);
        notifyListeners();
      }
    } catch (e) {
      print("Error adding to inquiry: $e");
    }
  }

  Future<void> removeFromInquiry(Product product) async {
    if (currentUserId == null) return;

    try {
      // Find and delete the inquiry from Firestore
      final querySnapshot = await _firestore
          .collection('user_inquiries')
          .where('productId', isEqualTo: product.id)
          .where('inquirerUserId', isEqualTo: currentUserId)
          .get();

      for (var doc in querySnapshot.docs) {
        await _firestore.collection('user_inquiries').doc(doc.id).delete();
      }

      // Remove from local list
      _inquiryList.removeWhere((p) => p.id == product.id);
      notifyListeners();
    } catch (e) {
      print("Error removing from inquiry: $e");
    }
  }

  Future<void> clearAllInquiry() async {
    if (currentUserId == null) return;

    try {
      // Delete all inquiries for this user from Firestore
      final querySnapshot = await _firestore
          .collection('user_inquiries')
          .where('inquirerUserId', isEqualTo: currentUserId)
          .get();

      for (var doc in querySnapshot.docs) {
        await _firestore.collection('user_inquiries').doc(doc.id).delete();
      }

      // Clear local list
      _inquiryList.clear();
      notifyListeners();
    } catch (e) {
      print("Error clearing all inquiries: $e");
    }
  }

  Future<void> markInquiryAsViewed(String inquiryId) async {
    try {
      await _firestore
          .collection('user_inquiries')
          .doc(inquiryId)
          .update({'isViewed': true});

      // Update local list
      final index = _receivedInquiries.indexWhere((i) => i.id == inquiryId);
      if (index != -1) {
        final updated = UserInquiry(
          id: _receivedInquiries[index].id,
          productId: _receivedInquiries[index].productId,
          productOwnerId: _receivedInquiries[index].productOwnerId,
          inquirerUserId: _receivedInquiries[index].inquirerUserId,
          inquirerName: _receivedInquiries[index].inquirerName,
          createdAt: _receivedInquiries[index].createdAt,
          isViewed: true,
        );
        _receivedInquiries[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      print("Error marking inquiry as viewed: $e");
    }
  }
}
