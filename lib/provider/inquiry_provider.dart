import 'package:flutter/material.dart';
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
}
