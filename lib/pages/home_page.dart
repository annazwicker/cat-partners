import "package:flutter/material.dart";
import "package:flutter_application_1/components/nav_bar.dart";
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
  final int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const AboutScreen(),
    const AdminScreen(),
    const FeederScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TopNavBar(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Home Screen!!'),
    );
  }
}
