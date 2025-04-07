/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/component/customer_flow_screen.dart';

class ReceiptViewer extends StatelessWidget {
  final String receiptId;
  final bool isBuyer;

  const ReceiptViewer({
    Key? key,
    required this.receiptId,
    this.isBuyer = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Receipt Details",
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('receipts')
            .doc(receiptId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          // Calculate values
          final quantity = data['quantity'] as int;
          final price = data['price'] as double;
          final discount = data['discount'] as double;
          final subtotal = data['subtotal'] as double;
          final total = data['total'] as double;
          final isPaid = data['isPaid'] as bool;
          final productName = data['productName'] as String;
          final receiptNumber = data['receiptNumber'] as String;
          final storeName = data['storeName'] ?? 'Store';
          final notes = data['notes'] as String?;

          // Format the date
          final receiptDate = (data['receiptDate'] as Timestamp).toDate();
          final formattedDate = DateFormat('dd/MM/yyyy').format(receiptDate);

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Receipt header
                Card(
                  color: const Color.fromARGB(255, 248, 248, 248),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              storeName,
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'RECEIPT',
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Receipt #: $receiptNumber',
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                            Text(
                              'Date: $formattedDate',
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Product details
                Card(
                  color: const Color.fromARGB(255, 248, 248, 248),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product Details',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Table(
                          columnWidths: const {
                            0: FlexColumnWidth(3),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(2),
                            3: FlexColumnWidth(2),
                          },
                          border: TableBorder.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          children: [
                            // Table header
                            TableRow(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                              ),
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'Item',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'Qty',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'Price',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'Amount',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            // Product row
                            TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    productName,
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    '$quantity',
                                    style: GoogleFonts.poppins(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    '\Rs ${price.toStringAsFixed(2)}',
                                    style: GoogleFonts.poppins(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    '\Rs ${subtotal.toStringAsFixed(2)}',
                                    style: GoogleFonts.poppins(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Totals
                Card(
                  color: const Color.fromARGB(255, 248, 248, 248),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Summary',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Subtotal:', style: GoogleFonts.poppins()),
                            Text('\Rs ${subtotal.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins()),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Discount ($discount%):',
                                style: GoogleFonts.poppins()),
                            Text(
                                '\Rs ${(subtotal * discount / 100).toStringAsFixed(2)}',
                                style: GoogleFonts.poppins()),
                          ],
                        ),
                        Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total:',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '\Rs ${total.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Payment details
                Card(
                  color: const Color.fromARGB(255, 248, 248, 248),
                  elevation: 2,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Payment Status: ',
                                style: GoogleFonts.poppins()),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isPaid ? Colors.green : Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                isPaid ? 'PAID' : 'UNPAID',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        if (isPaid || !isPaid)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Payment Method: ',
                                  style: GoogleFonts.poppins()),
                              Text(data['paymentMethod'] ?? 'N/A',
                                  style: GoogleFonts.poppins()),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Notes
                if (notes != null && notes.isNotEmpty)
                  Card(
                    color: const Color.fromARGB(255, 248, 248, 248),
                    elevation: 2,
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
                          Text(notes, style: GoogleFonts.poppins()),
                        ],
                      ),
                    ),
                  ),

                SizedBox(height: 24),

                // Payment button for buyer
                if (isBuyer && !isPaid)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _processPayment(context, receiptId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Pay Now",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _processPayment(BuildContext context, String receiptId) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      // Here you would integrate with your payment gateway
      // For now, we'll just simulate a successful payment

      // Simulate payment processing
      await Future.delayed(Duration(seconds: 2));

      // Update receipt status
      await FirebaseFirestore.instance
          .collection('receipts')
          .doc(receiptId)
          .update({
        'isPaid': true,
        'paymentDate': FieldValue.serverTimestamp(),
      });

      // Update inquiry status
      final receiptData = await FirebaseFirestore.instance
          .collection('receipts')
          .doc(receiptId)
          .get();

      if (receiptData.exists) {
        final inquiryId = receiptData.data()?['inquiryId'];
        if (inquiryId != null) {
          await FirebaseFirestore.instance
              .collection('inquiries')
              .doc(inquiryId)
              .update({
            'status': 'paid',
            'paymentDate': FieldValue.serverTimestamp(),
          });
        }
      }

      // Close loading dialog
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment successful!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Close loading dialog
      Navigator.pop(context);

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/component/customer_flow_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReceiptViewer extends StatefulWidget {
  final String receiptId;
  final bool isBuyer;

  const ReceiptViewer({
    Key? key,
    required this.receiptId,
    this.isBuyer = false,
  }) : super(key: key);

  @override
  _ReceiptViewerState createState() => _ReceiptViewerState();
}

class _ReceiptViewerState extends State<ReceiptViewer> {
  bool _usePoints = false;
  int _availablePoints = 0;
  int _pointsToUse = 0;
  final _pointsController = TextEditingController();
  bool _isMounted = false;

  // Define the points earning percentage as a constant to ensure consistency
  static const double POINTS_EARNING_PERCENTAGE = 0.05;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    if (widget.isBuyer) {
      _fetchUserPoints();
    }
  }

  @override
  void dispose() {
    _isMounted = false;
    _pointsController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserPoints() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      final userPoints = await FirebaseFirestore.instance
          .collection('user_points')
          .doc(userId)
          .get();

      if (!_isMounted) return; // Check if the widget is still mounted

      if (userPoints.exists) {
        setState(() {
          _availablePoints = userPoints.data()?['points'] ?? 0;
          _pointsController.text = '0';
        });
      } else {
        // Create points document if it doesn't exist
        await FirebaseFirestore.instance
            .collection('user_points')
            .doc(userId)
            .set({'points': 0});

        if (!_isMounted) return; // Check if the widget is still mounted

        setState(() {
          _availablePoints = 0;
          _pointsController.text = '0';
        });
      }
    } catch (e) {
      print("Error fetching user points: $e");
    }
  }

  // Helper function to calculate points earned from a purchase amount
  int calculatePointsEarned(double amount) {
    return (amount * POINTS_EARNING_PERCENTAGE).round();
  }

  // Helper function to calculate the effective points to use based on total amount
  int getEffectivePointsToUse(int pointsToUse, double totalAmount) {
    // Points can't exceed the total amount (1 point = 1 rupee)
    return pointsToUse > totalAmount ? totalAmount.toInt() : pointsToUse;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Receipt Details",
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('receipts')
            .doc(widget.receiptId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          // Calculate values
          final quantity = data['quantity'] as int;
          final price = data['price'] as double;
          final discount = data['discount'] as double;
          final subtotal = data['subtotal'] as double;
          final total = data['total'] as double;
          final isPaid = data['isPaid'] as bool;
          final productName = data['productName'] as String;
          final receiptNumber = data['receiptNumber'] as String;
          final storeName = data['storeName'] ?? 'Store';
          final notes = data['notes'] as String?;

          // Calculate points discount - ensure points don't exceed total
          final effectivePointsToUse =
              getEffectivePointsToUse(_pointsToUse, total);
          double pointsDiscount =
              _usePoints ? effectivePointsToUse.toDouble() : 0;

          // Calculate final amount after all discounts
          final finalAmount = total - pointsDiscount;

          // Calculate points to be earned on this purchase
          final pointsToEarn = calculatePointsEarned(finalAmount);

          // Format the date
          final receiptDate = (data['receiptDate'] as Timestamp).toDate();
          final formattedDate = DateFormat('dd/MM/yyyy').format(receiptDate);

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Receipt header
                Card(
                  color: const Color.fromARGB(255, 248, 248, 248),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              storeName,
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'RECEIPT',
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Receipt #: $receiptNumber',
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                            Text(
                              'Date: $formattedDate',
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Product details
                Card(
                  color: const Color.fromARGB(255, 248, 248, 248),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product Details',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Table(
                          columnWidths: const {
                            0: FlexColumnWidth(3),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(2),
                            3: FlexColumnWidth(2),
                          },
                          border: TableBorder.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          children: [
                            // Table header
                            TableRow(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                              ),
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'Item',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'Qty',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'Price',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'Amount',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            // Product row
                            TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    productName,
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    '$quantity',
                                    style: GoogleFonts.poppins(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'Rs ${price.toStringAsFixed(2)}',
                                    style: GoogleFonts.poppins(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'Rs ${subtotal.toStringAsFixed(2)}',
                                    style: GoogleFonts.poppins(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Loyalty Points Section (Only for the buyer and unpaid receipts)
                if (widget.isBuyer && !isPaid)
                  Card(
                    color: const Color.fromARGB(255, 248, 248, 248),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Use Loyalty Points',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Switch(
                                value: _usePoints,
                                onChanged: (value) {
                                  setState(() {
                                    _usePoints = value;
                                    if (!value) {
                                      _pointsToUse = 0;
                                      _pointsController.text = '0';
                                    }
                                  });
                                },
                                activeColor: Colors.green,
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Available Points: $_availablePoints',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10),
                          if (_usePoints)
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _pointsController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Points to use',
                                      border: OutlineInputBorder(),
                                      hintText:
                                          'Enter points (max: $_availablePoints)',
                                    ),
                                    onChanged: (value) {
                                      // Validate and limit points input
                                      int? points = int.tryParse(value);

                                      // Handle negative numbers
                                      if (points == null || points < 0) {
                                        points = 0;
                                        _pointsController.text = "0";
                                      }

                                      // Handle exceeding available points
                                      if (points > _availablePoints) {
                                        points = _availablePoints;
                                        _pointsController.text =
                                            points.toString();
                                      }

                                      // Update state
                                      setState(() {
                                        _pointsToUse = points!;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _pointsToUse = _availablePoints;
                                      _pointsController.text =
                                          _availablePoints.toString();
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  child: Text(
                                    'Max',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),

                SizedBox(height: 16),

                // Totals
                Card(
                  color: const Color.fromARGB(255, 248, 248, 248),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Summary',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Subtotal:', style: GoogleFonts.poppins()),
                            Text('Rs ${subtotal.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins()),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Discount ($discount%):',
                                style: GoogleFonts.poppins()),
                            Text(
                                'Rs ${(subtotal * discount / 100).toStringAsFixed(2)}',
                                style: GoogleFonts.poppins()),
                          ],
                        ),
                        // Add points discount if points are used
                        if (_usePoints && effectivePointsToUse > 0)
                          Column(
                            children: [
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Points Discount:',
                                      style: GoogleFonts.poppins()),
                                  Text(
                                      'Rs ${pointsDiscount.toStringAsFixed(2)}',
                                      style: GoogleFonts.poppins(
                                          color: Colors.green)),
                                ],
                              ),
                            ],
                          ),
                        Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total:',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Rs ${finalAmount.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        if (_usePoints && effectivePointsToUse > 0)
                          SizedBox(height: 10),
                        if (_usePoints && effectivePointsToUse > 0)
                          Text(
                            'You\'ll earn $pointsToEarn points on this purchase',
                            style: GoogleFonts.poppins(
                              color: Colors.blue,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Payment details
                Card(
                  color: const Color.fromARGB(255, 248, 248, 248),
                  elevation: 2,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Payment Status: ',
                                style: GoogleFonts.poppins()),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isPaid ? Colors.green : Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                isPaid ? 'PAID' : 'UNPAID',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        if (isPaid || !isPaid)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Payment Method: ',
                                  style: GoogleFonts.poppins()),
                              Text(data['paymentMethod'] ?? 'N/A',
                                  style: GoogleFonts.poppins()),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Notes
                if (notes != null && notes.isNotEmpty)
                  Card(
                    color: const Color.fromARGB(255, 248, 248, 248),
                    elevation: 2,
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
                          Text(notes, style: GoogleFonts.poppins()),
                        ],
                      ),
                    ),
                  ),

                SizedBox(height: 24),

                // Payment button for buyer
                if (widget.isBuyer && !isPaid)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _processPayment(
                          context,
                          widget.receiptId,
                          effectivePointsToUse,
                          total,
                          finalAmount),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Pay Now",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _processPayment(BuildContext context, String receiptId,
      int pointsUsed, double originalTotal, double finalAmount) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception("User not authenticated");

      // Calculate points earned using the consistent method
      int pointsEarned = calculatePointsEarned(finalAmount);

      // Start a batch write to ensure all operations succeed or fail together
      final batch = FirebaseFirestore.instance.batch();

      // 1. Update receipt status
      final receiptRef =
          FirebaseFirestore.instance.collection('receipts').doc(receiptId);

      batch.update(receiptRef, {
        'isPaid': true,
        'paymentDate': FieldValue.serverTimestamp(),
      });

      // 2. Update user points (subtract used points and add earned points)
      final userPointsRef =
          FirebaseFirestore.instance.collection('user_points').doc(userId);

      // Get current points
      final userPointsDoc = await userPointsRef.get();
      int currentPoints = 0;

      if (userPointsDoc.exists) {
        currentPoints = userPointsDoc.data()?['points'] ?? 0;
      }

      // Calculate new points balance
      int newPoints = currentPoints - pointsUsed + pointsEarned;

      batch.set(userPointsRef, {'points': newPoints}, SetOptions(merge: true));

      // 3. Create a points transaction record
      final pointsTransactionRef =
          FirebaseFirestore.instance.collection('points_transactions').doc();

      batch.set(pointsTransactionRef, {
        'userId': userId,
        'receiptId': receiptId,
        'pointsUsed': pointsUsed,
        'pointsEarned': pointsEarned,
        'originalTotal': originalTotal,
        'finalAmount': finalAmount,
        'netPointsChange': pointsEarned - pointsUsed,
        'transactionDate': FieldValue.serverTimestamp(),
        'transactionType': 'purchase',
      });

      // Commit the batch
      await batch.commit();

      if (!_isMounted) return;

      // Close loading dialog
      Navigator.pop(context);

      // Update the local state
      setState(() {
        _availablePoints = newPoints;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment successful! You earned $pointsEarned points.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!_isMounted) return;

      // Close loading dialog
      Navigator.pop(context);

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
