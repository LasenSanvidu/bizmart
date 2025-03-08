import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(200.0), // Adjust the height of the app bar
        child: Container(
          color: const Color.fromARGB(255, 184, 161, 249),
          child: Column(
            children: [
              AppBar(
                automaticallyImplyLeading:
                    false, // Remove the default leading widget
                backgroundColor: Colors.transparent,
                title: Text(
                  "Settings",
                  style: GoogleFonts.poppins(
                      fontSize: 25, fontWeight: FontWeight.w400),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      // Add settings options here
                    },
                  )
                ],
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    context.push("/main"); // Allows going back
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 184, 161, 249),
                  borderRadius: BorderRadius.circular(1),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child:
                          Icon(Icons.person, size: 50, color: Colors.black54),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Ingredia Nutrisha",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            "A/N:0751234567",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: const [
                SettingsTile(
                    icon: Icons.notifications,
                    title: "Notifications",
                    subtitle: "Change Notification Settings"),
                SettingsTile(
                    icon: Icons.lock,
                    title: "Password",
                    subtitle: "Change Password Settings"),
                SettingsTile(
                    icon: Icons.access_time,
                    title: "Time",
                    subtitle: "Change Time Settings"),
                SettingsTile(
                    icon: Icons.bar_chart,
                    title: "Statistics",
                    subtitle: "Change Statistics Settings"),
                SettingsTile(
                    icon: Icons.credit_card,
                    title: "Card",
                    subtitle: "Change Card Settings"),
                SettingsTile(
                    icon: Icons.date_range,
                    title: "Date",
                    subtitle: "Change Date Settings"),
              ],
            ),
          )
        ],
      ),
      /*bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),*/
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 30, color: Colors.black54),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black54),
      onTap: () {},
    );
  }
}
