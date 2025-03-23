import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/business_dashboard.dart';
import 'package:myapp/component/customer_flow_screen.dart';
import 'package:myapp/provider/summary_provider.dart';
import 'package:provider/provider.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  bool isLoading = true;
  Key _animationKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await Provider.of<SummaryProvider>(context, listen: false).fetchStats();
    } catch (e) {
      print("Error fetching stats: $e");
    } finally {
      //mounted is used to check if the widget is still in the widget tree
      if (mounted) {
        setState(() {
          isLoading = false;
          //create a new key to force animation rebuild
          _animationKey = UniqueKey();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Summary',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            /*CustomerFlowScreen.of(context)
                ?.updateIndex(6); // Go back to Business Dashboard screen*/
            CustomerFlowScreen.of(context)
                ?.setNewScreen(BusinessDashboardScreen());
          },
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: _buildStatsContent(),
            ),
    );
  }

  Widget _buildStatsContent() {
    return Consumer<SummaryProvider>(
      builder: (context, statsProvider, child) {
        final viewedColor = Colors.green;
        final newColor = Colors.redAccent;
        final primaryColor = Colors.blueAccent;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCards(
                  statsProvider, primaryColor, viewedColor, newColor),
              const SizedBox(height: 24),
              _buildPieChart(statsProvider, viewedColor, newColor),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCards(
    SummaryProvider stats,
    Color primaryColor,
    Color viewedColor,
    Color newColor,
  ) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.4,
      ),
      children: [
        _buildSummaryCard(
          'Total Products',
          stats.totalProducts,
          Icons.store,
          primaryColor,
          stats.totalProducts > 0 ? 1.0 : 0.0,
        ),
        _buildSummaryCard(
          'Total Inquiries',
          stats.totalInquiries,
          Icons.chat,
          Colors.orangeAccent,
          stats.totalInquiries > 0 ? 1.0 : 0.0,
        ),
        _buildSummaryCard(
          'Viewed Inquiries',
          stats.viewedInquiries,
          Icons.visibility,
          viewedColor,
          stats.totalInquiries > 0
              ? stats.viewedInquiries / stats.totalInquiries
              : 0.0,
        ),
        _buildSummaryCard(
          'New Inquiries',
          stats.newInquiries,
          Icons.new_releases,
          newColor,
          stats.totalInquiries > 0
              ? stats.newInquiries / stats.totalInquiries
              : 0.0,
        ),
        _buildSummaryCard(
          'Awaiting Approval',
          stats.awaitingOrders,
          Icons.pending_actions,
          Colors.teal,
          stats.awaitingOrders + stats.completedOrders > 0
              ? stats.awaitingOrders /
                  (stats.awaitingOrders + stats.completedOrders)
              : 0.0,
        ),
        _buildSummaryCard(
          'Completed Orders',
          stats.completedOrders,
          Icons.check_circle,
          Color.fromARGB(255, 186, 163, 251),
          stats.awaitingOrders + stats.completedOrders > 0
              ? stats.completedOrders /
                  (stats.awaitingOrders + stats.completedOrders)
              : 0.0,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    int count,
    IconData icon,
    Color color,
    double progressValue,
  ) {
    return Card(
      color: const Color.fromARGB(255, 249, 249, 249),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.2),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              count.toString(),
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(
    SummaryProvider stats,
    Color viewedColor,
    Color newColor,
  ) {
    return Card(
      color: const Color.fromARGB(255, 249, 249, 249),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribution',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 22,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: TweenAnimationBuilder(
                key: _animationKey,
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      stats.totalProducts > 0
                          ? PieChart(
                              duration: const Duration(milliseconds: 1200),
                              curve: Curves.easeInOutBack,
                              PieChartData(
                                startDegreeOffset: 270 * (1 - value),
                                sectionsSpace: 2,
                                centerSpaceRadius: 70,
                                sections: [
                                  PieChartSectionData(
                                    value: stats.totalProducts.toDouble(),
                                    color: Colors.blueAccent,
                                    radius: 40,
                                    title:
                                        stats.totalProducts.toStringAsFixed(0),
                                    titleStyle: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  PieChartSectionData(
                                    value: stats.totalInquiries.toDouble(),
                                    color: Colors.orangeAccent,
                                    radius: 40,
                                    title:
                                        stats.totalInquiries.toStringAsFixed(0),
                                    titleStyle: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  PieChartSectionData(
                                    value: stats.viewedInquiries.toDouble(),
                                    color: viewedColor,
                                    radius: 40,
                                    title: stats.viewedInquiries
                                        .toStringAsFixed(0),
                                    titleStyle: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  PieChartSectionData(
                                    value: stats.newInquiries.toDouble(),
                                    color: newColor,
                                    radius: 40,
                                    title: stats.newInquiriesPercentage > 0
                                        ? stats.newInquiries.toStringAsFixed(0)
                                        : '',
                                    titleStyle: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  PieChartSectionData(
                                    value: stats.awaitingOrders.toDouble(),
                                    color: Colors.teal,
                                    radius: 40,
                                    title: stats.awaitingOrders > 0
                                        ? stats.awaitingOrders
                                            .toStringAsFixed(0)
                                        : '',
                                    titleStyle: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  PieChartSectionData(
                                    value: stats.completedOrders.toDouble(),
                                    color: Color.fromARGB(255, 186, 163, 251),
                                    radius: 40,
                                    title: stats.completedOrders > 0
                                        ? stats.completedOrders
                                            .toStringAsFixed(0)
                                        : '',
                                    titleStyle: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Center(
                              child: Text(
                                'No inquiry data',
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                      AnimatedOpacity(
                        opacity: value.clamp(0.0, 1.0),
                        duration: const Duration(milliseconds: 1200),
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Overview',
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[800],
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLegendItem('Viewed', viewedColor),
                    _buildLegendItem('New', newColor),
                    _buildLegendItem('Products', Colors.blueAccent),
                    _buildLegendItem('Inquiries', Colors.orangeAccent),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildLegendItem('Awaiting', Colors.tealAccent),
                    _buildLegendItem(
                        'Completed', Color.fromARGB(255, 186, 163, 251)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //Legend item for pie chart
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
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
