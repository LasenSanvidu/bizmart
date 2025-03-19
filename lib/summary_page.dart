/*import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
//import 'package:animations/animations.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SoleCraft',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6A1B9A),
          brightness: Brightness.light,
        ),
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        cardTheme: CardTheme(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color(0xFF6A1B9A),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Color(0xFF6A1B9A)),
        ),
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

class _SoleCraftDashboardState extends State<SoleCraftDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  final orderStats = {
    'totalOrders': 476,
    'completedOrders': 186,
    'overdueOrders': 23,
    'pendingOrders': 48,
    'cancelledOrders': 54,
    'awaitingConfirmation': 47,
  };

  final completedColor = const Color(0xFF4CAF50);
  final awaitingColor = const Color(0xFF2196F3);
  final overdueColor = const Color(0xFFF44336);
  final pendingColor = const Color(0xFFFF9800);
  final cancelledColor = const Color(0xFF9C27B0);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SoleCraft'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            color: const Color(0xFFF8F9FA),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //_buildHeader(),
                    const SizedBox(height: 24),
                    _buildSummaryCards(isTablet),
                    const SizedBox(height: 24),
                    _buildStatisticsCard(isTablet),
                    const SizedBox(height: 24),
                    //_buildOrderStatusList(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards(bool isTablet) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 3 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: isTablet ? 2 : 1.5,
      ),
      children: [
        _buildSummaryCard(
          'Total Orders',
          orderStats['totalOrders']!,
          Icons.shopping_bag_outlined,
          const Color(0xFF6A1B9A),
        ),
        _buildSummaryCard(
          'Completed',
          orderStats['completedOrders']!,
          Icons.check_circle_outline,
          completedColor,
        ),
        _buildSummaryCard(
          'Overdue',
          orderStats['overdueOrders']!,
          Icons.timer_off_outlined,
          overdueColor,
        ),
        _buildSummaryCard(
          'Pending',
          orderStats['pendingOrders']!,
          Icons.pending_outlined,
          pendingColor,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
      String title, int count, IconData icon, Color color) {
    return FadeTransition(
      opacity: _animation,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 20,
                    ),
                  ),
                  Icon(
                    Icons.more_horiz,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                '$count',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsCard(bool isTablet) {
    return FadeTransition(
      opacity: _animation,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Order Distribution',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF333333),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: Color(0xFF6A1B9A),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'This Month',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: isTablet ? 300 : 250,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 70,
                      borderData: FlBorderData(show: false),
                      sections: [
                        _buildPieChartSection(
                          orderStats['completedOrders']!,
                          completedColor,
                          Icons.check_circle,
                        ),
                        _buildPieChartSection(
                          orderStats['awaitingConfirmation']!,
                          awaitingColor,
                          Icons.hourglass_empty,
                        ),
                        _buildPieChartSection(
                          orderStats['overdueOrders']!,
                          overdueColor,
                          Icons.timer_off,
                        ),
                        _buildPieChartSection(
                          orderStats['pendingOrders']!,
                          pendingColor,
                          Icons.pending,
                        ),
                        _buildPieChartSection(
                          orderStats['cancelledOrders']!,
                          cancelledColor,
                          Icons.cancel,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Completed',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(orderStats['completedOrders']! / orderStats['totalOrders']! * 100).toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: completedColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                _buildLegendItem('Completed', completedColor),
                _buildLegendItem('Awaiting', awaitingColor),
                _buildLegendItem('Overdue', overdueColor),
                _buildLegendItem('Pending', pendingColor),
                _buildLegendItem('Cancelled', cancelledColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  PieChartSectionData _buildPieChartSection(
      int count, Color color, IconData icon) {
    final percentage = (count / orderStats['totalOrders']! * 100);
    return PieChartSectionData(
      value: count.toDouble(),
      color: color,
      radius: 40,
      title: '${percentage.toStringAsFixed(0)}%',
      titleStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [Shadow(color: Colors.black26, blurRadius: 2)],
      ),
      badgeWidget: _getCustomBadge(icon, color),
      badgePositionPercentageOffset: 1.3,
    );
  }

  Widget _getCustomBadge(IconData icon, Color color) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          size: 16,
          color: color,
        ),
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
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}*/

//
//
//
//
//
//
//
//
/*import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/provider/stat_provider.dart';
import 'package:provider/provider.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await Provider.of<StatsProvider>(context, listen: false).fetchStats();
    } catch (e) {
      print("Error fetching stats: $e");
    } finally {
      //mounted is used to check if the widget is still in the widget tree
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('SoleCraft', style: GoogleFonts.poppins(color: Colors.black)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
    return Consumer<StatsProvider>(
      builder: (context, statsProvider, child) {
        // Define colors
        final viewedColor = Colors.black;
        final newColor = Colors.grey[700]!;
        final otherColor = Colors.grey[400]!;
        final primaryColor = Colors.black;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildSummaryCards(
                  statsProvider, primaryColor, viewedColor, newColor),
              const SizedBox(height: 24),
              _buildPieChart(statsProvider, viewedColor, newColor, otherColor),
              const SizedBox(height: 24),
              _buildInquiryStatusList(
                  statsProvider, viewedColor, newColor, otherColor),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.bubble_chart,
            color: Colors.black,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Store Statistics',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(
    StatsProvider stats,
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
        childAspectRatio: 1.5,
      ),
      children: [
        _buildSummaryCard(
          'Total Products',
          stats.totalProducts,
          Icons.shopping_bag_outlined,
          primaryColor,
          stats.totalProducts > 0 ? 1.0 : 0.0,
        ),
        _buildSummaryCard(
          'Total Inquiries',
          stats.totalInquiries,
          Icons.question_answer_outlined,
          primaryColor,
          stats.totalInquiries > 0 ? 1.0 : 0.0,
        ),
        _buildSummaryCard(
          'Viewed Inquiries',
          stats.viewedInquiries,
          Icons.check_circle_outline,
          viewedColor,
          stats.totalInquiries > 0
              ? stats.viewedInquiries / stats.totalInquiries
              : 0.0,
        ),
        _buildSummaryCard(
          'New Inquiries',
          stats.newInquiries,
          Icons.hourglass_empty,
          newColor,
          stats.totalInquiries > 0
              ? stats.newInquiries / stats.totalInquiries
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
      elevation: 2,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
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
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: progressValue,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              borderRadius: BorderRadius.circular(2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(
    StatsProvider stats,
    Color viewedColor,
    Color newColor,
    Color otherColor,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Inquiry Distribution',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  stats.totalInquiries > 0
                      ? PieChart(
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeInOut,
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 70,
                            sections: [
                              PieChartSectionData(
                                value: stats.viewedInquiries.toDouble(),
                                color: viewedColor,
                                radius: 40,
                                title: stats.viewedInquiriesPercentage > 5
                                    ? '${stats.viewedInquiriesPercentage.toStringAsFixed(0)}%'
                                    : '',
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              PieChartSectionData(
                                value: stats.newInquiries.toDouble(),
                                color: newColor,
                                radius: 40,
                                title: stats.newInquiriesPercentage > 5
                                    ? '${stats.newInquiriesPercentage.toStringAsFixed(0)}%'
                                    : '',
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              PieChartSectionData(
                                value: stats.newInquiries.toDouble(),
                                color: newColor,
                                radius: 40,
                                title: stats.newInquiriesPercentage > 5
                                    ? '${stats.newInquiriesPercentage.toStringAsFixed(0)}%'
                                    : '',
                                titleStyle: const TextStyle(
                                  fontSize: 12,
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
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Viewed',
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${stats.viewedInquiriesPercentage.toStringAsFixed(0)}%',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Viewed', viewedColor),
                const SizedBox(width: 24),
                _buildLegendItem('New', newColor),
                const SizedBox(width: 24),
                _buildLegendItem('Other', otherColor),
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

  Widget _buildInquiryStatusList(
    StatsProvider stats,
    Color viewedColor,
    Color newColor,
    Color otherColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Inquiry Status',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        _buildInquiryStatusItem('Viewed Inquiries', stats.viewedInquiries,
            viewedColor, stats.viewedInquiriesPercentage),
        _buildInquiryStatusItem('New Inquiries', stats.newInquiries, newColor,
            stats.newInquiriesPercentage),
        if (stats.totalInquiries == 0)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: Text(
                'No inquiries yet',
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInquiryStatusItem(
      String title, int count, Color dotColor, double percentage) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
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
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(1)}% of total',
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: dotColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}*/

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
                      stats.totalInquiries > 0
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
