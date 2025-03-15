import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/component/customer_flow_screen.dart';
import 'package:myapp/models/product_and_store_model.dart';
import 'package:myapp/shop/store_products.dart';

class ShopPage extends StatefulWidget {
  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  bool isLoading = true;
  List<Store> allStores = [];

  @override
  void initState() {
    super.initState();
    fetchAllStores();
  }

  Future<void> fetchAllStores() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch all stores from Firestore
      final querySnapshot =
          await FirebaseFirestore.instance.collection('stores').get();

      List<Store> stores = [];

      for (var doc in querySnapshot.docs) {
        // For each store, get its products
        List<Product> products = [];
        if (doc.data().containsKey('products') && doc['products'] is List) {
          products = (doc['products'] as List).map((prod) {
            return Product(
              id: prod['id'],
              prodname: prod['prodname'],
              image: prod['image'],
              prodprice: prod['prodprice'].toDouble(),
              description: prod['description'],
            );
          }).toList();
        }

        // Create store object
        stores.add(Store(
          id: doc.id,
          storeName: doc['storeName'],
          products: products,
          userId: doc['userId'] ?? '',
          bannerImage: doc['bannerImage'] ?? '',
        ));
      }

      setState(() {
        allStores = stores;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching all stores: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildStoreCard(Store store) {
    // Count products in the store
    int productCount = store.products.length;

    // Use the first product image as store thumbnail if available
    String? thumbnailImage = store.bannerImage.isNotEmpty
        ? store.bannerImage
        : productCount > 0
            ? store.products[0].image
            : null;

    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          CustomerFlowScreen.of(context)?.setNewScreen(
            StoreProductsPage(store: store),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: thumbnailImage != null
                    ? _buildProductImage(thumbnailImage)
                    : Container(
                        color: Colors.grey[200],
                        child: Center(
                          child:
                              Icon(Icons.store, size: 50, color: Colors.grey),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                store.storeName,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                '$productCount products',
                style: const TextStyle(
                    color: Color.fromARGB(255, 126, 126, 126), fontSize: 14),
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
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
        title: Text("Shop", style: GoogleFonts.poppins(fontSize: 24)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : allStores.isEmpty
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
                        "No stores available",
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
                    childAspectRatio: 0.8,
                  ),
                  itemCount: allStores.length,
                  itemBuilder: (context, index) {
                    final store = allStores[index];
                    return _buildStoreCard(store);
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchAllStores,
        child: Icon(
          Icons.refresh,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
      ),
    );
  }
}
