import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/cal_event_page.dart';
import 'package:myapp/chat_homeScreen.dart';
import 'package:myapp/Register.dart';
import 'package:myapp/calender.dart';
import 'package:myapp/login.dart';
import 'package:myapp/main.dart';
import 'package:myapp/main_settings.dart';
import 'package:myapp/otp_code.dart';
import 'package:myapp/otp_confirmation.dart';
import 'package:myapp/onboarding.dart';
import 'package:myapp/profile.dart';
import 'package:myapp/settings_customer.dart';
import 'package:myapp/user_type_selection.dart';
import 'package:myapp/business_dashboard.dart';
import 'package:myapp/contact_us_page.dart';

class RouterClass {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  final router = GoRouter(
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
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: "/chat",
        builder: (context, state) => const ChatHomeScreen(),
      ),
      GoRoute(
        path: "/main",
        builder: (context, state) => MainSettings(),
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
