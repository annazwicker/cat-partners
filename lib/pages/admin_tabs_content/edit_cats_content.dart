import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firebase_helper.dart';

class EditCatsContent extends StatefulWidget {
  final Color textColor;

  const EditCatsContent({Key? key, required this.textColor}) : super(key: key);

  @override
  _EditCatsContentState createState() => _EditCatsContentState();
}

class _EditCatsContentState extends State<EditCatsContent> {
  String? selectedfeedingstation;
  String? selectedcat;

  final _dbHelper = FirebaseHelper();

  final TextEditingController nameController = TextEditingController();

  Widget _buildDropdownFieldAdd(
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
            value: selectedfeedingstation,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildDropdownFieldDelete(
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
            value: selectedcat,
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
                  'Add Cat',
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
                const SizedBox(height: 9),
                _buildDropdownFieldAdd(
                  'Select Feeding Station',
                  ['Admissions', 'Lord/Dorothy Lord Center', 'Mabee'],
                  (String? value) {
                    setState(() {
                      selectedfeedingstation = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: () {
                    showDialog(
                      context: context, 
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Confirm'),
                          content: Text("Are you sure you want to add a new cat named \"${nameController.text}\" at the \"${selectedfeedingstation}\" feeding station?"),
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
                                final catname = nameController.text;
                                // Check if the name and feeding station are not empty
                                if (catname.isNotEmpty && selectedfeedingstation != null) {
                                  // Add success dialog
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Success'),
                                        content: Text('Cat added successfully!'),
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
                                   //change in future to not be hard coded
                                  var catStation = '';

                                  switch (selectedfeedingstation) {
                                    case 'Admissions':
                                      catStation = '0';
                                      break;
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

                                  //create Map for adding cat

                                  Map<String, dynamic> catMap = {
                                    'description': 'placeholder',
                                    'name': catname,
                                    'photo': 'photo placeholder',
                                    'stationID': catStation,
                                  };

                                  //call function
                                  _dbHelper.addCat(catMap);

                                  print('Cat Name: $catname, Selected Feeding Station: $selectedfeedingstation');
                                  nameController.clear();
                                  setState(() {
                                    selectedfeedingstation = null;
                                  });
                                } else {
                                  // Add failure dialog
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Error'),
                                        content: Text('Please enter a name and select a feeding station.'),
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
                  child: const Text('Add Cat'),
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
                  'Delete Cat',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDropdownFieldDelete(
                      'Select Cat',
                      [
                        'Gray Mama',
                        'Gaia',
                        'Itty Bitty',
                        'Teddy',
                        'Patches',
                        'Ziggy',
                        'Super Cal',
                        'Pumpkin',
                        'Princess'
                      ],
                      (String? value) {
                        setState(() {
                          selectedcat = value;
                        });
                      },
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
                          content: Text("Are you sure you want to remove \"${selectedcat}\" from the list of cats?"),
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
                                // Check if the name and feeding station are not empty
                                if (selectedcat != null) {
                                  // Add success dialog
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Success'),
                                        content: Text('Cat deleted successfully!'),
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
                                  var catNumber = '';
            
                                  switch (selectedcat) {
                                    case 'Gray Mama':
                                      catNumber = '2BsT3Qfr3jDpMN9HGJnA';
                                      break;
                                    case 'Gaia':
                                      catNumber = '1';
                                      break;
                                    case 'Itty Bitty':
                                      catNumber = '2';
                                      break;
                                    case 'Teddy':
                                      catNumber = '3';
                                      break;
                                    case 'Patches':
                                      catNumber = '4';
                                      break;
                                    case 'Ziggy':
                                      catNumber = '5';
                                      break;
                                    case 'Super Cal':
                                      catNumber = '6';
                                      break;
                                    case 'Pumpkin':
                                      catNumber = '7';
                                      break;
                                    case 'Princess':
                                      catNumber = '8';
                                      break;
                                    default:
                                      catNumber = ''; // Handle default case if needed
                                  }

                                  _dbHelper.deleteCat(catNumber);
                                  print('Selected Cat: $selectedcat');
                                  setState(() {
                                    selectedcat = null;
                                  });
                                } else {
                                  // Add failure dialog
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Error'),
                                        content: Text('Please select a cat to remove.'),
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
                  child: const Text('Delete Cat'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
