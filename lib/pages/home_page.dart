import "package:flutter/material.dart";
import "package:flutter_application_1/components/nav_bar.dart";
import "package:flutter_application_1/components/notification.dart";
import 'package:flutter_application_1/const.dart';
import "package:flutter_application_1/models/userdoc.dart";

import "package:flutter_application_1/services/firebase_helper.dart";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:intl/intl.dart";
import "../components/user_google.dart";
import "../models/entry.dart";
import "../models/station.dart";
import "Feeder Files/feeder_controller.dart";

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
  final ScrollController _vertical = ScrollController();

  @override
  Widget build(BuildContext context) {
    UserGoogle userGoogle = UserGoogle();
    //get firebase ID
    Future<DocumentSnapshot<Map<String, dynamic>>> _userDocument =
        userGoogle.getUserDoc();
    return Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
        ),
        body: SingleChildScrollView(
          controller: _vertical,
          child: Center(
              child: FutureBuilder(
                  future: _userDocument,
                  builder: (context, userSnapshot) {
                    if(!userSnapshot.hasData) return Text("Loading...");
                    String userID = userSnapshot.data!.id;

                    if (userSnapshot.connectionState == ConnectionState.done) {
                      print("line 61");
                      print(userID);
                      // Map<String, dynamic> data = userSnapshot.data!.data() as Map<String, dynamic>;
                      // return Text("Full Name: ${data['full_name']} ${data['last_name']}");
                    }

                    return StreamBuilder(
                        stream: _dbHelper.getThisUser2(userID),
                        builder: (context, snapshot) {
                          if(!snapshot.hasData) return Text("Loading...");
                          return StreamBuilder(
                              stream: _dbHelper.getStationStream(),
                              builder: (context, stationSnapshot) {
                                if(!stationSnapshot.hasData) return Text("Loading...");
                                return Column(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      //notification box
                                      NotificationWidget(
                                        dbHelper: _dbHelper,
                                        stationSnapshot: stationSnapshot,
                                      ),
                                      //achievement box
                                      AchievementsBox(
                                        dbHelper: _dbHelper,
                                        userID: userID,
                                      ),

                                      // userEntries(dbHelper: _dbHelper),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 15),
                                        child: Text(
                                            "Your Upcoming Feeding Entries",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800,
                                              // fontWeight: FontWeight.bold,
                                            )),
                                      ),
                                      UpcomingEntries(
                                        dbHelper: _dbHelper,
                                        stationSnapshot: stationSnapshot,
                                        userID: userID,
                                      ),
                                    ]);
                              });
                        });
                  })),
        ));
  }
}

class UpcomingEntries extends StatelessWidget {
  const UpcomingEntries(
      {super.key,
      required FirebaseHelper dbHelper,
      required AsyncSnapshot<QuerySnapshot<Station>> stationSnapshot,
      required String userID})
      : _dbHelper = dbHelper,
        _stationSnapshot = stationSnapshot,
        _userID = userID;

  final FirebaseHelper _dbHelper;
  final AsyncSnapshot<QuerySnapshot<Station>> _stationSnapshot;
  final String _userID;

  @override
  Widget build(BuildContext context) {
    //get list of upcoming user entries -- organized by date (column1 date, column2 station)
    return StreamBuilder(
        stream: _dbHelper.getUpcomingUserEntries(_userID),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return Text("Loading...");
          //create list, map for stations
          List stationList = _stationSnapshot.data?.docs ?? [];
          _dbHelper.sortStationList(stationList);
          stationList.forEach((station) => print(station.data().name));
          Map<String, String> stationDic = {};
          for (var station in stationList) {
            String documentID = station.id;
            String name = station.data().name ?? '';
            stationDic[documentID] = name;
          }

          List entries = snapshot.data?.docs ?? [];
          entries.sort((a, b) {
            DateTime aE = a.data().date.toDate();
            DateTime bE = b.data().date.toDate();
            DateTime aDT = DateTime(aE.year, aE.month, aE.day);
            DateTime bDT = DateTime(bE.year, bE.month, bE.day);
            int comp = aDT.compareTo(bDT);
            if (comp == 0) {
              String aS = a.data().stationID.id;
              String bS = b.data().stationID.id;
              return aS.compareTo(bS);
            }
            return comp;
          });

          //reorganize list as a list of lists so there's one entry per date (Date, Stations)
          List listedEntries = [];

          if (entries.isEmpty) {
            return Center(child: Text('No entries found.'));
          }

          return SizedBox(
            // width: MediaQuery.of(context).size.width * 0.6,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                border: TableBorder.all(width: 1),
                dividerThickness: 1.0,
                columns: [
                  DataColumn(
                    label: Container(
                      child: Center(
                          child: Text(
                        'Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      width: 150,
                      child: Center(
                          child: Text(
                        'Note',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      child: Center(
                          child: Text(
                        'Station Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ],
                // rows: entries.map<DataRow>((entry) {
                rows: entries.map<DataRow>((entry) {
                  Entry entryData = entry.data();

                  //get name of station

                  //temp switch case for station names

                  String stationName = stationDic[entry.data().stationID.id]!;
                  return DataRow(
                    cells: [
                      DataCell(Center(
                          child: Text(DateFormat('yyyy-MM-dd')
                              .format(entryData.date.toDate())))),

                      // DataCell(Text(entryData.assignedUser?.id ?? 'nullUser')),
                      DataCell(Center(child: Text(entryData.note))),
                      // DataCell(Center(child: Text(entryData.stationID.id))),
                      DataCell(Center(child: Text(stationName as String))),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        });
  }
}

class userEntries extends StatelessWidget {
  const userEntries({
    super.key,
    required FirebaseHelper dbHelper,
    required String userID,
  })  : _dbHelper = dbHelper,
        _userID = userID;

  final FirebaseHelper _dbHelper;
  final _userID;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _dbHelper.getUpcomingUserEntries(_userID),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return Text("Loading...");
          List entries = snapshot.data?.docs ?? [];
          entries.sort((a, b) {
            DateTime aE = a.data().date.toDate();
            DateTime bE = b.data().date.toDate();
            DateTime aDT = DateTime(aE.year, aE.month, aE.day);
            DateTime bDT = DateTime(bE.year, bE.month, bE.day);
            int comp = aDT.compareTo(bDT);
            if (comp == 0) {
              String aS = a.data().stationID.id;
              String bS = b.data().stationID.id;
              return aS.compareTo(bS);
            }
            return comp;
          });

          if (entries.isEmpty) {
            return Center(child: Text('No entries found.'));
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              border: const TableBorder(
                  verticalInside:
                      BorderSide(width: 1, style: BorderStyle.solid)),
              columns: [
                DataColumn(label: Text('Date')),
                // DataColumn(label: Text('Assigned User')),
                DataColumn(label: Text('Note')),
                DataColumn(label: Text('Station')),
              ],
              rows: entries.map<DataRow>((entry) {
                Entry entryData = entry.data();
                return DataRow(
                  cells: [
                    DataCell(Text(entryData.date.toDate().toString())),
                    DataCell(Text(entryData.assignedUser?.id ?? 'nullUser')),
                    DataCell(Text(entryData.note)),
                    DataCell(Text(entryData.stationID.id)),
                  ],
                );
              }).toList(),
            ),
          );
        });
  }
}

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({
    super.key,
    required FirebaseHelper dbHelper,
    required AsyncSnapshot<QuerySnapshot<Station>>
        stationSnapshot, //add requirement for streamer
  })  : _dbHelper = dbHelper,
        _stationSnapshot = stationSnapshot;

  final AsyncSnapshot<QuerySnapshot<Station>> _stationSnapshot;
  final FirebaseHelper _dbHelper;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _dbHelper.getUrgentEntries(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return Text("Loading...");
          //get live list of stations
          List stationList = _stationSnapshot.data?.docs ?? [];
          _dbHelper.sortStationList(stationList);
          stationList.forEach((station) => print(station.data().name));
          Map<String, String> stationDic = {};
          for (var station in stationList) {
            String documentID = station.id;
            String name = station.data().name ??
                ''; // Adjust this based on your data structure
            stationDic[documentID] = name;
          }

          //get live list of upcoming entries
          List entries = snapshot.data?.docs ?? [];

          entries.sort((a, b) {
            DateTime aE = a.data().date.toDate();
            DateTime bE = b.data().date.toDate();

            DateTime aDT = DateTime(aE.year, aE.month, aE.day);
            DateTime bDT = DateTime(bE.year, bE.month, bE.day);
            int comp = aDT.compareTo(bDT);
            if (comp == 0) {
              String aS = a.data().stationID.id;
              String bS = b.data().stationID.id;
              return aS.compareTo(bS);
            }
            return comp;
          });

          String notificationMessage = "";
          //message for when there are no empty feeding entries
          if (entries.isEmpty) {
            notificationMessage =
                "There are no unassigned feeding entries today and tomorrow!";
          }

          //message for when there are empty feeding entries
          else {
            //format:
            //Today's x, y, z station entries are empty.\n
            //Tomorrow's x, y, z station entries are empty.\n

            DateTime now = DateTime.now();
            DateTime today = DateTime(now.year, now.month, now.day);
            DateTime tomorrow = today.add(Duration(days: 1));

            List<String> todayEntries = [];
            List<String> tmrwEntries = [];

            print("lines 310");
            print(entries);
            for (var entry in entries) {
              //check if any of today's entries are empty
              if (entry.data().date.toDate() == today) {
                String stationName = stationDic[entry.data().stationID.id]!;
                todayEntries.add(stationName);
              } else {
                //check if any of tomorrow's entries are empty
                String stationName = stationDic[entry.data().stationID.id]!;
                tmrwEntries.add(stationName);
              }
            }
            print("line321");
            print(todayEntries);
            print(tmrwEntries);
            if (todayEntries.isNotEmpty) {
              notificationMessage +=
                  "Today's ${todayEntries.join(', ')} entries are empty\n";
            } else {
              notificationMessage += "There are no empty entries today!\n";
            }

            if (tmrwEntries.isNotEmpty) {
              notificationMessage +=
                  "Tomorrow's ${tmrwEntries.join(', ')} entries are empty";
              print(notificationMessage);
              print("line360");
            } else {
              notificationMessage += "There are no empty entries tomorrow!";
            }
            print(notificationMessage);
          }

          return Column(
            children: [
              NotificationBox(
                message: notificationMessage,
              ),
            ],
          );
        });
  }
}

class AchievementsBox extends StatelessWidget {
  const AchievementsBox({
    Key? key,
    required FirebaseHelper dbHelper,
    required String userID,
  })  : _dbHelper = dbHelper,
        _userID = userID,
        super(key: key);

  final FirebaseHelper _dbHelper;
  final _userID;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _dbHelper.getAllCompletedUserEntries(_userID),
        builder: (context, snapshot) {

          if (!snapshot.hasData){
            return Text("Loading...");
          }
          List entries = snapshot.data?.docs ?? [];

          String achievementText = "";
          if (entries.isEmpty) {
            achievementText =
                "No cats fed yet! Sign up for an entry and add 1 to the count!";
          } else {
            achievementText = "You have fed the campus cats " +
                entries.length.toString() +
                " times!\n Thank you so much!";
          }
          return Align(
            alignment: Alignment.center,
            child: Container(
              // width: MediaQuery.of(context).size.width * 0.3,
              color: SUYellow,
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(20),
              child: Text(achievementText,
                  style: TextStyle(
                    fontSize: 16,
                  )),
            ),
          );
        });
  }
}
