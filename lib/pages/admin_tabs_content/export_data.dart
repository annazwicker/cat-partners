import 'package:flutter/material.dart';

class ExportDataContent extends StatefulWidget {
  final Color textColor;

  const ExportDataContent({Key? key, required this.textColor}) : super(key: key);

  @override
  _ExportDataContentState createState() => _ExportDataContentState();
}

class _ExportDataContentState extends State<ExportDataContent> {
  String? selectedYear;

  Widget _buildDropdownField(
  String title,
  List<String> options,
  Function(String?) onChanged,
) {
  // Sort the options alphabetically
  options.sort();

  return Padding(
    padding: const EdgeInsets.only(left: 8.0, top: 20.0, bottom: 20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        DropdownButtonFormField<String>(
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(
                option,
                style: const TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
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
                Text(
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
                    // NOTE: Kelly wants the data from July 1 - June 30
                    _buildDropdownField(
                    'Select Academic Year',
                    ['2020-2021', '2021-2022', '2022-2023', '2023-2024'],
                      (String? value) {
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
                    setState(() {
                      selectedYear = null;
                    });
                    // Add functionality for exporting data
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
