import 'package:go_router/go_router.dart';
import 'package:myapp/chat.dart';
import 'package:myapp/chat_homeScreen.dart';
import 'package:myapp/Register.dart';
import 'package:myapp/cal_event_page';
import 'package:myapp/calender.dart';
import 'package:myapp/login.dart';
import 'package:myapp/main.dart';
import 'package:myapp/main_settings.dart';
import 'package:myapp/order_confirmed.dart';
import 'package:myapp/profile.dart';
import 'package:myapp/settings_customer.dart';
import 'package:myapp/user_type_selection.dart';
import 'package:myapp/welcomesecond.dart';
import '../otp_code.dart';
import '../otp_confirmation.dart';

class RouterClass {
  final router = GoRouter(
    initialLocation: "/main",
    routes: [
      GoRoute(
        path: "/calendar",
        builder: (context, state) {
          return const CalendarPage();
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
          return const MainSettings();
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
        path: "/eventForm",
        builder: (context, state) {
          return const EventFormPage();
        },
      ),
    ],
  );
}
