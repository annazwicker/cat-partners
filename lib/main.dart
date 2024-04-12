import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:google_auth/firebase_options.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/components/login_page.dart';
import 'package:flutter_application_1/components/user_google.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); // add firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: UserGoogle.user != null ? const HomePage() : const LoginPage());
  }
}
