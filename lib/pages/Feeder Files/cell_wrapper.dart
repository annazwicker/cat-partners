import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/entry.dart';
import 'package:flutter_application_1/pages/Feeder%20Files/feeder_controller.dart';
import 'package:flutter_application_1/pages/Feeder%20Files/feeder_table.dart';
import 'package:flutter_application_1/services/firebase_helper.dart';

import '../../models/userdoc.dart';

/// Wrapper Widget with Cell contents
class CellWrapper extends StatefulWidget{

  CellWrapper({super.key,
  required this.data,
  required this.controller,
  required this.fh});

  final QueryDocumentSnapshot<Entry> data;
  final FeederController controller;
  final FirebaseHelper fh;

  @override
  State<CellWrapper> createState() => _CellWrapperState();
}

enum CellSelectStatus {
    inactive,
    adding,
    viewing
  }

class _CellWrapperState extends State<CellWrapper> {

  DocumentSnapshot<UserDoc>? assignedUser;
  bool isAddSelected = false;
  
  static const Color onDeselect = Colors.white;
  static const Color onSelect = Colors.lightBlue;
  Color currentColor = onDeselect;

  @override
  void initState() {
    widget.controller.addListener(() { 
      setState(() {
        if(widget.controller.currentState != PageState.select){
          isAddSelected = false;
          currentColor = onDeselect;
        }
      });      
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.controller.fds.getAssignedUser(widget.data),
      builder: (context, snapshot) {
        if (!snapshot.hasData){
          return commonCellWrapping('Loading...');
        }
        (bool, DocumentSnapshot<UserDoc>?) userTuple = snapshot.data!;
        String cellText = '';
        if(userTuple.$1){ // There is an assigned user
          assignedUser = userTuple.$2;
          UserDoc? userData = assignedUser!.data();
          if (userData == null) {
            cellText = 'ERROR';
          } else {
            cellText = userData.getName();
          }
        }
        
        return GestureDetector(
          onTap: doOnTap,
          child: commonCellWrapping(cellText, color: currentColor)
        );
      }
    ); 
  }

  bool hasUser() {
    return assignedUser != null; 
    }

  void doOnTap() {
    // Enter view for unassigned entries
    if (!hasUser()){
      setState(() {
        widget.controller.toSelectState();
        isAddSelected = widget.controller.toggleSelection(widget.data);
        currentColor = isAddSelected ? onSelect : onDeselect;
      });
    }
    // Enter view for assigned entries
    else {
      widget.controller.toViewState(widget.data, assignedUser);
    }
  }

}
