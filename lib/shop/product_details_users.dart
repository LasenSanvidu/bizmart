import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/Inquiry_page.dart';
import 'package:myapp/component/customer_flow_screen.dart';
import 'package:myapp/models/product_and_store_model.dart';
import 'package:myapp/provider/inquiry_provider.dart';
import 'package:myapp/provider/review_provider.dart';
import 'package:myapp/review.dart';
import 'package:myapp/services/message_service.dart';
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
    Future.delayed(Duration.zero, () {
      Provider.of<ReviewProvider>(context, listen: false).fetchReviews();
    });
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
    final reviewProvider = Provider.of<ReviewProvider>(context);
    final productReviews =
        reviewProvider.getReviewsForProduct(widget.product.id);
    final MessageService messageService = MessageService();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            CustomerFlowScreen.of(context)
                ?.updateIndex(1); // Go back to ShopPage
          },
        ),
        title: Text(
          widget.product.prodname,
          style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  height: 220,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: _buildProductImage(widget.product.image),
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
              const SizedBox(height: 25),
              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      //backgroundColor: const Color.fromARGB(255, 172, 144, 251),
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      textStyle: GoogleFonts.poppins(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () async {
                      final inquiryProvider =
                          Provider.of<InquiryProvider>(context, listen: false);
                      /*inquiryProvider.addToInquiry(widget.product);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InquiryPage()));*/
                      // Fetch product owner ID from Firestore
                      final productDoc = await FirebaseFirestore.instance
                          .collection('products')
                          .doc(widget.product.id)
                          .get();

                      if (productDoc.exists) {
                        final ownerId = productDoc.data()?['ownerId'];
                        await inquiryProvider.addToInquiry(
                            widget.product, ownerId);

                        await messageService.sendMessage(
                            productDoc['ownerId'], productDoc['prodname']);

                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Added to inquiry')));

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InquiryPage()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Product information not found')));
                      }
                    },
                    child: Text(
                      "Add to Inquiry",
                      style: GoogleFonts.poppins(
                          fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: SizedBox(
                  width: 320, // Set length here
                  child: Divider(),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Give Your Opinion Here",
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Reviews",
                    style: GoogleFonts.poppins(
                      fontSize: 21,
                      color: const Color.fromARGB(255, 82, 82, 82),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      /*Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddReviewScreen(productId: widget.product.id),
                        ),
                      );*/
                      CustomerFlowScreen.of(context)?.setNewScreen(
                          AddReviewScreen(productId: widget.product.id));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,
                    ),
                    child: Icon(
                      Icons.add_circle_outline_rounded,
                      color: const Color.fromARGB(255, 123, 123, 123),
                      size: 27,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 300,
                child: productReviews.isEmpty
                    ? Center(
                        child: Text(
                          "No reviews yet",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        //physics: NeverScrollableScrollPhysics(),
                        itemCount: productReviews.length,
                        itemBuilder: (context, index) {
                          final review = productReviews[index];
                          return Card(
                            color: const Color.fromARGB(255, 246, 246, 246),
                            elevation: 1, // Adds a subtle shadow
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 14.0), // Adds space around the card
                            child: Padding(
                              padding: const EdgeInsets.all(
                                  16.0), // Adds inner spacing
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Aligns text to the start
                                children: [
                                  Text(
                                    review.reviewerName,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    review.reviewText,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '${review.rating} ★',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
