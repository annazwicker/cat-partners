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

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  bool _isWindowOpen = true;

  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          if (_isWindowOpen)
            Positioned(
                top: 25,
                child: Container(
                  color: SUYellow,
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width * 0.85,
                  child:
                      Stack(alignment: AlignmentDirectional.center, children: [
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              _isWindowOpen = false;
                            });
                          },
                          icon: Icon(Icons.close)),
                    ),
                    Positioned(child: Text('Notifications'))
                  ]),
                )),
          Positioned(top: 0, left: 25, child: Text('Achievement Box')),
          Positioned(
            top: 150,
            child: Text('Scheduler'),
          ),
        ],
      ),
    );
  }
}
