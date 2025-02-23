import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainSettings extends StatelessWidget {
  const MainSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      drawer: CustomDrawer(), // Add custom drawer
      body: Center(
        child: Text("Home Screen Content"),
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              "Austin Miller",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            accountEmail: Text(
              "austinM@gmail.com",
              style: TextStyle(color: Colors.black),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 207, 207, 207),
              child: Icon(Icons.person,
                  size: 50, color: const Color.fromARGB(255, 159, 159, 159)),
            ),
            decoration: BoxDecoration(color: Colors.white),
          ),

          DrawerMenuItem(
            icon: Icons.shopping_bag,
            title: "My order",
            route: "/",
          ),
          DrawerMenuItem(
            icon: Icons.person,
            title: "My Profile",
            route: "/",
          ),
          DrawerMenuItem(
            icon: Icons.chat,
            title: "Chats",
            route: "/chat",
          ),
          DrawerMenuItem(
            icon: Icons.local_shipping,
            title: "Delivery Address",
            route: "/",
          ),
          DrawerMenuItem(
            icon: Icons.payment,
            title: "Payment Methods",
            route: "/",
          ),
          DrawerMenuItem(
            icon: Icons.mail,
            title: "Contact Us",
            route: "/",
          ),
          DrawerMenuItem(
            icon: Icons.settings,
            title: "Settings",
            route: "/settings",
          ), // Navigate to Settings Page
          DrawerMenuItem(
            icon: Icons.help,
            title: "Helps Us FAQs",
            route: "/",
          ),

          Spacer(),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                context.go("/");
              },
              icon: Icon(Icons.power_settings_new, color: Colors.purple),
              label: Text("Log Out"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 236, 213, 240),
                foregroundColor: Colors.black,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable Drawer Menu Item
class DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;

  const DrawerMenuItem(
      {super.key,
      required this.icon,
      required this.title,
      required this.route});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: TextStyle(fontSize: 16)),
      onTap: () {
        context.go(route); // Navigate using GoRouter
      },
    );
  }
}
