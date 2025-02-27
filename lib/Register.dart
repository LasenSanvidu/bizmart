import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Back Button at the Top-Left Corner
          Positioned(
            top: 40,
            left: 20,
            child: ElevatedButton(
              onPressed: () {
                context.push("/login");
              },
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(10),
                backgroundColor: Colors.white,
                elevation: 3,
              ),
              child: Icon(Icons.arrow_back_ios, color: Colors.black),
            ),
          ),
          // Scrollable Content
          SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior
                .onDrag, // Dismiss keyboard on scroll
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 80), // Give some space at the top

                  // Welcome Text
                  Text(
                    'Welcome',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Please enter your data to continue',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 40),

                  // Input Fields
                  buildTextField('First Name'),
                  buildTextField('Last Name'),
                  buildTextField('Email'),
                  buildTextField('Phone Number'),
                  buildTextField('Username'),
                  buildTextField('Password', obscureText: true),

                  SizedBox(height: 30),

                  // Terms and Conditions
                  Text(
                    'By connecting your account, you confirm that you agree',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 13),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'with our',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 13),
                      ),
                      TextButton(
                        onPressed: () {
                          print("Terms and Conditions Clicked!");
                        },
                        style: TextButton.styleFrom(
                            overlayColor: Colors.transparent),
                        child: Text(
                          'Terms and Conditions',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),

                  // Sign Up Button
                  ElevatedButton(
                    onPressed: () {
                      print("Sign Up Clicked!");
                      context.push("/otp_code");
                      // Sign-up action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Sign Up',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20), // Extra spacing at the bottom
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable TextField Widget
  Widget buildTextField(String label, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.5),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
    );
  }
}
