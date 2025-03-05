import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/product_and_store_model.dart';
import 'package:myapp/shop/product_details_users.dart';
import 'package:myapp/shop/product_details_businessman.dart';
import 'package:myapp/provider/store_provider.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);
    final allProducts = storeProvider.allProducts;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Shop", style: GoogleFonts.poppins(fontSize: 24)),
        backgroundColor: Colors.white,
      ),
      body: allProducts.isEmpty
          ? Center(child: Text("No products available"))
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsUserPage(product: product),
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
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(10)),
                            child: product.image.startsWith("http")
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
                                  ),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
    );
  }
}
