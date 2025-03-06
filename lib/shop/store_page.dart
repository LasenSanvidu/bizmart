import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/component/button.dart';
import 'package:myapp/models/product_and_store_model.dart';
import 'package:myapp/shop/product_details_businessman.dart';
import 'package:myapp/provider/store_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class StorePage extends StatelessWidget {
  final String storeId;

  const StorePage({super.key, required this.storeId});

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);
    final store = storeProvider.getStoreById(storeId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true, // This property centers the title
        title: Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the title within the row
          children: [
            Expanded(
              child: Text(
                store.storeName,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 26, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (store.products.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'Clear all Products?',
                      style: GoogleFonts.poppins(fontSize: 23),
                    ),
                    actions: [
                      // no button
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'No',
                            style: TextStyle(fontSize: 16),
                          )),

                      //yes button
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          storeProvider.clearAllProductsInStore(storeId);
                        },
                        child: const Text(
                          'Yes',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    ],
                  ),
                );
              }
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _showAddProductDialog(context, storeProvider),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 184, 161, 249),
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              textStyle: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            child: Text(
              "Add Product",
              style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
            ),
          ),
          //SizedBox(height: 20),
          //Text("Store ID: $storeId"),
          Expanded(
            child: store.products.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/no-products-remove.png',
                          width: 220,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "No products available in this store.",
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: const Color.fromARGB(255, 187, 187, 187)),
                        ),
                        Text(
                          "please add a product",
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: const Color.fromARGB(255, 187, 187, 187)),
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  )
                : Column(children: [
                    SizedBox(height: 20),
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.all(8.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
                              color: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(10)),
                                      child: product.image.startsWith("http")
                                          ? Image.network(
                                              product.image,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  const Icon(
                                                Icons.broken_image,
                                                size: 50,
                                              ),
                                            )
                                          : Image.file(
                                              File(product.image),
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  const Icon(
                                                Icons.broken_image,
                                                size: 50,
                                              ),
                                            ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product.prodname,
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 17,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '\$${product.prodprice.toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: Text(
                                                    'Clear the Product?',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 23),
                                                  ),
                                                  actions: [
                                                    // no button
                                                    TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: const Text(
                                                          'No',
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        )),

                                                    //yes button
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        storeProvider
                                                            .deleteProduct(
                                                                product.id);
                                                      },
                                                      child: const Text(
                                                        'Yes',
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                            icon: const Icon(Icons.close,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ]),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog(
      BuildContext context, StoreProvider storeProvider) {
    final TextEditingController productNameController =
        TextEditingController();
    final TextEditingController productPriceController =
        TextEditingController();

    //final TextEditingController _productImageController =
    //  TextEditingController();

    final TextEditingController productDescripController =
        TextEditingController();
    File? selectedImage;
    final ImagePicker picker = ImagePicker();

    final TextEditingController productQuantityController =
        TextEditingController();

    Future<void> pickImage() async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text("Add Product"),
              content: SizedBox(
                width: 300,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                          controller: productNameController,
                          decoration:
                              InputDecoration(labelText: "Product Name")),
                      TextField(
                        controller: productPriceController,
                        decoration: InputDecoration(labelText: "Price"),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(
                              r'^\d+\.?\d{0,2}$')), // Allows only numbers and up to two decimal places
                        ],
                      ),

                      SizedBox(height: 10),

                      // Image Picker Button
                      selectedImage != null
                          ? Image.file(
                              selectedImage!,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                          : Text("No Image Selected"),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Background color
                        ),
                        onPressed: () async {
                          await pickImage();
                          setState(() {}); // Update UI after picking image
                        },
                        icon: Icon(Icons.image),
                        label: Text("Pick Image"),
                      ),

                      TextField(
                          controller: productDescripController,
                          decoration:
                              InputDecoration(labelText: "Description")),

                      TextField(
                          controller: productQuantityController,
                          decoration: InputDecoration(labelText: "Quantity"),
                          keyboardType: TextInputType.number),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (productNameController.text.isNotEmpty &&
                        productPriceController.text.isNotEmpty) {
                      final product = Product(
                        id: Uuid().v4(),
                        prodname: productNameController.text,
                        prodprice: double.parse(productPriceController.text),
                        image: selectedImage != null
                            ? selectedImage!.path // Use local image path
                            : "https://via.placeholder.com/150", // Fallback
                        description: productDescripController.text.isNotEmpty
                            ? productDescripController.text
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
      },
    );
  }
}
