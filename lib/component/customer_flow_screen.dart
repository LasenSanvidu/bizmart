import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:myapp/business_dashboard.dart';
import 'package:myapp/main_settings.dart';
import 'package:myapp/notification_page.dart';
import 'package:myapp/settings_customer.dart';
import 'package:myapp/shop/shop.dart';
import 'package:myapp/stripe/payment.dart';

class CustomerFlowScreen extends StatefulWidget {
  const CustomerFlowScreen({super.key});

  static _CustomerFlowScreenState? of(BuildContext context) =>
      context.findAncestorStateOfType<_CustomerFlowScreenState>();

  @override
  State<CustomerFlowScreen> createState() => _CustomerFlowScreenState();
}

class _CustomerFlowScreenState extends State<CustomerFlowScreen> {
  int _currentIndex = 0;
  Widget? _activeScreen; // This will store the current screen being displayed

  final List<Widget> _pages = [
    MainSettings(),
    ShopPage(),
    BusinessDashboardScreen(),
    Payment(),
    SettingsPage(),
    NotificationPage(),
    //MyStoreUi(),
  ];

  void updateIndex(int index) {
    setState(() {
      _activeScreen = null;
      _currentIndex = index;
    });
  }

  void setNewScreen(Widget screen) {
    setState(() {
      _activeScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _activeScreen ??
          IndexedStack(
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
            updateIndex(index);
          });
        },
      ),
    );
  }
}
