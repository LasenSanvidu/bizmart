import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// A StatefulWidget that displays the user's profile information
class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // User profile fields with sensible defaults
  String _username = '';
  String _firstName = '';
  String _lastName = '';
  String _mobile = '';
  String _email = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  /// Fetches user data from Firestore with comprehensive error handling
  Future<void> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      
      if (user == null) {
        debugPrint('No authenticated user found');
        _updateLoadingState(false);
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        debugPrint('User data retrieved successfully: $userData');
        _updateProfileData(userData);
      } else {
        debugPrint('User document does not exist');
        _updateLoadingState(false);
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      _updateLoadingState(false);
    }
  }

  /// Updates profile data in state
  void _updateProfileData(Map<String, dynamic> data) {
    setState(() {
      _username = data['username'] ?? 'Not Set';
      _firstName = data['firstName'] ?? '';
      _lastName = data['lastName'] ?? '';
      _mobile = data['mobile'] ?? 'Not Provided';
      _email = data['email'] ?? 'Not Available';
      _isLoading = false;
    });
  }

  /// Updates loading state
  void _updateLoadingState(bool loading) => setState(() => _isLoading = loading);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: _buildAppBar(),
      body: _isLoading ? _buildLoadingView() : _buildProfileView(),
    );
  }

  /// Constructs the custom app bar with elegant styling
  AppBar _buildAppBar() => AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      );

  /// Displays a loading indicator during data fetch
  Widget _buildLoadingView() => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
          strokeWidth: 3,
        ),
      );

  /// Builds the main profile content with a gradient background
  Widget _buildProfileView() => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black87,
              Colors.blueGrey.shade900,
            ],
            stops: const [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildProfileAvatar(),
                const SizedBox(height: 32),
                _buildProfileDetails(),
                const SizedBox(height: 32),
                _buildEditProfileButton(),
              ],
            ),
          ),
        ),
      );

  /// Creates a stylish profile avatar with gradient border
  Widget _buildProfileAvatar() => Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Colors.blueGrey.shade300,
              Colors.blueGrey.shade700,
              Colors.black87,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const CircleAvatar(
          radius: 60,
          backgroundColor: Colors.white10,
          child: Icon(
            Icons.person_rounded,
            size: 70,
            color: Colors.white70,
          ),
        ),
      );

  /// Constructs the profile information section
  Widget _buildProfileDetails() => Column(
        children: [
          _buildInfoTile('Username', _username, Icons.person_outline),
          _buildInfoTile('Full Name', '$_firstName $_lastName', Icons.account_circle),
          _buildInfoTile('Email', _email, Icons.email_outlined),
          _buildInfoTile('Mobile', _mobile, Icons.phone_outlined),
        ],
      );

  /// Builds individual information tiles with modern design
  Widget _buildInfoTile(String title, String value, IconData icon) => Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Card(
          elevation: 4,
          color: Colors.white.withOpacity(0.05),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.blueGrey.shade200,
                  size: 28,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        value.trim().isEmpty ? 'Not Set' : value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  /// Creates an attractive edit profile button
  Widget _buildEditProfileButton() => ElevatedButton.icon(
        onPressed: () {
          // TODO: Implement navigation to edit profile screen
          debugPrint('Edit profile button pressed');
        },
        icon: const Icon(Icons.edit_rounded, size: 20),
        label: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey.shade700,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 6,
          shadowColor: Colors.black45,
        ),
      );
}