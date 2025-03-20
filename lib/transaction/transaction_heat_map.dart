import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/invoices/receipt_veiwer.dart';

class TransactionHeatMap extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  final String selectedPeriod;
  final BuildContext contextForNavigation;

  const TransactionHeatMap({
    Key? key,
    required this.transactions,
    required this.selectedPeriod,
    required this.contextForNavigation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildTransactionHeatMap();
  }

  Widget _buildTransactionHeatMap() {
    // Map to store transaction data by date
    Map<DateTime, List<Map<String, dynamic>>> transactionsByDate = {};

    // Group transactions by date (ignoring time)
    for (var transaction in transactions) {
      DateTime date = DateTime(
        transaction['date'].year,
        transaction['date'].month,
        transaction['date'].day,
      );

      if (!transactionsByDate.containsKey(date)) {
        transactionsByDate[date] = [];
      }

      transactionsByDate[date]!.add(transaction);
    }

    // Determine the date range for the heatmap
    DateTime now = DateTime.now();
    DateTime startDate;
    DateTime endDate;

    switch (selectedPeriod) {
      case 'Week':
        // Calculate the start of the current week (Monday)
        startDate = now.subtract(Duration(days: now.weekday - 1));
        // Calculate the end of the current week (Sunday)
        endDate = startDate.add(Duration(days: 6));
        break;
      case 'Month':
        startDate = DateTime(now.year, now.month, 1);
        endDate =
            DateTime(now.year, now.month + 1, 0); // Last day of current month
        break;
      case 'Year':
        startDate = DateTime(now.year, 1, 1);
        endDate = DateTime(now.year, 12, 31);
        break;
      default:
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 0);
    }

    // Get all dates in the range
    List<DateTime> allDates = [];
    for (DateTime date = startDate;
        date.isBefore(endDate.add(Duration(days: 1)));
        date = date.add(Duration(days: 1))) {
      allDates.add(DateTime(date.year, date.month, date.day));
    }

    // Calculate the maximum transaction value for color scaling
    double maxValue = 0;
    transactionsByDate.forEach((date, transactions) {
      double dailyTotal = transactions.fold(
          0, (sum, transaction) => sum + transaction['amount']);
      if (dailyTotal > maxValue) maxValue = dailyTotal;
    });

    // Calculate color based on intensity
    Color _getColorForIntensity(double intensity) {
      // Define a color gradient from light to intense
      if (intensity <= 0) {
        return Colors.grey[200]!;
      } else if (intensity < 0.25) {
        return Color(0xFFFFE5B4); // Light orange
      } else if (intensity < 0.5) {
        return Color(0xFF8FD16A); // Medium green
      } else if (intensity < 0.75) {
        return Color(0xFF3D9BE0); // Medium blue
      } else {
        return Color(0xFF1255B3); // Dark blue
      }
    }

    // Calculate number of weeks for grid layout
    int totalWeeks = (allDates.length / 7).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 246, 246, 246),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: transactions.isEmpty
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      'No transactions in this period',
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                  ),
                )
              : Column(
                  children: [
                    // Day labels
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //SizedBox(width: 26),
                        //week labels
                        ...List.generate(7, (index) {
                          String dayLabel = DateFormat('E').format(
                                  DateTime.now().subtract(Duration(
                                      days:
                                          DateTime.now().weekday - 1 - index)))[
                              0]; // Get first letter of day name
                          return Expanded(
                            child: Center(
                              child: Text(
                                dayLabel,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    SizedBox(height: 14),
                    // Heat map grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        childAspectRatio: 1.0,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                      itemCount: allDates.length,
                      itemBuilder: (context, index) {
                        DateTime currentDate = allDates[index];
                        List<Map<String, dynamic>> dayTransactions =
                            transactionsByDate[currentDate] ?? [];

                        // Calculate daily total
                        double dailyTotal = dayTransactions.fold(0,
                            (sum, transaction) => sum + transaction['amount']);

                        // Determine color intensity based on transaction value
                        /*double intensity =
                            maxValue > 0 ? (dailyTotal / maxValue) : 0;
                        Color cellColor = dayTransactions.isEmpty
                            ? Colors.grey[200]!
                            : Color.fromRGBO(
                                0,
                                0,
                                0,
                                0.1 +
                                    (intensity *
                                        0.7)); // Darker color for higher values*/

                        double intensity =
                            maxValue > 0 ? (dailyTotal / maxValue) : 0;
                        Color cellColor = dayTransactions.isEmpty
                            ? const Color.fromARGB(255, 234, 234, 234)!
                            : _getColorForIntensity(intensity);

                        return InkWell(
                          onTap: () {
                            if (dayTransactions.isNotEmpty) {
                              _showDailyTransactions(
                                  dayTransactions, currentDate);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: cellColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Text(
                                '${currentDate.day}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: dayTransactions.isEmpty
                                      ? Colors.black87
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    // Legend
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 234, 234, 234),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'No transactions',
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: const Color.fromARGB(255, 54, 54, 54)),
                        ),
                        SizedBox(width: 12),
                        ...List.generate(4, (index) {
                          //double opacity = 0.1 + ((index + 1) * 0.2);
                          Color legendColor =
                              _getColorForIntensity(index * 0.25 + 0.05);
                          String label = index == 0
                              ? 'Low'
                              : index == 3
                                  ? 'High'
                                  : '';
                          return Row(
                            children: [
                              Container(
                                height: 12,
                                width: 12,
                                decoration: BoxDecoration(
                                  color: legendColor,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              SizedBox(width: 4),
                              index == 3
                                  ? Text('High',
                                      style: GoogleFonts.poppins(
                                          fontSize: 13, color: Colors.black))
                                  : SizedBox.shrink(),
                            ],
                          );
                        }),
                      ],
                    ),
                  ],
                ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  //method to show daily transactions in a bottom sheet
  void _showDailyTransactions(
      List<Map<String, dynamic>> transactions, DateTime date) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: contextForNavigation,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        double totalValue = transactions.fold(
            0, (sum, transaction) => sum + transaction['amount']);

        return Container(
          padding: EdgeInsets.all(20),
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Transactions on ${DateFormat('MMMM d, yyyy').format(date)}',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Total: \Rs ${totalValue.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return Card(
                      color: const Color.fromARGB(255, 248, 248, 248),
                      elevation: 2,
                      margin: EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        title: Text(
                          transaction['productName'],
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
                              'Receipt #: ${transaction['receiptNumber']}',
                              style: GoogleFonts.poppins(fontSize: 13),
                            ),
                          ],
                        ),
                        trailing: Text(
                          '\Rs ${transaction['amount'].toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context); // Close the bottom sheet
                          Navigator.push(
                            contextForNavigation,
                            MaterialPageRoute(
                              builder: (context) => ReceiptViewer(
                                receiptId: transaction['receiptNumber'],
                                isBuyer: false,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
