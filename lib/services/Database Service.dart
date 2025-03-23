// // lib/services/database_service.dart
// import 'package:cloud_firestore/cloud_firestore.dart';

// class DatabaseService {
//   final FirebaseFirestore _firestore;

//   DatabaseService({FirebaseFirestore? firestore})
//       : _firestore = firestore ?? FirebaseFirestore.instance;

//   // Create operations
//   Future<void> addProduct(Map<String, dynamic> productData) async {
//     try {
//       await _firestore.collection('products').add(productData);
//     } catch (e) {
//       print('Error adding product: $e');
//       rethrow;
//     }
//   }

//   // Read operations
//   Future<List<Map<String, dynamic>>> getProducts() async {
//     try {
//       QuerySnapshot<Map<String, dynamic>> snapshot = 
//           await _firestore.collection('products').get();
//       return snapshot.docs
//           .map((doc) => {
//                 'id': doc.id,
//                 ...doc.data(),
//               })
//           .toList();
//     } catch (e) {
//       print('Error fetching products: $e');
//       return [];
//     }
//   }

//   // Update operations
//   Future<void> updateProduct(String productId, Map<String, dynamic> newData) async {
//     try {
//       await _firestore.collection('products').doc(productId).update(newData);
//     } catch (e) {
//       print('Error updating product: $e');
//       rethrow;
//     }
//   }

//   // Delete operations
//   Future<void> deleteProduct(String productId) async {
//     try {
//       await _firestore.collection('products').doc(productId).delete();
//     } catch (e) {
//       print('Error deleting product: $e');
//       rethrow;
//     }
//   }
// }