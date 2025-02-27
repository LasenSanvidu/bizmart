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
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = false;

  String getValueFromInput(TextEditingController controller) {
    return controller.text.trim();
  }

  Future<void> register() async {
    try {
      var userRef = _firestore.collection('users');

      var mobileCheck = await userRef
          .where('mobile', isEqualTo: getValueFromInput(mobileController))
          .get();
      if (mobileCheck.docs.isNotEmpty) {
        throw Exception("Mobile Already Exists!");
      }

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: getValueFromInput(emailController),
              password: getValueFromInput(passwordController));

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        "first_name": getValueFromInput(firstNameController),
        "last_name": getValueFromInput(lastNameController),
        "mobile": getValueFromInput(mobileController),
        "username": getValueFromInput(userNameController),
      });
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? "Something went")));
    } on Exception catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString().replaceFirst("Exception: ", "") )));
    }
  }

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
                context.go("/login");
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
