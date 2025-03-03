import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/services/auth_service.dart';

class MainSettings extends StatefulWidget {
  const MainSettings({super.key});

  @override
  State<MainSettings> createState() => _MainSettingsState();
}

class _MainSettingsState extends State<MainSettings> {
  final List<String> adImages = [
    "https://images.pexels.com/photos/376464/pexels-photo-376464.jpeg",
  ];

  List<String> trendingImages = [];

  @override
  void initState() {
    super.initState();
    // Fetch images from Firestore
    fetchTrendingImages();
  }

// Method to fetch images from Firestore
  Future<void> fetchTrendingImages() async {
    try {
      // Fetch data from Firestore collection (assuming collection name is 'trending_images')
      final snapshot =
          await FirebaseFirestore.instance.collection('trending_images').get();
      List<String> imageUrls = [];
      snapshot.docs.forEach((doc) {
        imageUrls.add(
            doc['url']); // Assuming the field containing the image URL is 'url'
      });

      setState(() {
        trendingImages = imageUrls; // Set the state with fetched URLs
      });
    } catch (e) {
      print("Error fetching images: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Dashboard"),
        backgroundColor: Colors.white,
      ),
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
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        width: double.infinity,
                        child: Icon(Icons.broken_image,
                            size: 50, color: Colors.grey),
                      );
                    },
                  ),
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
                  child: Image.network(
                    trendingImages[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Icon(Icons.broken_image,
                            size: 50, color: Colors.grey),
                      );
                    },
                  ),
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
  CustomDrawer({super.key});
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
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
              icon: Icons.shopping_bag, title: "My order", route: "/"),
          DrawerMenuItem(icon: Icons.person, title: "My Profile", route: "/"),
          DrawerMenuItem(icon: Icons.chat, title: "Chats", route: "/chat"),
          DrawerMenuItem(
              icon: Icons.local_shipping,
              title: "Delivery Address",
              route: "/"),
          DrawerMenuItem(
              icon: Icons.payment, title: "Payment Methods", route: "/"),
          DrawerMenuItem(icon: Icons.mail, title: "Contact Us", route: "/"),
          DrawerMenuItem(
              icon: Icons.settings, title: "Settings", route: "/settings"),
          DrawerMenuItem(icon: Icons.help, title: "Helps Us FAQs", route: "/"),
          Spacer(),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                await _authService.signOut();
                context.push("/login");
              },
              icon: Icon(
                Icons.power_settings_new,
                color: Colors.deepPurpleAccent,
                size: 25,
              ),
              label: Text(
                "Log Out",
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 186, 163, 251),
                foregroundColor: Colors.white,
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
        context.push(route);
      },
    );
  }
}
