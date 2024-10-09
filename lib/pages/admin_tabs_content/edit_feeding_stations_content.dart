import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../components/snapshots.dart';
import '../../models/station.dart';
import '../../services/firebase_helper.dart';

class EditFeedingStationsContent extends StatefulWidget {
  final Color textColor;

  const EditFeedingStationsContent({super.key, required this.textColor});

  @override
  State<EditFeedingStationsContent> createState() =>
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
                const Text(
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
                    const Text(
                      'Name:',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                     showDialog(
                      context: context, 
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Confirm'),
                          content: Text("Are you sure you want to add a feeding station named \"${nameController.text}\"?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              }, 
                              child: const Text('Cancel')
                            ), 
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                               final name = nameController.text;
                                // Check if the name and feeding station are not empty
                                if (name.isNotEmpty) {
                                  // Add success dialog
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Success'),
                                        content: Text('Feeding station added successfully!'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            }, 
                                            child: const Text('OK')
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  print('Name: $name');
                                  nameController.clear();
                                  //create map for feeding station
                                  Station station = Station(
                                    description: 'placeholder', 
                                    fullName: name, 
                                    name: name, 
                                    photo: 'photo placeholder', 
                                    dateCreated: Timestamp.now());
                                  Snapshots.addStation(station);
                                } else {
                                  // Add failure dialog
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Error'),
                                        content: Text('Please enter a name.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            }, 
                                            child: const Text('OK')
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              }, 
                              child: const Text('Confirm'),
                            )
                          ],    
                        );
                      }
                    );
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
            child: StreamBuilder(
                stream: _dbHelper.stationsRef.where(Station.dateDeletedString, isNull: true).snapshots(),
                builder: (context, snapshot) {
                  List stationSnapshots = snapshot.data?.docs ?? [];
                  stationSnapshots.sort((a, b) {
                    String aDT = a.data().name;
                    String bDT = b.data().name;
                    int comp = aDT.compareTo(bDT);
                    if (comp == 0) {
                      String aS = a.id;
                      String bS = b.id;
                      return aS.compareTo(bS);
                    }
                    return comp;
                  });
                  //map of station docID and names
                  Map<String, dynamic> stationMap = {};
                  // Iterate over each document snapshot in the list
                  stationSnapshots.forEach((doc) {
                    // Get the document ID
                    String docId = doc.id;
                    // Get the name from the document data
                    String name = doc['name'];
                    // Add the document name-id pair to the map
                    stationMap[name] = docId;
                  });
                  //drop down list: stations
                  List<String> stationDropDown = stationMap.keys.toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
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
                            stationDropDown,
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
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Confirm'),
                                  content: Text(
                                      "Are you sure you want to delete \"${selectedFeedingStation}\" from the list of feeding stations?"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          //confirm press?
                                          print("line267");
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel')),
                                    TextButton(
                                      onPressed: () {
                                        print("line275");
                                        Snapshots.deleteStation(
                                            stationMap[selectedFeedingStation]);
                                        Navigator.of(context).pop();
                                        // Check if the name and feeding station are not empty
                                        if (selectedFeedingStation != null) {
                                          // Add success dialog
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text('Success'),
                                                content: const Text(
                                                    'Feeding station deleted successfully!'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text('OK')),
                                                ],
                                              );
                                            },
                                          );
                                          print(
                                              'Selected Feeding Station: $selectedFeedingStation');
                                          setState(() {
                                            selectedFeedingStation = null;
                                          });
                                        } else {
                                          // Add failure dialog
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text('Error'),
                                                content: const Text(
                                                    'Please select a feeding station.'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text('OK')),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      child: const Text('Confirm'),
                                    )
                                  ],
                                );
                              });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black, // white text
                        ),
                        child: const Text('Delete Feeding Station'),
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}
