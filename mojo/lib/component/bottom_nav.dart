import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
  
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return 
      /*body: Center(
        //child: Text('Selected Index: $_selectedIndex'),
      ),*/
      BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 0,
        items:[
          BottomNavigationBarItem(
            icon: Image.asset(
              'lib/Icons/home-agreement.png',
              height: 30, // previous was 34
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'lib/Icons/shopping-bag.png',
              height: 30,
            ),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'lib/Icons/wallet.png',
              height: 30,
            ),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Image.asset(
                'lib/Icons/secure.png',
                height: 30,
              ),
            ),
            label: 'Secure',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'lib/Icons/user.png',
              height: 30, 
            ),
            label: 'User',
          ),
        ],
      );
  }
}