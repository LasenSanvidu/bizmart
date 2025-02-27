import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';

class MainSettings extends StatelessWidget {
  MainSettings({super.key});

  final List<String> adImages = [
    "https://images.pexels.com/photos/376464/pexels-photo-376464.jpeg",
    "https://images.pexels.com/photos/70497/pexels-photo-70497.jpeg",
    "https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg",
    "https://source.unsplash.com/600x400/?fries",
    "https://source.unsplash.com/600x400/?snacks",
  ];

  final List<String> trendingImages = [
    "https://images.pexels.com/photos/3184287/pexels-photo-3184287.jpeg",
    "https://images.pexels.com/photos/1181671/pexels-photo-1181671.jpeg",
    "https://source.unsplash.com/600x600/?businessman",
    "https://source.unsplash.com/600x600/?technology",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel
            CarouselSlider(
              options: CarouselOptions(
                height: 180.0,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                enableInfiniteScroll: true,
              ),
              items: adImages.map((imageUrl) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(imageUrl,
                      fit: BoxFit.cover, width: double.infinity),
                );
              }).toList(),
            ),

            SizedBox(height: 20),

            // Trending Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "TRENDING",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 10),

            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: trendingImages.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                      Image.network(trendingImages[index], fit: BoxFit.cover),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Drawer Menu
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
            accountEmail: Text("austinM@gmail.com",
                style: TextStyle(color: Colors.black)),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Color.fromARGB(255, 207, 207, 207),
              child: Icon(Icons.person,
                  size: 50, color: Color.fromARGB(255, 159, 159, 159)),
            ),
            decoration: BoxDecoration(color: Colors.white),
          ),
          DrawerMenuItem(
              icon: Icons.shopping_bag, title: "My order", route: "/main"),
          DrawerMenuItem(
              icon: Icons.person, title: "My Profile", route: "/main"),
          DrawerMenuItem(icon: Icons.chat, title: "Chats", route: "/chat"),
          // DrawerMenuItem(
          //     icon: Icons.local_shipping,
          //     title: "Delivery Address",
          //     route: "/main"),
          DrawerMenuItem(
              icon: Icons.payment, title: "Payment Methods", route: "/"),
          DrawerMenuItem(icon: Icons.mail, title: "Contact Us", route: "/main"),
          DrawerMenuItem(
              icon: Icons.settings, title: "Settings", route: "/settings"),
          DrawerMenuItem(
              icon: Icons.help, title: "Helps Us FAQs", route: "/main"),
          
          Spacer(),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                context.go("/login");
              },
              icon: Icon(Icons.power_settings_new, color: Colors.purple),
              label: Text("Log Out"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 236, 213, 240),
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

// Drawer Menu Item
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
        context.go(route);
      },
    );
  }
}
