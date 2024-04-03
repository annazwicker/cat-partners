import 'package:flutter/material.dart';

class FeederSidebar extends StatefulWidget {
  const FeederSidebar({super.key});

  @override
  State<FeederSidebar> createState() => _FeederSidebarState();
}

class _FeederSidebarState extends State<FeederSidebar> {
  // TODO sidebar states
  // 1) Default
  // 2) Add-select (adding one/multiple entries)
  // 3) Selected filled entry
  //  a) yours
  //  b) someone else's

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sidebar title'),
        ),
    );
  }
}