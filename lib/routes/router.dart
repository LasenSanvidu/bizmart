import 'package:go_router/go_router.dart';
import 'package:myapp/cal_event_page.dart';
import 'package:myapp/chat_homeScreen.dart';
import 'package:myapp/login_and_register/Register.dart';
import 'package:myapp/calender.dart';
import 'package:myapp/component/flow_screen.dart';
import 'package:myapp/login_and_register/login.dart';
import 'package:myapp/main.dart';
import 'package:myapp/main_settings.dart';
import 'package:myapp/otp/otp_code.dart';
import 'package:myapp/otp/otp_confirmation.dart';
import 'package:myapp/onboarding.dart';
import 'package:myapp/profile.dart';
import 'package:myapp/settings_customer.dart';
import 'package:myapp/user_type_selection.dart';
import 'package:myapp/business_dashboard.dart';
import 'package:myapp/contact_us_page.dart';

class RouterClass {
  final router = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) {
          return OnboardingScreen();
        },
      ),
      GoRoute(
        path: "/chat",
        builder: (context, state) {
          return const ChatHomeScreen();
        },
      ),
      GoRoute(
        path: "/main",
        builder: (context, state) {
          return MainSettings(); // Removed 'const' to fix the error
        },
      ),
      GoRoute(
        path: "/settings",
        builder: (context, state) {
          return const SettingsPage();
        },
      ),
      GoRoute(
        path: "/login",
        builder: (context, state) {
          return const Login();
        },
      ),
      GoRoute(
        path: "/user_type_selection",
        builder: (context, state) {
          return const UserTypeSelection();
        },
      ),
      GoRoute(
        path: "/register",
        builder: (context, state) {
          return const Register();
        },
      ),
      GoRoute(
        path: "/otp_code",
        builder: (context, state) {
          return const OtpCode();
        },
      ),
      GoRoute(
        path: "/otp_confirmation",
        builder: (context, state) {
          return const OtpConfirmation();
        },
      ),
      GoRoute(
        path: "/flow_screen",
        builder: (context, state) {
          return const MainScreen();
        },
      ),
    ],
  );
}
