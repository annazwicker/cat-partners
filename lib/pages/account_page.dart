//import 'dart:io';
//import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_application_1/const.dart'; 
import 'package:flutter_application_1/components/user_google.dart';

import '../services/firebase_helper.dart';

void main() => runApp(const AccountScreen());
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
    const appTitle = 'User Account Information';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const AccountInfoForm(),
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
  final _dbHelper = FirebaseHelper();
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _email;
  String? _phoneNumber;
  String? _affiliation;
  String? _rescuegroupaffiliation;

  final ScrollController _vertical = ScrollController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth;
    {// min window is 500, max is 1536 for my device
      if(screenWidth <= 800){
        containerWidth = screenWidth;
      } else { // screenWidth > 800
        containerWidth = screenWidth / 2;
      }
    }
    // added extra padding around the form
    return SingleChildScrollView(
      controller: _vertical,
      child: Builder( /////// builder - to add an if-else statement depending on window size
        builder: (context){ /// context -> window stuff
          if(screenWidth > 800){
            return horizontalWidgets(containerWidth);
          } else {
            return verticalWidgets(containerWidth);
          }
        }
      )
    );
  }

  Widget horizontalWidgets(double containerWidth){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            accountInfo(containerWidth),
            pfpBox(containerWidth)
          ],
        ),
        signOutButton()
      ],
    );
  }
  Widget verticalWidgets(double screenWidth){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        accountInfo(screenWidth),
        pfpBox(screenWidth),
        Padding(
          padding: const EdgeInsets.fromLTRB(0,0,0,20),
          child: signOutButton(),
        )
      ],
    );
  }
  // No longer using to upload image. Relying on user's own pfp from Google
  /*
  void selectImage() async{
    final ImagePicker imagePicker = ImagePicker();
    Uint8List temp;
      XFile? result = await imagePicker.pickImage(source: ImageSource.gallery);
      if (result != null) {
        //_pfp = File(result.path)
        temp = await result.readAsBytes(); 
        setState(() {
          _pfpByte = temp;
        });
      }
      
  }
  */
  Widget accountInfo(double containerWidth){
    return SizedBox(
      width: containerWidth,
      height: 520,
      child: Padding(
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
                // TextFormField(
                //   initialValue: 'value',
                //   readOnly: true,
                //   decoration: InputDecoration(
                //     labelText: 'Email',
                //     hintText: 'hintText',
                //     labelStyle: TextStyle(fontWeight: FontWeight.bold), // Bold label
                //   ),
                // ),

                _buildTextField('Email', 'email@gmail.com', (value) {
                  _email = 'email@gmail.com';
                  
                }),
                _buildTextField('Phone Number', 'Enter your phone number', (value) {
                  _phoneNumber = value;
                }),
                _buildDropdownField('SU Affiliation', ['Student', 'Staff', 'Faculty', 'Alumni', 'Parent of Student', 'Friend of Cats'], (value) {
                _affiliation = value;
                }),
                _buildTextField('Rescue Group Affiliation', 'Enter your rescue group affiliation', (value) {
                  _rescuegroupaffiliation = value;
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                        // Process the collected data (you can send it to a server or save it in a database
                        Map<String, dynamic> formData = {
                          'name': _name?.trim(),
                          'email': _email?.trim(),
                          'phone' : _phoneNumber?.trim(),
                          'affiliation': _affiliation?.trim(),
                          'rescueGroup': _rescuegroupaffiliation?.trim(),
                          };

                        //print('Name: $_name, Email: $_email, Phone Number: $_phoneNumber, Status: $_affiliation, Rescue Group Affiliation: $_rescuegroupaffiliation');
                        //create map 
                        //_dbHelper.changeProfileFields('5SLi4nS54TigU4XtHzAp', formData);
                        if(_email != UserGoogle.getUser().email){
                          UserGoogle().reLogin(_email!, _name, _phoneNumber, _affiliation, _rescuegroupaffiliation);
                        } else {
                          await UserGoogle().db.collection('users').doc(UserGoogle.getUser().uid).update(formData);
                        }
                      }
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget pfpBox(double containerWidth){
    return Container(
      alignment: Alignment.center,
      width: containerWidth,
      height: 520,
      child: Column(
        children: [
          Builder(
            builder: (context){
              try{
                return CircleAvatar(
                  radius: 200,
                  backgroundImage: NetworkImage(UserGoogle.getUser().photoURL.toString())
                );
              } on Exception{
                return const CircleAvatar(
                  radius: 200,
                  backgroundImage: AssetImage('images/defualtPFP.jpg')
                );
              }
            }
          )
        ],
      )
    );
  }

  Widget signOutButton(){
    return ElevatedButton(
      onPressed: () {UserGoogle.signOut();}, 
      child: const Text('Sign Out')  
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
          style: const TextStyle(fontWeight: FontWeight.bold),
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
          maxLines: null,
        ),
        const SizedBox(height: 15), // Add some spacing between fields
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
          style: const TextStyle(fontWeight: FontWeight.bold),
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
        const SizedBox(height: 10),
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