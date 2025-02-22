import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserTypeSelection extends StatelessWidget {
  const UserTypeSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF7F67E0), // Purple gradient color
                  Color(0xFFABA5F3), // Light purple gradient color
                ],
              ),
            ),
          ),

          // Main content
          Column(
            children: [
              const SizedBox(height: 80),
              // Top text
              const Text(
                "Please select your user type ?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 70),
              // Buttons
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UserTypeButton(
                      label: "Business",
                      onPressed: () {
                        context.go("/login");
                        print("Business button pressed");
                      },
                    ),
                    const SizedBox(height: 50),
                    UserTypeButton(
                      label: "Consumer",
                      onPressed: () {
                        context.go("/login");
                        print("Consumer button pressed");
                      },
                    ),
                  ],
                ),
              ),

              // Bottom illustration
              Container(
                width: double.infinity,
                height: 200, // Adjust height as needed
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/login_Image.png'), // Replace with your asset path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UserTypeButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const UserTypeButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.purple,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 25),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
