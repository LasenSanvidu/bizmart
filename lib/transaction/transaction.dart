import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myapp/business_dashboard.dart';
import 'package:myapp/component/customer_flow_screen.dart';
import 'package:myapp/invoices/receipt_veiwer.dart';
import 'dart:async';

import 'package:myapp/transaction/transaction_heat_map.dart';

class TransactionTrackerPage extends StatefulWidget {
  const TransactionTrackerPage({Key? key}) : super(key: key);

  @override
  _TransactionTrackerPageState createState() => _TransactionTrackerPageState();
}

class _TransactionTrackerPageState extends State<TransactionTrackerPage> {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  String _selectedPeriod = 'Month';
  bool _isLoading = true;
  List<Map<String, dynamic>> _transactions = [];
  double _totalIncome = 0;
  StreamSubscription? _transactionSubscription;

  // Data for the chart
  List<FlSpot> _chartData = [];
  double _maxY = 0;
  List<String> _chartLabels = [];

  @override
  void initState() {
    super.initState();
    _setupTransactionListener();
  }

  @override
  void dispose() {
    _transactionSubscription?.cancel();
    super.dispose();
  }

  Future<void> _setupTransactionListener() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Calculate date range based on selected period
      DateTime startDate;
      DateTime endDate = DateTime.now();

      switch (_selectedPeriod) {
        case 'Week':
          startDate = endDate.subtract(Duration(days: 7));
          break;
        case 'Month':
          startDate = DateTime(endDate.year, endDate.month - 1, endDate.day);
          break;
        case 'Year':
          startDate = DateTime(endDate.year - 1, endDate.month, endDate.day);
          break;
        default:
          startDate = DateTime(endDate.year, endDate.month - 1, endDate.day);
      }

      // Cancel existing subscription if any
      _transactionSubscription?.cancel();

      // Setup real-time listener for paid transactions
      _transactionSubscription = FirebaseFirestore.instance
          .collection('receipts')
          .where('businessId', isEqualTo: currentUserId)
          .where('isPaid', isEqualTo: true)
          .where('createdAt', isGreaterThanOrEqualTo: startDate)
          .where('createdAt', isLessThanOrEqualTo: endDate)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((snapshot) {
        List<Map<String, dynamic>> transactions = [];
        double totalIncome = 0;

        // Process transaction data
        for (var doc in snapshot.docs) {
          Map<String, dynamic> data = doc.data();
          transactions.add({
            'id': doc.id,
            'amount': data['total'] as double,
            'date': (data['createdAt'] as Timestamp).toDate(),
            'productName': data['productName'] as String,
            'customer': data['customerId'] as String,
            'receiptNumber': data['receiptNumber'] as String,
          });

          totalIncome += data['total'] as double;
        }

        // Process chart data
        _prepareChartData(transactions, startDate, endDate);

        setState(() {
          _transactions = transactions;
          _totalIncome = totalIncome;
          _isLoading = false;
        });
      }, onError: (error) {
        print('Error in transaction stream: $error');
        setState(() {
          _isLoading = false;
        });
      });
    } catch (e) {
      print('Error setting up transaction listener: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  //to group transactions by date:
  Map<String, List<Map<String, dynamic>>> _groupTransactionsByDate() {
    Map<String, List<Map<String, dynamic>>> groupedTransactions = {};

    for (var transaction in _transactions) {
      String dateKey = DateFormat('yyyy-MM-dd').format(transaction['date']);

      if (!groupedTransactions.containsKey(dateKey)) {
        groupedTransactions[dateKey] = [];
      }

      groupedTransactions[dateKey]!.add(transaction);
    }

    return groupedTransactions;
  }

  // When period selection changes
  void _onPeriodChanged(String newPeriod) {
    setState(() {
      _selectedPeriod = newPeriod;
    });
    _setupTransactionListener(); // Reestablish listener with new date range
  }

  void _prepareChartData(List<Map<String, dynamic>> transactions,
      DateTime startDate, DateTime endDate) {
    Map<String, double> dailyTotals = {};
    List<FlSpot> chartData = [];
    List<String> labels = [];

    // Initialize with zero values for each day in the range
    DateTime currentDate = startDate;
    int index = 0;

    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      String dateKey = DateFormat('yyyy-MM-dd').format(currentDate);
      dailyTotals[dateKey] = 0;
      currentDate = currentDate.add(Duration(days: 1));
    }

    // Sum transactions by day
    for (var transaction in transactions) {
      String dateKey = DateFormat('yyyy-MM-dd').format(transaction['date']);
      dailyTotals[dateKey] =
          (dailyTotals[dateKey] ?? 0) + transaction['amount'];
    }

    // Convert to chart data points
    index = 0;
    double maxY = 0;

    dailyTotals.forEach((date, amount) {
      chartData.add(FlSpot(index.toDouble(), amount));

      // Format label based on period
      String label = '';
      switch (_selectedPeriod) {
        case 'Week':
          label = DateFormat('E').format(DateTime.parse(date));
          break;
        case 'Month':
          label = DateFormat('d').format(DateTime.parse(date));
          break;
        case 'Year':
          label = DateFormat('MMM').format(DateTime.parse(date));
          break;
      }

      // Add label every 5 days for month view to avoid overcrowding
      if (_selectedPeriod == 'Month' && index % 5 == 0) {
        labels.add(label);
      } else if (_selectedPeriod != 'Month') {
        labels.add(label);
      } else {
        labels.add('');
      }

      if (amount > maxY) maxY = amount;
      index++;
    });

    // Update state variables
    _chartData = chartData;
    _chartLabels = labels;
    _maxY = maxY * 1.2; // Add 20% padding to the top
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Transaction Tracker",
          style: GoogleFonts.poppins(
              fontSize: 23, color: Colors.black, fontWeight: FontWeight.w400),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            CustomerFlowScreen.of(context)
                ?.setNewScreen(BusinessDashboardScreen());
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Card
                  Card(
                    color: Colors.black,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Income',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '\Rs ${_totalIncome.toStringAsFixed(2)}',
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Last $_selectedPeriod',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Period Selection
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Income Chart',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        DropdownButton<String>(
                          dropdownColor:
                              const Color.fromARGB(255, 183, 183, 183),
                          value: _selectedPeriod,
                          items: ['Week', 'Month', 'Year']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: GoogleFonts.poppins()),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null &&
                                newValue != _selectedPeriod) {
                              _onPeriodChanged(newValue);
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10),

                  // Chart
                  Container(
                    height: 280,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 248, 248, 248),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: _transactions.isEmpty
                        ? Center(
                            child: Text(
                              'No transactions in this period',
                              style: GoogleFonts.poppins(color: Colors.grey),
                            ),
                          )
                        : LineChart(
                            LineChartData(
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: _maxY / 5,
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: const Color(0xffE5E5E5),
                                    strokeWidth: 1,
                                  );
                                },
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 30,
                                    getTitlesWidget: (value, meta) {
                                      if (value >= 0 &&
                                          value < _chartLabels.length) {
                                        return Column(
                                          children: [
                                            SizedBox(height: 13),
                                            Text(
                                              _chartLabels[value.toInt()],
                                              style: GoogleFonts.poppins(
                                                color: Colors.black54,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                      return const Text('');
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 45,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value >= 100000
                                            ? '${(value / 1000).toStringAsFixed(0)}k'
                                            : '\Rs ${value.toInt()}',
                                        style: GoogleFonts.poppins(
                                          color: Colors.black87,
                                          fontSize: 10,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              minX: 0,
                              maxX: (_chartData.length - 1).toDouble(),
                              minY: 0,
                              maxY: _maxY,
                              lineBarsData: [
                                LineChartBarData(
                                  spots: _chartData,
                                  isCurved: true,
                                  color: Colors.black,
                                  barWidth: 2,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(
                                    show: false,
                                  ),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: Colors.black.withOpacity(0.2),
                                  ),
                                ),
                              ],
                              lineTouchData: LineTouchData(
                                touchTooltipData: LineTouchTooltipData(
                                  getTooltipItems: (touchedSpots) {
                                    return touchedSpots.map((touchedSpot) {
                                      final flSpot = touchedSpot;
                                      return LineTooltipItem(
                                        '${flSpot.y}', // Display the y value
                                        TextStyle(
                                          color: Colors
                                              .white, // Change text color to white
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    }).toList();
                                  },
                                ),
                              ),
                            ),
                          ),
                  ),

                  SizedBox(height: 20),

                  // Recent Transactions
                  Text(
                    'Transaction Heat Map',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  TransactionHeatMap(
                    transactions: _transactions,
                    selectedPeriod: _selectedPeriod,
                    contextForNavigation: context,
                  )
                ],
              ),
            ),
    );
  }
}
