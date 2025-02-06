import 'package:flutter/material.dart';
//import 'package:mojo/login_page.dart'; 
import 'package:mojo/login.dart';
//import 'package:firebase_core/firebase_core.dart'; // added for firebase access.
import 'package:mojo/welcomesecond.dart';
import 'package:device_preview/device_preview.dart';

void main() async{ // async added for continous access from project to firebase.
  WidgetsFlutterBinding.ensureInitialized(); 
 
  //await Firebase.initializeApp(); // added for firebase access.
 
  runApp(
    DevicePreview(

      enabled: true,
      builder: (context) => MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: WelcomeSecond(),
      home: Login()
    );
  }
}
