import 'package:flutter/material.dart';
import 'package:myapp/models/product_and_store_model.dart';
import 'package:uuid/uuid.dart';

class StoreProvider with ChangeNotifier {
  final List<Store> _stores = [];

  //Getter to access the private _stores list. Returns a List of Store.
  List<Store> get stores => _stores;

  // getter to get all products from all stores
  List<Product> get allProducts {
    return _stores.expand((store) => store.products).toList();
  }

  // function to add a new store to storesList
  void addNewStore(String storeName, BuildContext context) {
    final newStore = Store(id: Uuid().v4(), storeName: storeName);
    _stores.add(newStore);
    notifyListeners();

    /*Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StorePage(storeId: newStore.id)),
    );*/
  }

  void addProductToStore(String storeId, Product product) {
    //_stores list to find the first store that matches a given storeId
    final store = _stores.firstWhere((s) => s.id == storeId);
    store.products.add(product);
    notifyListeners();
  }

  Store getStoreById(String storeId) {
    return _stores.firstWhere((store) => store.id == storeId);
  }

  /*void UpdateProductQuantity(String prodId, int newQuantity) {
    for (var store in _stores) {
      var product = store.products.firstWhere((p) => p.id == prodId);

      if (product.id.isNotEmpty) {
        product.quantity = newQuantity;
        notifyListeners();
        break;
      }
    }
  }*/

  void updateProduct(String productId, String newName, double newPrice,
      String newImage, String newDescription) {
    for (var store in _stores) {
      var product = store.products.firstWhere(
        (p) => p.id == productId,
      );

      if (product.id.isNotEmpty) {
        product.prodname = newName;
        product.prodprice = newPrice;
        product.image = newImage;
        product.description = newDescription;
        //product.quantity = newQuantity;

        notifyListeners();
        break;
      }
    }
  }

  void deleteProduct(String productId) {
    for (var store in _stores) {
      store.products.removeWhere((product) => product.id == productId);
    }
    notifyListeners();
  }

  void clearAllProductsInStore(String storeId) {
    final store = _stores.firstWhere((s) => s.id == storeId);
    store.products.clear();
    notifyListeners();
  }

  void renameStore(String storeId, String renamedText) {
    for (var store in _stores) {
      if (store.storeName == renamedText) {
        // Use a proper way to notify the user, such as logging
        print('Store name already exists');
        return;
      }
    }
    final store = _stores.firstWhere((s) => s.id == storeId);
    store.storeName = renamedText;
    notifyListeners();
  }

  void clearWholeStore(String storeId) {
    _stores.removeWhere((store) => store.id == storeId);
    notifyListeners();
  }
}
