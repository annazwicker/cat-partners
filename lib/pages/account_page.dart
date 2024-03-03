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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
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
          _buildTextField('Status', 'Select your status', (value) {
            _phoneNumber = value;
          }),
          _buildTextField('Rescue Group Affiliation', 'Enter your rescue group affiliation', (value) {
            _phoneNumber = value;
          }),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );

                  // Process the collected data (you can send it to a server or save it in a database)
                  print('Name: $_name, Email: $_email, Phone Number: $_phoneNumber');
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

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
        SizedBox(height: 10), // Add some spacing between fields
      ],
    );
  }
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