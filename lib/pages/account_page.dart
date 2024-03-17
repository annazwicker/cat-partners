import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

void main() => runApp(const AccountScreen());

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'User Account Information';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: AccountInfoForm(),
      ),
    );
  }
}

class AccountInfoForm extends StatefulWidget {
  const AccountInfoForm({Key? key});

  @override
  AccountInfoFormState createState() {
    return AccountInfoFormState();
  }
}

class AccountInfoFormState extends State<AccountInfoForm> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _email;
  String? _phoneNumber;
  String? _status;
  String? _rescuegroupaffiliation;


  @override
  Widget build(BuildContext context) {
    // added extra padding around the form
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Name', 'Enter your name', (value) {
                _name = value;
              }),
              _buildTextField('Email', 'Enter your email', (value) {
                _email = value;
              }),
              _buildTextField('Phone Number', 'Enter your phone number', (value) {
                _phoneNumber = value;
              }),
              _buildDropdownField('Status', ['Student', 'Staff', 'Faculty', 'Alumni', 'Parent of Student'], (value) {
              _status = value;
              }),
              _buildTextField('Rescue Group Affiliation', 'Enter your rescue group affiliation', (value) {
                _rescuegroupaffiliation = value;
              }),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
          
                      // Process the collected data (you can send it to a server or save it in a database)
                      print('Name: $_name, Email: $_email, Phone Number: $_phoneNumber, Status: $_status, Rescue Group Affiliation: $_rescuegroupaffiliation');
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// This is the code that creates the name of the text field and the actual box
// for users to submit information.
  Widget _buildTextField(String title, String hintText, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextFormField(
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hintText,
          ),
        ),
        SizedBox(height: 15), // Add some spacing between fields
      ],
    );
  }
}


  Widget _buildDropdownField(String title, List<String> options, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        DropdownButtonFormField<String>(
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
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
        SizedBox(height: 10),
    ],
  );
}

// This was the original test code for the account page
// keeping it here just in case, but likely will have no use for it.
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text('Account Screen'),
//     );
//   }

// }