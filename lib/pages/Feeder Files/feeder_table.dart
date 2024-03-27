import 'package:flutter/material.dart';

class FeederTable extends StatefulWidget {
  const FeederTable({super.key});

  @override
  State<FeederTable> createState() => _FeederTableState();
}

class _FeederTableState extends State<FeederTable> {
  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      children: const <TableRow>[
         TableRow(
          children: <Widget>[
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Text('Words')
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Text('More words')
            )
          ]
        ),
        TableRow(
          children: <Widget>[
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Text('yet more words')
            )
          ])
      ],
    );
  }
}
