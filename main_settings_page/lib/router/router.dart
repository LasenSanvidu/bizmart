import 'package:go_router/go_router.dart';
import 'package:main_settings_page/main_settings_page/main_settings.dart';
import 'package:main_settings_page/main_settings_page/settings_customer.dart';

class RouterClass {
  final router = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) {
          return const MainSettings();
        },
      ),
      GoRoute(
        path: "/settings",
        builder: (context, state) {
          return const SettingsPage();
        },
      )
    ],
  );
}
