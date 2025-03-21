import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/Inquiry_page.dart';
import 'package:myapp/business_dashboard.dart';
import 'package:myapp/chat/chat_list_screen.dart';
import 'package:myapp/component/customer_flow_screen.dart';
import 'package:myapp/contact_us.dart';
import 'package:myapp/faqs.dart';
import 'package:myapp/profile/profile_image_en-decoder.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainSettings extends StatefulWidget {
  const MainSettings({super.key});

  @override
  _MainSettingsState createState() => _MainSettingsState();
}

class _MainSettingsState extends State<MainSettings> {
  List<String> adImages = [];
  String _userName = "User";
  final List<String> trendingImages = [
    "https://images.pexels.com/photos/3184287/pexels-photo-3184287.jpeg",
    "https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=1999&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://images.unsplash.com/photo-1503602642458-232111445657?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "https://dmc.dilmahtea.com/web-space/dmc/heritage-centre/54ceb91256e8190e474aa752a6e0650a2df5ba37/500_500.154080881152699.jpg"
  ];

  @override
  void initState() {
    super.initState();
    fetchAdImages();
    _loadUserName();
  }

  /// Fetch latest ad images from Firestore and update expired URLs
  Future<void> fetchAdImages() async {
    try {
      DateTime sevenDaysAgo = DateTime.now().subtract(Duration(days: 7));

      // Query to fetch the latest 5 images updated within the last 7 days
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('ads')
          .where('updatedAt', isGreaterThanOrEqualTo: sevenDaysAgo)
          .orderBy('updatedAt',
              descending: true) // Sort by update date (latest first)
          .limit(5) // Limit to 5 images
          .get();

      List<String> images = [];

      for (var doc in snapshot.docs) {
        String imageUrl = doc['imageUrl'] ?? '';

        // Add the image URL to the list
        if (imageUrl.isNotEmpty) {
          images.add(imageUrl);
        }
      }

      // Update the state to trigger UI refresh
      setState(() {
        adImages = images;
      });
    } catch (e) {
      print("Error fetching images: $e");
    }
  }

  Future<void> _loadUserName() async {
    String? username = await AuthService().getUsername();
    if (mounted) {
      setState(() {
        _userName = username ?? "User";
      });
    }
  }

  /// Refresh expired Firebase Storage URL
  Future<String> refreshImageUrl(String path) async {
    return await FirebaseStorage.instance.ref(path).getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Dashboard"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.question_answer_rounded, color: Colors.black),
            onPressed: () {
              // Implement navigation
              CustomerFlowScreen.of(context)?.setNewScreen(InquiryPage());
            },
          ),
        ],
        backgroundColor: Colors.white,
      ),
      drawer: CustomDrawer(), // Use your custom drawer
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(left: 0, right: 0),
              child: Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  //borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi $_userName",
                          style: GoogleFonts.caveat(
                            fontSize: 44,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Welcome back",
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Image Carousel with Loading Indicator
            CarouselSlider(
              options: CarouselOptions(
                height: 180.0,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                enableInfiniteScroll: true,
              ),
              items: adImages.isNotEmpty
                  ? adImages.map((imageUrl) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: imageUrl.startsWith(
                                'http') // Check if the image is a normal URL
                            ? Image.network(
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
                              )
                            : Image.memory(
                                base64Decode(imageUrl.split(',')[1]),
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
                    }).toList()
                  : [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          'https://static.vecteezy.com/system/resources/previews/022/014/063/original/missing-picture-page-for-website-design-or-mobile-app-design-no-image-available-icon-vector.jpg', // Hardcoded fallback image URL
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
                      ),
                    ],
            ),

            SizedBox(height: 20),

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
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(child: CircularProgressIndicator());
                    },
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
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Drawer Menu
class CustomDrawer extends StatefulWidget {
  CustomDrawer({super.key});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final AuthService _authService = AuthService();
  String userName = "Loading..."; // Default text until data is fetched
  String userEmail = "Loading..."; // Default text until data is fetched
  String? profileImageBase64;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load user data from Firebase and update UI
  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    //Try to get data from SharedPreferences first (for quick display)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cachedName = prefs.getString('userName') ?? "";
    String cachedEmail = prefs.getString('userEmail') ?? "";
    String? cachedProfileImage = prefs.getString('profileImage');

    if (cachedName.isNotEmpty && cachedEmail.isNotEmpty) {
      // If we have cached data, show it immediately
      if (mounted) {
        setState(() {
          userName = cachedName;
          userEmail = cachedEmail;
          profileImageBase64 = cachedProfileImage;
          _isLoading = false;
        });
      }
    }

    // Get the current user from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String? username = await AuthService().getUsername();
      String? image = await ProfileImageHandler.getProfileImage();
      // Checking if widget is still mounted before calling setState
      if (!mounted) return;
      // Fetch user data from Firebase and only update state id new data is different from cashed data.
      if (username != userName ||
          user.email != userEmail ||
          image != profileImageBase64) {
        setState(() {
          userName =
              username ?? "Guest User"; // Default to "Guest User" if null
          userEmail = user.email ?? "No Email"; // Default to "No Email" if null
          profileImageBase64 = image;
          _isLoading = false;
        });

        // Save the updated data to SharedPreferences (cashe data)
        prefs.setString('userName', userName);
        prefs.setString('userEmail', userEmail);
        if (image != null) {
          prefs.setString('profileImage', image);
        } else {
          prefs.remove('profileImage');
        }
      }
    } else {
      // Checking if widget is still mounted before calling setState
      if (mounted) {
        // Handle case if no user is logged in
        setState(() {
          userName = "Guest User";
          userEmail = "No Email";
          profileImageBase64 = null;
          _isLoading = false;
        });
      }

      // Clear cached data if user is not logged in
      prefs.remove('userName');
      prefs.remove('userEmail');
      prefs.remove('profileImage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
            color: Colors.white,
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: ProfileImageHandler.profileImageWidget(
                        base64Image: profileImageBase64,
                        firstName: userName,
                        lastName: userName.split(' ').length > 1
                            ? userName.split(' ').last
                            : "",
                        radius: 50,
                      )),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          userName,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          userEmail,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
          ),
          // Other Drawer Menu Items
          DrawerMenuItem(
              icon: Icons.person, title: "My Profile" /*, route: "/"*/),
          SizedBox(height: 5),
          DrawerMenuItem(
            icon: Icons.shopping_bag,
            title: "My Business",
            onTap: () {
              CustomerFlowScreen.of(context)
                  ?.setNewScreen(BusinessDashboardScreen());
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 5),
          DrawerMenuItem(
            icon: Icons.chat,
            title: "Chats",
            /*route: "/chat"*/ onTap: () {
              CustomerFlowScreen.of(context)?.setNewScreen(ChatListScreen());
              Navigator.pop(context); // Close the drawer
            },
          ),
          SizedBox(height: 5),
          DrawerMenuItem(
            icon: Icons.mail,
            title: "Contact Us",
            onTap: () {
              CustomerFlowScreen.of(context)?.setNewScreen(ContactUsPage());
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 5),
          DrawerMenuItem(
            icon: Icons.help,
            title: "FAQs",
            onTap: () {
              CustomerFlowScreen.of(context)?.setNewScreen(FAQPage());
              Navigator.pop(context);
            },
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                bool rememberPassword =
                    prefs.getBool('rememberPassword') ?? false;

                if (!rememberPassword) {
                  prefs.remove('email');
                  prefs.remove('password');
                  prefs.remove('rememberPassword');
                }

                prefs.remove('profileImage');
                await _authService.signOut();
                context.push("/login");
              },
              icon: Icon(
                Icons.power_settings_new,
                color: Colors.white,
                size: 25,
              ),
              label: Text(
                "Log Out",
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
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
  //final String route;
  final String? route; // Make route nullable
  final VoidCallback? onTap; // Allow custom onTap behavior

  const DrawerMenuItem({
    super.key,
    required this.icon,
    required this.title,
    //required this.route
    this.route, // Optional route
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: GoogleFonts.poppins(fontSize: 18)),
      /*onTap: () {
        context.push(route);
      },*/
      onTap: onTap ??
          () {
            if (route != null) {
              context.push(route!);
            }
          },
    );
  }
}
