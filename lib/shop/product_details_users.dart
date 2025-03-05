import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/Inquiry_page.dart';
import 'package:myapp/models/product_and_store_model.dart';
import 'package:myapp/provider/inquiry_provider.dart';
import 'package:myapp/provider/store_provider.dart';
import 'package:myapp/shop/shop.dart';
import 'package:provider/provider.dart';

class ProductDetailsUserPage extends StatefulWidget {
  final Product product;

  const ProductDetailsUserPage({super.key, required this.product});

  @override
  State<ProductDetailsUserPage> createState() => _ProductDetailsUserPageState();
}

class _ProductDetailsUserPageState extends State<ProductDetailsUserPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    //final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.product.prodname,
          style: GoogleFonts.poppins(
            fontSize: 26,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: widget.product.image.startsWith('http')
                      ? Image.network(
                          widget.product.image,
                          height: 250,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 50),
                        )
                      : Image.file(
                          File(widget.product.image), // Use local file path
                          height: 250,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 50),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Text(widget.product.prodname,
                  style: GoogleFonts.poppins(
                      fontSize: 28, fontWeight: FontWeight.w400)),
              const SizedBox(height: 0),
              Text('\$${widget.product.prodprice}',
                  style: const TextStyle(fontSize: 20, color: Colors.grey)),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  widget.product.description,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 126, 126, 126)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(width: 40),
              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 172, 144, 251),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      textStyle: GoogleFonts.poppins(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      final inquiryProvider =
                          Provider.of<InquiryProvider>(context, listen: false);
                      inquiryProvider.addToInquiry(widget.product);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InquiryPage()));
                    },
                    child: Text("Add to Inquiry",
                        style: GoogleFonts.poppins(
                            fontSize: 20, color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
