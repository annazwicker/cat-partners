import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/Feeder%20Files/feeder_controller.dart';
import 'package:flutter_application_1/pages/Feeder%20Files/feeder_table.dart';
import 'package:flutter_application_1/pages/Feeder%20Files/feeder_test_data.dart';

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
      setState(() {});
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
    return body;
  }

  Widget viewBody(){
    // Will hold basic structure of view mode sidebar
    Map<String, dynamic> currentEntry = widget.controller.currentEntry!;
    return Scaffold( 
      appBar: AppBar(
        title: const Text('Entry'),
        ),
      body: Center( child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(format.format(currentEntry['date'])), // Date
          Row( // Name + remove button
            children: <Widget>[
              Text(optToString(currentEntry[feedIDString])),
              const Text('button placeholder!'),
            ]
          ),
          // TODO Notes must be editable for user's entries.
          Text(optToString(currentEntry[noteIDString])), // Notes
        ]
    )));
  }

  Widget selectBody(){
    // Will hold basic structure of select mode sidebar
    return Scaffold( 
      appBar: AppBar(
        title: const Text('Select'),
        ), 
      body: Text(placeholderString)
    );
  }

  Widget defaultBody(){
    // Will hold basic structure of default (empty) sidebar
    return Scaffold( 
      appBar: AppBar(
        title: const Text('Welcome!'),
        ), 
      body: Text(placeholderString)
    );
  }

  selectCell(String placeholder) {
    setState(() {
      placeholderString = placeholder;
    });
  }

}