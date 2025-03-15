import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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

  // Mock data instead of Firebase data
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
                    const SizedBox(height: 24),
                    _buildSummaryCards(isTablet),
                    const SizedBox(height: 24),
                    _buildStatisticsCard(isTablet),
                    const SizedBox(height: 24),
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
}