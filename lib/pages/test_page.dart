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
                if(!snapshot.hasData){
                  // return some placeholder widget
                }
                // wrk with snapshot data and do yo thang :)
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
                    // _dbHelper.searchUsers('nay');
                    //TEST
                    // Map<String, dynamic> catMap = {

                    //   'description': 'description',
                    //   'name': 'catName',
                    //   'photo': 'placeholder',
                    //   'stationID': '0',
                    // };
                    // _dbHelper.addCat(catMap);

                    // _dbHelper.deleteCat('vkk0GJDaqvfd5P5YOtmW');

                    // Map<String, dynamic> stationMap = {

                    //   'description': 'description',
                    //   'fullName': 'amogus sus',
                    //   'name': 'amogus',
                    //   'photo': 'photo!',
                    // };
                    // _dbHelper.addStation(stationMap);

                    _dbHelper.deleteStation('alJszq8K6pC1unaWwNc1');
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


