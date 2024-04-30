import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/entry.dart';
import 'package:flutter_application_1/pages/Feeder%20Files/feeder_controller.dart';
import 'package:flutter_application_1/pages/Feeder%20Files/feeder_table.dart';

import '../../components/snapshots.dart';
import '../../models/userdoc.dart';

/// Wrapper Widget with Cell contents
class CellWrapper extends StatefulWidget{

  CellWrapper({super.key,
  required this.data,
  required this.controller});

  final QueryDocumentSnapshot<Entry> data;
  final FeederController controller;

  @override
  State<CellWrapper> createState() => CellWrapperState();
}

enum CellSelectStatus {
    inactive(color: Colors.white),
    adding(color: Colors.lightBlueAccent),
    viewing(color: Colors.lightGreenAccent);
    final Color color;

  const CellSelectStatus({required this.color});
  }

class CellWrapperState extends State<CellWrapper> {
  
  DocumentSnapshot<UserDoc>? assignedUser;

  // CellWrapperState({this.data});

  /// Selection status of this cell.
  /// Inactive: cell is not being selected
  /// Adding: Cell is empty, and being selected for assignment by user.
  /// Viewing: Cell's information is being viewed by user.
  CellSelectStatus selection = CellSelectStatus.inactive;

  @override
  void initState() {
    widget.controller.addListener(() { 
      if(widget.controller.currentState != PageState.select &&
          selection == CellSelectStatus.adding){
        setState(() {selection = CellSelectStatus.inactive;});
      }
      if(widget.controller.currentState != PageState.view &&
          selection == CellSelectStatus.viewing){
        setState(() {selection = CellSelectStatus.inactive;});
      }
      if(widget.controller.currentState == PageState.empty && selection != CellSelectStatus.inactive){
        setState(() {selection = CellSelectStatus.inactive;});
      }
    });
    super.initState();
  }

  void unAssign() {
    setState(() {
      assignedUser = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Snapshots.getAssignedUser(widget.data),
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
        } else {
          assignedUser = null;
        }
        
        return GestureDetector(
          onTap: doOnTap,
          child: commonCellWrapping(cellText, color: selection.color)
        );
      }
    ); 
  }

  bool hasUser() {
    return assignedUser != null; 
    }

  void doOnTap() {
    if(widget.controller.currentState != PageState.view) {
      // Enter view for unassigned entries
      if (!hasUser()){
        setState(() {
          widget.controller.toSelectState();
          if(widget.controller.toggleSelection(widget.data)){
            selection = CellSelectStatus.adding;
          } else {
            selection = CellSelectStatus.inactive;
          }
        });
      }
      // Enter view for assigned entries
      else {
        setState(() {
            selection = CellSelectStatus.viewing;
          }
        );
        widget.controller.toViewState(widget.data, assignedUser);
      }
    } else {
      // This is the viewed cell
      if(selection == CellSelectStatus.viewing){
        // Deselect
        setState(() {
          selection = CellSelectStatus.inactive;
        });
        widget.controller.toEmptyState();
      }
    }
    
  }

}
