import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/product_and_store_model.dart';

class ReceiptGenerator extends StatefulWidget {
  final String customerId;
  final String productId;
  final String inquiryId;

  const ReceiptGenerator({
    Key? key,
    required this.customerId,
    required this.productId,
    required this.inquiryId,
  }) : super(key: key);

  @override
  _ReceiptGeneratorState createState() => _ReceiptGeneratorState();
}

class _ReceiptGeneratorState extends State<ReceiptGenerator> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  bool _isGenerating = false;

  // Product details
  Product? _product;
  String? _storeName;

  // Form fields
  final _quantityController = TextEditingController(text: '1');
  final _discountController = TextEditingController(text: '0');
  final _additionalNotesController = TextEditingController();
  bool _isPaid = false;
  String _paymentMethod = 'Card';

  // Receipt details
  final String _receiptNumber =
      'REC-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
  final DateTime _receiptDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadProductDetails();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _discountController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }

  Future<void> _loadProductDetails() async {
    try {
      // Fetch product details
      final productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .get();

      if (productDoc.exists) {
        final data = productDoc.data()!;
        final product = Product(
          id: data['id'],
          prodname: data['prodname'],
          image: data['image'],
          prodprice: data['prodprice'].toDouble(),
          description: data['description'],
        );

        // Fetch store name
        final storeDoc = await FirebaseFirestore.instance
            .collection('stores')
            .doc(data['storeId'])
            .get();

        setState(() {
          _product = product;
          _storeName = storeDoc.exists ? storeDoc['storeName'] : 'Your Store';
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product not found')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error loading product details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading product details')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _generateAndSendReceipt() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_isPaid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please mark pay method before generating an invoice.',
              style: GoogleFonts.poppins()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      final receiptData = _createReceiptData();
      await _saveReceiptToFirestore(receiptData);

      // Notify the buyer or navigate to receipt view
      await _notifyBuyer(receiptData['receiptNumber']);

      Navigator.pop(context, receiptData['receiptNumber']);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Receipt generated and shared successfully')),
      );
    } catch (e) {
      print('Error generating receipt: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating receipt')),
      );
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  Map<String, dynamic> _createReceiptData() {
    final quantity = int.parse(_quantityController.text);
    final discount = double.parse(_discountController.text);

    final subtotal = _product!.prodprice * quantity;
    final discountAmount = subtotal * (discount / 100);
    final total = subtotal - discountAmount;

    // Return receipt data
    return {
      'receiptNumber': _receiptNumber,
      'receiptDate': _receiptDate,
      'customerId': widget.customerId,
      'productId': widget.productId,
      'inquiryId': widget.inquiryId,
      'quantity': quantity,
      'discount': discount,
      'subtotal': subtotal,
      'total': total,
      'isPaid': !_isPaid,
      'paymentMethod': _paymentMethod,
      'notes': _additionalNotesController.text,
    };
  }

  Future<void> _saveReceiptToFirestore(Map<String, dynamic> receiptData) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    print("Saving receipt with storeName: $_storeName");

    await FirebaseFirestore.instance
        .collection('receipts')
        .doc(_receiptNumber)
        .set({
      'receiptNumber': receiptData['receiptNumber'],
      'receiptDate': receiptData['receiptDate'],
      'businessId': currentUserId,
      'customerId': receiptData['customerId'],
      'productId': receiptData['productId'],
      'inquiryId': receiptData['inquiryId'],
      'storeName': _storeName ?? 'Your StoreBITCOin',
      'productName': _product!.prodname,
      'quantity': receiptData['quantity'],
      'price': _product!.prodprice,
      'discount': receiptData['discount'],
      'subtotal': receiptData['subtotal'],
      'total': receiptData['total'],
      'isPaid': receiptData['isPaid'],
      'paymentMethod': receiptData['paymentMethod'],
      'notes': receiptData['notes'],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _notifyBuyer(String receiptNumber) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.customerId)
        .get();

    if (userDoc.exists) {
      final user = userDoc.data()!;
      final buyerName = user['name'];
      final buyerEmail = user['email'];

      final emailContent = '''
      <h1>Receipt Generated</h1>
      <p>Hi $buyerName,</p>
      <p>Your receipt for the purchase of ${_product!.prodname} has been generated successfully.</p>
      <p>Receipt Number: $receiptNumber</p>
      <p>Thank you for shopping with us!</p>
      <p>Regards,<br>$_storeName</p>
      ''';

      // Send email to buyer
      await FirebaseFirestore.instance.collection('emails').add({
        'to': buyerEmail,
        'message': emailContent,
        'subject': 'Receipt Generated for Purchase of ${_product!.prodname}',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Generate Invoice",
            style: GoogleFonts.poppins(fontSize: 22, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product information card
                    Card(
                      color: const Color.fromARGB(255, 248, 248, 248),
                      elevation: 2,
                      margin: EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Product Information',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text('Name:',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500)),
                                SizedBox(width: 5),
                                Expanded(
                                    child: Text(_product!.prodname,
                                        style: GoogleFonts.poppins())),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text('Price:',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500)),
                                SizedBox(width: 5),
                                Text(
                                    '\Rs ${_product!.prodprice.toStringAsFixed(2)}',
                                    style: GoogleFonts.poppins()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Receipt details card
                    Card(
                      color: const Color.fromARGB(255, 248, 248, 248),
                      elevation: 2,
                      margin: EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Receipt Details',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text('Receipt #:',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500)),
                                SizedBox(width: 5),
                                Text(_receiptNumber,
                                    style: GoogleFonts.poppins()),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text('Date:',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500)),
                                SizedBox(width: 5),
                                Text(
                                    DateFormat('dd/MM/yyyy')
                                        .format(_receiptDate),
                                    style: GoogleFonts.poppins()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Quantity and discount inputs
                    Card(
                      color: const Color.fromARGB(255, 248, 248, 248),
                      elevation: 2,
                      margin: EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sale Details',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _quantityController,
                              decoration: InputDecoration(
                                labelText: 'Quantity',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter quantity';
                                }
                                if (int.tryParse(value) == null ||
                                    int.parse(value) < 1) {
                                  return 'Please enter a valid quantity';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _discountController,
                              decoration: InputDecoration(
                                labelText: 'Discount (%)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter discount';
                                }
                                final discount = double.tryParse(value);
                                if (discount == null ||
                                    discount < 0 ||
                                    discount > 100) {
                                  return 'Discount must be between 0 and 100';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Payment details
                    Card(
                      color: const Color.fromARGB(255, 248, 248, 248),
                      elevation: 2,
                      margin: EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Payment Details',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            SwitchListTile(
                              title: Text('Pay method',
                                  style: GoogleFonts.poppins()),
                              value: _isPaid,
                              onChanged: (value) {
                                setState(() {
                                  _isPaid = value;
                                });
                              },
                              activeColor: Colors
                                  .black, // Change the active color when switch is ON
                              inactiveTrackColor: Colors
                                  .white, // Change the track color when switch is OFF
                              inactiveThumbColor: Colors.black,
                            ),
                            if (_isPaid)
                              Container(
                                constraints: BoxConstraints(maxWidth: 200),
                                child: DropdownButtonFormField<String>(
                                  elevation: 0,
                                  decoration: InputDecoration(
                                    labelText: 'Payment Method',
                                    border: OutlineInputBorder(),
                                  ),
                                  dropdownColor: Colors.grey,
                                  value: _paymentMethod,
                                  items: [
                                    'Card',
                                    'Bank Transfer',
                                  ]
                                      .map((method) => DropdownMenuItem(
                                            value: method,
                                            child: Text(
                                              method,
                                              style: GoogleFonts.poppins(
                                                color: Colors
                                                    .black, // Text in dropdown is white
                                                fontSize: 16,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _paymentMethod = value!;
                                    });
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    // Additional notes
                    Card(
                      color: const Color.fromARGB(255, 248, 248, 248),
                      elevation: 2,
                      margin: EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Additional Notes',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _additionalNotesController,
                              decoration: InputDecoration(
                                hintText:
                                    'Add any additional information here...',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Generate Receipt Button
                    SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: ElevatedButton(
                        onPressed:
                            _isGenerating ? null : _generateAndSendReceipt,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isGenerating
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                'Generate Invoice',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
