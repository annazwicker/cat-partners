import "package:flutter/material.dart";
import 'package:flutter_application_1/const.dart';

class TopNavBar extends StatelessWidget {
  const TopNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: [
        Tab(icon: Icon(Icons.home), text: 'Home'),
        Tab(icon: Icon(Icons.favorite), text: 'About'),
        Tab(icon: Icon(Icons.person), text: 'Admin'),
        Tab(icon: Icon(Icons.person), text: 'Feeder Sign Up'),
        Tab(icon: Icon(Icons.person), text: 'Account'),
      ],
    );
  }
}
