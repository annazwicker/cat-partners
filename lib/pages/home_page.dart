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
            NotificationWidget(dbHelper: _dbHelper),
            //achievement box
            AchievementsBox(dbHelper: _dbHelper),
            
          ]
        )
      )
    );
  }
}

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({
    super.key,
    required FirebaseHelper dbHelper,
  }) : _dbHelper = dbHelper;

  final FirebaseHelper _dbHelper;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
    
        String notificationMessage = "";
        //message for when there are no empty feeding entries
        if(entries.isEmpty) {
          notificationMessage = "There are no unassigned feeding entries today and tomorrow!";
        }
    
        //message for when there are empty feeding entries
        else{
          //format: 
          //Today's x, y, z station entries are empty.\n
          //Tomorrow's x, y, z station entries are empty.\n
          
          DateTime now = DateTime.now();
          DateTime today = DateTime(now.year, now.month, now.day);
          DateTime tomorrow = today.add(Duration(days: 1)); 
    
    
    
          List<String> todayEntries = [];
          List <String> tmrwEntries = [];
          for (var entry in entries){
            if (entry.data().date.toDate() == today){
              todayEntries.add(entry.data().stationID.id);
            }
            else{
              tmrwEntries.add(entry.data().stationID.id);
            }
          }
          if(todayEntries.length > 0){
              notificationMessage += "Today's ${todayEntries.join(', ')} entries are empty\n";
          }
          if(tmrwEntries.length > 0){
            notificationMessage += "Tomorrow's ${tmrwEntries.join(', ')} entries are empty";
          }
    
        }
    
    
        return Flexible(
          child: Column(
            children: [
              NotificationBox(message: notificationMessage,),
            ],
          )
        );
      }
    );
  }
}

class AchievementsBox extends StatelessWidget {
  const AchievementsBox({
    Key? key,
    required FirebaseHelper dbHelper,
  }) : _dbHelper = dbHelper,
       super(key: key);

  final FirebaseHelper _dbHelper;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _dbHelper.getUpcomingUserEntries(_dbHelper.getCurrentUser()),
      builder: (context, snapshot) {
        List entries = snapshot.data?.docs ?? [];
        
        String achievementText = "";
        if(entries.isEmpty) {
          achievementText = "No cats fed yet! Sign up for an entry and add 1 to the count!";
        }
        else{
          achievementText = "You have filled in " + entries.length.toString() + " entries!\n Thank you so much!";
        }
        return Align(
          alignment:Alignment.topLeft,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            color: SUYellow,
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(20),
            child: Text(achievementText),
          ),
        );
      }
    );
  }
}
