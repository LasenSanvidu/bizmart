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
