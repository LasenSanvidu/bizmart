import 'package:flutter/material.dart';
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
                    context.go("/otp_confirmation");
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
}
