import 'package:flutter/material.dart';
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
}
