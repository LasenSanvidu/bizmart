import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            // Back Button at the Top-Left Corner
            Positioned(
              top: 40, // Adjust position from top
              left: 20, // Adjust position from left
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(), // Makes button circular
                  padding: EdgeInsets.all(10), // Adjust button size
                  backgroundColor: Colors.white, // Background color
                  elevation: 3, // Shadow effect
                ),
                child: Icon(Icons.arrow_back_ios, color: Colors.black),
              ),
            ),
            // Main Content
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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

                      // Username Input
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          border: InputBorder.none,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1.5), // Adds underline
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2), // Changes color when focused
                          ),
                        ),
                      ),
                      SizedBox(height: 15),

                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          border: InputBorder.none,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1.5), // Adds underline
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2), // Changes color when focused
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: InputBorder.none,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1.5), // Adds underline
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2), // Changes color when focused
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: InputBorder.none,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1.5), // Adds underline
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2), // Changes color when focused
                          ),
                        ),
                      ),
                      SizedBox(height: 15),

                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: InputBorder.none,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1.5), // Adds underline
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2), // Changes color when focused
                          ),
                        ),
                      ),
                      SizedBox(height: 15),

                      // Password Input
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            border: InputBorder.none,
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1.5,

                                )
                            ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2), // Changes color when focused
                          ),


                        ),
                      ),



                      // Forgot Password Button
                      /*Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),*/

                      SizedBox(height: 30),

                      // Remember Me Switch
                      /*Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Remember me',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 13,
                            ),
                          ),
                          Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                              });
                            },
                            activeColor: Colors.green,
                            inactiveThumbColor: Colors.grey,
                          ),
                        ],
                      ),*/



                      // Terms and Conditions
                      Text(
                        'By connecting your account confirm that you agree',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'with our',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              print("Sakalabujan!!!!");
                            },
                            style: TextButton.styleFrom(
                              overlayColor: Colors.transparent, // Removes hover effect
                            ),
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

                      // Login Button
                      ElevatedButton(
                        onPressed: () {
                          // Login action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Change this to your preferred color
                          foregroundColor: Colors.white, // Text color
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50), // Button size
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30), // Rounded corners
                          ),
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                ),
              ),
            ),
          ],
        ),
      );
  }
}