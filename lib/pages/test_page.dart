import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:flutter_application_1/services/firebase_helper.dart";

import "../models/entry.dart";

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() {
    return _TestScreenState();
  }
}

class _TestScreenState extends State<TestScreen> {

  final _dbHelper = FirebaseHelper();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Feeder Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
              stream: _dbHelper.getEntryStream(),
              builder: (context, snapshot) {
                List entries = snapshot.data?.docs ?? [];
                if(entries.isEmpty) {
                  return const Center(
                    child: Text('No entries found.')
                  );
                }
                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    Entry entry = entries[index].data();
                    // String entryId = entries[index].id;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      child: Wrap(
                        spacing: 50,
                        children: [
                          Text(entry.date.toDate().toString()),
                          Text(entry.assignedUser?.id ?? 'nullUser'),
                          Text(entry.note),
                          Text(entry.stationID.id)
                        ],
                      )
                    );
                  },
                );
              }
            ),
            StreamBuilder(
              stream: _dbHelper.getStationStream(), 
              builder: (context, snapshot)
              {
                List<QueryDocumentSnapshot> stations = snapshot.data?.docs ?? [];
                if(stations.isEmpty){
                  return const Center(
                    child: Text('No stations for entries!')
                  );
                }
                return ElevatedButton(
                  onPressed: () {
                    for (var station in stations) {
                      Entry entry = Entry(
                        assignedUser: null, 
                        date: Timestamp.fromDate(DateTime(2024, DateTime.april, 7)), 
                        note: '', 
                        stationID: station.reference,
                      );
                      _dbHelper.addEntry(entry);
                    }
                    
                  }, 
                child: const Text('Generate!'));
              }
            ),
            
          ]
        )
      )
    );
  }

}


