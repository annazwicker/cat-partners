import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/Feeder%20Files/cell_wrapper.dart';
import 'package:intl/intl.dart';

import '../../components/snapshots.dart';
import '../../models/entry.dart';
import '../../models/userdoc.dart';

/// Formats the date in yyyy-MM-dd format. E.g., 2024-12-30
var formatDashes = DateFormat('yyyy-MM-dd');
/// Formats the date in mm dd, yyyy format. E.g., Dec 30, 2024.
var formatAbbr = DateFormat('yMMMd');

/// Enumeration for the current state of the page.
enum PageState { 
  /// Default view. Displays basic information.
  empty,  
  /// Entry selection. User selects multiple entries.
  select, 
  /// View an entry, the user's or another's.
  view,   
  }

/// Controller for the FeederSidebar and CellWrappers. User interactions with table cells
/// and sidebar components invoke methods of this controller, prompting state changes
/// to the FeederSidebar and CellWrappers as appropriate.
class FeederController extends ChangeNotifier {

  /// The current state of the page.
  PageState currentState = PageState.empty;

  // Entry select
  /// List of information about all selected cells. The first value in an element is the 
  /// DocumentSnapshot of an entry, and the second value is the ValueNotifier for that entry's
  /// cell. 
  late List<(QueryDocumentSnapshot<Entry>, ValueNotifier<CellSelectStatus>)>? selectedEntries;

  // Entry view
  /// The DocumentSnapshot of the entry of the selected cell.
  late QueryDocumentSnapshot<Entry>? currentEntry;
  /// The DocumentSnapshot of the user assigned to the selected cell.
  late DocumentSnapshot<UserDoc>? currentEntryUser;
  /// The ValueNotifier of the selected cell.
  late ValueNotifier? currentCellNotifier;
  late bool isUsersEntry; // TODO true if user is viewing their own entry

  /// Asserts that, for the Controller's current state, certain variables 
  /// are in order.
  void checkState(){
    checkThisState(currentState);
  }
  
  /// Asserts that the Controller is in the PageState [state], and that
  /// certain variables are in order.
  void checkThisState(PageState state){
    assert (currentState == state);
    switch (state){
      case PageState.view:
        // Variables necessary for view
        assert (currentEntry != null);
        assert (currentEntryUser != null);
        assert (currentCellNotifier != null);
      case PageState.select:
        // Variables necessary for selection
        assert (selectedEntries != null);
      default:
        // PageState.empty doesn't need anything initialized
    }
  }

  /// Adds given entry to selection if it's not included,
  /// And removes entry from selection if it is.
  /// Returns whether this entry will be in the selection AFTER this operation.
  /// Must be in selection mode to invoke.
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

  /// Returns a list of the DocumentSnapshots of entries currently selected.
  List<QueryDocumentSnapshot<Entry>> getSelection(){
    checkThisState(PageState.select);
    return selectedEntries!.map((e) => e.$1).toList();
  }

  /// Assigns the logged-in user to all currently selected entries.
  void commitSelections() async {
    checkThisState(PageState.select);
    var (success, currentUserRef) = await Snapshots.getCurrentUserDoc();
    if(!success) {
      // TODO display to user
      print('Error occurred during selection commit.');
      return;
    }
    for(var entryPair in selectedEntries!){
      var entry = entryPair.$1;
      Snapshots.runTransaction((transaction) async {
        transaction.update(entry.reference, {Entry.userRefString: currentUserRef!.reference});
      });
      entryPair.$2.value = CellSelectStatus.inactive;
    }
    toEmptyState();
  }

  /// Unassigns the user in the current entry.
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

  /// Performs cleanup to move on from the current state. Mostly entails setting
  /// certain attributes to null, and notifying any relevant CellWrappers.
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