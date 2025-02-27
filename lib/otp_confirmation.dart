import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class OtpConfirmation extends StatefulWidget {
  const OtpConfirmation({super.key});

  @override
  State<OtpConfirmation> createState() => _OtpConfirmationState();
}

class _OtpConfirmationState extends State<OtpConfirmation> {
  bool _isAnimationLoaded =
      false; // indicating wheather animation running or not. for future use.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'lib/animations/verify.json',
              width: 280,
              onLoaded: (composition) {
                // play the animation once when started
                setState(() {
                  _isAnimationLoaded = true;
                });
                // navigate to another page when the animation finishes
                Future.delayed(composition.duration, () {
                  context.go("/main");
                });
              },
              repeat: false, // disable looping
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              'OTP Verification',
              style: GoogleFonts.raleway(
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Successfully',
              style: GoogleFonts.raleway(
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
