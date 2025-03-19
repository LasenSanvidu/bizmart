import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/provider/inquiry_provider.dart';
import 'package:myapp/provider/order_stats_provider.dart';
import 'package:myapp/provider/review_provider.dart';
import 'package:myapp/provider/store_provider.dart';
import 'package:myapp/routes/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/stripe/consts.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'stats_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await _setup();
  /*runApp(
    const MyApp(),
  );*/
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => StoreProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => InquiryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ReviewProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderStatsProvider(), // Add the new provider
        ),
      ],
      child: MyApp(),
    ),
  );
}

// for Stripe
Future<void> _setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: RouterClass().router,
      debugShowCheckedModeBanner: false,
      //home: HomeScreen(),
      // key: const HomeScreen(),
      //home: Login(),
      //home: WelcomeSecond(),
      //home:OrderConfirmed(),
      // home: Profile(),
      //home: ChatHomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/background.jpg'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Foreground content
          Column(
            children: [
              const SizedBox(height: 100), // Adds space from the top
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(
                        height: 10), // Space between the circle and text
                    const Text(
                      'Find your Style',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 400,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          context.push("/login");
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 20)),
                        child: const Text('Get Started',
                            style: TextStyle(fontSize: 18)))
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}