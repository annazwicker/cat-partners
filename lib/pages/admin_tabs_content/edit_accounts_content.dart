import 'package:flutter/material.dart';


class EditAccountsContent extends StatefulWidget {
  final Color textColor;

  const EditAccountsContent({Key? key, required this.textColor}) : super(key: key);

  @override
  _EditAccountsContentState createState() => _EditAccountsContentState();
}

class _EditAccountsContentState extends State<EditAccountsContent> {
  String? selectedAffiliation;
  final TextEditingController emailControllerEdit = TextEditingController();
  final TextEditingController emailControllerDelete = TextEditingController();

  Widget _buildDropdownField(
    String title,
    List<String> options,
    Function(String?) onChanged,
  ) {
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
             value: selectedAffiliation, // Set initial value of dropdown
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
                  "Edit User's SU Affiliation",
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
                      controller: emailControllerEdit,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildDropdownField(
                  'Select SU Affiliation',
                  ['Student', 'Staff', 'Faculty', 'Alumni', 'Parent of Student'],
                  (String? value) {
                    setState(() {
                      selectedAffiliation = value;
                    });
                  },
                ),
                const SizedBox(height: 9),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context, 
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Confirm'),
                          content: Text("Are you sure you want to change the SU affiliation for \"${emailControllerEdit.text}\" to \"${selectedAffiliation}\"?"),
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
                                final emailedit = emailControllerEdit.text;
                                // Check if the name and feeding station are not empty
                                if (emailedit.isNotEmpty && selectedAffiliation != null) {
                                  // Add success dialog
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Success'),
                                        content: Text('SU Affiliation has successfully been changed.'),
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
                                  print('Email: $emailedit, Selected Affiliation: $selectedAffiliation');
                                  emailControllerEdit.clear();
                                  setState(() {
                                    selectedAffiliation = null;
                                  });
                                } else {
                                  // Add failure dialog
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Error'),
                                        content: Text('Please enter an email and select an SU affiliation.'),
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
                  child: const Text('Save Changes'),
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
                  'Delete Account',
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
                      controller: emailControllerDelete,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height:25),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context, 
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Confirm'),
                          content: Text("Are you sure you want to delete the account associated with the email \"${emailControllerDelete.text}\"?"),
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
                                final emaildelete = emailControllerDelete.text;
                                // Check if the name and feeding station are not empty
                                if (emaildelete.isNotEmpty) {
                                  // Add success dialog
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Success'),
                                        content: Text('User deleted successfully.'),
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
                                  final emaildelete = emailControllerDelete.text;
                                  print('Email: $emaildelete');
                                  emailControllerDelete.clear();
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
                  child: const Text('Delete Account'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
