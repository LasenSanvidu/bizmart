// // lib/blocs/product_bloc.dart
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:myapp/services/Database%20Service.dart';
// import '../models/product.dart';

// // Events
// abstract class ProductEvent {}

// class LoadProductsEvent extends ProductEvent {}
// class AddProductEvent extends ProductEvent {
//   final Product product;
//   AddProductEvent(this.product);
// }
// class UpdateProductEvent extends ProductEvent {
//   final String id;
//   final Map<String, dynamic> newData;
//   UpdateProductEvent(this.id, this.newData);
// }
// class DeleteProductEvent extends ProductEvent {
//   final String id;
//   DeleteProductEvent(this.id);
// }

// // States
// abstract class ProductState {}

// class ProductInitial extends ProductState {}
// class ProductLoading extends ProductState {}
// class ProductsLoaded extends ProductState {
//   final List<Product> products;
//   ProductsLoaded(this.products);
// }
// class ProductError extends ProductState {
//   final String message;
//   ProductError(this.message);
// }

// // BLoC
// class ProductBloc extends Bloc<ProductEvent, ProductState> {
//   final DatabaseService _databaseService;

//   ProductBloc({required DatabaseService databaseService})
//       : _databaseService = databaseService,
//         super(ProductInitial()) {
//     on<LoadProductsEvent>(_onLoadProducts);
//     on<AddProductEvent>(_onAddProduct);
//     on<UpdateProductEvent>(_onUpdateProduct);
//     on<DeleteProductEvent>(_onDeleteProduct);
//   }

//   Future<void> _onLoadProducts(
//       LoadProductsEvent event, Emitter<ProductState> emit) async {
//     emit(ProductLoading());
//     try {
//       final products = await _databaseService.getProducts();
//       emit(ProductsLoaded(products.cast<Product>()));
//     } catch (e) {
//       emit(ProductError("Failed to load products: $e"));
//     }
//   }

//   Future<void> _onAddProduct(
//       AddProductEvent event, Emitter<ProductState> emit) async {
//     try {
//       await _databaseService.addProduct(event.product.toMap());
//       add(LoadProductsEvent()); // Refresh the list
//     } catch (e) {
//       emit(ProductError("Failed to add product: $e"));
//     }
//   }

//   Future<void> _onUpdateProduct(
//       UpdateProductEvent event, Emitter<ProductState> emit) async {
//     try {
//       await _databaseService.updateProduct(event.id, event.newData);
//       add(LoadProductsEvent()); // Refresh the list
//     } catch (e) {
//       emit(ProductError("Failed to update product: $e"));
//     }
//   }

//   Future<void> _onDeleteProduct(
//       DeleteProductEvent event, Emitter<ProductState> emit) async {
//     try {
//       await _databaseService.deleteProduct(event.id);
//       add(LoadProductsEvent()); // Refresh the list
//     } catch (e) {
//       emit(ProductError("Failed to delete product: $e"));
//     }
//   }
// }