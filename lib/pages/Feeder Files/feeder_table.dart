import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/Feeder%20Files/feeder_controller.dart';
import 'package:intl/intl.dart';

import 'feeder_test_data.dart'; // Test data for dev

class FeederTable extends StatefulWidget {
  const FeederTable({super.key,
  required this.controller});

  final FeederController controller;

  @override
  State<FeederTable> createState() => _FeederTableState();
}

class _FeederTableState extends State<FeederTable> {
  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      children: [
        headerRow(),
        for (var row in testData) buildRow(row)
      ]
    );
  }

  /// Builds the table's header row with a list of stations.
  TableRow headerRow(){
    List<TableCell> cells = [];
    cells.add(buildCell(const Text('Date')));
    for (var station in listOfStations) {
      cells.add(buildCell(Text(station)));
    }
    return TableRow(
      children: cells
    );
  }

  /// Builds a row with the given Map.
  TableRow buildRow(Map<String, dynamic> rowData){
    // TODO: Anticipate date, and a list of actual entries
    // Build however many columns to hold date info, and a variable
    // Number of entries, one for each station. Cells should be interactable
    // to allow user editing.

    List<TableCell> cells = [];
    // Add date first
    var format = DateFormat('yyyy-MM-dd');
    String formattedDate = format.format(rowData['date']);
    cells.add(buildCell(Text(formattedDate)));
    for (var entry in rowData['data']) {
      // CellWrapper holds all cell data
      cells.add(buildCell(CellWrapper(
        data: entry, 
        date: rowData['date'],
        controller: widget.controller
      )));
    }
    return TableRow(
      children: cells
    );
  }

  /// Builds a cell holding the given Widget.
  TableCell buildCell(dynamic cellData){
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: cellData
    );
  }

  /// Builds an interactable cell denoting an entry.
  /// 
  /// feederName : Name of the user assigned the entry.
  TableCell buildEntryCell(String feederName){
    GestureDetector g = GestureDetector(
      onTap: () {
        widget.controller.setString(feederName); // TODO DEBUG
      },
      child: Text(feederName)
    );
    return buildCell(g);
  }
}

/// Wrapper Widget with Cell contents
class CellWrapper extends StatelessWidget{
  const CellWrapper({super.key,
  required this.data,
  required this.date,
  required this.controller});

  // TODO ought to be an entryID to a shared data from DB call
  final DateTime date;
  final Map<String, dynamic> data;
  final FeederController controller;

  @override
  Widget build(BuildContext context) {
    String feederName = optToString(data[feedIDString]);
    return GestureDetector(
      onTap: () {
        controller.setString(feederName); 
      },
      child: Text(feederName)
    );
  }

}

/// Given a piece of data that may be a String or null, returns that data.
/// Returns '' if the data is null.
String optToString(String? maybeString){
  if (maybeString == null) {
    return ''; 
  }
  else {
    return maybeString;
  }
}



