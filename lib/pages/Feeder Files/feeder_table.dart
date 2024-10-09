
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
    Snapshots.ensureEntriesPast();
    return StreamBuilder(
      stream: Snapshots.stationStream,
      builder: (stationContext, stationSnapshot) {
        if (!stationSnapshot.hasData) {
          return const CircularProgressIndicator();
        }
        DateTime now = Snapshots.equalizeDate(DateTime.now());
        DateTime startDate = now.subtract(const Duration(days: 7)); // Start one week prior to current date
        DateTime endDate = now.add(const Duration(days: 14)); // End two weeks past current date

        stations = stationSnapshot.data!.docs;

        // Filter out stations that were deleted before the starting date
        stations = stations.where( (element) { 
          Timestamp? dateDeleted = element.data().dateDeleted;
          if (dateDeleted != null) { // Station has been deleted
            DateTime dateCreatedDate = Snapshots.equalizeDate(element.data().dateCreated.toDate());
            DateTime dateDeletedDate = Snapshots.equalizeDate(dateDeleted.toDate());
            return 
              // Don't include if station was added/deleted on same day (no entries)
              !dateCreatedDate.isAtSameMomentAs(dateDeletedDate) 
              // Don't include if station was deleted on/before start date
              && dateDeletedDate.isAfter(startDate);
          } else { return true; } // Station has never been deleted; include
        }).toList();

        // Limit entries shown to range of dates
        var entryRangeQuery = Snapshots.entriesFromToQuery(startDate, endDate);

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
      rows.add(buildRow(stamp, snapshots));
    });
    return rows; // TODO
  }
  
  TableRow buildRow(Timestamp date, List<QueryDocumentSnapshot<Entry>> data){
    List<TableCell> cells = [];

    // 'Indexes' entries by stationID
    var dataMap = groupBy(data, (p0) => p0.data().stationID.id);

    // Add date cell first
    String formattedDate = formatAbbr.format(date.toDate());
    cells.add(buildCell(commonCellWrapping(formattedDate)));
    
    // Add cells for each station
    for (var station in stations) {
      // Entry exists for this station
      if(dataMap.containsKey(station.id)){ 
        // CellWrapper holds all cell data
        cells.add(buildCell(CellWrapper(
          data: dataMap[station.id]![0], 
          controller: widget.controller,
        )));
      } 
      // Entry does not exist for this station
      else {
        // Display null cell
        cells.add(buildCell(
          Container(
            alignment: Alignment.center,
            color: Colors.black,
            padding: const EdgeInsets.all(8.0),
            child: const Text('N/A', 
              style: TextStyle(color: Colors.white),)
          )
        ));
      }
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