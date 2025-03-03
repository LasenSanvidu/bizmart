import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:myapp/business_dashboard.dart';
import 'package:myapp/main_settings.dart';
import 'package:myapp/notification_page.dart';
import 'package:myapp/order_confirmed.dart';
import 'package:myapp/profile.dart';
import 'package:myapp/store_ui.dart';
import 'package:myapp/stripe/payment.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static _MainScreenState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MainScreenState>();

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    MainSettings(),
    OrderConfirmed(),
    BusinessDashboardScreen(),
    Payment(),
    Profile(),
    NotificationPage(),
    StoreUi(),
  ];

  void updateIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 55,
        backgroundColor: Colors.black,
        buttonBackgroundColor: Colors.white,
        items: [
          Image.asset('lib/Icons/home-agreement.png', width: 25),
          Image.asset('lib/Icons/shopping-bag.png', width: 25),
          Image.asset('lib/Icons/wallet.png', width: 25),
          Image.asset('lib/Icons/secure.png', width: 25),
          Image.asset('lib/Icons/user.png', width: 25),
        ],
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
