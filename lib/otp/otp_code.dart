/*import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import 'otp_confirmation.dart';

class OtpCode extends StatelessWidget {
  const OtpCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // A P P   B A R
          Padding(
            padding: const EdgeInsets.only(top: 65, bottom: 10, right: 350),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Image.asset('lib/Icons/left_arrow.png',
                  height: 20, width: 20),
            ),
          ),

          SizedBox(
            height: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Verification',
                style: GoogleFonts.poppins(
                    fontSize: 25, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12),
              Text(
                "We've sent an SMS with an activation code",
                style: TextStyle(
                  fontSize: 17,
                  color: Color.fromARGB(255, 118, 118, 118),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ' to your phone',
                    style: TextStyle(
                      fontSize: 17,
                      color: Color.fromARGB(255, 118, 118, 118),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ],
          ),
          SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Form(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  5,
                  (index) => SizedBox(
                    height: 68,
                    width: 64,
                    child: TextField(
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      style: Theme.of(context).textTheme.headlineSmall,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Send code',
                style: TextStyle(
                  fontSize: 17,
                  color: Color.fromARGB(255, 98, 98, 98),
                ),
              ),
              Text(
                ' again',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              Text(
                '  00:20',
                style: TextStyle(
                  fontSize: 17,
                  color: Color.fromARGB(255, 98, 98, 98),
                ),
              ),
            ],
          ),
          SizedBox(height: 50),

          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    context.push("/otp_confirmation");
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 14),
                    child: Text(
                      'resend',
                      style: GoogleFonts.poppins(
                        color: const Color.fromARGB(255, 160, 126, 255),
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OtpConfirmation()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 160, 126, 255),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'Confirm',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpCode extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const OtpCode({super.key, this.userData});

  @override
  State<OtpCode> createState() => _OtpCodeState();
}

class _OtpCodeState extends State<OtpCode> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  String verificationId = '';
  String phoneNumber = '';

  // Controllers for OTP input fields
  final List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();

    // Get the phone number from user data
    if (widget.userData != null) {
      print("Received user data in OTP screen: ${widget.userData}");
      phoneNumber = widget.userData!['mobile'] ?? '';
      print("Phone number to verify: $phoneNumber");

      // Format phone number if it doesn't have a country code
      if (!phoneNumber.startsWith('+')) {
        // Add your country code here - using +1 as example
        phoneNumber = '+1$phoneNumber';
        print("Formatted phone number: $phoneNumber");
      }

      // Start phone verification
      if (phoneNumber.isNotEmpty) {
        _verifyPhoneNumber();
      } else {
        print("Error: Empty phone number");
      }
    } else {
      print("Error: No user data received in OTP screen");
    }
  }

  /// Function to verify phone number through Firebase
  Future<void> _verifyPhoneNumber() async {
    setState(() {
      isLoading = true;
    });

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto verification completed (usually on Android)
          await _signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification Failed: ${e.message}')),
          );
        },
        codeSent: (String verId, int? resendToken) {
          setState(() {
            verificationId = verId;
            isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('OTP sent to your phone')),
          );
        },
        codeAutoRetrievalTimeout: (String verId) {
          setState(() {
            verificationId = verId;
          });
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  /// Function to sign in with phone credential
  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      await _auth.signInWithCredential(credential);

      // Navigate to OTP confirmation page with user data
      if (!mounted) return;
      context.push('/otp_confirmation', extra: widget.userData);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication Failed: ${e.toString()}')),
      );
    }
  }

  /// Function to verify OTP
  Future<void> _verifyOTP() async {
    setState(() {
      isLoading = true;
    });

    print("DEBUG MODE: Bypassing actual OTP verification for testing");

    // Combine all OTP digits
    final otp = otpControllers.map((controller) => controller.text).join();
    print(
        "Attempting to verify OTP: $otp with verificationId: $verificationId");

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the complete 6 digit  OTP')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      if (verificationId.isEmpty) {
        print("ERROR: verification ID is empty!");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Verification ID is missing, please try again')),
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Create credential
      print("Creating phone auth credential...");
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      // Sign in with credential
      print("Attempting to sign in with phone credential...");
      await _signInWithCredential(credential);
    } catch (e) {
      print("Error verifying OTP: $e");
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP: ${e.toString()}')),
      );
    }
  }

  /// Function to resend OTP
  void _resendOTP() {
    // Reset OTP fields
    for (var controller in otpControllers) {
      controller.clear();
    }

    // Request new OTP
    _verifyPhoneNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // A P P   B A R
          Padding(
            padding: const EdgeInsets.only(top: 65, bottom: 10, left: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  //Navigator.pop(context);
                },
                child: Image.asset('lib/Icons/left_arrow.png',
                    height: 20, width: 20),
              ),
            ),
          ),

          SizedBox(
            height: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Verification',
                style: GoogleFonts.poppins(
                    fontSize: 25, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12),
              Text(
                "We've sent an SMS with an activation code",
                style: TextStyle(
                  fontSize: 17,
                  color: Color.fromARGB(255, 118, 118, 118),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ' to your phone',
                    style: TextStyle(
                      fontSize: 17,
                      color: Color.fromARGB(255, 118, 118, 118),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
              SizedBox(height: 10),
              Text(
                phoneNumber,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),

          // OTP Input Fields
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Form(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                  (index) => SizedBox(
                    height: 68,
                    width: 64,
                    child: TextField(
                      controller: otpControllers[index],
                      onChanged: (value) {
                        if (value.length == 1 && index < 4) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      style: Theme.of(context).textTheme.headlineSmall,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 14),

          // Resend Timer
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Send code',
                style: TextStyle(
                  fontSize: 17,
                  color: Color.fromARGB(255, 98, 98, 98),
                ),
              ),
              Text(
                ' again',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              Text(
                '  00:20',
                style: TextStyle(
                  fontSize: 17,
                  color: Color.fromARGB(255, 98, 98, 98),
                ),
              ),
            ],
          ),
          SizedBox(height: 50),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Resend Button
                GestureDetector(
                  onTap: isLoading ? null : _resendOTP,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 14),
                    child: Text(
                      'Resend',
                      style: GoogleFonts.poppins(
                        color: const Color.fromARGB(255, 160, 126, 255),
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Confirm Button
                GestureDetector(
                  onTap: isLoading ? null : _verifyOTP,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 160, 126, 255),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Confirm',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
