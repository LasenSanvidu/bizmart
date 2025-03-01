import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SoleCraft',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      home: const SoleCraftDashboard(),
    );
  }
}

class SoleCraftDashboard extends StatefulWidget {
  const SoleCraftDashboard({Key? key}) : super(key: key);

  @override
  State<SoleCraftDashboard> createState() => _SoleCraftDashboardState();
}

class _SoleCraftDashboardState extends State<SoleCraftDashboard> {
  // These values would eventually come from a database
  final orderStats = {
    'totalOrders': 476,
    'completedOrders': 186,
    'overdueOrders': 23,
    'pendingOrders': 48,
    'cancelledOrders': 54,
    'awaitingConfirmation': 47,
  };

  // Define colors directly with RGB values for better visibility
  final completedColor = const Color(0xFF4CAF50); // Green
  final awaitingColor = const Color(0xFF2196F3); // Blue
  final overdueColor = const Color(0xFFF44336); // Red
  final pendingColor = const Color(0xFFFF9800); // Orange
  final cancelledColor = const Color(0xFF9C27B0); // Purple

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6E6FA), // Light purple
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          'SoleCraft',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Container(
              height:
                  constraints.maxHeight, // Set height to max available height
              color: const Color(0xFFE6E6FA), // Light purple
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.bubble_chart,
                          color: Colors.purple,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Summary',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Order Statistics',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Total Orders',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  '${orderStats['totalOrders']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Text(
                                  'Overdue Orders',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  '${orderStats['overdueOrders']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          height: 220,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              PieChart(
                                PieChartData(
                                  sectionsSpace: 3,
                                  centerSpaceRadius: 60,
                                  sections: [
                                    PieChartSectionData(
                                      value: orderStats['completedOrders']!
                                          .toDouble(),
                                      color: completedColor,
                                      radius: 30,
                                      title: '',
                                    ),
                                    PieChartSectionData(
                                      value: orderStats['awaitingConfirmation']!
                                          .toDouble(),
                                      color: awaitingColor,
                                      radius: 30,
                                      title: '',
                                    ),
                                    PieChartSectionData(
                                      value: orderStats['overdueOrders']!
                                          .toDouble(),
                                      color: overdueColor,
                                      radius: 30,
                                      title: '',
                                    ),
                                    PieChartSectionData(
                                      value: orderStats['pendingOrders']!
                                          .toDouble(),
                                      color: pendingColor,
                                      radius: 30,
                                      title: '',
                                    ),
                                    PieChartSectionData(
                                      value: orderStats['cancelledOrders']!
                                          .toDouble(),
                                      color: cancelledColor,
                                      radius: 30,
                                      title: '',
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Completed Orders',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${orderStats['completedOrders']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: completedColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Legend removed from here
                        const Divider(),
                        const SizedBox(height: 8),
                        _buildOrderStatusItem('Completed Tasks',
                            orderStats['completedOrders']!, completedColor),
                        _buildOrderStatusItem('Awaiting Confirmation',
                            orderStats['awaitingConfirmation']!, awaitingColor),
                        _buildOrderStatusItem('Overdue orders',
                            orderStats['overdueOrders']!, overdueColor),
                        _buildOrderStatusItem('Pending Orders',
                            orderStats['pendingOrders']!, pendingColor),
                        _buildOrderStatusItem('Cancelled Orders',
                            orderStats['cancelledOrders']!, cancelledColor),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderStatusItem(String title, int count, Color dotColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Text(
            '$count',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
