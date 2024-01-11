import 'package:flutter/material.dart';
import 'package:iot/components/auth_page.dart';
import 'package:iot/pages/crud_firebase.dart';
import 'package:iot/pages/home_page.dart';
import 'package:iot/pages/landing_pages.dart';
import 'package:iot/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:iot/pages/register_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
    );
  }
}

