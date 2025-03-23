// // test/blocs/product_bloc_test.dart
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:mockito/annotations.dart';
// import 'package:bloc_test/bloc_test.dart';
// import 'package:myapp/bloc/product_bloc.dart';
// import 'package:myapp/models/product.dart';
// import 'package:myapp/services/Database%20Service.dart';

// import 'product_bloc_test.mocks.dart';

// @GenerateMocks([DatabaseService])


// void main() {
//   late ProductBloc productBloc;
//   late MockDatabaseService mockDatabaseService;

//   setUp(() {
//     mockDatabaseService = MockDatabaseService();
//     productBloc = ProductBloc(databaseService: mockDatabaseService);
//   });

//   tearDown(() {
//     productBloc.close();
//   });

//   test('initial state should be ProductInitial', () {
//     expect(productBloc.state, isA<ProductInitial>());
//   });

//   group('LoadProductsEvent', () {
//     final List<Map<String, dynamic>> testProductMaps = [
//       {'id': '1', 'name': 'Test Product 1', 'price': 19.99, 'description': 'Description 1'},
//       {'id': '2', 'name': 'Test Product 2', 'price': 29.99, 'description': 'Description 2'},
//     ];

//     blocTest<ProductBloc, ProductState>(
//       'emits [ProductLoading, ProductsLoaded] when products are loaded successfully',
//       build: () {
//         when(mockDatabaseService.getProducts())
//             .thenAnswer((_) async => testProductMaps);
//         return productBloc;
//       },
//       act: (bloc) => bloc.add(LoadProductsEvent()),
//       expect: () => [
//         isA<ProductLoading>(),
//         isA<ProductsLoaded>(),
//       ],
//       verify: (_) {
//         verify(mockDatabaseService.getProducts()).called(1);
//       },
//     );

//     blocTest<ProductBloc, ProductState>(
//       'emits [ProductLoading, ProductError] when loading products fails',
//       build: () {
//         when(mockDatabaseService.getProducts())
//             .thenThrow(Exception('Network error'));
//         return productBloc;
//       },
//       act: (bloc) => bloc.add(LoadProductsEvent()),
//       expect: () => [
//         isA<ProductLoading>(),
//         isA<ProductError>(),
//       ],
//     );
//   });

//   group('AddProductEvent', () {
//     final testProduct = Product(
//       name: 'New Product',
//       price: 49.99,
//       description: 'A new test product',
//     );

//     blocTest<ProductBloc, ProductState>(
//       'calls addProduct and then loads products when AddProductEvent is added',
//       build: () {
//         // Set up all mock behaviors before the bloc is used
//         when(mockDatabaseService.addProduct(any))
//             .thenAnswer((_) async => {});
//         when(mockDatabaseService.getProducts())
//             .thenAnswer((_) async => []);
//         return productBloc;
//       },
//       act: (bloc) => bloc.add(AddProductEvent(testProduct)),
//       expect: () => [
//         isA<ProductLoading>(),
//         isA<ProductsLoaded>(),
//       ],
//       verify: (_) {
//         verify(mockDatabaseService.addProduct(any)).called(1);
//         verify(mockDatabaseService.getProducts()).called(1);
//       },
//     );
//   });

//   group('UpdateProductEvent', () {
//     final String productId = 'prod1';
//     final Map<String, dynamic> newData = {
//       'name': 'Updated Product',
//       'price': 99.99,
//     };

//     blocTest<ProductBloc, ProductState>(
//       'calls updateProduct and then loads products when UpdateProductEvent is added',
//       build: () {
//         when(mockDatabaseService.updateProduct(productId, newData))
//             .thenAnswer((_) async => {});
//         when(mockDatabaseService.getProducts())
//             .thenAnswer((_) async => []);
//         return productBloc;
//       },
//       act: (bloc) => bloc.add(UpdateProductEvent(productId, newData)),
//       expect: () => [
//         isA<ProductLoading>(),
//         isA<ProductsLoaded>(),
//       ],
//       verify: (_) {
//         verify(mockDatabaseService.updateProduct(productId, newData)).called(1);
//         verify(mockDatabaseService.getProducts()).called(1);
//       },
//     );
//   });

//   group('DeleteProductEvent', () {
//     final String productId = 'prod1';

//     blocTest<ProductBloc, ProductState>(
//       'calls deleteProduct and then loads products when DeleteProductEvent is added',
//       build: () {
//         when(mockDatabaseService.deleteProduct(productId))
//             .thenAnswer((_) async => {});
//         when(mockDatabaseService.getProducts())
//             .thenAnswer((_) async => []);
//         return productBloc;
//       },
//       act: (bloc) => bloc.add(DeleteProductEvent(productId)),
//       expect: () => [
//         isA<ProductLoading>(),
//         isA<ProductsLoaded>(),
//       ],
//       verify: (_) {
//         verify(mockDatabaseService.deleteProduct(productId)).called(1);
//         verify(mockDatabaseService.getProducts()).called(1);
//       },
//     );
//   });
// }