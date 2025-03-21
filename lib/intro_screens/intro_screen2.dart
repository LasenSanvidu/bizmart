import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IntroScreen2 extends StatelessWidget {
  const IntroScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        //color: const Color.fromARGB(255, 186, 163, 251),
        color: Colors.black,
        child: Container(
          padding: const EdgeInsets.only(top: 183, bottom: 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset('lib/animations/onboard2.json', width: 350),
              SizedBox(
                height: 90,
              ),
              Text(
                'Track Your Sales & Boost',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Your Business!',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ));
  }
}
