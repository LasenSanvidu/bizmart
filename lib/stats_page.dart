import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SummaryScreen extends StatelessWidget {
  final int totalOrders = 476;
  final int completedOrders = 186;
  final int overdueOrders = 23;
  final int awaitingConfirmation = 47;
  final int pendingOrders = 48;
  final int canceledOrders = 54;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SoleCraft",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Summary",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildOrderStat("Total Orders", totalOrders),
                _buildOrderStat("Overdue Orders", overdueOrders),
              ],
            ),
            const SizedBox(height: 20),
            Center(child: _buildPieChart()),
            const SizedBox(height: 20),
            _buildLegend(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildOrderStat(String title, int value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value.toString(), style: const TextStyle(fontSize: 20)),
      ],
    );
  }

  Widget _buildPieChart() {
    return SizedBox(
      height: 150,
      child: PieChart(
        PieChartData(
          sections: [
            _chartSection(186, Colors.purple, "Completed Orders"),
            _chartSection(47, Colors.orange, "Awaiting Confirmation"),
            _chartSection(23, Colors.red, "Overdue"),
            _chartSection(48, Colors.blue, "Pending"),
            _chartSection(54, Colors.grey, "Canceled"),
          ],
        ),
      ),
    );
  }

  PieChartSectionData _chartSection(int value, Color color, String title) {
    return PieChartSectionData(
      value: value.toDouble(),
      title: "$value",
      color: color,
      radius: 40,
      titleStyle: const TextStyle(
          fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  Widget _buildLegend() {
    return Column(
      children: [
        _legendItem(Colors.purple, "Completed Tasks", completedOrders),
        _legendItem(
            Colors.orange, "Awaiting Confirmation", awaitingConfirmation),
        _legendItem(Colors.red, "Overdue Orders", overdueOrders),
        _legendItem(Colors.blue, "Pending Orders", pendingOrders),
        _legendItem(Colors.grey, "Canceled Orders", canceledOrders),
      ],
    );
  }

  Widget _legendItem(Color color, String title, int value) {
    return Row(
      children: [
        Container(width: 10, height: 10, color: color),
        const SizedBox(width: 10),
        Text("$title: $value"),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Stats"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
      ],
    );
  }
}
