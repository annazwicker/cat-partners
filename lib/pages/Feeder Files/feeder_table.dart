import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/const.dart';
import 'package:flutter_application_1/pages/Feeder%20Files/feeder_controller.dart';
import 'package:intl/intl.dart';

import '../../models/entry.dart';
import '../../models/station.dart';
import '../../models/userdoc.dart';
import '../../services/firebase_helper.dart';
import 'package:collection/collection.dart';

class FeederTable extends StatefulWidget {
  const FeederTable({super.key,
  required this.controller,
  required this.fh});

  final FeederController controller;
  final FirebaseHelper fh;

  @override
  State<FeederTable> createState() => _FeederTableState();
}

class _FeederTableState extends State<FeederTable> {

  // late Stream<QuerySnapshot<Entry>> entryStream;
  late List<QueryDocumentSnapshot<Station>> stations;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.controller.fds.stations,
      builder: (stationContext, stationSnapshot) {
        if (!stationSnapshot.hasData) {
          return const CircularProgressIndicator();
        }
        stations = stationSnapshot.data!;
        return StreamBuilder(
          stream: widget.controller.fds.tableStream,
          builder: (context, snapshot) {
            List<QueryDocumentSnapshot<Entry>> allEntries = snapshot.data?.docs ?? [];
        
            // Groups entries by date
            Map<Timestamp, List<QueryDocumentSnapshot<Entry>>> groupedEntries = groupBy(allEntries, 
              (p0) {
                return widget.fh.equalizeTime(p0.data().date);
              }
            );

            var entriesAsList = groupedEntries.entries.toList();
            entriesAsList.sort( (a, b) => a.key.compareTo(b.key));
            groupedEntries = Map.fromEntries(entriesAsList);
            
            var rows = buildAllRows(groupedEntries);
            var t = Table(
                  border: TableBorder.all(),
                  children: [headerRow()] + rows);
            // return t;
            return SingleChildScrollView(
              controller: ScrollController(),
              child: t
            );
          }
        );
      }
    );
  }

  List<TableRow> buildAllRows(Map<Timestamp, List<QueryDocumentSnapshot<Entry>>> groupedEntries) {
    List<TableRow> rows = [];
    groupedEntries.forEach((stamp, snapshots) { 
      DateTime date = stamp.toDate();
      // Ensure data for this row is valid (iterate through stations)
      bool rowIsValid = true;
      if(snapshots.length == stations.length) {
        // There must exist an entry for each station
        for (QueryDocumentSnapshot<Station> station in stations) {
          // Find entries with this stationID
          if(!snapshots.any((element) => element.data().stationID.id == station.id)){
            rowIsValid = false;
            break;
          }
        }
      } else { rowIsValid = false; }

      if(rowIsValid) {
        rows.add(buildRow(stamp, snapshots));
      } 
      else { // debug
        print('Row invalid: $date');
      }

    });
    // TODO sort rows...
    return rows; // TODO
  }
  
  TableRow buildRow(Timestamp date, List<QueryDocumentSnapshot<Entry>> data){
    List<TableCell> cells = [];
    // Add date first
    var format = DateFormat('yyyy-MM-dd');
    String formattedDate = format.format(date.toDate());
    cells.add(buildCell(Text(formattedDate)));
    for (int i = 0; i < data.length; i++) {
      // CellWrapper holds all cell data
      cells.add(buildCell(CellWrapper(
        data: data[i], 
        controller: widget.controller,
        fh: widget.fh,
      )));
    }
    return TableRow(
      children: cells
    );
  }

  /// Builds the table's header row with a list of stations.
  TableRow headerRow(){
    List<TableCell> cells = [];
    cells.add(buildCell(const Text('Date')));
    for (var station in stations) {
      cells.add(buildCell(
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Text(station.data().name))
      ));
    }
    return TableRow(
      children: cells
    );
  }

  /// Builds a cell holding the given Widget.
  TableCell buildCell(Widget cellData){
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: cellData
    );
  }
}

/// Wrapper Widget with Cell contents
class CellWrapper extends StatefulWidget{

  CellWrapper({super.key,
  required this.data,
  required this.controller,
  required this.fh});

  final QueryDocumentSnapshot<Entry> data;
  final FeederController controller;
  final FirebaseHelper fh;

  @override
  State<CellWrapper> createState() => _CellWrapperState();
}

class _CellWrapperState extends State<CellWrapper> {

  DocumentSnapshot<UserDoc>? assignedUser;
  bool isSelected = false;

  
  static const Color onDeselect = Colors.white;
  static const Color onSelect = Colors.lightBlue;
  Color currentColor = onDeselect;


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.controller.fds.getAssignedUser(widget.data),
      builder: (context, snapshot) {
        if (!snapshot.hasData){
          return Container(
          padding: const EdgeInsets.all(8.0),
          child: const Text('Loading...'),
          );
        }
        (bool, DocumentSnapshot<UserDoc>?) userTuple = snapshot.data!;
        String cellText = '';
        if(userTuple.$1){ // There is an assigned user
          assignedUser = userTuple.$2;
          UserDoc? userData = assignedUser!.data();
          if (userData == null) {
            cellText = 'ERROR';
          } else {
            cellText = userData.getName();
          }
        }
        
        return Container(
          color: currentColor,
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: doOnTap,
            child: Text(cellText),
          ),
        );
      }
    ); 
  }

  bool hasUser() {
    return assignedUser != null; 
    }

  void doOnTap() {
    // Enter view for unassigned entries
    if (!hasUser()){
      setState(() {
        widget.controller.toSelectState();
        isSelected = widget.controller.toggleSelection(widget.data);
        currentColor = isSelected ? onSelect : onDeselect;
        // print(isSelected);
        // print(currentColor);
      });
    }
    // Enter view for assigned entries
    else {
      widget.controller.toViewState(widget.data, assignedUser);
    }
  }

}



