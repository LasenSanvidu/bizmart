import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:myapp/models/review_model.dart';

class ReviewProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<Review> _reviews = [];

  List<Review> get reviews => _reviews;

  Future<void> fetchReviews() async {
    try {
      final querySnapshot = await _firestore.collection('reviews').get();
      _reviews.clear();
      for (var doc in querySnapshot.docs) {
        _reviews.add(Review(
          id: doc.id,
          productId: doc['productId'],
          reviewerName: doc['reviewerName'],
          reviewText: doc['reviewText'],
          rating: doc['rating'].toDouble(),
        ));
      }
      notifyListeners();
    } catch (e) {
      print("Error fetching reviews: $e");
    }
  }

  List<Review> getReviewsForProduct(String productId) {
    return _reviews.where((review) => review.productId == productId).toList();
  }

  Future<void> addReview(String productId, String reviewerName, String comment,
      double rating) async {
    final newReview = Review(
      id: Uuid().v4(),
      productId: productId,
      reviewerName: reviewerName,
      reviewText: comment,
      rating: rating,
    );

    _reviews.add(newReview);

    await _firestore.collection('reviews').doc(newReview.id).set({
      'productId': productId,
      'reviewerName': reviewerName,
      'reviewText': comment,
      'rating': rating,
    });

    notifyListeners();
  }
}
