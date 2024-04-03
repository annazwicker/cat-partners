import "package:flutter/material.dart";

import "Feeder Files/feeder_sidebar.dart";
import "Feeder Files/feeder_table.dart";

class FeederScreen extends StatelessWidget {
  const FeederScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
      ),
      body: Row(
        children: [
          Flexible ( 
            child: Container(
              margin: const EdgeInsets.all(20),
              constraints: const BoxConstraints(
                // maxWidth: 600, 
                minWidth: 600
              ),
              // child: const Text('table goes here!!!')
              child: const FeederTable()
            )
          ), 
          Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
            margin: const EdgeInsets.all(20),
            constraints: const BoxConstraints(
              maxWidth: 400,
              minWidth: 400,
            ),
            child: const FeederSidebar()
          )
        ],
      )
    );
  }
}
