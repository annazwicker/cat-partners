import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:flutter_application_1/services/firebase_helper.dart";
import "package:intl/intl.dart";

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
        // title: Text('Feeder Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
              stream: _dbHelper.getEntryStream(),
              builder: (context, snapshot) {
                List entries = snapshot.data?.docs ?? [];
                entries.sort((a, b) {
                  DateTime aE = a.data().date.toDate();
                  DateTime bE = b.data().date.toDate();
                  DateTime aDT = DateTime(aE.year, aE.month, aE.day);
                  DateTime bDT = DateTime(bE.year, bE.month, bE.day);
                  int comp = aDT.compareTo(bDT);
                  if(comp == 0){
                    String aS = a.data().stationID.id;
                    String bS = b.data().stationID.id;
                    return aS.compareTo(bS);
                  }
                  return comp;
                });
                if(entries.isEmpty) {
                  return const Center(
                    child: Text('No entries found.')
                  );
                }
                return Flexible(
                  child: ListView.builder(
                    // physics: const AlwaysScrollableScrollPhysics(),
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
                        child: SingleChildScrollView(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(child: Text(entry.date.toDate().toString())),
                              Flexible(child: Text(entry.assignedUser?.id ?? 'nullUser')),
                              Flexible(child: Text(entry.note)),
                              Flexible(child: Text(entry.stationID.id))
                            ],
                          ),
                        )
                      );
                    },
                  ),
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
                    for (int i = 1; i <= 30; i++){
                      DateTime thisDateTime = DateTime(2024, DateTime.april, i);
                      DateTime nextDateTime = thisDateTime.add(const Duration(days: 1));
                      Timestamp thisStamp = Timestamp.fromDate(thisDateTime);
                      Timestamp nextStamp = Timestamp.fromDate(nextDateTime);
                      Query<Entry> dateQuery = _dbHelper.entriesRef.where('date', isGreaterThanOrEqualTo: thisStamp, isLessThan: nextStamp);
                      dateQuery.get().then(
                        (value) {
                          int numEntries = value.size;
                          DateFormat format = DateFormat("yyyy-MM-dd");
                          String fDate = format.format(thisDateTime);
                          print("Entries for $fDate: $numEntries");
                        },
                      );
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


