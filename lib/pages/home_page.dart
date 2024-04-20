import "package:flutter/material.dart";
import "package:flutter_application_1/components/nav_bar.dart";
import "package:flutter_application_1/components/notification.dart";
import 'package:flutter_application_1/const.dart';
import "package:flutter_application_1/services/firebase_helper.dart";



import "package:cloud_firestore/cloud_firestore.dart";
import "package:intl/intl.dart";
import "../models/entry.dart";



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TopNavBar(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _dbHelper = FirebaseHelper();
  var _isWindowOpen = true;

  @override
    Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //notification box
            StreamBuilder(
              stream: _dbHelper.getUrgentEntries(),
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
                  child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // alignment: AlignmentDirectional.center,
        children: [
          NotificationBox(),

          Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.width * 0.1,
                  color: SUYellow,
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  child: const Text('Achievement Box'))),
          Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.width * 0.3,
              color: SUYellow,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              child: const Text('Scheduler')),
        ],
      )
                );
              }
            ),
            //achievement box
            StreamBuilder(
              stream: _dbHelper.getUpcomingUserEntries(_dbHelper.getCurrentUser()),
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
            
          ]
        )
      )
    );
  }
}
