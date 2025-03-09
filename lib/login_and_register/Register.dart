/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Text controllers for each input field
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false; // Loading state for button

  /// Function to get the trimmed text from a TextField
  String getValueFromInput(TextEditingController controller) {
    return controller.text.trim();
  }

  /// Function to handle user registration
  Future<void> register() async {
    // Step 1: Validate if any field is empty
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        mobileController.text.isEmpty ||
        userNameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("All fields are required!")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var userRef = _firestore.collection('users');

      // Step 2: Check if mobile number already exists
      var mobileCheck = await userRef
          .where('mobile', isEqualTo: getValueFromInput(mobileController))
          .get();
      if (mobileCheck.docs.isNotEmpty) {
        throw Exception("Mobile Number Already Exists!");
      }

      // Step 3: Check if username is unique
      var usernameCheck = await userRef
          .where('username', isEqualTo: getValueFromInput(userNameController))
          .get();
      if (usernameCheck.docs.isNotEmpty) {
        throw Exception("Username Already Taken!");
      }

      // Step 4: Create user with Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: getValueFromInput(emailController),
              password: getValueFromInput(passwordController));

      // Step 5: Store user details in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        "first_name": getValueFromInput(firstNameController),
        "last_name": getValueFromInput(lastNameController),
        "mobile": getValueFromInput(mobileController),
        "username": getValueFromInput(userNameController),
        "email": getValueFromInput(emailController),
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Registration Successful!")));

      context.go("/home"); // Redirect to home after successful registration
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Authentication Error")));
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Something went wrong!")));
    } on Exception catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.toString().replaceFirst("Exception: ", ""))));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Back Button
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

          // Main Content
          SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior
                .onDrag, // Dismiss keyboard on scroll
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 80),

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
                  buildTextField('First Name', firstNameController),
                  buildTextField('Last Name', lastNameController),
                  buildTextField('Email', emailController),
                  buildTextField('Phone Number', mobileController),
                  buildTextField('Username', userNameController),
                  buildTextField('Password', passwordController,
                      obscureText: true),

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
                    onPressed: register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Sign Up',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Reusable TextField Widget
  Widget buildTextField(String label, TextEditingController controller,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
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
}*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Text controllers for each input field
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false; // Loading state for button

  /// Function to get the trimmed text from a TextField
  String getValueFromInput(TextEditingController controller) {
    return controller.text.trim();
  }

  /// Helper function to debug Firebase permission issues
  /*Future<void> debugFirebasePermissions() async {
    try {
      // Test Firebase Authentication
      print("Testing Firebase Authentication...");
      final authMethods = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail("test@example.com");
      print("Available sign-in methods: $authMethods");

      // Test Firestore access
      print("Testing Firestore access...");
      final testDoc = await FirebaseFirestore.instance
          .collection('test_collection')
          .doc('test_doc')
          .get();
      print("Firestore test doc exists: ${testDoc.exists}");

      print("Firebase permissions check complete without errors");
    } catch (e) {
      print("Firebase permissions check failed: $e");
    }
  }*/

// Call this function at app startup or on a debug button press

  /// Function to handle user registration
  Future<void> register() async {
    // Step 1: Validate if any field is empty
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        mobileController.text.isEmpty ||
        userNameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("All fields are required!")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    //debugFirebasePermissions();

    try {
      print("Attempting to register user: ${emailController.text}");

      // Step 2: Create user with Firebase Authentication first
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: getValueFromInput(emailController),
              password: getValueFromInput(passwordController));

      print("User created successfully with ID: ${userCredential.user!.uid}");
      var userRef = _firestore.collection('users');

      // Step 2: Check if mobile number already exists
      var mobileCheck = await userRef
          .where('mobile', isEqualTo: getValueFromInput(mobileController))
          .get();
      if (mobileCheck.docs.isNotEmpty) {
        await userCredential.user?.delete();
        throw Exception("Mobile Number Already Exists!");
      }

      // Step 3: Check if username is unique
      var usernameCheck = await userRef
          .where('username', isEqualTo: getValueFromInput(userNameController))
          .get();
      if (usernameCheck.docs.isNotEmpty) {
        await userCredential.user?.delete();
        throw Exception("Username Already Taken!");
      }

      // Step 5: Store user details in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        "first_name": getValueFromInput(firstNameController),
        "last_name": getValueFromInput(lastNameController),
        "mobile": getValueFromInput(mobileController),
        "username": getValueFromInput(userNameController),
        "email": getValueFromInput(emailController),
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Registration Successful!")));

      context.go("/login"); // Redirect to home after successful registration
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: ${e.code} - ${e.message}");
      String errorMessage = "Authentication Error";

      // Provide more user-friendly error messages for common auth errors
      if (e.code == 'email-already-in-use') {
        errorMessage =
            "This email is already registered. Please use another email.";
      } else if (e.code == 'weak-password') {
        errorMessage = "Password is too weak. Please use a stronger password.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Invalid email format. Please check your email.";
      } else if (e.code == 'operation-not-allowed') {
        errorMessage =
            "Email/password accounts are not enabled. Please contact support.";
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    } on FirebaseException catch (e) {
      print("Firebase Error: ${e.code} - ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Something went wrong!")));
    } on Exception catch (error) {
      print("General Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.toString().replaceFirst("Exception: ", ""))));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Create Account',
          style: GoogleFonts.abel(
            fontSize: 32,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                //keyboardDismissBehavior:
                //  ScrollViewKeyboardDismissBehavior.onDrag,
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Header

                    SizedBox(height: 15),
                    Center(
                      child: Text(
                        'Please fill in your information to get started',
                        style: GoogleFonts.abel(
                          fontSize: 20,
                          color: const Color.fromARGB(255, 146, 146, 146),
                          //height: 1.5,
                        ),
                      ),
                    ),
                    SizedBox(height: 25),

                    // Form Fields
                    Row(
                      children: [
                        Expanded(
                            child: buildInputField(
                                'First Name', firstNameController)),
                        SizedBox(width: 16),
                        Expanded(
                            child: buildInputField(
                                'Last Name', lastNameController)),
                      ],
                    ),
                    buildInputField(
                      'Email Address',
                      emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                    ),
                    buildInputField(
                      'Phone Number',
                      mobileController,
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icons.phone_outlined,
                    ),
                    buildInputField(
                      'Username',
                      userNameController,
                      prefixIcon: Icons.person_outline,
                    ),
                    buildInputField(
                      'Password',
                      passwordController,
                      obscureText: true,
                      prefixIcon: Icons.lock_outline,
                      suffixIcon: Icons.visibility_outlined,
                    ),

                    // Terms and Privacy
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'By signing up, you agree to our ',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("Terms and Conditions Clicked!");
                          },
                          child: Text(
                            'Terms & Conditions',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 40),

                    // Sign Up Button
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.black),
                      child: ElevatedButton(
                        onPressed: register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: isLoading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Create Account',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),

                    // Sign in alternative
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///input field
  Widget buildInputField(
    String label,
    TextEditingController controller, {
    bool obscureText = false,
    IconData? prefixIcon,
    IconData? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
              ),
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: InputBorder.none,
                prefixIcon: prefixIcon != null
                    ? Icon(prefixIcon, color: Colors.grey[600], size: 20)
                    : null,
                suffixIcon: suffixIcon != null
                    ? Icon(suffixIcon, color: Colors.grey[600], size: 20)
                    : null,
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
