import 'package:flutter/material.dart';
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
}
