import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/chat/chat_page.dart';
import 'package:myapp/chat/chat_screen.dart';
import 'package:myapp/component/customer_flow_screen.dart';
import 'package:myapp/models/product_and_store_model.dart';
import 'package:myapp/provider/inquiry_provider.dart';
import 'package:myapp/receipt_generator.dart';
import 'package:myapp/receipt_veiwer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ReceivedInquiriesPage extends StatefulWidget {
  const ReceivedInquiriesPage({Key? key}) : super(key: key);

  @override
  _ReceivedInquiriesPageState createState() => _ReceivedInquiriesPageState();
}

class _ReceivedInquiriesPageState extends State<ReceivedInquiriesPage> {
  bool _isLoading = true;
  Map<String, Product> _products = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final currentUserId =
          Provider.of<InquiryProvider>(context, listen: false).currentUserId;
      print("Current user ID: $currentUserId");
      // Fetch received inquiries
      await Provider.of<InquiryProvider>(context, listen: false)
          .fetchReceivedInquiries();

      // Fetch product details for all inquiries
      final inquiries = Provider.of<InquiryProvider>(context, listen: false)
          .receivedInquiries;
      print("Received inquiries count: ${inquiries.length}");

      for (var inquiry in inquiries) {
        print("Inquiry productOwnerId: ${inquiry.productOwnerId}");
      }

      for (var inquiry in inquiries) {
        if (_products.containsKey(inquiry.productId)) continue;

        final productDoc = await FirebaseFirestore.instance
            .collection('products')
            .doc(inquiry.productId)
            .get();

        if (productDoc.exists) {
          final data = productDoc.data()!;
          _products[inquiry.productId] = Product(
            id: data['id'],
            prodname: data['prodname'],
            image: data['image'],
            prodprice: data['prodprice'].toDouble(),
            description: data['description'],
          );
        }
      }
    } catch (e) {
      print("Error loading inquiries data: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final inquiryProvider = Provider.of<InquiryProvider>(context);
    final receivedInquiries = inquiryProvider.receivedInquiries;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Received Inquiries",
          style: GoogleFonts.poppins(fontSize: 24),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            CustomerFlowScreen.of(context)
                ?.updateIndex(6); // Go back to Business Dashboard
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : receivedInquiries.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/Inquiry_0.jpg', // Use appropriate image
                        width: 300,
                        fit: BoxFit.fitWidth,
                      ),
                      SizedBox(height: 40),
                      Text(
                        'No Inquiries Received',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: receivedInquiries.length,
                  itemBuilder: (context, index) {
                    final inquiry = receivedInquiries[index];
                    final product = _products[inquiry.productId];

                    if (product == null) {
                      return SizedBox.shrink(); // Skip if product not found
                    }

                    return Card(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: inquiry.isViewed
                              ? Colors.grey.shade300
                              : Colors.black,
                          width: 1.5,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          _showInquiryDetails(inquiry, product);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              if (!inquiry.isViewed)
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              SizedBox(width: inquiry.isViewed ? 0 : 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Inquiry for ${product.prodname}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'From: ${inquiry.inquirerName}',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Received: ${_formatDate(inquiry.createdAt)}',
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 102, 102, 102),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.chevron_right),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  String _formatDate(DateTime date) {
    // Simple date formatting
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void goToChat(String userId) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          userId: userId,
        ),
      ),
    );
  }

  void _showInquiryDetails(UserInquiry inquiry, Product product) {
    // Mark as viewed if not already
    if (!inquiry.isViewed) {
      Provider.of<InquiryProvider>(context, listen: false)
          .markInquiryAsViewed(inquiry.id);
    }

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 18),
              Text(
                'Inquiry Details',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              _buildDetailRow('Product', product.prodname),
              _buildDetailRow(
                  'Price', '\$${product.prodprice.toStringAsFixed(2)}'),
              _buildDetailRow('From', inquiry.inquirerName),
              _buildDetailRow('Date', _formatDate(inquiry.createdAt)),
              SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        goToChat(inquiry.inquirerUserId);
                      },
                      icon: Icon(Icons.chat, color: Colors.white, size: 20),
                      label: Text(
                        'Start Chat',
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding:
                            EdgeInsets.symmetric(horizontal: 36, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 14),
                    ElevatedButton.icon(
                      onPressed: () async {
                        // Navigate to ReceiptGenerator
                        final receiptNumber = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReceiptGenerator(
                              customerId: inquiry.inquirerUserId,
                              productId: product.id,
                              inquiryId: inquiry.id,
                            ),
                          ),
                        );
                        // If receipt was successfully generated (receiptNumber is not null)
                        if (receiptNumber != null) {
                          // Close the bottom sheet
                          Navigator.pop(context);

                          // Navigate to ReceiptViewer with the generated receipt
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReceiptViewer(
                                receiptId: receiptNumber,
                                isBuyer: false, // This is the seller viewing it
                              ),
                            ),
                          );
                        }
                      },
                      icon: Icon(
                        Icons.receipt_long,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: Text(
                        'Gen E-Receipt',
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label + ':',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
