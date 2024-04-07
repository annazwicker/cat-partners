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

    // DEBUG: Change placeholder string.
    widget.controller.addListener(() {
      setState(() {
        placeholderString = widget.controller.testStr;
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    widget.controller.checkState();
    Widget body = switch (widget.controller.currentState){
      PageState.empty => defaultBody(),
      PageState.select => selectBody(),
      PageState.view => viewBody(),
    };
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sidebar title'),
        ),
      body: body,
    );
  }

  Widget viewBody(){
    // Will hold basic structure of view mode sidebar
    return Text(placeholderString);
  }

  Widget selectBody(){
    // Will hold basic structure of selection mode sidebar
    Map<String, dynamic> currentEntry = widget.controller.currentEntry!;
    return Text(placeholderString);

  }

  Widget defaultBody(){
    // Will hold basic structure of default (empty) sidebar
    return Text(placeholderString);
  }

  selectCell(String placeholder) {
    setState(() {
      placeholderString = placeholder;
    });
  }

}