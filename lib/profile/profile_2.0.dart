/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // User data variables
  String username = "";
  String firstName = "";
  String lastName = "";
  String mobile = "";
  String email = "";
  bool isLoading = true; // To track loading state

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch data when the page loads
  }

  // Fetch user data from Firebase
  void fetchUserData() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        print("User ID is null.");
        return;
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;
        print("Fetched User Data: $userData"); // Debugging step

        setState(() {
          username = userData['username'] ?? "Unknown"; // Adjust key if needed
          firstName =
              userData['first_name'] ?? "Unknown"; // Adjust key if needed
          lastName = userData['last_name'] ?? "Unknown"; // Adjust key if needed
          mobile = userData['mobile'] ?? "Unknown"; // Adjust key if needed
          email = userData['email'] ??
              "Unknown"; // Email works, so it's likely correct
          isLoading = false;
        });
      } else {
        print("User document does not exist.");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title:
            const Text("User Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.blueGrey],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      // Profile Avatar
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.2),
                                spreadRadius: 4,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.white24,
                            child: Icon(Icons.person,
                                color: Colors.white, size: 60),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Profile Info
                      profileInfoCard("Username", username, Icons.person),
                      profileInfoCard(
                          "Full Name", "$firstName $lastName", Icons.badge),
                      profileInfoCard("Email", email, Icons.email),
                      profileInfoCard("Mobile", mobile, Icons.phone),

                      const SizedBox(height: 20),

                      // Edit Profile Button
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Implement Edit Profile functionality
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Edit Profile",
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // Profile Info Card with Icons
  Widget profileInfoCard(String title, String value, IconData icon) {
    return Card(
      color: Colors.white10,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/component/customer_flow_screen.dart';
import 'package:myapp/profile/edit_profile.dart';
import 'package:myapp/profile/profile_image_en-decoder.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // User data variables
  String username = "";
  String firstName = "";
  String lastName = "";
  String mobile = "";
  String email = "";
  bool isLoading = true; // To track loading state
  String? profileImageBase64;

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch data when the page loads
  }

  // Fetch user data from Firebase
  void fetchUserData() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        print("User ID is null.");
        return;
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!mounted) return;

      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;
        print("Fetched User Data: $userData");

        // Get profile image
        String? image = await ProfileImageHandler.getProfileImage();

        if (!mounted) return;

        setState(() {
          username = userData['username'] ?? "Unknown";
          firstName = userData['first_name'] ?? "Unknown";
          lastName = userData['last_name'] ?? "Unknown";
          mobile = userData['mobile'] ?? "Unknown";
          email = userData['email'] ?? "Unknown";
          profileImageBase64 = image;
          isLoading = false;
        });
      } else {
        print("User document does not exist.");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "My Profile",
          style: GoogleFonts.poppins(
            fontSize: 22,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black54, size: 22),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Implement settings action
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: Color(0xFF3E64FF),
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Loading profile...",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  )
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Header with Gradient Background
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Profile Avatar with better shadows
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ProfileImageHandler.profileImageWidget(
                                  base64Image: profileImageBase64,
                                  firstName: firstName,
                                  lastName: lastName,
                                  radius: 60),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF3E64FF)
                                        .withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // User name with better typography
                        Text(
                          "$firstName $lastName",
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "@$username",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: const Color(0xFF3E64FF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Personal Information Section
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 20, bottom: 8),
                          child: Text(
                            "Personal Information",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        profileInfoItem(
                          Icons.email_rounded,
                          "Email",
                          email,
                          Colors.orange.shade400,
                        ),
                        const Divider(
                            height: 1,
                            thickness: 0.5,
                            color: Color(0xFFEEEEEE)),
                        profileInfoItem(
                          Icons.phone_rounded,
                          "Mobile",
                          mobile,
                          Colors.green.shade400,
                        ),
                        const Divider(
                            height: 1,
                            thickness: 0.5,
                            color: Color(0xFFEEEEEE)),
                        profileInfoItem(
                          Icons.person_rounded,
                          "Username",
                          username,
                          Colors.purple.shade400,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  const SizedBox(height: 42),

                  // Edit Profile Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Edit Profile",
                        style: GoogleFonts.poppins(
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  // Get initials from name
  String getInitials(String firstName, String lastName) {
    String firstInitial = firstName.isNotEmpty ? firstName[0] : "";
    String lastInitial = lastName.isNotEmpty ? lastName[0] : "";
    return "$firstInitial$lastInitial".toUpperCase();
  }

  // Profile Info Item with colored icon background
  Widget profileInfoItem(
      IconData icon, String title, String value, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
