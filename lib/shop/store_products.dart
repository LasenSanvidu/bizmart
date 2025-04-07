/*
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/component/customer_flow_screen.dart';
import 'package:myapp/models/product_and_store_model.dart';
import 'package:myapp/shop/product_details_users.dart';
import 'package:myapp/component/voice_command_button.dart';

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
  double _maxPrice = 500000;
  RangeValues _currentRangeValues = RangeValues(0, 500000);

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
      body: Stack(
        children: [
          Column(
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      '\Rs ${product.prodprice.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 126, 126, 126),
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
          VoiceButton(
            onTextRecognized: (text) {
              setState(() {
                searchController.text = text;
                searchProducts(text);
              });
            },
            initialX: 320.0,
            initialY: 550.0,
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
}*/

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/component/customer_flow_screen.dart';
import 'package:myapp/models/product_and_store_model.dart';
import 'package:myapp/shop/product_details_users.dart';
import 'package:myapp/component/voice_command_button.dart';

class StoreProductsPage extends StatefulWidget {
  final Store store;

  const StoreProductsPage({Key? key, required this.store}) : super(key: key);

  @override
  State<StoreProductsPage> createState() => _StoreProductsPageState();
}

class _StoreProductsPageState extends State<StoreProductsPage>
    with SingleTickerProviderStateMixin {
  late List<Product> storeProducts;
  List<Product> filteredProducts = [];
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  double _minPrice = 0;
  double _maxPrice = 500000;
  RangeValues _currentRangeValues = RangeValues(0, 500000);
  bool _isMounted = true;

  late AnimationController _animationController;

  late Widget _bannerWidget;
  final Color primaryColor = Colors.black;
  final Color secondaryColor = Colors.white;
  final Color accentColor = Color(0xFFE0E0E0);

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    storeProducts = widget.store.products;
    filteredProducts = storeProducts;
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _animationController.forward();
    _bannerWidget = _buildBannerWidget();
  }

  @override
  void dispose() {
    _isMounted = false;
    _animationController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void searchProducts(String query) {
    if (!_isMounted) return;
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
            height: 200,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.memory(
                  base64Decode(widget.store.bannerImage.split(',')[1]),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.black,
                    child: Center(
                      child: Icon(Icons.image_not_supported,
                          color: Colors.white, size: 40),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.store.storeName,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Discover exceptional quality and style",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container(
            width: double.infinity,
            height: 120,
            color: Colors.black,
            child: Center(
              child: Text(
                widget.store.storeName,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
  }

  Widget _buildProductImage(String imagePath) {
    if (imagePath.startsWith('data:image')) {
      // Base64 image
      return Image.memory(
        base64Decode(imagePath.split(',')[1]),
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[200],
          child: Center(
            child: Icon(Icons.image_not_supported,
                color: Colors.grey[400], size: 40),
          ),
        ),
      );
    } else if (imagePath.startsWith('http')) {
      // Network image
      return Image.network(
        imagePath,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[200],
          child: Center(
            child: Icon(Icons.image_not_supported,
                color: Colors.grey[400], size: 40),
          ),
        ),
      );
    } else {
      // Local file path
      return Image.file(
        File(imagePath),
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[200],
          child: Center(
            child: Icon(Icons.image_not_supported,
                color: Colors.grey[400], size: 40),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        elevation: 0,
        title: isSearching
            ? Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                    prefixIcon:
                        Icon(Icons.search, color: Colors.grey[400], size: 20),
                  ),
                  style: GoogleFonts.poppins(fontSize: 14),
                  onChanged: searchProducts,
                  cursorColor: primaryColor,
                ),
              )
            : Text(
                widget.store.storeName,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: primaryColor,
                ),
              ),
        centerTitle: true,
        backgroundColor: secondaryColor,
        iconTheme: IconThemeData(color: primaryColor),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 22),
          onPressed: () {
            CustomerFlowScreen.of(context)?.updateIndex(1); // Go back to shop
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              isSearching ? Icons.close : Icons.search,
              color: primaryColor,
              size: 22,
            ),
            onPressed: () {
              if (!_isMounted) return;
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
      body: Stack(
        children: [
          Column(
            children: [
              _bannerWidget,
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "PRODUCTS",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        "${filteredProducts.length} items",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: storeProducts.isEmpty || filteredProducts.isEmpty
                    ? _buildEmptyState()
                    : _buildProductGrid(),
              ),
            ],
          ),
          VoiceButton(
            onTextRecognized: (text) {
              if (!_isMounted) return;
              setState(() {
                searchController.text = text;
                searchProducts(text);
              });
            },
            initialX: 320.0,
            initialY: 550.0,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => _buildFilterBottomSheet(),
          );
        },
        backgroundColor: primaryColor,
        child: Icon(
          Icons.filter_list,
          color: secondaryColor,
        ),
        elevation: 4,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/empty-shop.png',
              width: 180,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(height: 20),
            Text(
              "No products available",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Check back soon for new arrivals!",
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                CustomerFlowScreen.of(context)?.updateIndex(1);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: secondaryColor,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Browse Other Stores",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.75,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return _buildProductCard(product, index);
      },
    );
  }

  Widget _buildProductCard(Product product, int index) {
    // Create staggered animation for cards
    final delay = index % 2 == 0 ? 100 : 200;

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + delay),
      curve: Curves.easeOut,
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        key: ValueKey(product.id),
        onTap: () {
          CustomerFlowScreen.of(context)?.setNewScreen(
            ProductDetailsUserPage(product: product),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Hero(
                  tag: 'product-${product.id}',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                      child: _buildProductImage(product.image),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                child: Text(
                  product.prodname,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: primaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Text(
                  '\Rs ${product.prodprice.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[800],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterBottomSheet() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with drag indicator
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Filter Products",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey[600], size: 20),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ],
          ),
          Divider(height: 24),
          Text(
            "Price Range",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: primaryColor,
            ),
          ),
          SizedBox(height: 20),
          StatefulBuilder(
            builder: (context, setBottomSheetState) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rs ${_currentRangeValues.start.round()}",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        "Rs ${_currentRangeValues.end.round()}",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: primaryColor,
                      inactiveTrackColor: Colors.grey[300],
                      thumbColor: primaryColor,
                      overlayColor: primaryColor.withOpacity(0.2),
                      trackHeight: 2,
                    ),
                    child: RangeSlider(
                      values: _currentRangeValues,
                      min: _minPrice,
                      max: _maxPrice,
                      onChanged: (RangeValues values) {
                        setBottomSheetState(() {
                          _currentRangeValues = values;
                        });
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryColor,
                    side: BorderSide(color: Colors.grey[400]!),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () {
                    if (!_isMounted) return;
                    setState(() {
                      _currentRangeValues = RangeValues(_minPrice, _maxPrice);
                      filteredProducts = storeProducts;
                    });
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Reset",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: secondaryColor,
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () {
                    if (!_isMounted) return;
                    setState(() {
                      filteredProducts = storeProducts.where((product) {
                        return product.prodprice >= _currentRangeValues.start &&
                            product.prodprice <= _currentRangeValues.end;
                      }).toList();
                    });
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Apply",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
