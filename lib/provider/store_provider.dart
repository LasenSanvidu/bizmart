import 'package:flutter/material.dart';
import 'package:myapp/models/product_and_store_model.dart';
import 'package:myapp/store_page.dart';

import 'package:uuid/uuid.dart';

class StoreProvider with ChangeNotifier {
  final List<Store> _stores = [];

  //Getter to access the private _stores list. Returns a List of Store.
  List<Store> get stores => _stores;

  // function to add a new store to storesList
  void addNewStore(String storeName, BuildContext context) {
    final newStore = Store(id: Uuid().v4(), storeName: storeName);
    _stores.add(newStore);
    notifyListeners();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StorePage(storeId: newStore.id)),
    );
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
}
