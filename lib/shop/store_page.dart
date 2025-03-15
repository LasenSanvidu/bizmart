import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/component/business_flow_screens.dart';
import 'package:myapp/component/button.dart';
import 'package:myapp/component/customer_flow_screen.dart';
import 'package:myapp/models/product_and_store_model.dart';
import 'package:myapp/shop/add_product_page.dart';
import 'package:myapp/shop/product_details_businessman.dart';
import 'package:myapp/provider/store_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class StorePage extends StatelessWidget {
  final String storeId;

  const StorePage({super.key, required this.storeId});

  Widget _buildProductImage(String imagePath) {
    if (imagePath.startsWith('data:image')) {
      // This is a base64 image
      return Image.memory(
        base64Decode(imagePath.split(',')[1]),
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.broken_image,
          size: 50,
        ),
      );
    } else if (imagePath.startsWith('http')) {
      // This is a network image
      return Image.network(
        imagePath,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.broken_image,
          size: 50,
        ),
      );
    } else {
      // This is a local file path
      return Image.file(
        File(imagePath),
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.broken_image,
          size: 50,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);
    final store = storeProvider.getStoreById(storeId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            /*BusinessFlowScreens.of(context)
                ?.updateIndex(1);*/
            CustomerFlowScreen.of(context)
                ?.updateIndex(5); // Go back to MyStoreUi
          },
        ),
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
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )),

                      //yes button
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          storeProvider.clearAllProductsInStore(storeId);
                        },
                        child: const Text(
                          'Yes',
                          style: TextStyle(fontSize: 16, color: Colors.black),
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
            //onPressed: () => _showAddProductDialog(context, storeProvider),
            onPressed: () {
              CustomerFlowScreen.of(context)
                  ?.setNewScreen(AddProductPage(storeId: store.id));
            },

            style: ElevatedButton.styleFrom(
              //backgroundColor: const Color.fromARGB(255, 184, 161, 249),
              backgroundColor: Colors.black,
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
                              /*Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailsPage(product: product),
                                ),
                              );*/

                              CustomerFlowScreen.of(context)?.setNewScreen(
                                ProductDetailsPage(product: product),
                              );
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
                                        child: /*product.image.startsWith("http")
                                    ? Image.network(
                                        product.image,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(Icons.broken_image,
                                                    size: 50),
                                      )
                                    : Image.file(
                                        File(product.image),
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(Icons.broken_image,
                                                    size: 50),
                                      ),*/
                                            _buildProductImage(product.image)),
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
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black),
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
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black),
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
}
