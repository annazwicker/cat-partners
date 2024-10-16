import "package:flutter/material.dart";
import 'package:flutter_application_1/const.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/pages/about_page.dart';
import 'package:flutter_application_1/pages/account_page.dart';
import 'package:flutter_application_1/pages/admin_page.dart';
import 'package:flutter_application_1/pages/feeder_page.dart';
import 'package:flutter_application_1/pages/test_page.dart';

class TopNavBar extends StatefulWidget {
  const TopNavBar({super.key});

  @override
  State<TopNavBar> createState() => _TopNavBarState();
}

class _TopNavBarState extends State<TopNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    AboutScreen(),
    AdminScreen(),
    FeederScreen(),
    const AccountScreen(),
    const TestScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: SUYellow,
        title: const Text('Southwestern Cat Partners'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: BottomNavigationBar(
            backgroundColor: SUYellow,
            type: BottomNavigationBarType.fixed,
            elevation: 0.0,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: SUYellow,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.info),
                label: 'About',
                backgroundColor: SUYellow,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.admin_panel_settings),
                label: 'Admin',
                backgroundColor: SUYellow,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_dining),
                label: 'Sign Up to Feed',
                backgroundColor: SUYellow,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_box),
                label: 'Account',
                backgroundColor: SUYellow,
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.home),
              //   label: 'Testing',
              //   backgroundColor: SUYellow,
              // ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
            onTap: _onItemTapped,
          ),
        ),
      ),
      body: Center( 
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
