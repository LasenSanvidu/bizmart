import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/component/button.dart';
import 'package:myapp/login.dart';

class WelcomeSecond extends StatelessWidget {
  const WelcomeSecond({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Image.asset(
              'assets/welcome.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
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
          Padding(
            padding: const EdgeInsets.only(top: 580.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),  
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,

              child: Center(
                child: Column(
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
                    
                    const Button(buttonText: 'Business', navigateTo: Login(), backgroundColor: Color(0xFF9C9BFB), color: Colors.white),
                  
                    const SizedBox(height: 19),

                    const Button(buttonText: 'Customer', navigateTo: Login(), backgroundColor: Color(0xFF9C9BFB), color: Colors.white),
                    
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}