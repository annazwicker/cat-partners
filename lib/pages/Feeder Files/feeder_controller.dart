import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/Feeder%20Files/cell_wrapper.dart';
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
  late List<CellWrapperState>? selectedEntries;

  // Entry view
  late QueryDocumentSnapshot<Entry>? currentEntry;
  late DocumentSnapshot<UserDoc>? currentEntryUser;
  late bool isUsersEntry; // TODO true if user is viewing their own entry
  late CellWrapperState selectedCell;

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
  /// Returns whether this entry will be in the selection AFTER this operation.
  bool toggleSelection(CellWrapperState cellWrapper){
    checkThisState(PageState.select);
    if (selectedEntries!.contains(cellWrapper)){
      selectedEntries!.remove(cellWrapper);
      cellWrapper.selection = CellSelectStatus.inactive;
      notifyListeners();
      if(selectedEntries!.isEmpty) {
        currentState = PageState.empty;
      }
      return false;
    } else {
      selectedEntries!.add(cellWrapper);
      notifyListeners();
      return true;
    }
  }

  List<QueryDocumentSnapshot<Entry>> wrappersAsEntries() => selectedEntries!.map((e) => e.widget.data).toList();

  List<QueryDocumentSnapshot<Entry>> getSelection(){
    checkThisState(PageState.select);
    return wrappersAsEntries();
  }

  void commitSelections() async {
    checkThisState(PageState.select);
    DocumentReference currentUserRef = await fds.getCurrentUserTEST();
    for(QueryDocumentSnapshot<Entry> entry in wrappersAsEntries()){
      fh.db.runTransaction((transaction) async {
        Entry newEntry = entry.data().copyWith(assignedUser: currentUserRef);
        transaction.update(entry.reference, newEntry.toJson());
      }).then((value) => print('transaction successful!'), onError: (e) => print(e),);
    }
    toEmptyState();
  }

  void unassignCurrent() async {
    checkThisState(PageState.view);
    fh.db.runTransaction(
      (transaction) async {
      // print('starting');
      print(currentEntry);
      assert (currentEntry != null);
      Entry newEntry = currentEntry!.data().copyWithUser(null);
      // print('new Entry: ${newEntry}');
      transaction.update(currentEntry!.reference, newEntry.toJson());
      toEmptyState();
    },);
    // selectedCell.unAssign();
    notifyListeners();
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
  void toViewState(
    QueryDocumentSnapshot<Entry> entry, 
    DocumentSnapshot<UserDoc>? entryUser, 
    CellWrapperState cell) {
    // TODO Once Controller uses user IDs, check
    // given userID against stored and update if they're
    // different.
    fromState();
    currentEntry = entry;
    currentEntryUser = entryUser;
    currentState = PageState.view;
    selectedCell = cell;
    notifyListeners();
  }

  /// Changes current page state to empty and notifies listeners.
  void toEmptyState() {
    if(currentState != PageState.empty){
      fromState();
      currentState = PageState.empty;
      notifyListeners();
    }
  }

  /// Changes current page state to selection, and notifies
  /// listeners if state wasn't already selection.
  void toSelectState() {
    if(currentState != PageState.select){
      fromState();
      selectedEntries = [];
      currentState = PageState.select;
      notifyListeners();
    }
  }

  void fromState() {
    switch (currentState) {
      case PageState.empty:
        break;
      case PageState.select:
        for(CellWrapperState cell in selectedEntries!) {
          cell.selection = CellSelectStatus.inactive;
        }
        selectedEntries = null;
      case PageState.view:
        selectedCell.selection = CellSelectStatus.inactive;
        currentEntry = null;
        currentEntryUser = null;
    }
  }
  
}