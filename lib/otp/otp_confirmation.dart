/*import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class OtpConfirmation extends StatefulWidget {
  const OtpConfirmation({super.key});

  @override
  State<OtpConfirmation> createState() => _OtpConfirmationState();
}

class _OtpConfirmationState extends State<OtpConfirmation> {
  bool _isAnimationLoaded =
      false; // indicating wheather animation running or not. for future use.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'lib/animations/verify.json',
              width: 280,
              onLoaded: (composition) {
                // play the animation once when started
                setState(() {
                  _isAnimationLoaded = true;
                });
                // navigate to another page when the animation finishes
                Future.delayed(composition.duration, () {
                  context.push("/flow_screen");
                });
              },
              repeat: false, // disable looping
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              'OTP Verification',
              style: GoogleFonts.raleway(
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Successfully',
              style: GoogleFonts.raleway(
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class OtpConfirmation extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const OtpConfirmation({super.key, this.userData});

  @override
  State<OtpConfirmation> createState() => _OtpConfirmationState();
}

class _OtpConfirmationState extends State<OtpConfirmation> {
  bool _isAnimationLoaded = false;
  bool _isProcessing = true;

  @override
  void initState() {
    super.initState();

    // Create user account after OTP verification
    if (widget.userData != null) {
      _createUserAccount();
    }
  }

  /// Function to create user account after OTP verification
  Future<void> _createUserAccount() async {
    try {
      // Firebase instances
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      // Create user with Firebase Authentication
      print("Creating auth user with email: ${widget.userData!['email']}");
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: widget.userData!['email'],
        password: widget.userData!['password'],
      );
      print("Auth user created with UID: ${userCredential.user!.uid}");

      // Store user details in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        "first_name": widget.userData!['first_name'],
        "last_name": widget.userData!['last_name'],
        "mobile": widget.userData!['mobile'],
        "username": widget.userData!['username'],
        "email": widget.userData!['email'],
        "phone_verified": true,
      });
      print("User data stored successfully");

      setState(() {
        _isProcessing = false;
      });
    } catch (e) {
      // Handle any errors
      print("Error creating user account: $e");

      setState(() {
        _isProcessing = false;
      });

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account creation failed: ${e.toString()}')),
        );

        // Go back to register page
        Future.delayed(const Duration(seconds: 2), () {
          context.go("/register");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isProcessing)
              CircularProgressIndicator(
                color: const Color.fromARGB(255, 160, 126, 255),
              ),
            if (!_isProcessing)
              Lottie.asset(
                'lib/animations/verify.json',
                width: 280,
                onLoaded: (composition) {
                  // play the animation once when started
                  setState(() {
                    _isAnimationLoaded = true;
                  });
                  // navigate to another page when the animation finishes
                  Future.delayed(composition.duration, () {
                    context.go("/main");
                  });
                },
                repeat: false, // disable looping
              ),
            SizedBox(
              height: 40,
            ),
            Text(
              'OTP Verification',
              style: GoogleFonts.raleway(
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Successfully',
              style: GoogleFonts.raleway(
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (_isProcessing)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Creating your account...',
                  style: GoogleFonts.raleway(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
