
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/const.dart';
import 'package:flutter_application_1/pages/Feeder%20Files/feeder_controller.dart';

import '../../models/entry.dart';
import '../../models/station.dart';
import '../../components/snapshots.dart';
import 'package:collection/collection.dart';

import 'cell_wrapper.dart';

Widget commonCellWrapping(String text, {Color? color}) {
  return Container(
    alignment: Alignment.center,
    color: color,
        padding: const EdgeInsets.all(8.0),
        child: Text(text)
  );
}

class FeederTable extends StatefulWidget {
  const FeederTable({super.key,
  required this.controller});

  final FeederController controller;

  @override
  State<FeederTable> createState() => _FeederTableState();
}

class _FeederTableState extends State<FeederTable> {

  // late Stream<QuerySnapshot<Entry>> entryStream;
  late List<QueryDocumentSnapshot<Station>> stations;

  @override
  Widget build(BuildContext context) {
    // Ensures entries exist for at least 2 weeks past current date
    // Snapshots.ensureEntriesPast();
    return FutureBuilder(
      future: Snapshots.stationQuery,
      builder: (stationContext, stationSnapshot) {
        if (!stationSnapshot.hasData) {
          return const CircularProgressIndicator();
        }
        stations = stationSnapshot.data!;
        
        // Limit entries shown to range of dates
        DateTime now = Snapshots.equalizeDate(DateTime.now());
        var entryRangeQuery = Snapshots.entriesFromToQuery(
          now.subtract(const Duration(days: 7)),  // Start one week prior to current date
          now.add(const Duration(days: 14))); // End two weeks past current date
        return StreamBuilder(
          stream: entryRangeQuery.snapshots(),
          builder: (context, snapshot) {
            List<QueryDocumentSnapshot<Entry>> allEntries = snapshot.data?.docs ?? [];
        
            // Groups entries by date
            Map<Timestamp, List<QueryDocumentSnapshot<Entry>>> groupedEntries = groupBy(allEntries, 
              (p0) {
                return Snapshots.equalizeTime(p0.data().date);
              }
            );

            var entriesAsList = groupedEntries.entries.toList();
            entriesAsList.sort( (a, b) => a.key.compareTo(b.key));
            groupedEntries = Map.fromEntries(entriesAsList);
            
            var rows = buildAllRows(groupedEntries);
            // return t;
            return SingleChildScrollView(
              controller: ScrollController(),
              child: Table(
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                  },
                  border: TableBorder.all(),
                  children: [headerRow()] + rows)
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
            // print('couldn\'t find an entry for station ${station.id} on date ${formatDashes.format(date)}');
            rowIsValid = false;
            break;
          }
        }
      } else 
      { 
        // print('Unexpected number of entries for date ${formatDashes.format(date)}.'
        // ' Expected ${stations.length}, got ${snapshots.length}');
        rowIsValid = false; 
      }

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
    String formattedDate = formatAbbr.format(date.toDate());
    cells.add(buildCell(commonCellWrapping(formattedDate)));
    for (int i = 0; i < data.length; i++) {
      // CellWrapper holds all cell data
      cells.add(buildCell(CellWrapper(
        data: data[i], 
        controller: widget.controller,
      )));
    }
    return TableRow(
      children: cells
    );
  }

  /// Builds the table's header row with a list of stations.
  TableRow headerRow(){
    List<TableCell> cells = [];
    cells.add(buildCell(commonCellWrapping('Date', color:SUYellow)));
    for (var station in stations) {
      cells.add(buildCell(commonCellWrapping(station.data().name, color:SUYellow)));
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