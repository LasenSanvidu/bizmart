import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/product_and_store_model.dart';
import 'package:uuid/uuid.dart';

class StoreProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final List<Store> _stores = [];

  List<Store> get stores => _stores;

  String? get currentUserId => _auth.currentUser?.uid;

  Future<void> fetchStores() async {
    try {
      if (currentUserId == null) {
        print("No user logged in");
        return;
      }
      final querySnapshot = await _firestore
          .collection('stores')
          .where('userId', isEqualTo: currentUserId)
          .get();
      _stores.clear();
      for (var doc in querySnapshot.docs) {
        List<Product> products = [];

        if (doc.data().containsKey('products') && doc['products'] is List) {
          products = (doc['products'] as List).map((prod) {
            return Product(
              id: prod['id'],
              prodname: prod['prodname'],
              image: prod['image'],
              prodprice: prod['prodprice'].toDouble(),
              description: prod['description'],
            );
          }).toList();
        }

        _stores.add(Store(
          id: doc.id,
          storeName: doc['storeName'],
          products: products,
          bannerImage: doc['bannerImage'] ?? '', // Add this line
        ));
      }
      notifyListeners();
    } catch (e) {
      print("Error fetching stores: $e");
    }
  }

  //method to update the store banner image
  Future<void> updateStoreBanner(String storeId, String bannerImage) async {
    final store = _stores.firstWhere((s) => s.id == storeId);
    store.bannerImage = bannerImage;
    await _firestore.collection('stores').doc(storeId).update({
      'bannerImage': bannerImage,
    });
    notifyListeners();
  }

  //a getter to get all products from all stores
  List<Product> get allProducts {
    return _stores.isNotEmpty
        ? _stores.expand((store) => store.products).toList()
        : [];
  }

  Future<void> addNewStore(String storeName) async {
    if (currentUserId == null) {
      print("No user logged in");
      return;
    }
    final newStore = Store(id: Uuid().v4(), storeName: storeName);
    _stores.add(newStore);
    await _firestore.collection('stores').doc(newStore.id).set({
      'storeName': newStore.storeName,
      'products': [],
      'userId': currentUserId,
      'bannerImage': '',
    });
    notifyListeners();
  }

  // In StoreProvider, update the addProductToStore method
  Future<void> addProductToStore(String storeId, Product product) async {
    final store = _stores.firstWhere((s) => s.id == storeId);
    store.products.add(product);

    await _firestore.collection('stores').doc(storeId).update({
      'products': store.products
          .map((p) => {
                'id': p.id,
                'prodname': p.prodname,
                'image': p.image,
                'prodprice': p.prodprice,
                'description': p.description,
                'ownerId': currentUserId, // Add this line
              })
          .toList()
    });

    // Also add to products collection for easier querying
    await _firestore.collection('products').doc(product.id).set({
      'id': product.id,
      'prodname': product.prodname,
      'image': product.image,
      'prodprice': product.prodprice,
      'description': product.description,
      'ownerId': currentUserId,
      'storeId': storeId,
    });

    notifyListeners();
  }

  Store getStoreById(String storeId) {
    return _stores.firstWhere((store) => store.id == storeId);
  }

  Future<void> updateProduct(String productId, String newName, double newPrice,
      String newImage, String newDescription) async {
    for (var store in _stores) {
      var productIndex = store.products.indexWhere((p) => p.id == productId);
      if (productIndex != -1) {
        store.products[productIndex] = Product(
          id: productId,
          prodname: newName,
          prodprice: newPrice,
          image: newImage,
          description: newDescription,
        );
        await _firestore.collection('stores').doc(store.id).update({
          'products': store.products
              .map((p) => {
                    'id': p.id,
                    'prodname': p.prodname,
                    'image': p.image,
                    'prodprice': p.prodprice,
                    'description': p.description,
                  })
              .toList()
        });

        // Also needs to update the product in the products collection as well
        await _firestore.collection('products').doc(productId).update({
          'prodname': newName,
          'prodprice': newPrice,
          'image': newImage,
          'description': newDescription,
        });
        notifyListeners();
        break;
      }
    }
  }

  Future<void> deleteAllReviewsForAProduct(String productId) async {
    final reviewsSnapshot = await _firestore
        .collection('reviews')
        .where('productId', isEqualTo: productId)
        .get();

    for (var doc in reviewsSnapshot.docs) {
      await _firestore.collection('reviews').doc(doc.id).delete();
    }
  }

  Future<void> deleteProductsAndReviews(List<String> productIds) async {
    for (var productId in productIds) {
      await _firestore.collection('products').doc(productId).delete();

      // Delete all reviews for the specific product
      deleteAllReviewsForAProduct(productId);
    }
  }

  Future<void> deleteProduct(String productId) async {
    for (var store in _stores) {
      store.products.removeWhere((product) => product.id == productId);
      await _firestore.collection('stores').doc(store.id).update({
        'products': store.products
            .map((p) => {
                  'id': p.id,
                  'prodname': p.prodname,
                  'image': p.image,
                  'prodprice': p.prodprice,
                  'description': p.description,
                })
            .toList()
      });
    }

    // Delete the product from products collection also
    await _firestore.collection('products').doc(productId).delete();

    // Delete all reviews for this product
    deleteAllReviewsForAProduct(productId);

    notifyListeners();
  }

  /*Future<void> clearAllProductsInStore(String storeId) async {
    final store = _stores.firstWhere((s) => s.id == storeId);
    store.products.clear();
    await _firestore.collection('stores').doc(storeId).update({'products': []});
    notifyListeners();
  }*/

  Future<void> clearAllProductsInStore(String storeId) async {
    final store = _stores.firstWhere((s) => s.id == storeId);
    // Get all product IDs before clearing them
    final productIds = store.products.map((product) => product.id).toList();
    store.products.clear();
    await _firestore.collection('stores').doc(storeId).update({'products': []});
    deleteProductsAndReviews(productIds);
    notifyListeners();
  }

  Future<void> renameStore(String storeId, String renamedText) async {
    for (var store in _stores) {
      if (store.storeName == renamedText) {
        print('Store name already exists');
        return;
      }
    }
    final store = _stores.firstWhere((s) => s.id == storeId);
    store.storeName = renamedText;
    await _firestore
        .collection('stores')
        .doc(storeId)
        .update({'storeName': renamedText});
    notifyListeners();
  }

  Future<void> clearWholeStore(String storeId) async {
    // Get all products in the store before deleting it
    final store = _stores.firstWhere((store) => store.id == storeId);
    final productIds = store.products.map((product) => product.id).toList();

    // Delete the store
    _stores.removeWhere((store) => store.id == storeId);
    await _firestore.collection('stores').doc(storeId).delete();

    // Delete all products in the products collection that was in the store
    deleteProductsAndReviews(productIds);

    notifyListeners();
  }
}
