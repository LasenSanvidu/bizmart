import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:myapp/business_dashboard.dart';
import 'package:myapp/main_settings.dart';
import 'package:myapp/profile.dart';
import 'package:myapp/shop/my_store_ui.dart';
import 'package:myapp/stripe/payment.dart';

class BusinessFlowScreens extends StatefulWidget {
  const BusinessFlowScreens({super.key});

  static _BusinessFlowScreensState? of(BuildContext context) =>
      context.findAncestorStateOfType<_BusinessFlowScreensState>();

  @override
  State<BusinessFlowScreens> createState() => _BusinessFlowScreensState();
}

class _BusinessFlowScreensState extends State<BusinessFlowScreens> {
  int _currentIndex = 0;
  /**/ Widget? _activeScreen;

  final List<Widget> _pages = [
    MainSettings(),
    MyStoreUi(),
    Payment(),
    BusinessDashboardScreen(),
    Profile(),
    //StorePage()
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
