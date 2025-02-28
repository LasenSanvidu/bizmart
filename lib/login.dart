import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Import Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:myapp/component/square_tile.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscured = true;
  bool _rememberPassword = true;
  bool _isLoginSelected = true;

  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance

  void _togglePasswordVisibility() {
    setState(() {
      _obscured = !_obscured;
    });
  }

  void _toggleRememberPassword() {
    setState(() {
      _rememberPassword = !_rememberPassword;
    });
  }

  // Login function using Firebase Authentication
  Future<void> _login() async {
    try {
      // Authenticate user with Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // After authentication, fetch user data from Firestore (optional)
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot userDoc = await firestore.collection('users').doc(userCredential.user!.uid).get();

      if (userDoc.exists) {
        // Access user data (e.g., name, profile picture, etc.)
        var userData = userDoc.data();
        print('User data from Firestore: $userData');
      } else {
        print('No additional user data found in Firestore');
      }

      // Navigate to the next screen (e.g., main page)
      context.go("/main");

    } catch (e) {
      print('Login failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              // G R E E T I N G S
              Text(
                "Login",
                style: GoogleFonts.abel(
                  fontSize: 36,
                ),
              ),
              const SizedBox(height: 10),
              Text("By signing in, you are agreeing",
                  style: GoogleFonts.abel(
                      fontSize: 18, color: const Color(0xFF6B5E5E))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("our",
                      style: GoogleFonts.abel(
                          fontSize: 18, color: const Color(0xFF6B5E5E))),
                  Text(" Terms and Privacy Policy",
                      style: GoogleFonts.abel(
                          fontSize: 18, color: const Color(0xFF0386D0))),
                ],
              ),
              const SizedBox(height: 29),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isLoginSelected = true;
                      });
                    },
                    child: Column(
                      children: [
                        Text("Login",
                            style: GoogleFonts.abel(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: _isLoginSelected
                                  ? const Color(0xFF0386D0)
                                  : const Color(0xFFA6A6A6),
                            )),
                        const SizedBox(height: 0),
                        Container(
                          height: 2,
                          width: 50,
                          color: _isLoginSelected
                              ? const Color.fromARGB(255, 196, 195, 195)
                              : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        context.go("/register");
                        _isLoginSelected = false;
                      });
                    },
                    child: Column(
                      children: [
                        Text("Register",
                            style: GoogleFonts.abel(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: !_isLoginSelected
                                  ? const Color(0xFF0386D0)
                                  : const Color(0xFFA6A6A6),
                            )),
                        const SizedBox(height: 0),
                        Container(
                          height: 2,
                          width: 55,
                          color: !_isLoginSelected
                              ? const Color.fromARGB(255, 196, 195, 195)
                              : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 47),

              // E M A I L  T E X T F I E L D
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0.0),
                          child: Icon(Icons.email_outlined,
                              color: Color(0xFFA6A6A6)),
                        ),
                        border: UnderlineInputBorder(),
                        hintText: 'Email Address',
                        hintStyle: TextStyle(
                          color: Color(0xFFA6A6A6),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFA6A6A6),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFA6A6A6),
                          ),
                        ),
                        contentPadding:
                            EdgeInsets.only(top: 14.0, bottom: 0.0)),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // P A S W O R D   F I E L D
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _obscured,
                    decoration: InputDecoration(
                        prefixIcon: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0.0),
                          child: Icon(Icons.lock_outline_rounded,
                              color: Color(0xFFA6A6A6)),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscured
                                ? Icons.visibility_outlined
                                : Icons.visibility_off,
                            color: const Color(0xFFA6A6A6),
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                        border: const UnderlineInputBorder(),
                        hintText: 'Password',
                        hintStyle: const TextStyle(
                          color: Color(0xFFA6A6A6),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFA6A6A6),
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFA6A6A6),
                          ),
                        ),
                        contentPadding:
                            const EdgeInsets.only(top: 14.0, bottom: 0.0)),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ),
              const SizedBox(height: 35),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _toggleRememberPassword,
                        child: Transform.scale(
                          scale: 1.3,
                          child: Icon(
                            _rememberPassword
                                ? Icons.check_box_outlined
                                : Icons.check_box_outline_blank,
                            color: const Color.fromARGB(255, 157, 151, 151),
                            size: 20.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        "Remember password",
                        style:
                            TextStyle(fontSize: 15, color: Color(0xFF6B5E5E)),
                      ),
                    ],
                  ),
                  const Text(
                    "      Forgot password",
                    style: TextStyle(fontSize: 15, color: Color(0xFF0386D0)),
                  ),
                ],
              ),
              const SizedBox(height: 38),

              // L O G I N   B U T T O N
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: GestureDetector(
                  onTap: _login,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0386D0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text('Login',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'or connect with',
                style: TextStyle(
                  color: Color(0xFF747070),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),

              // S O C I A L   M E D I A   B U T T O N S
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // google button
                  SquareTile(imagePath: 'assets/google1.jpg'),
                ],
              ),
              Expanded(
                child: Image.asset(
                  'assets/login_Image.png',
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
