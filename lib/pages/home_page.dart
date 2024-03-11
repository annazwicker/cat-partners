import "package:flutter/material.dart";
import "package:flutter_application_1/components/nav_bar.dart";
import "package:flutter_application_1/const.dart";
import 'package:flutter_application_1/pages/about_page.dart';
import 'package:flutter_application_1/pages/account_page.dart';
import 'package:flutter_application_1/pages/admin_page.dart';
import 'package:flutter_application_1/pages/feeder_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    AboutScreen(),
    AdminScreen(),
    FeederScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TopNavBar(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Home Screen!!'),
    );
  }
}