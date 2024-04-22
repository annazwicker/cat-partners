import 'package:flutter/material.dart';


class EditAccountsContent extends StatelessWidget {
  final Color textColor;

  const EditAccountsContent({Key? key, required this.textColor}) : super(key: key);

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
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email:',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold
                        ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildDropdownField(
                  'Select Status',
                  ['Student', 'Staff', 'Faculty', 'Alumni', 'Parent of Student'],
                  (String? value) {
                    // Handle dropdown value change
                  },
                ),
                const SizedBox(height: 9),
                ElevatedButton(
                  onPressed: () {
                    // Add functionality for adding an account
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
            color: textColor,
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
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email:',
                       style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold
                        ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height:25),
                ElevatedButton(
                  onPressed: () {
                    // Add functionality for adding an account
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
