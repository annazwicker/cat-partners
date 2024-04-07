import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/Feeder%20Files/feeder_controller.dart';

class FeederSidebar extends StatefulWidget {
  const FeederSidebar({
    super.key, 
    required this.controller,
  }); 

  final FeederController controller;

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
  String placeholderString = 'placeholder';

  @override void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sidebar title'),
        ),
      body: Text(placeholderString),
    );
  }

  selectCell(String placeholder) {
    setState(() {
      placeholderString = placeholder;
    });
  }

}