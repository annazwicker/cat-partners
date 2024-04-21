import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:flutter_application_1/pages/Feeder%20Files/feeder_controller.dart";

import "../services/firebase_helper.dart";
import "Feeder Files/feeder_sidebar.dart";
import "Feeder Files/feeder_table.dart";

class FeederScreen extends StatefulWidget {
  const FeederScreen({super.key});

  @override
  State<FeederScreen> createState() => _FeederScreenState();
}

class _FeederScreenState extends State<FeederScreen> {

  FirebaseHelper fh = FirebaseHelper();
  late FeederController controller;

  @override
  void initState() {
    super.initState();
    controller = FeederController(fh: fh);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  
  Widget tableWrap(FeederTable table) {
    return Flexible ( 
      child: Container(
        margin: const EdgeInsets.all(20),
        constraints: const BoxConstraints(
          // maxWidth: 600, 
          minWidth: 600
        ),
        child: table
      )
    ); 
  }

  Widget sidebarWrap(FeederSidebar sidebar) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: const BorderRadius.all(Radius.circular(10))),
      margin: const EdgeInsets.all(15),
      constraints: const BoxConstraints(
        maxWidth: 400,
        minWidth: 400,
      ),
      child: sidebar
    );
  }

  @override
  Widget build(BuildContext context) {
    FeederTable fTable = FeederTable(controller: controller, fh: fh);
    FeederSidebar fSidebar = FeederSidebar(controller: controller, fh: fh);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feeder Sign Up'),
      ),
      body: Row(
        children: [tableWrap(fTable), sidebarWrap(fSidebar)],
      )
    );
  }

}


