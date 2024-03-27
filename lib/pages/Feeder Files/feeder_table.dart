import 'package:flutter/material.dart';

class FeederTable extends StatefulWidget {
  const FeederTable({super.key});

  @override
  State<FeederTable> createState() => _FeederTableState();
}

class _FeederTableState extends State<FeederTable> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> data = [
      {
        'col1': 'words', 
        'col2': 'more words'},
      {
        'col1': 'yet more words',
        'col2': 'the bogo bingus' },
    ];
    return Table(
      border: TableBorder.all(),
      children: [
        for (var row in data) buildRow(row)
      ]
    );
  }

  TableRow buildRow(Map<String, dynamic> rowData){
    // TODO: Anticipate date, and a list of actual entries
    // Build however many columns to hold date info, and a variable
    // Number of entries, one for each station. Cells should be interactable
    // to allow user editing.
    List<TableCell> cells = [];
    rowData.forEach((key, value) {
      cells.add(buildCell(Text(value)));
    });
    return TableRow(
      children: cells
    );
  }

  TableCell buildCell(dynamic cellData){
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: cellData
    );
  }
}
