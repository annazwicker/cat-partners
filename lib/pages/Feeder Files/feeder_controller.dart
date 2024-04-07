import 'package:flutter/material.dart';

enum PageState { 
  empty,  // Default view. Displays basic information.
  select, // Entry selection. User selects multiple entries.
  view,   // View an entry, the user's or another's.
  }

class FeederController extends ChangeNotifier {
  PageState currentState = PageState.empty;

  // Shared
  late int? currentUserID; // placeholder; should be global variable across app

  // Entry select
  late List<Map<String, dynamic>>? selectedEntries;

  // Entry view
  late Map<String, dynamic>? currentEntry;

  // Debug
  late String testStr;

  void setString(String newString){
    testStr = newString;
    notifyListeners();
  }
  
}