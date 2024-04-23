import 'package:flutter/material.dart';

import '../../services/firebase_helper.dart';

class EditFeedingStationsContent extends StatefulWidget {
  final Color textColor;

  const EditFeedingStationsContent({Key? key, required this.textColor})
      : super(key: key);

  @override
  _EditFeedingStationsContentState createState() =>
      _EditFeedingStationsContentState();
}

class _EditFeedingStationsContentState
    extends State<EditFeedingStationsContent> {
  String? selectedFeedingStation;
  final TextEditingController nameController = TextEditingController();
  final _dbHelper = FirebaseHelper();

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
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black),
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
            value: selectedFeedingStation,
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
            // The add account section
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Add Feeding Station',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name:',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text;
                    print('Name: $name');
                    nameController.clear();
                    // Add functionality for adding an account
                    //create map for feeding station
                    Map<String, dynamic> stationMap = {
                      'description': 'placeholder',
                      'fullName': name,
                      'name': name,
                      'photo': "photo placeholder",
                    };
                    _dbHelper.addStation(stationMap);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black, // white text
                  ),
                  child: const Text('Add Feeding Station'),
                ),
              ],
            ),
          ),
          // create a line between the two sections so it's clear
          // which text boxes belong to the add and delete accounts sections
          Container(
            width: 1,
            color: Colors.black,
            margin: const EdgeInsets.only(left: 20.0, right: 20.0),
          ),
          Expanded(
            // the delete account portion
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Delete Feeding Station',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDropdownField(
                      'Select Feeding Station',
                      ['Admissions', 'Lord/Dorothy Lord Center', 'Mabee'],
                      (String? value) {
                        setState(() {
                          selectedFeedingStation = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                ElevatedButton(
                  onPressed: () {
                    var catStation = '';

                    switch (selectedFeedingStation) {
                      case 'Admissions':
                        catStation = 'PRw7fnDb8hAPF6YWL7NL';
                        break; // Don't forget to add break statements after each case to prevent fall-through.
                      case 'Lord/Dorothy Lord Center':
                        catStation = '1';
                        break;
                      case 'Mabee':
                        catStation = '2';
                        break;
                      default:
                        catStation =
                            ''; // You might want to handle a default case.
                    }
                    _dbHelper.deleteStation(catStation);

                    print('Selected Feeding Station: $selectedFeedingStation');
                    setState(() {
                      selectedFeedingStation = null;
                    });
                    // Add functionality for adding an account
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black, // white text
                  ),
                  child: const Text('Delete Feeding Station'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
