/*import 'package:cloud_firestore/cloud_firestore.dart';
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

  // validation methods
  // First Name validation
  bool isValidFirstName(String value) {
    if (value.isEmpty) return false;
    if (value.length < 2) return false;
    final nameRegExp = RegExp(r'^[a-zA-Z]+$');
    return nameRegExp.hasMatch(value);
  }

  // Last Name validation
  bool isValidLastName(String value) {
    if (value.isEmpty) return false;
    if (value.length < 2) return false;
    final nameRegExp = RegExp(r'^[a-zA-Z]+$');
    return nameRegExp.hasMatch(value);
  }

// Email validation
  bool isValidEmail(String value) {
    if (value.isEmpty) return false;
    final emailRegExp = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return emailRegExp.hasMatch(value);
  }

// Phone number validation
  bool isValidPhoneNumber(String value) {
    if (value.isEmpty) return false;
    final phoneRegExp = RegExp(r'^\d{10}$'); // Assuming 10-digit phone number
    return phoneRegExp.hasMatch(value);
  }

  // Username validation
  bool isValidUsername(String value) {
    if (value.isEmpty) return false;
    if (value.length < 4) return false;
    final usernameRegExp = RegExp(r'^[a-zA-Z0-9_]+$');
    return usernameRegExp.hasMatch(value);
  }

  bool isValidPassword(String value) {
    if (value.isEmpty) return false;
    if (value.length < 8) return false;
    // Password should contain at least one uppercase, one lowercase, one digit
    final passwordRegExp = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
    return passwordRegExp.hasMatch(value);
  }

  // Error messages to show for each field
  Map<String, String> errorMessages = {
    'firstName': '',
    'lastName': '',
    'email': '',
    'mobile': '',
    'username': '',
    'password': '',
  };

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

  /// Function to handle user registration
  Future<void> register() async {
    // Step 1: Validate if any field is empty
    /*if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        mobileController.text.isEmpty ||
        userNameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("All fields are required!")));
      return;
    }*/
    setState(() {
      errorMessages = {
        'firstName': '',
        'lastName': '',
        'email': '',
        'mobile': '',
        'username': '',
        'password': '',
      };
    });

    // Validate each field
    bool hasErrors = false;

    if (!isValidFirstName(getValueFromInput(firstNameController))) {
      setState(() {
        errorMessages['firstName'] = 'Enter a valid first name (letters only)';
      });
      hasErrors = true;
    }

    if (!isValidLastName(getValueFromInput(lastNameController))) {
      setState(() {
        errorMessages['lastName'] = 'Enter a valid last name (letters only)';
      });
      hasErrors = true;
    }

    if (!isValidEmail(getValueFromInput(emailController))) {
      setState(() {
        errorMessages['email'] = 'Enter a valid email address';
      });
      hasErrors = true;
    }

    if (!isValidPhoneNumber(getValueFromInput(mobileController))) {
      setState(() {
        errorMessages['mobile'] = 'Enter a valid 10-digit phone number';
      });
      hasErrors = true;
    }

    if (!isValidUsername(getValueFromInput(userNameController))) {
      setState(() {
        errorMessages['username'] =
            'Username must be at least 4 characters (letters, numbers, underscores)';
      });
      hasErrors = true;
    }

    if (!isValidPassword(getValueFromInput(passwordController))) {
      setState(() {
        errorMessages['password'] =
            'Password must be at least 8 characters with uppercase, lowercase, and number';
      });
      hasErrors = true;
    }

    if (hasErrors) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fix the errors in the form")),
      );
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
                            'First Name',
                            firstNameController,
                            fieldName: 'firstName',
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                            child: buildInputField(
                          'Last Name',
                          lastNameController,
                          fieldName: 'lastName',
                        )),
                      ],
                    ),
                    buildInputField(
                      'Email Address',
                      emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      fieldName: 'email',
                    ),
                    buildInputField(
                      'Phone Number',
                      mobileController,
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icons.phone_outlined,
                      fieldName: 'mobile',
                    ),
                    buildInputField(
                      'Username',
                      userNameController,
                      prefixIcon: Icons.person_outline,
                      fieldName: 'username',
                    ),
                    buildInputField(
                      'Password',
                      passwordController,
                      obscureText: true,
                      prefixIcon: Icons.lock_outline,
                      suffixIcon: Icons.visibility_outlined,
                      fieldName: 'password',
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
    String fieldName = '',
  }) {
    String errorText = '';
    // Get the appropriate error message based on the field name
    if (fieldName == 'firstName')
      errorText = errorMessages['firstName'] ?? '';
    else if (fieldName == 'lastName')
      errorText = errorMessages['lastName'] ?? '';
    else if (fieldName == 'email')
      errorText = errorMessages['email'] ?? '';
    else if (fieldName == 'mobile')
      errorText = errorMessages['mobile'] ?? '';
    else if (fieldName == 'username')
      errorText = errorMessages['username'] ?? '';
    else if (fieldName == 'password')
      errorText = errorMessages['password'] ?? '';

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
          if (errorText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 4),
              child: Text(
                errorText,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: Colors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
