import 'package:cloud_firestore/cloud_firestore.dart';
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? "Something went wrong!")));
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
}
