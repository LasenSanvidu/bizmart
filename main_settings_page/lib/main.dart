import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:main_settings_page/router/router.dart';

void main() {
  runApp(DevicePreview(
    enabled: true,
    builder: (context) => Myapp(),
  ));
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: RouterClass().router,
    );
  }
}
