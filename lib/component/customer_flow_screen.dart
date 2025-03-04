import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:myapp/business_dashboard.dart';
import 'package:myapp/main_settings.dart';
import 'package:myapp/notification_page.dart';
import 'package:myapp/settings_customer.dart';
import 'package:myapp/shop/my_store_ui.dart';
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
