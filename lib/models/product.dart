// // lib/models/product.dart
// class Product {
//   final String? id;
//   final String name;
//   final double price;
//   final String description;

//   Product({
//     this.id,
//     required this.name,
//     required this.price,
//     required this.description,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'price': price,
//       'description': description,
//     };
//   }

//   factory Product.fromMap(Map<String, dynamic> map) {
//     return Product(
//       id: map['id'],
//       name: map['name'],
//       price: map['price'] is int 
//           ? (map['price'] as int).toDouble() 
//           : map['price'],
//       description: map['description'] ?? '',
//     );
//   }
// }