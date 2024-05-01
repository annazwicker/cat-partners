import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  State<CellWrapper> createState() => _CellWrapperState();
}

enum CellSelectStatus {
    inactive(color: Colors.white),
    adding(color: Colors.lightBlueAccent),
    viewing(color: Colors.lightGreenAccent);
    final Color color;

  const CellSelectStatus({required this.color});
  }

class _CellWrapperState extends State<CellWrapper> {
  
  DocumentSnapshot<UserDoc>? assignedUser;
  // CellWrapperState({this.data});

  /// Selection status of this cell.
  /// Inactive: cell is not being selected
  /// Adding: Cell is empty, and being selected for assignment by user.
  /// Viewing: Cell's information is being viewed by user.
  ValueNotifier<CellSelectStatus> cellController = ValueNotifier(CellSelectStatus.inactive);

  @override
  void initState() {
    cellController.addListener(() { setState(() {}); });
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
          child: commonCellWrapping(cellText, color: cellController.value.color)
        );
      }
    ); 
  }

  bool hasUser() {
    return assignedUser != null; 
    }

  void doOnTap() {
    if (!hasUser()){ 
      // Empty entry
      // Toggle selection mode when empty entry is clicked
      widget.controller.toSelectState();
      widget.controller.toggleSelection(widget.data, cellController);
    } else if (cellController.value == CellSelectStatus.viewing) {
      // Currently viewed entry
      // Exit view mode
      widget.controller.toEmptyState();
    } else {
      // Not currently viewed entry
      // Enter view mode
      widget.controller.toViewState(widget.data, assignedUser, cellController);
    }    
  }

}
