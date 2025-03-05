import 'package:flutter/material.dart';
import 'package:myapp/models/review_model.dart';
import 'package:uuid/uuid.dart';

class ReviewProvider with ChangeNotifier {
  final List<Review> _reviews = [];

  List<Review> get reviews => _reviews;

  List<Review> getReviewsForProduct(String productId) {
    return _reviews.where((review) => review.productId == productId).toList();
  }

  void addReview(
      String productId, String reviewerName, String comment, double rating) {
    final newReview = Review(
      id: Uuid().v4(),
      productId: productId,
      reviewerName: reviewerName,
      reviewText: comment,
      rating: rating,
    );
    _reviews.add(newReview);
    notifyListeners();
  }
}
