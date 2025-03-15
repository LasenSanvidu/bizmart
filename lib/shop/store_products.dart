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
  List<Product> filteredProducts = [];
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  double _minPrice = 0;
  double _maxPrice = 5000;
  RangeValues _currentRangeValues = RangeValues(0, 5000);

  late Widget _bannerWidget;

  @override
  void initState() {
    super.initState();
    storeProducts = widget.store.products;
    filteredProducts = storeProducts;
    // initialize the banner widget once
    // so that it doesn't rebuild on every setState, so it'll prevent banner flickering.
    _bannerWidget = _buildBannerWidget();
  }

  //search function
  void searchProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = storeProducts;
      } else {
        filteredProducts = storeProducts.where((product) {
          return product.prodname.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Widget _buildBannerWidget() {
    return widget.store.bannerImage.isNotEmpty
        ? Container(
            width: double.infinity,
            height: 180,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildProductImage(widget.store.bannerImage),
                // Gradient overlay for better text visibility
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.5),
                      ],
                    ),
                  ),
                ),
                // Store description
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome to ${widget.store.storeName}",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Discover our amazing products",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : SizedBox();
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
        title: isSearching
            ? TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  border: InputBorder.none,
                  hintStyle: GoogleFonts.poppins(color: Colors.grey),
                ),
                style: GoogleFonts.poppins(),
                onChanged: searchProducts,
              )
            : Text(widget.store.storeName,
                style: GoogleFonts.poppins(fontSize: 22)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            CustomerFlowScreen.of(context)?.updateIndex(1); // Go back to shop
          },
        ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search,
                color: Colors.black87),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchController.clear();
                  filteredProducts = storeProducts;
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _bannerWidget,
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Products",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  "${filteredProducts.length} items",
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
            child: storeProducts.isEmpty || filteredProducts.isEmpty
                ? Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey),
                            ),
                            Text(
                              "Check back soon for new arrivals!",
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
                      childAspectRatio: 0.7,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return GestureDetector(
                        key: ValueKey(product.id),
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
                                    top: Radius.circular(10),
                                  ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: Colors.white.withOpacity(0.85),
            context: context,
            builder: (context) => Container(
              padding: EdgeInsets.all(16),
              height: 280,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Filter Products",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Price Range",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 20),
                  StatefulBuilder(
                    builder: (context, setState) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Text(
                                  "Rs ${_currentRangeValues.start.round()}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Text(
                                  "Rs ${_currentRangeValues.end.round()}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          RangeSlider(
                            values: _currentRangeValues,
                            min: _minPrice,
                            max: _maxPrice,
                            //divisions: 50,
                            activeColor: Colors.black,
                            inactiveColor: Colors.grey[300],
                            labels: RangeLabels(
                              "Rs ${_currentRangeValues.start.round()}",
                              "Rs ${_currentRangeValues.end.round()}",
                            ),
                            onChanged: (RangeValues values) {
                              setState(() {
                                _currentRangeValues = values;
                              });
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          filteredProducts = storeProducts.where((product) {
                            return product.prodprice >=
                                    _currentRangeValues.start &&
                                product.prodprice <= _currentRangeValues.end;
                          }).toList();
                        });
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Apply Filters",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        backgroundColor: Colors.black,
        child: Icon(
          Icons.filter_list,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
