/*import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BusinessDashboardScreen extends StatelessWidget {
  const BusinessDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "SoleCraft",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Business Dashboard",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Buttons for different sections
            _buildDashboardButton(
                context, Icons.pie_chart, "Summary", "/summary"),
            _buildDashboardButton(
                context, Icons.bar_chart, "Transactions", "/transactions"),
            _buildDashboardButton(
                context, Icons.insert_chart, "Statistics", "/statistics"),
            _buildDashboardButton(
                context, Icons.inventory, "Products", "/products"),
            _buildDashboardButton(
                context, Icons.category, "Categories", "/categories"),
          ],
        ),
      ),
    );
  }

  // Helper method to create buttons
  Widget _buildDashboardButton(
      BuildContext context, IconData icon, String title, String route) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          context.push(route);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple[100],
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.purple, size: 28),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/ad_screen.dart';
import 'package:myapp/business_calendar_page.dart';
import 'package:myapp/component/customer_flow_screen.dart';
import 'package:myapp/invoices/receipt_list_page.dart';
import 'package:myapp/received_inquiries_page.dart';
import 'package:myapp/shop/my_store_ui.dart';
import 'package:myapp/summary_page.dart';
import 'package:myapp/transaction/transaction.dart';
import 'package:myapp/transaction_screen.dart';

class BusinessDashboardScreen extends StatelessWidget {
  const BusinessDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            CustomerFlowScreen.of(context)?.updateIndex(0); // Go back to Home
          },
        ),
        title: Text(
          "Business Dashboard",
          style: GoogleFonts.poppins(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Buttons for different sections
              _buildDashboardButton(
                  context, Icons.pie_chart, "Summary", SummaryPage()),
              _buildDashboardButton(context, Icons.bar_chart, "Transactions",
                  TransactionTrackerPage()),
              _buildDashboardButton(
                  context, Icons.inventory, "Store & Products", MyStoreUi()),
              /*_buildDashboardButton(
                  context, Icons.category, "Categories", MyStoreUi()),*/
              _buildDashboardButton(context, Icons.question_answer_rounded,
                  "Recieved Inquiries", ReceivedInquiriesPage()),
              _buildDashboardButton(context, Icons.receipt_rounded, "Invoices",
                  ReceiptsListPage()),
              _buildDashboardButton(
                  context, Icons.inventory, "Boost sells", AddAdScreen()),
              _buildDashboardButton(context, Icons.inventory,
                  "Business Calendar", BusinessCalendarPage()),
              _buildDashboardButton(context, Icons.inventory,
                  "Custom Transactions", TransactionsScreen()),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create buttons
  Widget _buildDashboardButton(
      BuildContext context, IconData icon, String title, Widget screen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: ElevatedButton(
        onPressed: () {
          CustomerFlowScreen.of(context)?.setNewScreen(screen);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(color: Colors.black)),
          elevation: 0,
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                //color: const Color.fromARGB(255, 153, 116, 255),
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
