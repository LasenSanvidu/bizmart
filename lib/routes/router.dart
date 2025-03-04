import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/chat_homeScreen.dart';
import 'package:myapp/component/business_flow_screens.dart';
import 'package:myapp/component/customer_flow_screen.dart';
import 'package:myapp/main_settings.dart';
import 'package:myapp/login_and_register/Register.dart';
import 'package:myapp/login_and_register/login.dart';
import 'package:myapp/otp/otp_code.dart';
import 'package:myapp/otp/otp_confirmation.dart';
import 'package:myapp/settings_customer.dart';
import 'package:myapp/user_type_selection.dart';

class RouterClass {
  Future<String> _getInitialRoute() async {
    final user = FirebaseAuth.instance.currentUser;
    await Firebase
        .initializeApp(); // Ensure Firebase is initialized before getting user info.
    return user == null
        ? "/login"
        : "/main"; // Decide initial route based on authentication state.
  }

  GoRouter get router {
    return GoRouter(
      navigatorKey:
          GlobalKey<NavigatorState>(), // ✅ Added to handle back navigation
      initialLocation: "/",
      redirect: (context, state) {
        final user = FirebaseAuth.instance.currentUser;
        final isLoggingIn = state.matchedLocation == "/login";

        if (user == null && !isLoggingIn) {
          return "/login"; // Redirect to login if not authenticated
        }
        if (user != null && isLoggingIn) {
          return "/main"; // Redirect to home if already logged in
        }
        return null; // Allow normal navigation
      },
      routes: [
        GoRoute(
          path: "/",
          builder: (context, state) {
            return FutureBuilder<String>(
              future: _getInitialRoute(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                      body: Center(
                          child:
                              CircularProgressIndicator())); // Show loading screen
                }

                // Based on the result of _getInitialRoute, navigate to the right screen
                return snapshot.data == "/login"
                    ? const Login()
                    : BusinessFlowScreens();
              },
            );
          },
        ),
        GoRoute(
          path: "/chat",
          builder: (context, state) => const ChatHomeScreen(),
        ),
        GoRoute(
          path: "/main",
          builder: (context, state) => BusinessFlowScreens(),
        ),
        GoRoute(
          path: "/settings",
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: "/login",
          builder: (context, state) => const Login(),
        ),
        GoRoute(
          path: "/user_type_selection",
          builder: (context, state) => const UserTypeSelection(),
        ),
        GoRoute(
          path: "/register",
          builder: (context, state) => const Register(),
        ),
        GoRoute(
          path: "/otp_code",
          builder: (context, state) => const OtpCode(),
        ),
        GoRoute(
          path: "/otp_confirmation",
          builder: (context, state) => const OtpConfirmation(),
        ),
      ],
    );
  }
}
