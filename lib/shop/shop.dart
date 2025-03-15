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
  List<Store> filteredStores = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAllStores();
    filteredStores = allStores;
  }

  //search function
  void _searchStores(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredStores = allStores;
      } else {
        filteredStores = allStores.where((store) {
          return store.storeName.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Future<void> fetchAllStores() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch all stores from Firestore
      final querySnapshot =
          await FirebaseFirestore.instance.collection('stores').get();
      print("Number of documents found: ${querySnapshot.docs.length}");

      List<Store> stores = [];

      for (var doc in querySnapshot.docs) {
        try {
          print("Store ID: ${doc.id}, Name: ${doc.data()['storeName']}");
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
            print("Number of products in store: ${products.length}");
          }

          // Safely access bannerImage - provide a default if it doesn't exist
          String bannerImage = '';
          try {
            if (doc.data().containsKey('bannerImage')) {
              bannerImage = doc['bannerImage'];
            }
          } catch (e) {
            print("No banner image for store ${doc.id}");
          }

          // Create store object
          stores.add(
            Store(
              id: doc.id,
              storeName: doc['storeName'],
              products: products,
              userId: doc['userId'] ?? '',
              bannerImage: bannerImage,
            ),
          );
        } catch (e) {
          print("Error processing store document ${doc.id}: $e");
        }
      }
      filteredStores = stores;
      if (!mounted)
        return; // Avoid calling `setState` if the widget is disposed
      setState(() {
        allStores = stores;
        isLoading = false;
      });
      print("Total stores loaded: ${allStores.length}");
    } catch (e) {
      print("Error fetching all stores: $e");
      if (!mounted)
        return; // Avoid calling `setState` if the widget is disposed
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
        : (productCount > 0 ? store.products[0].image : null);

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
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false, // This removes the back button
        title: Text("Shop", style: GoogleFonts.poppins(fontSize: 24)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            margin: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Discover Stores",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Explore your store in one click and get find your favorite products",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search stores...',
                hintStyle: GoogleFonts.poppins(
                    color: const Color.fromARGB(255, 127, 127, 127)),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 243, 243, 243),
              ),
              onChanged: _searchStores,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "All Stores",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  "${filteredStores.length} items",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: isLoading
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
                    : filteredStores.isEmpty
                        ? Center(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/empty-shop.png',
                                      width: 250,
                                      fit: BoxFit.fitWidth,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "No matching stores found",
                                      style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[700]),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Try a different search term",
                                      style: GoogleFonts.poppins(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : GridView.builder(
                            padding: EdgeInsets.all(8.0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: filteredStores.length,
                            itemBuilder: (context, index) {
                              final store = filteredStores[index];
                              return _buildStoreCard(store);
                            },
                          ),
          ),
          //SizedBox(height: 9),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchAllStores,
        child: Icon(
          Icons.refresh,
          color: Colors.white,
          size: 26,
        ),
        backgroundColor: Colors.black,
      ),
    );
  }
}
