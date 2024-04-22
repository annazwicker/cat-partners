import 'package:flutter/material.dart';


class SearchUsersContent extends StatelessWidget {
  final Color textColor;

  SearchUsersContent({Key? key, required this.textColor}) : super(key: key);
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
                Text(
                  'Search for a user using first name, last name, and email address',
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
                      'First and Last Name:',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold
                        ),
                    ),
                    const SizedBox(height: 10),
                    const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height:10),
                    Text(
                      'Email:',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold
                        ),
                    ),
                    const SizedBox(height: 10),
                    const TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // Add functionality for adding an account
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.black, // white text
                  ),
                  child: const Text('Search Account'),
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
