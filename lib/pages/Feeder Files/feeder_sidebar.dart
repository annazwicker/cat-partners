import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/const.dart';
import 'package:flutter_application_1/pages/Feeder%20Files/feeder_controller.dart';
import 'package:flutter_application_1/services/firebase_helper.dart';

import '../../components/snapshots.dart';
import '../../models/entry.dart';
import '../../models/station.dart';

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

    Future<bool> isThisUserEntry() async {
      var currentUser = await Snapshots.getCurrentUserTEST();
      return currentUser.path == currentEntryData.assignedUser!.path;
    }
    
    Map<String, String> prints = {
      'date': formatAbbr.format(currentEntryData.date.toDate()), 
      'user': entryUserName,
      'note': currentEntryData.note,
      };

    Container commonCont(String string) => Container(
    alignment: Alignment.topLeft,
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: Text(string),
    );
  
    IconButton exitButton() => IconButton(
      onPressed: () {
        widget.controller.toEmptyState();
      }, 
      icon: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.close),
      )); 
    
    Container fieldNameCont(String text) => 
      Container(
        margin: const EdgeInsets.only(top: 8.0, bottom: 4.0, right: 4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: SUYellow),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(text),
      );

    Container fieldDataCont(String text) =>
      Container(
        margin: const EdgeInsets.only(top: 8.0, bottom: 4.0, right: 4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.grey[350]),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(text),
      );

    return FutureBuilder(
      future: isThisUserEntry(),
      builder: (context, snapshot) {
        bool isUsersEntry = false;
        if(snapshot.hasData){
          isUsersEntry = snapshot.data!;
          if(isUsersEntry) {
          }
        }
        var notesController = TextEditingController( text: prints['note']);
       
        return Scaffold( 
          appBar: AppBar(
            title: const Text('Entry'),
            actions: [exitButton()]
            ),
          body: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.topLeft,
                child: Table(
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: IntrinsicColumnWidth(),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      children: [
                        fieldNameCont('Date'),
                        fieldDataCont(prints['date']!),
                        Container(),
                      ],
                    ), 
                    TableRow(
                      children: [
                        fieldNameCont('Station'),
                        FutureBuilder(
                          future: Snapshots.getDocument<Station>(currentEntryData.stationID), 
                          builder:
                          (context, snapshot) {
                            String contents = 'Loading';
                            if(snapshot.hasData){
                              contents = snapshot.data!.data().name;
                            }
                            return fieldDataCont(contents);
                          },
                        ),
                        Container(),
                      ],
                    ),
                    TableRow(
                      children: [
                        fieldNameCont('Feeder'),
                        fieldDataCont(prints['user'] ?? ''),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange[700],
                              foregroundColor: Colors.black),
                            onPressed: isUsersEntry ? () {
                              showDialog(
                                context: context, 
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Confirm'),
                                    content: const Text('Are you sure you want to unassign yourself from this entry?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }, 
                                        child: const Text('Cancel')
                                      ), 
                                      TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        widget.controller.unassignCurrent();
                                      }, 
                                      child: const Text('Unassign')
                                      )
                                    ],    
                                  );
                                }
                              );
                              } : null, 
                          child: const Text('Unassign')),
                        ),
                      ]
                    )
                  ],
                ),
              ),
              Container( // Notes
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                alignment: Alignment.topLeft,
                child: TextField(
                  enabled: isUsersEntry,
                  // readOnly: !isUsersEntry,
                  maxLines: null,
                  expands: true,
                  controller: notesController,
                  decoration: const InputDecoration(
                    filled: true,
                    constraints: BoxConstraints(
                      minHeight: 5.0,
                      maxHeight: 150,
                    ),
                    hintText: 'Use this field to write anything notable \nyou see while feeding the station.',
                    hintMaxLines: null,
                    labelText: 'Notes',),
                  onChanged: (value) {
                    // saveButton.
                  },
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: SUYellow,
                ),
                statesController: MaterialStatesController(),
                onPressed: isUsersEntry ? () {
                  if(notesController.text != prints['note']){
                    widget.controller.fh.db.runTransaction(
                      (transaction) async {
                        Entry newEntry = currentEntryData.copyWith(note: notesController.text);
                        transaction.update(currentEntry.reference, newEntry.toJson());
                      }
                    );
                  }
                } : null, 
                child: const Text('Save notes')
              ),
            ]
                  ));
      }
    );
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
      QueryDocumentSnapshot<Station> station = await Snapshots.getDocument<Station>(data.stationID);
      rows.add(TableRow(
          children: [
              TableCell(child: Text(formatAbbr.format(data.date.toDate()))),
              TableCell(child: Text(station.data().name)),
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