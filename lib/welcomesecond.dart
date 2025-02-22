import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/component/button.dart';
import 'package:myapp/login.dart';

class WelcomeSecond extends StatelessWidget {
  const WelcomeSecond({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen height
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            child: Image.asset(
              'assets/welcome.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // Back button
          Positioned(
            top: 40,
            left: 22,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12),
                backgroundColor: const Color.fromARGB(255, 169, 168, 251),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),

          // Bottom container
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * 0.4, // Use 40% of the screen height
              width: MediaQuery.of(context).size.width *
                  0.9, // Use 90% of the screen width
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      'Get Started',
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Business Button
                    const Button(
                      buttonText: 'Business',
                      navigateTo: Login(),
                      backgroundColor: Color(0xFF9C9BFB),
                      color: Colors.white,
                    ),
                    const SizedBox(height: 19),

                    // Customer Button
                    const Button(
                      buttonText: 'Customer',
                      navigateTo: Login(),
                      backgroundColor: Color(0xFF9C9BFB),
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
