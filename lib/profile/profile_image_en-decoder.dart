import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileImageHandler {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Pick image from gallery
  static Future<String?> pickAndEncodeImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85, // Compress to balance quality and size
      );

      if (image == null) return null;

      // Read image as bytes
      final bytes = await image.readAsBytes();

      // Encode to base64
      final String base64Image = base64Encode(bytes);
      return base64Image;
    } catch (e) {
      print("Error picking or encoding image: $e");
      return null;
    }
  }

  // Save image to user profile in Firestore
  static Future<bool> saveProfileImage(String base64Image) async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) {
        print("User not authenticated");
        return false;
      }

      await _firestore.collection('users').doc(userId).update({
        'profile_image': base64Image,
      });

      return true;
    } catch (e) {
      print("Error saving profile image: $e");
      return false;
    }
  }

  // Get profile image from Firebase
  static Future<String?> getProfileImage() async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) {
        print("User not authenticated");
        return null;
      }

      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) return null;

      Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
      return userData['profile_image'] as String?;
    } catch (e) {
      print("Error fetching profile image: $e");
      return null;
    }
  }

  // Decode base64 image
  static Uint8List? decodeImage(String? base64Image) {
    if (base64Image == null || base64Image.isEmpty) return null;
    try {
      return base64Decode(base64Image);
    } catch (e) {
      print("Error decoding image: $e");
      return null;
    }
  }

  // Widget to display profile image
  static Widget profileImageWidget({
    required String? base64Image,
    required String firstName,
    required String lastName,
    double radius = 50,
    TextStyle? initialsStyle,
    VoidCallback? onTap,
  }) {
    if (base64Image != null && base64Image.isNotEmpty) {
      try {
        // Attempt to decode the image
        final imageData = decodeImage(base64Image);

        return GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: radius,
            backgroundImage: MemoryImage(imageData!),
          ),
        );
      } catch (e) {
        print("Error displaying image: $e");
        // Fall back to initials if decode fails
      }
    }

    // Default to initials if no image or error
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey.shade200,
        child: Text(
          _getInitials(firstName, lastName),
          style: initialsStyle ??
              TextStyle(
                fontSize: radius * 0.56,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
        ),
      ),
    );
  }

  // Helper to get initials from name
  static String _getInitials(String firstName, String lastName) {
    String firstInitial = firstName.isNotEmpty ? firstName[0] : "";
    String lastInitial = lastName.isNotEmpty ? lastName[0] : "";
    return "$firstInitial$lastInitial".toUpperCase();
  }

  // Pick and update profile image in one step
  static Future<bool> pickAndUpdateProfileImage() async {
    final String? base64Image = await pickAndEncodeImage();
    if (base64Image == null) return false;

    return await saveProfileImage(base64Image);
  }
}
