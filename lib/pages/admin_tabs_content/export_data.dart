import 'package:flutter/material.dart';

import '../../components/snapshots.dart';

class ExportDataContent extends StatefulWidget {
  final Color textColor;

  const ExportDataContent({Key? key, required this.textColor}) : super(key: key);

  @override
  _ExportDataContentState createState() => _ExportDataContentState();
}

class _ExportDataContentState extends State<ExportDataContent> {
  int? selectedYear;

  Widget buildDropdownField(
  String title,
  List<(int, String)> options,
  void Function(int?) onChanged,
) {
  // Sorting the options by the number year
  options.sort((a, b) { return a.$1.compareTo(b.$1); });

  return Padding(
    padding: const EdgeInsets.only(left: 8.0, top: 20.0, bottom: 20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        DropdownButtonFormField<int>(
          items: options.map(((int, String) option) {
            return DropdownMenuItem<int>(
              value: option.$1, // Return starting year
              child: Text(
                option.$2, // Display string
                style: const TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (value) {
            if (value == null) {
              return 'Please select an option';
            }
            return null;
          },
          value: selectedYear,
        ),
        const SizedBox(height: 10),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      // make the whole page a giant 'row' with columns within the row
      // to make the add accounts portion separate from the delete accounts portion
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            // the delete account portion
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Export Data as a CSV file',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tuples used to couple starting year with display
                    buildDropdownField(
                    'Select Academic Year (Starting July 1st).',
                    [(2020, '2020-2021'), (2021, '2021-2022'), (2022, '2022-2023'), (2023, '2023-2024')],
                    (int? value) {
                      setState(() {
                        selectedYear = value;
                      });
                    },
                ),
                  ],
                ),
                const SizedBox(height: 9),
                ElevatedButton(
                  onPressed: () {
                    print('Selected Year: $selectedYear');
                    if(selectedYear == null){
                      // TODO show user some error message before returning
                      print('Please select a year');
                      return;
                    }
                    // TODO show user download process; tell them when DL is done
                    // TODO show user error if something goes wrong
                    var (startDate, endDate) = Snapshots.academicYear(selectedYear!);
                    Snapshots.saveEntryCSVTimeframe(startDate, endDate);
                    setState(() {
                      selectedYear = null;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.black, // white text
                  ),
                  child: const Text('Export Data'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
