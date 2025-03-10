import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // User profile data
  String username = '';
  String firstName = '';
  String lastName = '';
  String mobile = '';
  String email = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch user data from Firestore with error handling
  Future<void> _fetchUserData() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      
      if (userId == null) {
        debugPrint('No authenticated user found');
        setState(() => isLoading = false);
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        debugPrint('User data retrieved: $userData');

        setState(() {
          username = userData['username'] ?? 'N/A';
          firstName = userData['firstName'] ?? 'N/A';
          lastName = userData['lastName'] ?? 'N/A';
          mobile = userData['mobile'] ?? 'N/A';
          email = userData['email'] ?? 'N/A';
          isLoading = false;
        });
      } else {
        debugPrint('User document not found');
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint('Error retrieving user data: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: _buildAppBar(),
      body: isLoading ? _buildLoadingIndicator() : _buildProfileContent(),
    );
  }

  // Custom AppBar
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'My Profile',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  // Loading indicator
  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
      ),
    );
  }

  // Main profile content
  Widget _buildProfileContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black87,
            Colors.blueGrey.shade900,
          ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _buildProfileAvatar(),
              const SizedBox(height: 32),
              _buildProfileInfo(),
              const SizedBox(height: 32),
              _buildEditButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Profile avatar with gradient
  Widget _buildProfileAvatar() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.blueGrey.shade300, Colors.black87],
        ),
      ),
      child: const CircleAvatar(
        radius: 60,
        backgroundColor: Colors.white12,
        child: Icon(
          Icons.person_rounded,
          size: 70,
          color: Colors.white70,
        ),
      ),
    );
  }

  // Profile information cards
  Widget _buildProfileInfo() {
    return Column(
      children: [
        _buildInfoCard('Username', username, Icons.person_outline),
        _buildInfoCard('Full Name', '$firstName $lastName', Icons.account_circle),
        _buildInfoCard('Email', email, Icons.email_outlined),
        _buildInfoCard('Mobile', mobile, Icons.phone_outlined),
      ],
    );
  }

  // Individual info card
  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      color: Colors.white.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Colors.blueGrey.shade200, size: 28),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Edit profile button
  Widget _buildEditButton() {
    return ElevatedButton.icon(
      onPressed: () {
        // TODO: Implement edit profile functionality
      },
      icon: const Icon(Icons.edit, size: 20),
      label: const Text('Edit Profile'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey.shade700,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
      ),
    );
  }
}