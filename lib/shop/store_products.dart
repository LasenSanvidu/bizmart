/*import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/component/customer_flow_screen.dart';
import 'package:myapp/models/product_and_store_model.dart';
import 'package:myapp/shop/product_details_users.dart';
import 'package:myapp/shop/product_details_businessman.dart';
import 'package:myapp/provider/store_provider.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatefulWidget {
  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  bool isLoading = true;
  List<Product> allProducts = [];

  @override
  void initState() {
    super.initState();
    /**Future.delayed(Duration.zero, () async {
      await Provider.of<StoreProvider>(context, listen: false).fetchStores();
      setState(() {
        isLoading = false; // Set loading to false once fetching is done
      });
    });*/
    fetchAllProducts();
  }

  Future<void> fetchAllProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch all stores from Firestore
      final querySnapshot =
          await FirebaseFirestore.instance.collection('stores').get();

      List<Product> products = [];

      for (var doc in querySnapshot.docs) {
        if (doc.data().containsKey('products') && doc['products'] is List) {
          final storeProducts = (doc['products'] as List).map((prod) {
            return Product(
              id: prod['id'],
              prodname: prod['prodname'],
              image: prod['image'],
              prodprice: prod['prodprice'].toDouble(),
              description: prod['description'],
            );
          }).toList();

          products.addAll(storeProducts);
        }
      }

      setState(() {
        allProducts = products;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching all products: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

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
    //final storeProvider = Provider.of<StoreProvider>(context);
    //final allProducts =
    //storeProvider.stores.isNotEmpty ? storeProvider.allProducts : [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Shop", style: GoogleFonts.poppins(fontSize: 24)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : allProducts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/empty-shop.png',
                        width: 350,
                        fit: BoxFit.fitWidth,
                      ),
                      Text(
                        "No products available",
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: allProducts.length,
                  itemBuilder: (context, index) {
                    final product = allProducts[index];
                    return GestureDetector(
                      onTap: () {
                        /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailsUserPage(product: product),
                      ),
                    );*/
                        CustomerFlowScreen.of(context)?.setNewScreen(
                            ProductDetailsUserPage(product: product));
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
                                child: _buildProductImage(product.image),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                product.prodname,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                '\Rs ${product.prodprice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 126, 126, 126),
                                    fontSize: 15),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchAllProducts,
        child: Icon(
          Icons.refresh,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
      ),
    );
  }
}*/

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/component/customer_flow_screen.dart';
import 'package:myapp/models/product_and_store_model.dart';
import 'package:myapp/shop/product_details_users.dart';

class StoreProductsPage extends StatefulWidget {
  final Store store;

  const StoreProductsPage({Key? key, required this.store}) : super(key: key);

  @override
  State<StoreProductsPage> createState() => _StoreProductsPageState();
}

class _StoreProductsPageState extends State<StoreProductsPage> {
  late List<Product> storeProducts;

  @override
  void initState() {
    super.initState();
    storeProducts = widget.store.products;
  }

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.store.storeName,
            style: GoogleFonts.poppins(fontSize: 22)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            CustomerFlowScreen.of(context)?.updateIndex(1); // Go back to shop
          },
        ),
      ),
      body: Column(
        children: [
          widget.store.bannerImage.isNotEmpty
              ? Container(
                  width: double.infinity,
                  height: 150,
                  child: _buildProductImage(widget.store.bannerImage),
                )
              : SizedBox(),
          Expanded(
            child: storeProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/empty-shop.png',
                          width: 350,
                          fit: BoxFit.fitWidth,
                        ),
                        Text(
                          "No products in this store",
                          style: GoogleFonts.poppins(
                              fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.all(8.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: storeProducts.length,
                    itemBuilder: (context, index) {
                      final product = storeProducts[index];
                      return GestureDetector(
                        onTap: () {
                          CustomerFlowScreen.of(context)?.setNewScreen(
                            ProductDetailsUserPage(product: product),
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
                                  child: _buildProductImage(product.image),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product.prodname,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  '\Rs ${product.prodprice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 126, 126, 126),
                                      fontSize: 15),
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
}
