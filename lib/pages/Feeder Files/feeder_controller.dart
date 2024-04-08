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
  late bool isUsersEntry; // TODO true if user is viewing their own entry

  // Debug
  late String testStr;

  void setString(String newString){
    testStr = newString;
    notifyListeners();
  }

  /// Asserts that, for the Controller's current state, certain variables 
  /// are in order.
  void checkState(){
    checkThisState(currentState);
  }
  
  void checkThisState(PageState state){
    assert (currentState == state);
    switch (state){
      case PageState.view:
        assert (currentEntry != null);
      case PageState.select:
        assert (selectedEntries != null);
      default:
    }
  }


  /// Adds given entry to selection if it's not included,
  /// And removes entry from selection if it is.
  void toggleSelection(Map<String, dynamic> entry){
    checkThisState(PageState.select);
    if (selectedEntries!.contains(entry)){
      selectedEntries!.remove(entry);
      notifyListeners();
    } else {
      selectedEntries!.add(entry);
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> getSelection(){
    checkThisState(PageState.select);
    return selectedEntries!;
  }

  /// Changes current page state to View, viewing the given entry.
  void toViewState(Map<String, dynamic> entry) {
    // TODO Once Controller uses user IDs, check
    // given userID against stored and update if they're
    // different.
    currentEntry = entry;
    currentState = PageState.view;
    notifyListeners();
  }

  /// Changes current page state to empty and notifies listeners.
  void toEmptyState() {
    toThisState(PageState.select);
  }

  /// Changes current page state to selection, and notifies
  /// listeners if state wasn't already selection.
  void toSelectState() {
    if(currentState != PageState.select){
      selectedEntries = [];
      currentState = PageState.select;
      notifyListeners();
    }
  }

  void toThisState(PageState newState) {
    if(currentState != newState){
      currentState = newState;
      notifyListeners();
    }
  }
  
}