import 'dart:convert';
import 'dart:math';
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
import 'package:myapp/models/product_and_store_model.dart';
import 'package:myapp/profile/profile_image_en-decoder.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:myapp/shop/product_details_users.dart';
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
  List<Product> _trendingProducts = [];
  bool _isRefreshingProducts = false;

  @override
  void initState() {
    super.initState();
    fetchAdImages();
    _loadUserName();
    fetchTrendingProducts();
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
      if (mounted) {
        setState(() {
          adImages = images;
        });
      }
    } catch (e) {
      print("Error fetching images: $e");
    }
  }

  Future<void> fetchTrendingProducts() async {
    try {
      // Query to fetch latest 4 products ordered by creation date
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .limit(50) // Limit to 50 products for better performance
          .get();

      int totalDocs = snapshot.docs.length;

      if (totalDocs > 4) {
        List<Product> products = [];

        Random random = Random();

        Set<int> selectedIndices = {};

        while (
            selectedIndices.length < 4 && selectedIndices.length < totalDocs) {
          int randomIndex = random.nextInt(totalDocs);
          if (!selectedIndices.contains(randomIndex)) {
            selectedIndices.add(randomIndex);

            DocumentSnapshot doc = snapshot.docs[randomIndex];

            products.add(Product(
              id: doc['id'],
              prodname: doc['prodname'],
              image: doc['image'],
              prodprice: doc['prodprice'].toDouble(),
              description: doc['description'],
            ));
          }
        }

        // Update the state to trigger UI refresh
        if (mounted) {
          setState(() {
            _trendingProducts = products;
          });
        }
      } else {
        // If there are less than 4 products, fetch all of them
        List<Product> products = snapshot.docs.map((doc) {
          return Product(
            id: doc['id'],
            prodname: doc['prodname'],
            image: doc['image'],
            prodprice: doc['prodprice'].toDouble(),
            description: doc['description'],
          );
        }).toList();

        setState(() {
          _trendingProducts = products;
        });
      }
    } catch (e) {
      print("Error fetching trending products: $e");
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
              CustomerFlowScreen.of(context)?.setNewScreen(InquiryPage());
            },
          ),
        ],
        backgroundColor: Colors.white,
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            // Welcome banner with gradient background
            Container(
              padding: const EdgeInsets.only(left: 0, right: 0),
              child: Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.black, Color(0xFF303030)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
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
                            fontSize: 23,
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Text(
                "Featured for you",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),

            // Enhanced Carousel with indicators
            Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 180.0,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      enableInfiniteScroll: true,
                      viewportFraction: 0.85,
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                    ),
                    items: adImages.isNotEmpty
                        ? adImages.map((imageUrl) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.memory(
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
                              ),
                            );
                          }).toList()
                        : [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                'https://static.vecteezy.com/system/resources/previews/022/014/063/original/missing-picture-page-for-website-design-or-mobile-app-design-no-image-available-icon-vector.jpg',
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
                ],
              ),
            ),

            // section between carousel and trending
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue.shade50, Colors.blue.shade100],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade100.withOpacity(0.6),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline,
                          color: Colors.amber.shade700),
                      SizedBox(width: 8),
                      Text(
                        "Today's Highlights",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Discover our newest collection and exclusive deals tailored just for you. Check out our trending products below!",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ],
              ),
            ),

            // Improved Trending section header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "TRENDING",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (mounted) {
                        setState(() {
                          _isRefreshingProducts = true;
                        });
                      }

                      // Refresh only the trending products
                      await fetchTrendingProducts();

                      // Update only the products refresh state
                      if (mounted) {
                        setState(() {
                          _isRefreshingProducts = false;
                        });
                      }

                      await fetchTrendingProducts();
                    },
                    child: Text(
                      "Refresh All",
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            _isRefreshingProducts
                ? Center(
                    child: Container(
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            "Refreshing products...",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _trendingProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.8, // Make items slightly taller
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                // TODO: Navigate to product detail page
                                CustomerFlowScreen.of(context)?.setNewScreen(
                                  ProductDetailsUserPage(
                                      product: _trendingProducts[index]),
                                );
                              },
                              splashColor: Colors.black.withOpacity(0.1),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  // Product Image
                                  _trendingProducts[index]
                                          .image
                                          .startsWith('data:')
                                      ? Hero(
                                          tag:
                                              'product-${_trendingProducts[index].id}',
                                          child: Image.memory(
                                            base64Decode(
                                                _trendingProducts[index]
                                                    .image
                                                    .split(',')[1]),
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                color: Colors.grey[100],
                                                child: Icon(
                                                    Icons
                                                        .image_not_supported_outlined,
                                                    size: 50,
                                                    color: Colors.grey[400]),
                                              );
                                            },
                                          ),
                                        )
                                      : Container(
                                          color: Colors.grey[100],
                                          child: Icon(
                                              Icons
                                                  .image_not_supported_outlined,
                                              size: 50,
                                              color: Colors.grey[400]),
                                        ),

                                  // Gradient overlay for better text readability
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.7),
                                          ],
                                          stops: [0.0, 0.7, 1.0],
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Product name and price
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            _trendingProducts[index].prodname,
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 3),
                                          Text(
                                            '\RS ${_trendingProducts[index].prodprice.toStringAsFixed(2)}',
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Sale badge (for items with higher prices)
                                  if (_trendingProducts[index].prodprice > 6000)
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'Top Pick',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
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
