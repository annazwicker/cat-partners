import 'package:flutter/material.dart';

import '../../services/firebase_helper.dart';

class EditAdminContent extends StatefulWidget {
  final Color textColor;

  const EditAdminContent({Key? key, required this.textColor}) : super(key: key);

  @override
  _EditAdminContentState createState() => _EditAdminContentState();
}

class _EditAdminContentState extends State<EditAdminContent> {
  String? selectedAdminUser;
  final TextEditingController emailController = TextEditingController();
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
          value: selectedAdminUser,
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
                  'Add Admin User',
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
                      'Email:',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                        ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
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
                          content: Text("Are you sure you want to add \"${emailController.text}\" as an admin user?"),
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
                                final emailedit = emailController.text;
                                //make user admin
                                _dbHelper.addAdmin(emailedit);
                                // Check if the name and feeding station are not empty
                                if (emailedit.isNotEmpty) {
                                  // Add success dialog
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Success'),
                                        content: Text('Admin user added successfully!'),
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
                                  print('Email: $emailedit');
                                  emailController.clear();
                                } else {
                                  // Add failure dialog
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Error'),
                                        content: Text('Please enter an email.'),
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
                    foregroundColor: Colors.white, backgroundColor: Colors.black, // white text
                  ),
                  child: const Text('Add Admin User'),
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
                  'Revoke Admin Permissions',
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
                    'Select Admin User',
                    ['5SLi4nS54TigU4XtHzAp', 'Kelly Lessard', 'Jayden Beauchea', 'Daniel Na', 'Anna Wicker', 'Marlon Mata'],
                      (String? value) {
                        setState(() {
                          selectedAdminUser = value;
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
                          content: Text("Are you sure you want to remove \"${selectedAdminUser}\" as an admin user?"),
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
                                if (selectedAdminUser != null) {
                                  // Add success dialog
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Success'),
                                        content: Text('Admin user added successfully!'),
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
                                  _dbHelper.removeAdmin(selectedAdminUser!);
                                  print('Selected Admin User: $selectedAdminUser');
                                  setState(() {
                                    selectedAdminUser = null;
                                  });
                                } else {
                                  // Add failure dialog
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Error'),
                                        content: Text('Please select an admin user.'),
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
                    foregroundColor: Colors.white, backgroundColor: Colors.black, // white text
                  ),
                  child: const Text('Revoke Permissions'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
