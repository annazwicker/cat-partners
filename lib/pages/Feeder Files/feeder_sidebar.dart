import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/const.dart';
import 'package:flutter_application_1/pages/Feeder%20Files/feeder_controller.dart';
import 'package:flutter_application_1/services/firebase_helper.dart';

import '../../models/entry.dart';
import '../../models/station.dart';
import 'feeder_data_source.dart';

class FeederSidebar extends StatefulWidget {
  const FeederSidebar({
    super.key, 
    required this.controller,
    required this.fh
  }); 

  final FeederController controller;
  final FirebaseHelper fh;

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
    QueryDocumentSnapshot<Entry> currentEntry = widget.controller.currentEntry!;
    Entry currentEntryData = currentEntry.data();
    String entryUserName = widget.controller.getCurrentEntryUserName();

    List<String> prints = [
      formatAbbr.format(currentEntryData.date.toDate()), 
      entryUserName,
      currentEntryData.note
      ];
    
    IconButton exitButton() => IconButton(
      onPressed: () {
        widget.controller.toEmptyState();
      }, 
      icon: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.close),
      )); 
    return Scaffold( 
      appBar: AppBar(
        title: const Text('Entry'),
        actions: [exitButton()]
        ),
      body: Center( child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(16.0),
            child: Text('Date: ${prints[0]}'),
          ), // Date
          Row( // Name + remove button
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                child: Text('Feeder: ${prints[1]}'),
              ),
              // TODO add button
            ]
          ),
          // TODO Notes must be editable for user's entries.
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
            child: Text('Notes: \n${prints[2]}')
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
      body: Container( // TODO wrap in scrollable
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
            child: const Text('Selected entries: '),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
            child: FutureBuilder(
              future: getSelectedEntryRows(),
              builder: (context, snapshot) {
                if(!snapshot.hasData) {
                  return const Text('Loading...');
                }
                return Table(
                  children: [
                    const TableRow(
                      decoration:BoxDecoration(
                        color: SUYellow
                      ),
                      children: [
                        TableCell(child: Text('Date', 
                          style:TextStyle(fontWeight:FontWeight.bold))),
                        TableCell(child: Text('Station',
                          style:TextStyle(fontWeight:FontWeight.bold))),
                      ]
                    )] + snapshot.data!
                );
              }
            ),
          ),
          // TODO confirm button should stick to bottom of sidebar
          Container(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: SUYellow,
                foregroundColor: Colors.black),
              onPressed: () 
              // TODO assigns user to all selected entries and returns to default mode.
              {
                widget.controller.commitSelections();
              }, 
            child: const Text('Confirm')),
          ),
        ],) // TODO implement
      ),
    );
  }

  Future<List<TableRow>> getSelectedEntryRows() async {
    List<TableRow> rows = [];
    for (var entry in widget.controller.getSelection()) {
      Entry data = entry.data();
      Station station;
      station = await widget.controller.fds.getStation(data.stationID);
      rows.add(TableRow(
          children: [
              TableCell(child: Text(formatAbbr.format(data.date.toDate()))),
              TableCell(child: Text(station.name)),
            ],
        ));
    }
    return rows;

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