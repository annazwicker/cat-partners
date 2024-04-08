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

  @override void initState() {
    // Resets state on any Controller change
    // TODO specialize if needed (are there Controller
    // changes that don't necessitate a reload?)
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
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(16.0),
            child: Text('Date: ${format.format(currentEntry['date'])}'),
          ), // Date
          Row( // Name + remove button
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                child: Text('Feeder: ${optToString(currentEntry[feedIDString])}'),
              ),
              // TODO add button
            ]
          ),
          // TODO Notes must be editable for user's entries.
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
            child: Text('Notes: \n${optToString(currentEntry[noteIDString])}')
          ), // Notes
        ]
    )));
  }

  /// Holds build return of selection mode sidebar
  Widget selectBody(){
    return Scaffold( 
      appBar: AppBar(
        title: const Text('Select'),
        ), 
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: const Text('Selection mode') // TODO implement
      ),
    );
  }

  /// Holds build return of default sidebar
  Widget defaultBody(){
    return Scaffold( 
      appBar: AppBar(
        title: const Text('Welcome!'),
        ), 
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: const Text('Select an entry to get started.') // TODO add text
      ),
    );
  }
}