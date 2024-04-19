import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/Feeder%20Files/feeder_data_source.dart';

import '../../models/entry.dart';
import '../../models/userdoc.dart';
import '../../services/firebase_helper.dart';

enum PageState { 
  empty,  // Default view. Displays basic information.
  select, // Entry selection. User selects multiple entries.
  view,   // View an entry, the user's or another's.
  }

class FeederController extends ChangeNotifier {
  final FirebaseHelper fh;
  final FeederDataSource fds;

  PageState currentState = PageState.empty;

  // Shared
  // late int? currentUserID; // placeholder; should be global variable across app

  // Entry select
  late List<QueryDocumentSnapshot<Entry>>? selectedEntries;

  // Entry view
  late QueryDocumentSnapshot<Entry>? currentEntry;
  late DocumentSnapshot<UserDoc>? currentEntryUser;
  late bool isUsersEntry; // TODO true if user is viewing their own entry

  FeederController({
    required this.fh
  }) : fds = FeederDataSource(fh: fh);

  /// Asserts that, for the Controller's current state, certain variables 
  /// are in order.
  void checkState(){
    checkThisState(currentState);
  }
  
  /// Asserts that the Controller is in the PageState [state], and that
  /// certain variables are non-null.
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
  void toggleSelection(QueryDocumentSnapshot<Entry> entry){
    checkThisState(PageState.select);
    if (selectedEntries!.contains(entry)){
      selectedEntries!.remove(entry);
      notifyListeners();
    } else {
      selectedEntries!.add(entry);
      notifyListeners();
    }
  }

  List<QueryDocumentSnapshot<Entry>> getSelection(){
    checkThisState(PageState.select);
    return selectedEntries!;
  }

  /// Gets the name of the user currently selected 
  String getCurrentEntryUserName() {
    checkThisState(PageState.view);
    if(currentEntryUser != null) {
      UserDoc? data = currentEntryUser!.data();
      return data == null ? 'ERROR' : data.getName();
    } else { return ''; }
  }

  /// Changes current page state to View, viewing the given entry.
  void toViewState(QueryDocumentSnapshot<Entry> entry, DocumentSnapshot<UserDoc>? entryUser) {
    // TODO Once Controller uses user IDs, check
    // given userID against stored and update if they're
    // different.
    currentEntry = entry;
    currentEntryUser = entryUser;
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