/*import 'package:chat/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String username = "";
  String firstName = "";
  String lastName = "";
  String mobile = "";
  String email = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

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
        setState(() {
          username = userData['username'] ?? "Unknown";
          firstName = userData['first_name'] ?? "Unknown";
          lastName = userData['last_name'] ?? "Unknown";
          mobile = userData['mobile'] ?? "Unknown";
          email = userData['email'] ?? "Unknown";
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        title: const Text(
          "User Profile",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black26,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.black),
            )
          : Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Profile Avatar with enhanced styling
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 4,
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.black12,
                            child: Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 70,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Profile Info Cards
                      profileInfoCard("Username", username, Icons.person),
                      profileInfoCard(
                          "Full Name", "$firstName $lastName", Icons.badge),
                      profileInfoCard("Email", email, Icons.email),
                      profileInfoCard("Mobile", mobile, Icons.phone),

                      const SizedBox(height: 30),

                      // Edit Profile Button with enhanced styling
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditProfileScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          shadowColor: Colors.black54,
                        ),
                        child: const Text(
                          "Edit Profile",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget profileInfoCard(String title, String value, IconData icon) {
    return Card(
      elevation: 3,
      color: Colors.white,
      shadowColor: Colors.black26,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: Colors.black12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Colors.black,
            size: 28,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animate_do/animate_do.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // Profile data
  String _username = '';
  String _firstName = '';
  String _lastName = '';
  String _mobile = '';
  String _email = '';
  bool _isLoading = true;

  // Theme constants
  static const _gradientColors = [
    Color(0xFF1A2238),
    Color(0xFF2A4066),
    Color(0xFF3D6199),
  ];
  static const _accentColor = Colors.cyanAccent;
  static const _textColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint('No authenticated user found');
        return _updateLoadingState(false);
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        debugPrint('User data retrieved: $userData');
        _updateProfileData(userData);
      } else {
        debugPrint('User document not found');
        _updateLoadingState(false);
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      _updateLoadingState(false);
    }
  }

  void _updateProfileData(Map<String, dynamic> data) => setState(() {
        _username = data['username'] ?? 'Not Set';
        _firstName = data['firstName'] ?? '';
        _lastName = data['lastName'] ?? '';
        _mobile = data['mobile'] ?? 'Not Provided';
        _email = data['email'] ?? 'Not Available';
        _isLoading = false;
      });

  void _updateLoadingState(bool loading) => setState(() => _isLoading = loading);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: _isLoading ? _buildLoadingView() : _buildProfileView(),
    );
  }

  AppBar _buildAppBar() => AppBar(
        title: FadeInDown(
          duration: const Duration(milliseconds: 600),
          child: Text(
            'My Profile',
            style: TextStyle(
              color: _textColor,
              fontWeight: FontWeight.bold,
              fontSize: 26,
              letterSpacing: 1.2,
              shadows: [
                Shadow(
                  color: _accentColor.withOpacity(0.5),
                  blurRadius: 15,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: _textColor),
      );

  Widget _buildLoadingView() => Center(
        child: Spin(
          duration: const Duration(milliseconds: 1000),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
            backgroundColor: Colors.white.withOpacity(0.1),
            strokeWidth: 5,
          ),
        ),
      );

  Widget _buildProfileView() => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _gradientColors,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FadeInUp(child: _buildProfileAvatar()),
                  const SizedBox(height: 48),
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: _buildProfileDetails(),
                  ),
                  const SizedBox(height: 48),
                  ZoomIn(
                    delay: const Duration(milliseconds: 400),
                    child: _buildEditProfileButton(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildProfileAvatar() => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: SweepGradient(
            center: Alignment.center,
            colors: [
              _accentColor,
              Colors.purpleAccent,
              Colors.blueAccent,
              _accentColor,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: _accentColor.withOpacity(0.4),
              blurRadius: 25,
              spreadRadius: 3,
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 75,
          backgroundColor: Colors.black.withOpacity(0.8),
          child: Icon(
            Icons.person_rounded,
            size: 90,
            color: _textColor.withOpacity(0.9),
          ),
        ),
      );

  Widget _buildProfileDetails() => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.black.withOpacity(0.5),
          border: Border.all(
            color: _accentColor.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildInfoTile('Username', _username, Icons.person_outline),
            _buildDivider(),
            _buildInfoTile('Full Name', '$_firstName $_lastName', Icons.account_circle),
            _buildDivider(),
            _buildInfoTile('Email', _email, Icons.email_outlined),
            _buildDivider(),
            _buildInfoTile('Mobile', _mobile, Icons.phone_outlined),
          ],
        ),
      );

  Widget _buildDivider() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Divider(
          color: _textColor.withOpacity(0.1),
          thickness: 1,
          height: 20,
        ),
      );

  Widget _buildInfoTile(String title, String value, IconData icon) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _accentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: _accentColor.withOpacity(0.2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: _accentColor,
                size: 32,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: _textColor.withOpacity(0.7),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value.trim().isEmpty ? 'Not Set' : value,
                    style: TextStyle(
                      color: _textColor,
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildEditProfileButton() => ElevatedButton.icon(
        onPressed: () => debugPrint('Edit profile tapped'),
        icon: const Icon(Icons.edit_rounded, size: 24),
        label: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
          backgroundColor: _accentColor,
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 12,
          shadowColor: _accentColor.withOpacity(0.6),
          animationDuration: const Duration(milliseconds: 400),
        ),
      );
}