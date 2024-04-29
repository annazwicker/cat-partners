import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/Feeder%20Files/cell_wrapper.dart';
import 'package:intl/intl.dart';

import '../../components/snapshots.dart';
import '../../models/entry.dart';
import '../../models/userdoc.dart';

var formatDashes = DateFormat('yyyy-MM-dd');
var formatAbbr = DateFormat('yMMMd');

enum PageState { 
  empty,  // Default view. Displays basic information.
  select, // Entry selection. User selects multiple entries.
  view,   // View an entry, the user's or another's.
  }

class FeederController extends ChangeNotifier {

  PageState currentState = PageState.empty;

  // Shared
  // late int? currentUserID; // placeholder; should be global variable across app

  // Entry select
  late List<(QueryDocumentSnapshot<Entry>, ValueNotifier<CellSelectStatus>)>? selectedEntries;

  // Entry view
  late QueryDocumentSnapshot<Entry>? currentEntry;
  late DocumentSnapshot<UserDoc>? currentEntryUser;
  late ValueNotifier? currentCellNotifier;
  late bool isUsersEntry; // TODO true if user is viewing their own entry

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
        assert (currentCellNotifier != null);
      case PageState.select:
        assert (selectedEntries != null);
      default:
    }
  }

  /// Adds given entry to selection if it's not included,
  /// And removes entry from selection if it is.
  /// Returns whether this entry will be in the selection AFTER this operation.
  bool toggleSelection(QueryDocumentSnapshot<Entry> entry, ValueNotifier<CellSelectStatus> cellController){
    checkThisState(PageState.select);
    var lookingFor = selectedEntries!.where((element) => element.$1 == entry);
    if (lookingFor.isNotEmpty){
      var selected = lookingFor.elementAt(0);
      selectedEntries!.remove(selected);
      selected.$2.value = CellSelectStatus.inactive;
      notifyListeners();
      if(selectedEntries!.isEmpty) {
        currentState = PageState.empty;
      }
      return false;
    } else {
      selectedEntries!.add((entry, cellController));
      cellController.value = CellSelectStatus.adding;
      notifyListeners();
      return true;
    }
  }

  // List<QueryDocumentSnapshot<Entry>> wrappersAsEntries() => selectedEntries!.map((e) => e.widget.data).toList();

  List<QueryDocumentSnapshot<Entry>> getSelection(){
    checkThisState(PageState.select);
    return selectedEntries!.map((e) => e.$1).toList();
  }

  void commitSelections() async {
    checkThisState(PageState.select);
    DocumentReference currentUserRef = await Snapshots.getCurrentUserTEST();
    for(var entryPair in selectedEntries!){
      var entry = entryPair.$1;
      Snapshots.runTransaction((transaction) async {
        Entry newEntry = entry.data().copyWith(assignedUser: currentUserRef);
        transaction.update(entry.reference, newEntry.toJson());
      });
      entryPair.$2.value = CellSelectStatus.inactive;
    }
    toEmptyState();
  }

  void unassignCurrent() async {
    checkThisState(PageState.view);
    Snapshots.runTransaction(
      (transaction) async {
      assert (currentEntry != null);
      Entry newEntry = currentEntry!.data().copyWithUser(null);
      transaction.update(currentEntry!.reference, newEntry.toJson());
      toEmptyState();
    },);
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
    ValueNotifier cellController) {
    // TODO Once Controller uses user IDs, check
    // given userID against stored and update if they're
    // different.
    fromState();
    currentEntry = entry;
    currentEntryUser = entryUser;
    currentState = PageState.view;
    currentCellNotifier = cellController;
    cellController.value = CellSelectStatus.viewing;
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
        for(var pair in selectedEntries!){
          pair.$2.value = CellSelectStatus.inactive;
        }
        selectedEntries = null;
      case PageState.view:
        currentCellNotifier!.value = CellSelectStatus.inactive;
        currentEntry = null;
        currentEntryUser = null;
        currentCellNotifier = null;
    }
  }
  
}