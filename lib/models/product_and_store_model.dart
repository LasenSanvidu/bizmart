/*// class for store
class Store {
  String id;
  String storeName;
  List<Product> products; // list of Products to store

  Store({required this.id, required this.storeName, List<Product>? products})
      : products = products ?? [];
}

// class for products
class Product {
  String id;
  String prodname;
  String image;
  double prodprice;
  String description;

  Product(
      {required this.id,
      required this.prodname,
      required this.image,
      required this.prodprice,
      required this.description});
}*/

import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  String id;
  String storeName;
  List<Product> products; // list of Products to store
  String userId; // Add userId field

  Store({
    required this.id,
    required this.storeName,
    List<Product>? products,
    this.userId = '', // Default empty string for backward compatibility
  }) : products = products ?? [];
}

// Product class remains the same
class Product {
  String id;
  String prodname;
  String image;
  double prodprice;
  String description;

  Product(
      {required this.id,
      required this.prodname,
      required this.image,
      required this.prodprice,
      required this.description});
}

// new one for inquiry shit
class UserInquiry {
  final String id;
  final String productId;
  final String productOwnerId;
  final String inquirerUserId;
  final String inquirerName;
  final DateTime createdAt;
  final bool isViewed;

  UserInquiry({
    required this.id,
    required this.productId,
    required this.productOwnerId,
    required this.inquirerUserId,
    required this.inquirerName,
    required this.createdAt,
    this.isViewed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productOwnerId': productOwnerId,
      'inquirerUserId': inquirerUserId,
      'inquirerName': inquirerName,
      'createdAt': createdAt,
      'isViewed': isViewed,
    };
  }

  factory UserInquiry.fromMap(Map<String, dynamic> map) {
    return UserInquiry(
      id: map['id'],
      productId: map['productId'],
      productOwnerId: map['productOwnerId'],
      inquirerUserId: map['inquirerUserId'],
      inquirerName: map['inquirerName'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isViewed: map['isViewed'] ?? false,
    );
  }
}
