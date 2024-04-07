import "package:flutter/material.dart";
import "package:flutter_application_1/services/firebase_helper.dart";

class FeederScreen extends StatefulWidget {
  const FeederScreen({super.key});

  @override
  State<FeederScreen> createState() {
    return _FeederScreenState();
  }
}

class _FeederScreenState extends State<FeederScreen> {

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
            ElevatedButton(
              onPressed: (){
                FirebaseHelper.saveStation(
                  stationID: 0, 
                  name: "name", 
                  description: "description", 
                  photo: "photo"
                  );
              },
              child: Text('Send DB Info'),
            )
          ]
        )
      )
    );
  }

}


