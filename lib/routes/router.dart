import 'package:go_router/go_router.dart';
import 'package:myapp/login.dart';
import 'package:myapp/main.dart';
import 'package:myapp/main_settings.dart';
import 'package:myapp/order_confirmed.dart';
import 'package:myapp/profile.dart';
import 'package:myapp/settings_customer.dart';
import 'package:myapp/user_type_selection.dart';
import 'package:myapp/welcomesecond.dart';

class RouterClass {
  final router = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) {
          return const HomeScreen();
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
    ],
  );
}
