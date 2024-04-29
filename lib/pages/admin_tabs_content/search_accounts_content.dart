import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firebase_helper.dart';

import '../../const.dart';
import '../../models/userdoc.dart';

class SearchUsersContent extends StatefulWidget {
  final Color textColor;

  const SearchUsersContent({Key? key, required this.textColor}) : super(key: key);

  @override
  _SearchUsersContentState createState() => _SearchUsersContentState();
}

class _SearchUsersContentState extends State<SearchUsersContent> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final FirebaseHelper fh = FirebaseHelper();
  bool doSearch = false;

  final ScrollController _searchScroll = new ScrollController();
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _searchScroll,
      child: Padding(
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
                  'Search for a user using their email address',
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
                    // const Text(
                    //   'First and Last Name:',
                    //   style: TextStyle(
                    //     color: Colors.black,
                    //     fontWeight: FontWeight.bold
                    //     ),
                    // ),
                    // const SizedBox(height: 10),
                    // TextField(
                    //   controller: nameController,
                    //   decoration: const InputDecoration(
                    //     border: OutlineInputBorder(),
                    //   ),
                    // ),
                    const SizedBox(height:10),
                    const Text(
                      'Email:',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                        ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text;
                    final email = emailController.text;
                    print('Name: $name, Email: $email');
                    doSearch = true;
                    setState(() {});
                    // nameController.clear();
                    // emailController.clear();
                    // Add functionality for adding an account
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.black, // white text
                  ),
                  child: const Text('Search Account'),
                ),
                StreamBuilder(
                  stream: fh.usersRef.where('email', isEqualTo: emailController.text).snapshots(), 
                  builder:(context, snapshot) {
                    // Show no results 
                    if(!doSearch) {
                      return Container();
                    }
                    if(!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    List<QueryDocumentSnapshot<UserDoc>> results = snapshot.data!.docs;

                    // Widgets for dressing data
                    Container fieldNameCont(String text) => 
                      Container(
                        margin: const EdgeInsets.only(top: 8.0, bottom: 4.0, right: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.black54),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8.0),
                        child: Text(text,
                          style: const TextStyle(color: Colors.white),),
                      );

                    Container fieldDataCont(String text) =>
                      Container(
                        margin: const EdgeInsets.only(top: 8.0, bottom: 4.0, right: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          // color: Colors.grey[350]
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8.0),
                        child: Text(text),
                      );
                    
                    // Returns nothing when results are greater than 1 because the query
                    // Will return multiple entries before it's finished. Prevents a frame
                    // Where some nonsense is returned.
                    if(results.isEmpty || results.length != 1) {
                      return fieldDataCont('No user found with that email. '
                      'Make sure you\'ve spelled the email exactly.');
                    }
                    
                    UserDoc result = results[0].data();
                    List<(String, String)> data = [
                      ('Email', result.getEmail()),
                      ('Name', result.getName()),
                      ('SU Affiliation', result.affiliation),
                      ('Rescue Groups', result.rescueGroup == '' ? 'None' : result.rescueGroup),
                      ('Phone Number', result.phoneNumber == '' ? 'Not provided' : result.phoneNumber),
                    ];
                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: List.generate(
                          data.length, (index) {
                            var item = data[index];
                            return Row(
                              children: [
                                fieldNameCont(item.$1),
                                fieldDataCont(item.$2)
                              ],
                            );
                          }),
                      )
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    )
    );
  }
}
