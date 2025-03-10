import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animate_do/animate_do.dart'; // Add this package for animations

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
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
          child: const Text(
            'My Profile',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 24,
              shadows: [
                Shadow(color: Colors.blueAccent, blurRadius: 10),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      );

  Widget _buildLoadingView() => Center(
        child: Spin(
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
            strokeWidth: 4,
            backgroundColor: Colors.white12,
          ),
        ),
      );

  Widget _buildProfileView() => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  FadeInUp(child: _buildProfileAvatar()),
                  const SizedBox(height: 40),
                  FadeInUp(child: _buildProfileDetails(), delay: const Duration(milliseconds: 200)),
                  const SizedBox(height: 40),
                  ZoomIn(child: _buildEditProfileButton()),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildProfileAvatar() => Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const SweepGradient(
            colors: [
              Colors.cyan,
              Colors.purple,
              Colors.blue,
              Colors.cyan,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.cyan.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const CircleAvatar(
          radius: 70,
          backgroundColor: Colors.black87,
          child: Icon(
            Icons.person_rounded,
            size: 80,
            color: Colors.white,
          ),
        ),
      );

  Widget _buildProfileDetails() => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.black.withOpacity(0.4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildInfoTile('Username', _username, Icons.person_outline),
            const Divider(color: Colors.white10, height: 20),
            _buildInfoTile('Full Name', '$_firstName $_lastName', Icons.account_circle),
            const Divider(color: Colors.white10, height: 20),
            _buildInfoTile('Email', _email, Icons.email_outlined),
            const Divider(color: Colors.white10, height: 20),
            _buildInfoTile('Mobile', _mobile, Icons.phone_outlined),
          ],
        ),
      );

  Widget _buildInfoTile(String title, String value, IconData icon) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.cyan.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.cyanAccent,
                size: 30,
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
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value.trim().isEmpty ? 'Not Set' : value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildEditProfileButton() => ElevatedButton.icon(
        onPressed: () {
          debugPrint('Edit profile button pressed');
        },
        icon: const Icon(Icons.edit_rounded, size: 22),
        label: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
          backgroundColor: Colors.cyanAccent,
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 10,
          shadowColor: Colors.cyan.withOpacity(0.5),
          animationDuration: const Duration(milliseconds: 300),
        ),
      );
}