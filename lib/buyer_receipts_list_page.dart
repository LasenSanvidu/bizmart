import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/component/customer_flow_screen.dart';
import 'package:myapp/receipt_veiwer.dart';

class BuyerReceiptsListPage extends StatelessWidget {
  const BuyerReceiptsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("My Purchases",
            style: GoogleFonts.poppins(
                fontSize: 23,
                color: Colors.black,
                fontWeight: FontWeight.w400)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('receipts')
            .where('customerId', isEqualTo: currentUserId)
            //.orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child:
                  Text('Error loading purchases', style: GoogleFonts.poppins()),
            );
          }

          final receipts = snapshot.data?.docs ?? [];

          if (receipts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /*Image.asset(
                    'assets/no_purchases.jpg', // Replace with appropriate image
                    width: 200,
                    height: 200,
                  ),*/
                  SizedBox(height: 20),
                  Text(
                    'No purchases yet',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: receipts.length,
            itemBuilder: (context, index) {
              final receipt = receipts[index].data() as Map<String, dynamic>;
              final receiptNumber = receipt['receiptNumber'] as String;
              final productName = receipt['productName'] as String;
              final total = receipt['total'] as double;
              final isPaid = receipt['isPaid'] as bool;
              final timestamp = receipt['createdAt'] as Timestamp?;
              final date = timestamp?.toDate() ?? DateTime.now();
              final formattedDate = DateFormat('MMM d, yyyy').format(date);
              final storeName = receipt['storeName'] ?? 'Store';

              return Card(
                color: const Color.fromARGB(255, 248, 248, 248),
                elevation: 2,
                margin: EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReceiptViewer(
                          receiptId: receiptNumber,
                          isBuyer: true,
                        ),
                      ),
                    );
                    /*CustomerFlowScreen.of(context)?.setNewScreen(
                      ReceiptViewer(
                        receiptId: receiptNumber,
                        isBuyer: true,
                      ),
                    );*/
                  },
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    productName,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text(
                        'From: $storeName',
                        style: GoogleFonts.poppins(fontSize: 13),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Date: $formattedDate',
                        style: GoogleFonts.poppins(fontSize: 13),
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\Rs ${total.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isPaid ? Colors.green : Colors.orange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isPaid ? 'PAID' : 'PAY NOW',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
