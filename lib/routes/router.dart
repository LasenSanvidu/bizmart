/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/chat/chat_list_screen.dart';
import 'package:myapp/chat/chat_page.dart';
import 'package:myapp/chat_homeScreen.dart';
import 'package:myapp/component/business_flow_screens.dart';
import 'package:myapp/component/customer_flow_screen.dart';
import 'package:myapp/contact_us.dart';
import 'package:myapp/contact_us_page.dart';
import 'package:myapp/faqs.dart';
import 'package:myapp/main_settings.dart';
import 'package:myapp/login_and_register/Register.dart';
import 'package:myapp/login_and_register/login.dart';
import 'package:myapp/onboarding.dart';
import 'package:myapp/otp/otp_code.dart';
import 'package:myapp/otp/otp_confirmation.dart';
import 'package:myapp/review.dart';
import 'package:myapp/settings_customer.dart';
import 'package:myapp/shop/my_store_ui.dart';
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
      initialLocation: "/onboard",
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
                      child: CircularProgressIndicator(),
                    ),
                  ); // Show loading screen
                }

                // Based on the result of _getInitialRoute, navigate to the right screen
                return snapshot.data == "/login"
                    ? const Login()
                    : CustomerFlowScreen();
              },
            );
          },
        ),
        GoRoute(
          path: "/chat",
          builder: (context, state) => ChatListScreen(),
        ),
        GoRoute(
          path: "/main",
          builder: (context, state) => CustomerFlowScreen(),
        ),
        GoRoute(
          path: "/my_ui",
          builder: (context, state) => MyStoreUi(),
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
        GoRoute(
          path: "/faQs",
          builder: (context, state) => FAQPage(),
        ),
        GoRoute(
          path: "/contact_us",
          builder: (context, state) => ContactUsPage(),
        ),
        GoRoute(
          path: "/onboard",
          builder: (context, state) => OnboardingScreen(),
        ),
      ],
    );
  }
}*/

/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/chat_homeScreen.dart';
import 'package:myapp/component/business_flow_screens.dart';
import 'package:myapp/component/customer_flow_screen.dart';
import 'package:myapp/contact_us.dart';
import 'package:myapp/contact_us_page.dart';
import 'package:myapp/faqs.dart';
import 'package:myapp/main_settings.dart';
import 'package:myapp/login_and_register/Register.dart';
import 'package:myapp/login_and_register/login.dart';
import 'package:myapp/onboarding.dart';
import 'package:myapp/otp/otp_code.dart';
import 'package:myapp/otp/otp_confirmation.dart';
import 'package:myapp/review.dart';
import 'package:myapp/settings_customer.dart';
import 'package:myapp/shop/my_store_ui.dart';
import 'package:myapp/user_type_selection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RouterClass {
  // Define a constant key for the onboarding flag
  static const String _hasCompletedOnboardingKey = 'hasCompletedOnboarding';

  // Check if user has completed onboarding
  Future<bool> _hasCompletedOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasCompletedOnboardingKey) ?? false;
  }

  // Mark onboarding as completed
  static Future<void> markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasCompletedOnboardingKey, true);
  }

  Future<String> _getInitialRoute() async {
    await Firebase
        .initializeApp(); // Ensure Firebase is initialized before getting user info.

    // First check if user has completed onboarding
    bool onboardingCompleted = await _hasCompletedOnboarding();
    if (!onboardingCompleted) {
      return "/onboard";
    }

    // Then check authentication state
    final user = FirebaseAuth.instance.currentUser;
    return user == null ? "/login" : "/main";
  }

  GoRouter get router {
    return GoRouter(
      navigatorKey: GlobalKey<NavigatorState>(),
      initialLocation: "/", // Changed to root so we can decide dynamically
      redirect: (context, state) {
        final user = FirebaseAuth.instance.currentUser;
        final isLoggingIn = state.matchedLocation == "/login";
        final isOnboarding = state.matchedLocation == "/onboard";
        final isRegistering = state.matchedLocation == "/register";

        // Don't redirect when on onboarding screen or checking initial route
        if (isOnboarding || state.matchedLocation == "/") {
          return null;
        }

        if (user == null && !isLoggingIn && !isRegistering) {
          return "/login"; // Redirect to login if not authenticated
        }
        if (user != null && (isLoggingIn || isRegistering)) {
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
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                // Navigate based on the result of _getInitialRoute
                final route = snapshot.data ?? "/onboard";
                if (route == "/onboard") {
                  return OnboardingScreen();
                } else if (route == "/login") {
                  return const Login();
                } else {
                  return CustomerFlowScreen();
                }
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
          builder: (context, state) => CustomerFlowScreen(),
        ),
        GoRoute(
          path: "/my_ui",
          builder: (context, state) => MyStoreUi(),
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
        GoRoute(
          path: "/faQs",
          builder: (context, state) => FAQPage(),
        ),
        GoRoute(
          path: "/contact_us",
          builder: (context, state) => ContactUsPage(),
        ),
        GoRoute(
          path: "/onboard",
          builder: (context, state) => OnboardingScreen(),
        ),
      ],
    );
  }
}*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/cal_event_page.dart';
import 'package:myapp/calender.dart';
import 'package:myapp/chat/chat_list_screen.dart';
import 'package:myapp/chat_homeScreen.dart';
import 'package:myapp/component/business_flow_screens.dart';
import 'package:myapp/component/customer_flow_screen.dart';
import 'package:myapp/contact_us.dart';
import 'package:myapp/contact_us_page.dart';
import 'package:myapp/faqs.dart';
import 'package:myapp/main_settings.dart';
import 'package:myapp/login_and_register/Register.dart';
import 'package:myapp/login_and_register/login.dart';
import 'package:myapp/onboarding.dart';
import 'package:myapp/otp/otp_code.dart';
import 'package:myapp/otp/otp_confirmation.dart';
import 'package:myapp/review.dart';
import 'package:myapp/settings_customer.dart';
import 'package:myapp/shop/my_store_ui.dart';
import 'package:myapp/user_type_selection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/ad_screen.dart';

class RouterClass {
  // Define a constant key for the onboarding flag
  static const String _hasCompletedOnboardingKey = 'hasCompletedOnboarding';

  // Check if user has completed onboarding
  Future<bool> _hasCompletedOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasCompletedOnboardingKey) ?? false;
  }

  // Mark onboarding as completed
  static Future<void> markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasCompletedOnboardingKey, true);
  }

  Future<String> _getInitialRoute() async {
    await Firebase
        .initializeApp(); // Ensure Firebase is initialized before getting user info.

    // First check if user has completed onboarding
    bool onboardingCompleted = await _hasCompletedOnboarding();
    if (!onboardingCompleted) {
      return "/onboard";
    }

    // Then check authentication state
    final user = FirebaseAuth.instance.currentUser;
    return user == null ? "/login" : "/main";
  }

  GoRouter get router {
    return GoRouter(
      navigatorKey: GlobalKey<NavigatorState>(),
      initialLocation: "/", // Changed to root so can decide dynamically
      redirect: (context, state) {
        final user = FirebaseAuth.instance.currentUser;
        //final isLoggingIn = state.matchedLocation == "/login";
        //final isOnboarding = state.matchedLocation == "/onboard";

        final isAuthRoute = state.matchedLocation == "/login" ||
            state.matchedLocation == "/register" ||
            state.matchedLocation == "/onboard";

        // Don't redirect when on onboarding screen or checking initial route
        if (/*isOnboarding*/ isAuthRoute || state.matchedLocation == "/") {
          return null;
        }

        if (user == null /*&& !isLoggingIn*/) {
          return "/login"; // Redirect to login if not authenticated
        }
        if (state.matchedLocation == "/login") {
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
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                // Navigate based on the result of _getInitialRoute
                final route = snapshot.data ?? "/onboard";
                if (route == "/onboard") {
                  return OnboardingScreen();
                } else if (route == "/login") {
                  return const Login();
                } else {
                  return CustomerFlowScreen();
                }
              },
            );
          },
        ),
        GoRoute(
          path: "/chat",
          builder: (context, state) => ChatListScreen(),
        ),
        GoRoute(
          path: "/main",
          builder: (context, state) => CustomerFlowScreen(),
        ),
        GoRoute(
          path: "/my_ui",
          builder: (context, state) => MyStoreUi(),
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
        GoRoute(
          path: "/faQs",
          builder: (context, state) => FAQPage(),
        ),
        GoRoute(
          path: "/contact_us",
          builder: (context, state) => ContactUsPage(),
        ),
        GoRoute(
          path: "/onboard",
          builder: (context, state) => OnboardingScreen(),
        ),
        GoRoute(
          path: "/ad_screen",
          builder: (context, state) => AddAdScreen(),
        ),
        GoRoute(
          path: "/cal_eve",
          builder: (context, state) => EventFormPage(),
        ),
        GoRoute(
          path: "/calender",
          builder: (context, state) => CalendarPage(),
        ),
      ],
    );
  }
}
