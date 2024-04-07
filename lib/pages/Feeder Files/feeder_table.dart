import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/Feeder%20Files/feeder_controller.dart';
import 'package:intl/intl.dart'; // DateFormat

// To be used after date cell reformatting
final Map<int, String> monthMap = {
  1: 'Jan',
  2: 'Feb',
  3: 'Mar',
  4: 'Apr',
  5: 'May',
  6: 'Jun',
  7: 'Jul',
  8: 'Aug',
  9: 'Sep',
  10: 'Oct',
  11: 'Nov',
  12: 'Dec',
};

class FeederTable extends StatefulWidget {
  const FeederTable({super.key,
  required this.controller});

  final FeederController controller;

  @override
  State<FeederTable> createState() => _FeederTableState();
}

// Stations + cats
final List<int> testStationIDs = [0, 1, 2];
final Map<int, Map<String, dynamic>> testStationData = {
  0: {
    'name': 'Caskey Lords',
    'cats': ['Patches', 'Super Cal', 'Ziggy']
  },
  1: {
    'name': 'Mabee',
    'cats': ['Pumpkin', 'Princess']
  },
  2: {
    'name': 'Admissions',
    'cats': ['Gray Mama', 'Itty Bitty', 'Gaia', 'Teddy']
  },
};

// TODO REPLACE with call to DB
final List<String> listOfStations = ['Caskey', 'Mabee', 'Admin'];

// Placeholder variables
const String feedIDString = 'feederID';
const String noteIDString = 'notes';
const String sightingsIDString = 'sightings';
final List<Map<String, dynamic>> testData = [
      {
        'date': DateTime.utc(2024, 1, 1), 
        'data': [
          {feedIDString: 'Joe Schmoe',
           noteIDString: 'Saw Super Cal yelling at me',
           sightingsIDString: [true, true, false],
          },
          
          {feedIDString: 'Joe Schmoe',
           noteIDString: '',
           sightingsIDString: [true, true],
          },
          
          {feedIDString: 'Argus',
           noteIDString: '',
           sightingsIDString: [false, false, false, false],
          },
        ]
      },
      {
        'date': DateTime.utc(2024, 1, 2), 
        'data': [
          {feedIDString: 'Mary Sue',
           noteIDString: 'No one around :(',
           sightingsIDString: [false, false, false],
          },
          
          {feedIDString: 'Just Joe',
           noteIDString: '',
           sightingsIDString: [true, true],
          },
          
          {feedIDString: 'Tori Vanderbucks',
           noteIDString: 'Saw a silly little guy',
           sightingsIDString: [false, true, false, false],
          },
        ]
      },
      {
        'date': DateTime.utc(2024, 1, 3), 
        'data': [
          {feedIDString: 'Smorgus Borde',
           noteIDString: 'woah!!!1!!',
           sightingsIDString: [true, false, false],
          },
          
          {feedIDString: 'Smorgus Borde',
           noteIDString: '',
           sightingsIDString: [true, true],
          },
          
          {feedIDString: 'Smorgus Borde',
           noteIDString: '',
           sightingsIDString: [false, true, false, true],
          },
        ]
      },
      {
        'date': DateTime.utc(2024, 1, 4), 
        'data': [
          {feedIDString: null,
           noteIDString: '',
           sightingsIDString: [false, false, false],
          },
          
          {feedIDString: 'Felid Day',
           noteIDString: '',
           sightingsIDString: [true, true],
          },
          
          {feedIDString: 'Felid Day',
           noteIDString: '',
           sightingsIDString: [false, false, false, false],
          },
        ]
      },
    ];

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
      // Display user's name  
      if (entry[feedIDString] != null) {
        cells.add(buildEntryCell(entry[feedIDString]));
      } else {
        cells.add(buildEntryCell(''));
      }
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
