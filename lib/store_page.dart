import 'package:flutter/material.dart';
import 'package:myapp/models/product_and_store_model.dart';
import 'package:myapp/product_details.dart';
import 'package:myapp/provider/store_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class StorePage extends StatelessWidget {
  final String storeId;

  StorePage({required this.storeId});

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);
    final store = storeProvider.getStoreById(storeId);

    return Scaffold(
      appBar: AppBar(title: Text(store.storeName)),
      body: Column(
        children: [
          Text("Store ID: $storeId"),
          ElevatedButton(
            onPressed: () => _showAddProductDialog(context, storeProvider),
            child: Text("Add Product"),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: store.products.length,
              itemBuilder: (context, index) {
                final product = store.products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsPage(product: product),
                        ));
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(10)),
                            child: Image.network(
                              product.image,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                Icons.broken_image,
                                size: 50,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product.prodname,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '\$${product.prodprice.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.green),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog(
      BuildContext context, StoreProvider storeProvider) {
    final TextEditingController _productNameController =
        TextEditingController();
    final TextEditingController _productPriceController =
        TextEditingController();
    final TextEditingController _productImageController =
        TextEditingController();
    final TextEditingController _productDescripController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Product"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: _productNameController,
                  decoration: InputDecoration(labelText: "Product Name")),
              TextField(
                  controller: _productPriceController,
                  decoration: InputDecoration(labelText: "Price"),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: _productImageController,
                  decoration: InputDecoration(labelText: "Image URL")),
              TextField(
                  controller: _productDescripController,
                  decoration: InputDecoration(labelText: "Description")),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_productNameController.text.isNotEmpty &&
                    _productPriceController.text.isNotEmpty) {
                  final product = Product(
                    id: Uuid().v4(),
                    prodname: _productNameController.text,
                    prodprice: double.parse(_productPriceController.text),
                    image: _productImageController.text.isNotEmpty
                        ? _productImageController.text
                        : "https://via.placeholder.com/150",
                    description: _productDescripController.text.isNotEmpty
                        ? _productDescripController.text
                        : "No Description",
                  );
                  storeProvider.addProductToStore(storeId, product);
                  Navigator.pop(context);
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
