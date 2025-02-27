import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/intro_screens/intro_screen1.dart';
import 'package:myapp/intro_screens/intro_screen2.dart';
import 'package:myapp/intro_screens/intro_screen3.dart';
import 'package:myapp/main.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // page controller
  final PageController _controller = PageController();

  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              onLastPage = (index == 2);
            });
          },
          children: [
            IntroScreen1(),
            IntroScreen2(),
            IntroScreen3(),
          ],
        ),

        //dot indicator
        Container(
            alignment: Alignment(0, 0.85),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // skip
                GestureDetector(
                  onTap: () {
                    _controller.jumpToPage(2);
                  },
                  child: Text(
                    'skip',
                    style: GoogleFonts.poppins(
                        fontSize: 19,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),

                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: WormEffect(
                    dotColor: Colors.white, // Non-active dots color
                    activeDotColor: const Color.fromARGB(255, 145, 105, 255),
                    dotHeight: 11,
                    dotWidth: 11,
                    spacing: 4.0,
                  ),
                ),

                //next
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return HomeScreen();
                          }));
                        },
                        child: Text(
                          'done',
                          style: GoogleFonts.poppins(
                              fontSize: 19, fontWeight: FontWeight.w600),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                            duration: Duration(milliseconds: 550),
                            curve: Curves.easeIn,
                          );
                        },
                        child: Text(
                          'next',
                          style: GoogleFonts.poppins(
                              fontSize: 19,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
              ],
            ))
      ],
    ));
  }
}
