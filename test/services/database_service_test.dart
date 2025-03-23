// // test/services/database_service_test.dart
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:myapp/services/Database%20Service.dart';
// import '../mocks/mock_firebase.mocks.dart';


// void main() {
//   late MockFirebaseFirestore mockFirestore;
//   late MockCollectionReference<Map<String, dynamic>> mockCollectionRef;
//   late MockDocumentReference<Map<String, dynamic>> mockDocRef;
//   late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
//   late List<MockQueryDocumentSnapshot<Map<String, dynamic>>> mockDocList;
//   late DatabaseService databaseService;

//   setUp(() {
//     mockFirestore = MockFirebaseFirestore();
//     mockCollectionRef = MockCollectionReference<Map<String, dynamic>>();
//     mockDocRef = MockDocumentReference<Map<String, dynamic>>();
//     mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
    
//     databaseService = DatabaseService(firestore: mockFirestore);
//   });

//   group('DatabaseService - CRUD Operations Tests', () {
//     // CREATE operation test
//     test('addProduct should add a product to the database', () async {
//       final productData = {
//         'name': 'Test Product',
//         'price': 99.99,
//         'description': 'Test description'
//       };

//       when(mockFirestore.collection('products'))
//           .thenReturn(mockCollectionRef);
//       when(mockCollectionRef.add(productData))
//           .thenAnswer((_) async => mockDocRef);

//       await databaseService.addProduct(productData);

//       verify(mockCollectionRef.add(productData)).called(1);
//     });

//     // READ operation test
//     test('getProducts should return a list of products', () async {
//       // Create mock documents
//       final mockDocSnap1 = MockQueryDocumentSnapshot<Map<String, dynamic>>();
//       final mockDocSnap2 = MockQueryDocumentSnapshot<Map<String, dynamic>>();
//       mockDocList = [mockDocSnap1, mockDocSnap2];

//       // Setup the data for first document
//       when(mockDocSnap1.id).thenReturn('doc1');
//       when(mockDocSnap1.data()).thenReturn({
//         'name': 'Product 1',
//         'price': 19.99,
//       });

//       // Setup the data for second document
//       when(mockDocSnap2.id).thenReturn('doc2');
//       when(mockDocSnap2.data()).thenReturn({
//         'name': 'Product 2',
//         'price': 29.99,
//       });

//       // Setup the collection query and return
//       when(mockFirestore.collection('products'))
//           .thenReturn(mockCollectionRef);
//       when(mockCollectionRef.get())
//           .thenAnswer((_) async => mockQuerySnapshot);
//       when(mockQuerySnapshot.docs).thenReturn(mockDocList);

//       final products = await databaseService.getProducts();

//       expect(products.length, 2);
//       expect(products[0]['id'], 'doc1');
//       expect(products[0]['name'], 'Product 1');
//       expect(products[1]['id'], 'doc2');
//       expect(products[1]['name'], 'Product 2');
//     });

//     // UPDATE operation test
//     test('updateProduct should update the specified product', () async {
//       final String productId = 'product123';
//       final Map<String, dynamic> newData = {
//         'name': 'Updated Product',
//         'price': 149.99,
//       };

//       when(mockFirestore.collection('products'))
//           .thenReturn(mockCollectionRef);
//       when(mockCollectionRef.doc(productId))
//           .thenReturn(mockDocRef);
//       when(mockDocRef.update(newData))
//           .thenAnswer((_) async => {});

//       await databaseService.updateProduct(productId, newData);

//       verify(mockDocRef.update(newData)).called(1);
//     });

//     // DELETE operation test
//     test('deleteProduct should delete the specified product', () async {
//       final String productId = 'product123';

//       when(mockFirestore.collection('products'))
//           .thenReturn(mockCollectionRef);
//       when(mockCollectionRef.doc(productId))
//           .thenReturn(mockDocRef);
//       when(mockDocRef.delete())
//           .thenAnswer((_) async => {});

//       await databaseService.deleteProduct(productId);

//       verify(mockDocRef.delete()).called(1);
//     });

//     // Error handling test
//     test('getProducts should return empty list on error', () async {
//       when(mockFirestore.collection('products'))
//           .thenReturn(mockCollectionRef);
//       when(mockCollectionRef.get())
//           .thenThrow(FirebaseException(plugin: 'firestore'));

//       final products = await databaseService.getProducts();

//       expect(products, isEmpty);
//     });
//   });
// }